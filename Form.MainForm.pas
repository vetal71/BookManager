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
    bi5: TdxBarButton;
    dxBarSeparator2: TdxBarSeparator;
    actSaveToGoogleDrive: TAction;
    btnSaveGDrive: TdxBarLargeButton;
    procedure actExitExecute(Sender: TObject);
    procedure actRefreshLibraryExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actSaveToGoogleDriveExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    Connection: TUniConnection;
    FView: TForm;
  private
    procedure ShowSqlMonitorForm;
    procedure ShowLibraryForm;
    procedure BooksChange(Sender: TObject);
    procedure DeleteBook(DataSet: TDataSet);
  end;

var
  frmMain: TfrmMain;

implementation

uses
  Common.DatabaseUtils, Common.Utils, cxDBTL,
  Form.MainView, Common.GoogleAuth;

{$R *.dfm}

procedure TfrmMain.actExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.actRefreshLibraryExecute(Sender: TObject);
begin
  FillData;
end;

procedure TfrmMain.actSaveToGoogleDriveExecute(Sender: TObject);
begin
  // сохранить в google drive
  Screen.Cursor := crHourGlass;
  try
    TGoogleAuth.UploadFile(ExtractFilePath(ParamStr(0)) + DM.DBFile);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmMain.BooksChange(Sender: TObject);
var
  BookLink: string;
begin
  if not Assigned(Sender) then Exit;

  BookLink := DM.qryBooks.FieldByName('BookLink').AsString;
  sbMain.Panels[ 0 ].Text := BookLink;
end;

procedure TfrmMain.DeleteBook(DataSet: TDataSet);
var
  BookCount: Integer;
begin
  BookCount := GetFieldValue(['count(*)','Books']);
  sbMain.Panels[1].Text := Format('Всего книг в библиотеке: %d штук', [BookCount]);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  DM.RegChangeNotifier(BooksChange);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  DM.UnregChangeNotifier(BooksChange);
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = 116) or ((Key = 13) and (ssShift in Shift)) then // F5 или Shift+Enter - запуск просмотра
    TfrmLibraryView(FView).btnRunClick(nil);

  if Key = 45 then begin // Ins
    if ActiveControl is TcxDbTreeList then
      TfrmLibraryView(FView).btnAddCategoryClick(nil)
    else
      TfrmLibraryView(FView).btnAddBookClick(nil);
  end;
  if (Key = 113) or ((Key = 13) and (ssCtrl in Shift)) then begin // F2 или Ctrl+Enter
    if ActiveControl is TcxDbTreeList then
      TfrmLibraryView(FView).btnEditCategoryClick(nil)
    else
      TfrmLibraryView(FView).btnEditBookClick(nil);
  end;
  if (Key = 36) and (ssCtrl in Shift) then // Ctrl+Home
    DM.qryCategories.First;
  if (Key = 46) and (ssShift in Shift) then begin
    if ActiveControl is TcxDbTreeList then
      TfrmLibraryView(FView).btnDelCategoryClick(nil)
    else
      TfrmLibraryView(FView).btnDelBookClick(nil);
  end;
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
  FView := F;
  F.Parent := tsMainView;
  F.Align := alClient;
  F.BorderStyle := bsNone;
  DM.OnDeleteBook := DeleteBook;
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
