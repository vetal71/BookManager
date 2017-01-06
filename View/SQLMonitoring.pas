unit SQLMonitoring;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels, BaseForm,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore, dxSkinMetropolis,
  cxTextEdit, cxMemo, dxBevel, cxClasses, dxSkinsForm, Vcl.Menus, Vcl.StdCtrls,
  cxButtons, Vcl.ExtCtrls;

type
  TfrmSQLMonitoring = class(TfrmBase)
    mmoLog: TcxMemo;
    pnlButton: TPanel;
    btnExit: TcxButton;
    btnClear: TcxButton;
  private
    FInstance: TfrmSQLMonitoring;
  public
    class function GetInstance: TfrmSqlMonitoring;
  end;

var
  frmSQLMonitoring: TfrmSQLMonitoring;

implementation

{$R *.dfm}

{ TfrmSQLMonitoring }

class function TfrmSQLMonitoring.GetInstance: TfrmSqlMonitoring;
begin
  if FInstance = nil then
    FInstance := TfrmSqlMonitoring.Create(Application);
  Result := FInstance;
end;

end.
