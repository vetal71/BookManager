unit Form.ConnectionDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Form.BaseEditForm, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore,
  dxSkinMetropolis, System.ImageList, Vcl.ImgList, cxClasses, dxSkinsForm,
  Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxPropertiesStore;

type
  TfrmDlgConnection = class(TfrmBaseEditor)
    cbbConnections: TcxComboBox;
    psDefaultParams: TcxPropertiesStore;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    function GetDBFile: string;
  public
    property DBFile: string read GetDBFile;
  end;

var
  frmDlgConnection: TfrmDlgConnection;

implementation

uses
  System.IniFiles, synautil;

{$R *.dfm}

procedure TfrmDlgConnection.FormCreate(Sender: TObject);
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'conn.ini');
  try
    ini.ReadSectionValues('Database', cbbConnections.Properties.Items);
  finally
    ini.Free;
  end;
  psDefaultParams.RestoreFrom;
end;

procedure TfrmDlgConnection.FormDestroy(Sender: TObject);
begin
  inherited;
  psDefaultParams.StoreTo();
end;

function TfrmDlgConnection.GetDBFile: string;
begin
  Result := SeparateRight(cbbConnections.Text, '=');
end;

end.
