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
  System.ImageList, Vcl.ImgList,
  cxCheckBox, DASQLMonitor;

type
  TfrmSQLMonitoring = class(TfrmBase)
    mmoLog: TcxMemo;
    pnlButton: TPanel;
    btnClear: TcxButton;
    chkEnableMonitor: TcxCheckBox;
    procedure btnClearClick(Sender: TObject);
    procedure chkEnableMonitorClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    class var
      FInstance: TfrmSqlMonitoring;
  private
    procedure SQLMonitor(Sender: TObject; Text: string; Flag: TDATraceFlag);
  private
    procedure Log(const S: string);
    procedure BreakLine;
  end;

implementation

{$R *.dfm}

uses
  ConnectionModule;

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
  DM.ActiveMonitoring := chkEnableMonitor.Checked;
end;

procedure TfrmSQLMonitoring.FormCreate(Sender: TObject);
begin
  DM.OnSQLEvent := SQLMonitor;
end;

procedure TfrmSQLMonitoring.Log(const S: string);
begin
  mmoLog.Lines.Add(S);
end;

procedure TfrmSQLMonitoring.SQLMonitor(Sender: TObject; Text: string;
  Flag: TDATraceFlag);
begin
  BreakLine;
  Log(Text);
  BreakLine;
end;

end.
