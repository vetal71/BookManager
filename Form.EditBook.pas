unit Form.EditBook;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Form.BaseEditForm, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore,
  dxSkinMetropolis, cxClasses, dxSkinsForm, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, cxControls, cxContainer, cxEdit, cxMaskEdit, cxDropDownEdit,
  cxTextEdit, cxLabel, Vcl.Buttons,
  Model.Entities, Aurelius.Bind.Dataset, Aurelius.Engine.ObjectManager,
  System.ImageList, Vcl.ImgList, Data.DB, cxDBEdit, cxLookupEdit,
  cxDBLookupEdit, cxDBLookupComboBox;

type
  TfrmEditBook = class(TfrmBaseEditor)
    lblCategoryName: TcxLabel;
    lblParentCategory: TcxLabel;
    btnAddCategory: TcxButton;
    lblFileLink: TcxLabel;
    btnFileLink: TcxButton;
    adsCategories: TAureliusDataset;
    adsCategoriesSelf: TAureliusEntityField;
    adsCategoriesID: TIntegerField;
    adsCategoriesCategoryName: TStringField;
    adsCategoriesParent: TAureliusEntityField;
    adsCategoriesBooks: TDataSetField;
    dsCategories: TDataSource;
    adsBooks: TAureliusDataset;
    adsBooksSelf: TAureliusEntityField;
    adsBooksID: TIntegerField;
    adsBooksBookName: TStringField;
    adsBooksBookLink: TStringField;
    dsBooks: TDataSource;
    edtBookName: TcxDBTextEdit;
    edtFileLink: TcxDBTextEdit;
    cbbParentCategory: TcxComboBox;
    adsBooksCategory: TAureliusEntityField;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    procedure SetBook(ABook: TBook; AManager: TObjectManager);
    procedure LoadCategory;
  public
    class function Edit(ABook: TBook; AManager: TObjectManager): Boolean;
  end;

var
  frmEditBook: TfrmEditBook;

implementation

uses
  ConnectionModule,
  Common.Utils,
  System.Generics.Collections;

{$R *.dfm}

{ TfrmEditBook }

procedure TfrmEditBook.btnCancelClick(Sender: TObject);
begin
  adsBooks.Cancel;
  inherited;
end;

procedure TfrmEditBook.btnOKClick(Sender: TObject);
begin
  try
    if cbbParentCategory.ItemIndex >= 0 then
      adsBooks.EntityFieldByName('BooksCategory').AsObject :=
        TCategory(cbbParentCategory.ItemObject);
    adsBooks.Post;
  except on E: Exception do begin
    ShowErrorFmt('Не удалось сохранить книгу "%s"'#10#13+'%s', [edtBookName.Text, E.Message]);
    adsBooks.Cancel;
    ModalResult := mrCancel;
    end;
  end;
  inherited;
end;

class function TfrmEditBook.Edit(ABook: TBook; AManager: TObjectManager): Boolean;
var
  Form: TfrmEditBook;
  BookName: string;
begin
  Form := TfrmEditBook.Create(Application);
  try
    BookName := ABook.BookName;
    if BookName.IsEmpty then
      Form.Header := 'Новая книга'
    else
      Form.Header := Format('Редактирование книги: %s', [BookName]);
    Form.SetBook(ABook, AManager);
    Result := Form.ShowModal = mrOk;
  finally
    Form.Free;
  end;
end;

procedure TfrmEditBook.SetBook(ABook: TBook; AManager: TObjectManager);
begin
  // открытие DS
  with adsCategories do begin
    Close;
    SetSourceCriteria(AManager.Find<TCategory>.OrderBy('CategoryName'));
    Open;
  end;

  with adsBooks do begin
    Close;
    SetSourceObject(ABook);
    Open;
    Edit;
  end;

  LoadCategory;
//  if Assigned(ABook.BooksCategory) then
//    cbbParentCategory.ItemIndex := cbbParentCategory.Properties.Items.IndexOf( ABook.BooksCategory.CategoryName );
  cbbParentCategory.ItemObject := ABook.BooksCategory;
end;

procedure TfrmEditBook.LoadCategory;
var
  C: TCategory;
begin
  cbbParentCategory.Properties.Items.Clear;
  while not adsCategories.Eof do begin
    C := adsCategories.EntityFieldByName('Self').AsEntity<TCategory>;
    cbbParentCategory.Properties.Items.AddObject(C.CategoryName, C);
    adsCategories.Next;
  end;
end;

end.
