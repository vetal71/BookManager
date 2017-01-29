unit Form.MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dxSkinsCore, dxBevel, cxGraphics,
  Form.BaseForm,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinMetropolis,
  dxSkinsdxStatusBarPainter, dxSkinsdxBarPainter, dxSkinsForm, System.ImageList,
  System.Generics.Collections,
  Aurelius.Drivers.Interfaces,
  Vcl.ImgList, dxBar, cxClasses, dxStatusBar,
  Aurelius.Engine.DatabaseManager,
  Aurelius.Engine.ObjectManager,
  Vcl.Menus, System.Actions,
  Vcl.ActnList, cxSplitter, Vcl.ExtCtrls,
  Form.SQLMonitoring, cxStyles, dxSkinscxPCPainter,
  cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData, cxContainer, cxListBox,
  cxDBNavigator, cxGridLevel, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid,
  cxCustomData, cxFilter, cxData, cxDBEdit, Vcl.ComCtrls, Vcl.ToolWin, cxTL,
  cxTLdxBarBuiltInMenu, cxInplaceContainer, cxTLData, cxDBTL, cxMaskEdit,
  Vcl.Grids, Vcl.DBGrids, dxBarBuiltInMenu, cxPC,
  Common.DBConnection;

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
    bsiService: TdxBarSubItem;
    biSQLMonitor: TdxBarButton;
    btnSQLMonitor: TdxBarLargeButton;
    pgcMain: TcxPageControl;
    tsMainView: TcxTabSheet;
    tsAudit: TcxTabSheet;
    tsSQLMonitor: TcxTabSheet;
    procedure FormCreate(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actRefreshLibraryExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    Connection: IDBConnection;
  private
    procedure ShowSqlMonitorForm;
    procedure ShowAuditLogForm;
    procedure ShowLibraryForm;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  Common.DatabaseUtils,
  Form.AuditLogViewer,
  Form.MainView;

{$R *.dfm}

procedure TfrmMain.actExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.actRefreshLibraryExecute(Sender: TObject);
begin
  // вызвать метод, который возвратит лог (количество обработанных файлов, записей)
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin

  Connection := TDBConnection.CreateConnection;

  UpdateDatabaseShema(Connection);
  FillData(Connection);

// Менеджер объектов
//  FManager    := TDBConnection.GetInstance.CreateObjectManager;

//  sbMain.Panels[2].Text := Format('Всего книг зарегистрировано в базе данных: %d', [ FManager.FindAll<TBook>.Count ]);

  // Информация о БД
  //sbMain.Panels[1].Text := Format('База данных: %s', [ TDBConnection.GetDBName ]);
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  ShowSqlMonitorForm;
  ShowAuditLogForm;
  ShowLibraryForm;
end;

procedure TfrmMain.ShowAuditLogForm;
var
  F: TfrmAuditLogViewer;
begin
  F := TfrmAuditLogViewer.GetInstance;
  F.Parent := tsAudit;
  F.Align := alClient;
  F.BorderStyle := bsNone;
  F.Show;
end;

procedure TfrmMain.ShowLibraryForm;
var
  F: TfrmLibraryView;
begin
  F := TfrmLibraryView.Create(Application, TObjectManager.Create(TDBConnection.CreateConnection), True);
  F.Parent := tsMainView;
  F.Align := alClient;
  F.BorderStyle := bsNone;
  F.Show;
end;

procedure TfrmMain.ShowSqlMonitorForm;
var
  F: TfrmSQLMonitoring;
begin
  F := TfrmSQLMonitoring.GetInstance;
  F.Parent := tsSQLMonitor;
  F.Align := alClient;
  F.BorderStyle := bsNone;
  F.Show;
end;

end.
