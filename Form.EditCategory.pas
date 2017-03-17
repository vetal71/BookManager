unit Form.EditCategory;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Form.BaseEditForm, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore,
  dxSkinMetropolis, cxClasses, dxSkinsForm, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, Common.Utils,
  cxControls, cxContainer, cxEdit,
  cxMaskEdit, cxDropDownEdit, cxTextEdit, cxLabel,
  System.ImageList, Vcl.ImgList, Data.DB, cxLookupEdit, cxDBLookupEdit,
  cxDBLookupComboBox, cxDBEdit, MemDS, DBAccess, Uni;

type
  TfrmEditCategory = class(TfrmBaseEditor)
    lblCategoryName: TcxLabel;
    lblParentCategory: TcxLabel;
    edtCategoryName: TcxDBTextEdit;
    cbbParentCategory: TcxDBLookupComboBox;
    dsCategories: TUniDataSource;
    qryCategories: TUniQuery;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private

  public
    class function Edit(AMode: TEditMode): Boolean;
  end;

var
  frmEditCategory: TfrmEditCategory;

implementation

uses
  ConnectionModule;

{$R *.dfm}

{ TfrmEditCategory }

procedure TfrmEditCategory.btnCancelClick(Sender: TObject);
begin
  DM.qryCategories.Cancel;
  inherited;
end;

procedure TfrmEditCategory.btnOKClick(Sender: TObject);
begin
  with DM.qryCategories do begin
    try
      Post;
    except on E: Exception do begin
      ShowErrorFmt('Не удалось сохранить категорию "%s"'#10#13+'%s',
        [edtCategoryName.Text, E.Message]);
      ModalResult := mrCancel;
      end;
    end;
  end;
  inherited;
end;

class function TfrmEditCategory.Edit(AMode: TEditMode): Boolean;
var
  Form: TfrmEditCategory;
begin
  Form := TfrmEditCategory.Create(Application);
  try
    if AMode = emAppend then
      Form.Header := 'Новая категория книг'
    else
      Form.Header := Format('Редактирование категории книг: %s',
        [dm.qryCategories.FieldValues['CategoryName']]);
    Form.qryCategories.Open;
    Result := Form.ShowModal = mrOk;
  finally
    Form.Free;
  end;
end;

end.
