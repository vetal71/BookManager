unit Form.SQLMonitoring;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  Form.BaseForm,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore, dxSkinMetropolis,
  cxTextEdit, cxMemo, dxBevel, cxClasses, dxSkinsForm, Vcl.Menus, Vcl.StdCtrls,
  cxButtons, Vcl.ExtCtrls,
  System.Generics.Collections,
  Aurelius.Drivers.Interfaces,
  Aurelius.Commands.Listeners;

type
  TfrmSQLMonitoring = class(TfrmBase, ICommandExecutionListener)
    mmoLog: TcxMemo;
    pnlButton: TPanel;
    btnExit: TcxButton;
    btnClear: TcxButton;
    procedure btnExitClick(Sender: TObject);
  private
    class var
      FInstance: TfrmSqlMonitoring;
    procedure ExecutingCommand(SQL: string; Params: TEnumerable<TDBParam>);
  public
    class function GetInstance: TfrmSqlMonitoring;
  end;

implementation

uses
  Common.DBConnection;

{$R *.dfm}

{ TfrmSQLMonitoring }

procedure TfrmSQLMonitoring.btnExitClick(Sender: TObject);
begin
  Hide;
end;

procedure TfrmSQLMonitoring.ExecutingCommand(SQL: string;
  Params: TEnumerable<TDBParam>);
begin
  TDBConnection.AddLines(mmoLog.Lines, SQL, Params);
  Application.ProcessMessages;
end;

class function TfrmSQLMonitoring.GetInstance: TfrmSqlMonitoring;
begin
  if FInstance = nil then
    FInstance := TfrmSqlMonitoring.Create(Application);
  Result := FInstance;
end;

end.
