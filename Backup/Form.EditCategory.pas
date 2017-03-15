unit Form.EditCategory;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Form.BaseEditForm, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore,
  dxSkinMetropolis, cxClasses, dxSkinsForm, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls,
  Model.Entities, cxControls, cxContainer, cxEdit,
  cxMaskEdit, cxDropDownEdit, cxTextEdit, cxLabel,
  System.Generics.Collections,
  Aurelius.Bind.Dataset,
  Aurelius.Engine.ObjectManager,
  System.ImageList, Vcl.ImgList, Data.DB, cxLookupEdit, cxDBLookupEdit,
  cxDBLookupComboBox, cxDBEdit;

type
  TfrmEditCategory = class(TfrmBaseEditor)
    lblCategoryName: TcxLabel;
    lblParentCategory: TcxLabel;
    edtCategoryName: TcxDBTextEdit;
    cbbParentCategory: TcxDBLookupComboBox;
    adsCategories: TAureliusDataset;
    adsCategoriesSelf: TAureliusEntityField;
    adsCategoriesID: TIntegerField;
    adsCategoriesCategoryName: TStringField;
    adsCategoriesParent: TAureliusEntityField;
    adsCategoriesBooks: TDataSetField;
    dsCategories: TDataSource;
    adsParents: TAureliusDataset;
    adsParentsSelf: TAureliusEntityField;
    adsParentsID: TIntegerField;
    adsParentsCategoryName: TStringField;
    adsParentsParent: TAureliusEntityField;
    adsParentsBooks: TDataSetField;
    dsParents: TDataSource;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    procedure SetCategory(ACategory: TCategory; AManager: TObjectManager);
  public
    class function Edit(ACategory: TCategory; AManager: TObjectManager): Boolean;
  end;

var
  frmEditCategory: TfrmEditCategory;

implementation

uses
  Common.Utils;

{$R *.dfm}

{ TfrmEditCategory }

procedure TfrmEditCategory.btnCancelClick(Sender: TObject);
begin
  adsCategories.Cancel;
  inherited;
end;

procedure TfrmEditCategory.btnOKClick(Sender: TObject);
begin
  with adsCategories do begin
    try
      Post;
    except on E: Exception do begin
      ShowErrorFmt('Не удалось сохранить категорию "%s"'#10#13+'%s', [edtCategoryName.Text]);
      ModalResult := mrCancel;
      end;
    end;
  end;
  inherited;
end;

class function TfrmEditCategory.Edit(ACategory: TCategory;
  AManager: TObjectManager): Boolean;
var
  Form: TfrmEditCategory;
  CategoryName: string;
begin
  Form := TfrmEditCategory.Create(Application);
  try
    CategoryName := ACategory.CategoryName;
    if CategoryName.IsEmpty then
      Form.Header := 'Новая категория книг'
    else
      Form.Header := Format('Редактирование категории книг: %s', [CategoryName]);
    Form.SetCategory(ACategory, AManager);
    Result := Form.ShowModal = mrOk;
  finally
    Form.Free;
  end;
end;

procedure TfrmEditCategory.SetCategory(ACategory: TCategory;
  AManager: TObjectManager);
begin
  // открытие DS
  adsParents.Close;
  adsParents.SetSourceCriteria(AManager.Find<TCategory>.OrderBy('CategoryName'));
  adsParents.Open;

  with adsCategories do begin
    Close;
    SetSourceObject(ACategory);
    Open;
    Edit;
  end;
end;

end.
