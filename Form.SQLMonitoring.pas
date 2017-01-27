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
  Aurelius.Commands.Listeners, System.ImageList, Vcl.ImgList,
  cxCheckBox, Aurelius.Events.Manager, Aurelius.Mapping.Explorer;

type
  TfrmSQLMonitoring = class(TfrmBase)
    mmoLog: TcxMemo;
    pnlButton: TPanel;
    btnClear: TcxButton;
    chkEnableMonitor: TcxCheckBox;
    procedure btnClearClick(Sender: TObject);
    procedure chkEnableMonitorClick(Sender: TObject);
  private
    class var
      FInstance: TfrmSqlMonitoring;
  private
    FSqlExecutingProc: TSQLExecutingProc;
    procedure SqlExecutingHandler(Args: TSQLExecutingArgs);
  private
    procedure Log(const S: string);
    procedure BreakLine;
    procedure SubscribeListeners;
    procedure UnsubscribeListeners;
  public
    class function GetInstance: TfrmSQLMonitoring;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  Common.DBConnection;

{$R *.dfm}

{ TfrmSQLMonitoring }

procedure TfrmSQLMonitoring.BreakLine;
begin
  mmoLog.Lines.Add('================================================');
end;

procedure TfrmSQLMonitoring.btnClearClick(Sender: TObject);
begin
  mmoLog.Clear;
end;

procedure TfrmSQLMonitoring.chkEnableMonitorClick(Sender: TObject);
begin
  if chkEnableMonitor.Checked then
    SubscribeListeners
  else
    UnsubscribeListeners;
end;

constructor TfrmSQLMonitoring.Create(AOwner: TComponent);
begin
  inherited;
  FSqlExecutingProc := SqlExecutingHandler;
  SubscribeListeners;
end;

class function TfrmSQLMonitoring.GetInstance: TfrmSQLMonitoring;
begin
  if FInstance = nil then
    FInstance := TfrmSQLMonitoring.Create(Application);
  Result := FInstance;
end;

procedure TfrmSQLMonitoring.Log(const S: string);
begin
  mmoLog.Lines.Add(S);
end;

procedure TfrmSQLMonitoring.SqlExecutingHandler(Args: TSQLExecutingArgs);
var
  Param: TDBParam;
begin
  Log(Args.SQL);
  if Args.Params <> nil then
    for Param in Args.Params do
      Log(Param.ToString);
  BreakLine;
end;

procedure TfrmSQLMonitoring.SubscribeListeners;
var
  E: TManagerEvents;
begin
  E := TMappingExplorer.Default.Events;
  E.OnSQLExecuting.Subscribe(FSqlExecutingProc);
end;

procedure TfrmSQLMonitoring.UnsubscribeListeners;
var
  E: TManagerEvents;
begin
  E := TMappingExplorer.Default.Events;
  E.OnSqlExecuting.Unsubscribe(FSqlExecutingProc);
end;

end.
