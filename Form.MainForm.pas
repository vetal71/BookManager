unit Form.MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dxSkinsCore, dxBevel, cxGraphics,
  Form.BaseForm,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinMetropolis,
  dxSkinsdxStatusBarPainter, dxSkinsdxBarPainter, dxSkinsForm, System.ImageList,
  System.Generics.Collections,
  Vcl.ImgList, dxBar, cxClasses, dxStatusBar,
  Aurelius.Engine.DatabaseManager,
  Aurelius.Engine.ObjectManager,
  Vcl.Menus, System.Actions,
  Vcl.ActnList, cxSplitter, Vcl.ExtCtrls,
  Form.SQLMonitoring, cxStyles, dxSkinscxPCPainter,
  cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData, cxContainer, cxListBox,
  cxDBNavigator, cxGridLevel, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, Aurelius.Bind.Dataset,
  cxCustomData, cxFilter, cxData, cxDBEdit, Vcl.ComCtrls, Vcl.ToolWin, cxTL,
  cxTLdxBarBuiltInMenu, cxInplaceContainer, cxTLData, cxDBTL, cxMaskEdit,
  Vcl.Grids, Vcl.DBGrids;

type
  TfrmMain = class(TfrmBase)
    brMain: TdxBarManager;
    brmMainToolbar: TdxBar;
    btnRefreshLib: TdxBarLargeButton;
    sbMain: TdxStatusBar;
    bvlMain: TdxBevel;
    btnTest: TdxBarLargeButton;
    brmMainMenu: TdxBar;
    bsiFile: TdxBarSubItem;
    biRefreshLib: TdxBarButton;
    dxBarSeparator1: TdxBarSeparator;
    biExit: TdxBarButton;
    btnExit: TdxBarLargeButton;
    acList: TActionList;
    ilSmall: TcxImageList;
    actRefreshLibrary: TAction;
    actExit: TAction;
    pnlLeft: TPanel;
    MainSplitter: TcxSplitter;
    pnlRight: TPanel;
    grdBooksView: TcxGridDBTableView;
    grdBooksLevel: TcxGridLevel;
    grdBooks: TcxGrid;
    actSQLMonitor: TAction;
    bsiService: TdxBarSubItem;
    biSQLMonitor: TdxBarButton;
    btnSQLMonitor: TdxBarLargeButton;
    CategoriesDS: TAureliusDataset;
    dsCategories: TDataSource;
    grdBooksViewID: TcxGridDBColumn;
    grdBooksViewBOOK_NAME: TcxGridDBColumn;
    grdBooksViewFILE_LINK: TcxGridDBColumn;
    grdBooksViewCATEGORYCATEGORY: TcxGridDBColumn;
    tbCategoryEdit: TToolBar;
    btnAddCategory: TToolButton;
    ilEdit: TcxImageList;
    btnEditCategory: TToolButton;
    btnDelCategory: TToolButton;
    tbBookEdit: TToolBar;
    btnAddBook: TToolButton;
    btnEditBook: TToolButton;
    btnDelBook: TToolButton;
    lstCategories: TcxDBTreeList;
    lstCategoriesCategoryName: TcxDBTreeListColumn;
    dsBooks: TDataSource;
    BooksDS: TAureliusDataset;
    lstCategoriesCategoryID: TcxDBTreeListColumn;
    btnRefresh: TToolButton;
    btnRefreshBook: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure btnCreateObjectClick(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actRefreshLibraryExecute(Sender: TObject);
    procedure actSQLMonitorExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAddCategoryClick(Sender: TObject);
  private
    FManager : TObjectManager;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  Common.DBConnection,
  Model.Entities,
  Aurelius.Criteria.Base,
  Common.Utils;

{$R *.dfm}

procedure TfrmMain.actExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.actRefreshLibraryExecute(Sender: TObject);
begin
  // Обновление библиотеки
  //TController.SynhronizeLibrary;
end;

procedure TfrmMain.actSQLMonitorExecute(Sender: TObject);
begin
  TFrmSqlMonitoring.GetInstance.Show;
end;

procedure TfrmMain.btnAddCategoryClick(Sender: TObject);
begin
  // Новая категория
end;

procedure TfrmMain.btnCreateObjectClick(Sender: TObject);
var
  Cat: TCategory;
  CategoryID : Integer;
begin
  try
    { Новая категория }
    Cat := FManager.Find<TCategory>(1);
    if Cat = nil then begin
      Cat := TCategory.Create;
      Cat.CategoryName := 'Все книги';
      FManager.Save(Cat);
    end;
  except
    ShowError('Не удалось добавить новую категорию');
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  FDBManager : TDatabaseManager;
begin
// Добавляем листенер для SQL
  TDBConnection.GetInstance.AddCommandListener(TfrmSqlMonitoring.GetInstance);

// Обновление структуры БД
  FDBManager := TDBConnection.GetInstance.GetNewDatabaseManager;
  try
    FDBManager.UpdateDatabase;
  finally
    FDBManager.Free;
  end;

// Менеджер объектов
  FManager := TDBConnection.GetInstance.CreateObjectManager;

  with CategoriesDS do begin
    Manager := FManager;
    SetSourceList( FManager.Find<TCategory>.List );
    Open;
  end;

  with BooksDS do begin
    Manager := FManager;
    DatasetField := CategoriesDS.FieldByName('Books') as TDataSetField;
    Open;
  end;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FManager.Free;
  inherited;
end;

end.
