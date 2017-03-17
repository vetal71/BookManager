unit Form.MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dxSkinsCore, cxGraphics,
  Form.BaseForm,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinMetropolis,
  dxSkinsdxStatusBarPainter, dxSkinsdxBarPainter, dxSkinsForm, System.ImageList,
  Vcl.ImgList, dxBar, cxClasses, dxStatusBar,
  Vcl.Menus, System.Actions,
  Vcl.ActnList, cxSplitter, Vcl.ExtCtrls,
  Form.SQLMonitoring, cxStyles, dxSkinscxPCPainter,
  cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData, cxContainer, cxListBox,
  cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid,
  Vcl.ComCtrls, cxTL,
  cxTLdxBarBuiltInMenu, cxInplaceContainer, cxMaskEdit,
  dxBarBuiltInMenu, cxPC,
  ConnectionModule, Uni;

type
  TfrmMain = class(TfrmBase)
    brMain: TdxBarManager;
    brmMainToolbar: TdxBar;
    btnRefreshLib: TdxBarLargeButton;
    sbMain: TdxStatusBar;
    btnTest: TdxBarLargeButton;
    brmMainMenu: TdxBar;
    bsiFile: TdxBarSubItem;
    biRefreshLib: TdxBarButton;
    dxBarSeparator1: TdxBarSeparator;
    biExit: TdxBarButton;
    btnExit: TdxBarLargeButton;
    acList: TActionList;
    actRefreshLibrary: TAction;
    actExit: TAction;
    actSQLMonitor: TAction;
    btnSQLMonitor: TdxBarLargeButton;
    pgcMain: TcxPageControl;
    tsMainView: TcxTabSheet;
    tsSQLMonitor: TcxTabSheet;
    bi1: TdxBarButton;
    bsiService: TdxBarSubItem;
    bi2: TdxBarButton;
    biSQLMonitor: TdxBarButton;
    bi3: TdxBarButton;
    biSQLAudit: TdxBarButton;
    bsi1: TdxBarSubItem;
    bi4: TdxBarButton;
    procedure actExitExecute(Sender: TObject);
    procedure actRefreshLibraryExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    Connection: TUniConnection;
  private
    procedure ShowSqlMonitorForm;
    procedure ShowLibraryForm;
    procedure BooksDataChange(Sender: TObject; Field: TField);
  end;

var
  frmMain: TfrmMain;

implementation

uses
  Common.DatabaseUtils,
  Form.MainView;

{$R *.dfm}

procedure TfrmMain.actExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.actRefreshLibraryExecute(Sender: TObject);
begin
  FillData;
end;

procedure TfrmMain.BooksDataChange(Sender: TObject; Field: TField);
begin
  if not Assigned(Sender) then Exit;
  sbMain.Panels[ 0 ].Text := TDataSource(Sender).DataSet.FieldByName('BookLink').AsString;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  sbMain.Panels[2].Text := Format('База данных: %s', [DM.DBFile]);

  ShowSqlMonitorForm;
  ShowLibraryForm;
end;

procedure TfrmMain.ShowLibraryForm;
var
  F: TfrmLibraryView;
begin
  F := TfrmLibraryView.Create(Application);
  F.Parent := tsMainView;
  F.Align := alClient;
  F.BorderStyle := bsNone;
  DM.OnDataChange := BooksDataChange;
  F.Show;
  sbMain.Panels[1].Text := Format('Всего книг в библиотеке: %d штук', [F.BookCount]);
end;

procedure TfrmMain.ShowSqlMonitorForm;
var
  F: TfrmSQLMonitoring;
begin
  F := TfrmSQLMonitoring.Create(Application);
  F.Parent := tsSQLMonitor;
  F.Align := alClient;
  F.BorderStyle := bsNone;
  F.Show;
end;

end.
