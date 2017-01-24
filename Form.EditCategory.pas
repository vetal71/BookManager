unit Form.EditCategory;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Form.BaseEditForm, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore,
  dxSkinMetropolis, cxClasses, dxSkinsForm, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls,
  Controller.EditCategory, Model.Entities, cxControls, cxContainer, cxEdit,
  cxMaskEdit, cxDropDownEdit, cxTextEdit, cxLabel, System.Generics.Collections;

type
  TfrmEditCategory = class(TfrmBaseEditor)
    lblCategoryName: TcxLabel;
    lblParentCategory: TcxLabel;
    edtCategoryName: TcxTextEdit;
    cbbParentCategory: TcxComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    FController: TEditCategoryController;
    procedure LoadCategory;
  public
    procedure SetCategory(CategoryID: Variant);
    procedure SetParentCategory(Category: TCategory);
  end;

var
  frmEditCategory: TfrmEditCategory;

implementation

uses
  Common.Utils;

{$R *.dfm}

{ TfrmEditCategory }

procedure TfrmEditCategory.btnOKClick(Sender: TObject);
var
  Category: TCategory;
begin
  Category := FController.Category;

  with Category do begin
    CategoryName := edtCategoryName.Text;
    if cbbParentCategory.ItemIndex >= 0 then
      Parent := TCategory(cbbParentCategory.ItemObject);
  end;

  try
    FController.SaveCategory(Category);
    ModalResult := mrOk;
  except on E: Exception do begin
    ShowErrorFmt('Не удалось сохранить категорию "%s"'#10#13+'%s', [edtCategoryName.Text]);
    ModalResult := mrCancel;
    end;
  end;
end;

procedure TfrmEditCategory.FormCreate(Sender: TObject);
begin
  FController := TEditCategoryController.Create;
  LoadCategory;
end;

procedure TfrmEditCategory.FormDestroy(Sender: TObject);
begin
  FController.Free;
  inherited;
end;

procedure TfrmEditCategory.LoadCategory;
var
  Categories: TList<TCategory>;
  C: TCategory;
begin
  cbbParentCategory.Properties.Items.Clear;
  Categories := FController.GetCategories;
  try
    for C in Categories do
      cbbParentCategory.Properties.Items.AddObject(C.CategoryName, C);
  finally
    Categories.Free;
  end;
end;

procedure TfrmEditCategory.SetCategory(CategoryID: Variant);
var
  Category: TCategory;
begin
  FController.Load(CategoryID);
  Category := FController.Category;

  edtCategoryName.Text := Category.CategoryName;
  cbbParentCategory.ItemObject := Category.Parent;
end;

procedure TfrmEditCategory.SetParentCategory(Category: TCategory);
begin
  if Assigned(Category) then
    cbbParentCategory.ItemIndex := cbbParentCategory.Properties.Items.IndexOf( Category.CategoryName );
end;

end.
