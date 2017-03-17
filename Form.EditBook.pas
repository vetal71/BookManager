unit Form.EditBook;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Form.BaseEditForm, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore,
  dxSkinMetropolis, cxClasses, dxSkinsForm, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, cxControls, cxContainer, cxEdit, cxMaskEdit, cxDropDownEdit,
  cxTextEdit, cxLabel, Vcl.Buttons, ConnectionModule, Common.Utils,
  System.ImageList, Vcl.ImgList, Data.DB, cxDBEdit, cxLookupEdit,
  cxDBLookupEdit, cxDBLookupComboBox, DBAccess, Uni, MemDS, dxdbtrel;

type
  TfrmEditBook = class(TfrmBaseEditor)
    lblCategoryName: TcxLabel;
    lblParentCategory: TcxLabel;
    btnAddCategory: TcxButton;
    lblFileLink: TcxLabel;
    btnFileLink: TcxButton;
    edtBookName: TcxDBTextEdit;
    edtFileLink: TcxDBTextEdit;
    qryCategories: TUniQuery;
    dsCategories: TUniDataSource;
    cbbParentCategory: TcxDBLookupComboBox;
    edtFullCategory: TcxTextEdit;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnFileLinkClick(Sender: TObject);
    procedure btnAddCategoryClick(Sender: TObject);
    procedure cbbParentCategoryPropertiesChange(Sender: TObject);
  private
    function GetFullCategory: string;
  public
    class function Edit(AMode: TEditMode): Boolean;
  end;

var
  frmEditBook: TfrmEditBook;

implementation

uses
  Form.EditCategory;

{$R *.dfm}

{ TfrmEditBook }

procedure TfrmEditBook.btnAddCategoryClick(Sender: TObject);
begin
  if TfrmEditCategory.Edit(emAppend) then begin
    qryCategories.Active := False;
    qryCategories.Active := True;
  end;
end;

procedure TfrmEditBook.btnCancelClick(Sender: TObject);
begin
  DM.qryBooks.Cancel;
  inherited;
end;

procedure TfrmEditBook.btnFileLinkClick(Sender: TObject);
begin
  with TOpenDialog.Create(nil) do try
    Filter := 'Файлы книг|*.pdf;*.djvu;*.epab;*.chm';
    if Execute then
      edtFileLink.Text := FileName;
  finally
    Free;
  end;
end;

procedure TfrmEditBook.btnOKClick(Sender: TObject);
begin
  try
    DM.qryBooks.Post;
  except on E: Exception do begin
    ShowErrorFmt('Не удалось сохранить книгу "%s"'#10#13+'%s', [edtBookName.Text, E.Message]);
    DM.qryBooks.Cancel;
    ModalResult := mrCancel;
    end;
  end;
  inherited;
end;

procedure TfrmEditBook.cbbParentCategoryPropertiesChange(Sender: TObject);
begin
  inherited;
  edtFullCategory.Text := GetFullCategory;
end;

class function TfrmEditBook.Edit(AMode: TEditMode): Boolean;
var
  Form: TfrmEditBook;
begin
  Form := TfrmEditBook.Create(Application);
  try
    if AMode = emAppend then
      Form.Header := 'Новая книга'
    else
      Form.Header := Format('Редактирование книги: %s', [DM.qryBooks.FieldValues['BookName']]);
    Form.qryCategories.Open;
    Result := Form.ShowModal = mrOk;
  finally
    Form.Free;
  end;
end;

function TfrmEditBook.GetFullCategory: string;
const
  cSQL =
    'with recursive m(path, id) as ( '#13#10 +
    '    select categoryname path, id from categories where parent_id is null '#13#10 +
    '    union all '#13#10 +
    '    select path || '' -> '' || t.categoryname, t.id  '#13#10 +
    '    from categories t, m where t.parent_id = m.id '#13#10 +
    ') select * from m '#13#10 +
    'where id = :id;';
begin
  Result := '';
  with TUniQuery.Create(nil) do try
    Connection := DM.conn;
    SQL.Text := cSQL;
    ParamByName('ID').AsInteger := qryCategories.FieldByName('ID').AsInteger;
    Open;
    if not IsEmpty then
      Result := FieldValues['Path'];
  finally
    Free;
  end;
end;

end.
