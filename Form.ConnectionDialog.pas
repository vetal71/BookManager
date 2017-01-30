unit Form.ConnectionDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Form.BaseEditForm, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore,
  dxSkinMetropolis, System.ImageList, Vcl.ImgList, cxClasses, dxSkinsForm,
  Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxMaskEdit, cxDropDownEdit;

type
  TfrmDlgConnection = class(TfrmBaseEditor)
    cbbConnections: TcxComboBox;
    procedure FormCreate(Sender: TObject);
  private
    function GetDBFile: string;
    { Private declarations }
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
end;

function TfrmDlgConnection.GetDBFile: string;
begin
  Result := SeparateRight(cbbConnections.Text, '=');
end;

end.
