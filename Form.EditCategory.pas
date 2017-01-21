unit Form.EditCategory;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Form.BaseEditForm, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore,
  dxSkinMetropolis, cxClasses, dxSkinsForm, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls,
  Controller.EditCategory, Model.Entities, cxControls, cxContainer, cxEdit,
  cxMaskEdit, cxDropDownEdit, cxTextEdit, cxLabel;

type
  TfrmEditCategory = class(TfrmBaseEditor)
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxTextEdit1: TcxTextEdit;
    cbb1: TcxComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FController: TEditCategoryController;
  public
    procedure SetCategory(CategoryID: Variant);
  end;

var
  frmEditCategory: TfrmEditCategory;

implementation

{$R *.dfm}

{ TfrmEditCategory }

procedure TfrmEditCategory.FormCreate(Sender: TObject);
begin
  FController := TEditCategoryController.Create;
end;

procedure TfrmEditCategory.FormDestroy(Sender: TObject);
begin
  FController.Free;
  inherited;
end;

procedure TfrmEditCategory.SetCategory(CategoryID: Variant);
var
  Category: TCategory;
begin
  FController.Load(CategoryID);
  Category := FController.Category;

//  edName.Text := Album.AlbumName;
//
//  if Album.ReleaseYear.HasValue then
//    edYear.Text := IntToStr(Album.ReleaseYear);
end;

end.
