unit Form.EditBook;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Form.BaseEditForm, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore,
  dxSkinMetropolis, cxClasses, dxSkinsForm, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, cxControls, cxContainer, cxEdit, cxMaskEdit, cxDropDownEdit,
  cxTextEdit, cxLabel, Vcl.Buttons,
  Model.Entities,
  Controller.EditBook, System.ImageList, Vcl.ImgList;

type
  TfrmEditBook = class(TfrmBaseEditor)
    lblCategoryName: TcxLabel;
    edtBookName: TcxTextEdit;
    lblParentCategory: TcxLabel;
    cbbParentCategory: TcxComboBox;
    btnAddCategory: TcxButton;
    lblFileLink: TcxLabel;
    edtFileLink: TcxTextEdit;
    btnFileLink: TcxButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    FController: TEditBookController;
    procedure LoadCategory;
  public
    procedure SetBook(BookID: Variant);
    procedure SetParentCategory(Category: TCategory);
  end;

var
  frmEditBook: TfrmEditBook;

implementation

uses
  Common.Utils,
  Controller.EditCategory,
  System.Generics.Collections;

{$R *.dfm}

{ TfrmEditBook }

procedure TfrmEditBook.btnOKClick(Sender: TObject);
var
  Book: TBook;
begin
  Book := FController.Book;

  with Book do begin
    BookName := edtBookName.Text;
    BookLink := edtFileLink.Text;
    if cbbParentCategory.ItemIndex >= 0 then
      Category := TCategory(cbbParentCategory.ItemObject);
  end;

  try
    FController.SaveBook(Book);
    ModalResult := mrOk;
  except on E: Exception do begin
    ShowErrorFmt('Не удалось сохранить книгу "%s"'#10#13+'%s', [edtBookName.Text, E.Message]);
    ModalResult := mrCancel;
    end;
  end;
end;

procedure TfrmEditBook.FormCreate(Sender: TObject);
begin
  FController := TEditBookController.Create;
  LoadCategory;
end;

procedure TfrmEditBook.FormDestroy(Sender: TObject);
begin
  FController.Free;
  inherited;
end;

procedure TfrmEditBook.LoadCategory;
var
  Categories: TList<TCategory>;
  C: TCategory;
begin
  cbbParentCategory.Properties.Items.Clear;
  Categories :=FController.GetCategories;
  try
    for C in Categories do
      cbbParentCategory.Properties.Items.AddObject(C.CategoryName, C);
  finally
    Categories.Free;
  end;
end;

procedure TfrmEditBook.SetBook(BookID: Variant);
var
  Book: TBook;
begin
  FController.Load(BookID);
  Book := FController.Book;

  edtBookName.Text := Book.BookName;
  edtFileLink.Text := Book.BookLink;

  cbbParentCategory.ItemObject := Book.Category;
end;

procedure TfrmEditBook.SetParentCategory(Category: TCategory);
begin
  if Assigned(Category) then
    cbbParentCategory.ItemIndex := cbbParentCategory.Properties.Items.IndexOf( Category.CategoryName );
end;

end.
