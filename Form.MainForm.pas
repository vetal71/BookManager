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
  Vcl.Grids, Vcl.DBGrids,
  Model.Entities,
  Controller.Category, dxActivityIndicator;

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
    aiProgress: TdxActivityIndicator;
    procedure FormCreate(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actRefreshLibraryExecute(Sender: TObject);
    procedure actSQLMonitorExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAddCategoryClick(Sender: TObject);
    procedure btnEditCategoryClick(Sender: TObject);
    procedure btnDelCategoryClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure BooksDSBeforeOpen(DataSet: TDataSet);
    procedure btnAddBookClick(Sender: TObject);
    procedure btnEditBookClick(Sender: TObject);
    procedure btnRefreshBookClick(Sender: TObject);
    procedure btnDelBookClick(Sender: TObject);
  private
    FManager : TObjectManager;
    FCategories: TList<TCategory>;
    FCategoryController: TCategoryController;

    procedure OpenCategoryDataSet;
    procedure OpenBookDataSet;

    procedure SynhronizeLibrary;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  Common.DBConnection,
  Aurelius.Criteria.Base,
  Common.Utils,
  Controller.Book,
  Form.EditCategory,
  Form.EditBook,
  System.IniFiles,
  Vcl.FileCtrl;

resourcestring
  rsConfirmDeleteRecord = 'Вы действительно хотите удалить %s "%s"?';

{$R *.dfm}

procedure TfrmMain.actExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.actRefreshLibraryExecute(Sender: TObject);
begin
  // Обновление библиотеки
  aiProgress.Visible := True;
  aiProgress.Active  := True;
  try
    Application.ProcessMessages;
    SynhronizeLibrary;
  finally
    aiProgress.Active  := False;
    aiProgress.Visible := False;
  end;
end;

procedure TfrmMain.actSQLMonitorExecute(Sender: TObject);
begin
  TFrmSqlMonitoring.GetInstance.Show;
end;

procedure TfrmMain.BooksDSBeforeOpen(DataSet: TDataSet);
begin
  //ShowInfo('Метод BeforeOpen');
end;

procedure TfrmMain.btnAddBookClick(Sender: TObject);
var
  frmEditBook: TfrmEditBook;
begin
  frmEditBook := TfrmEditBook.Create(Self);
  try
    frmEditBook.Header := 'Новая книга';
    frmEditBook.SetParentCategory(CategoriesDS.Current<TCategory>);
    if frmEditBook.ShowModal = mrOk then begin
      OpenCategoryDataSet;
      OpenBookDataSet;
    end;
  finally
    frmEditBook.Free;
  end;
end;

procedure TfrmMain.btnAddCategoryClick(Sender: TObject);
var
  frmEditCategory: TfrmEditCategory;
begin
  // Новая категория
  frmEditCategory := TfrmEditCategory.Create(Self);
  try
    frmEditCategory.Header := 'Новая категория книг';
    frmEditCategory.SetParentCategory(CategoriesDS.Current<TCategory>);
    if frmEditCategory.ShowModal = mrOk then begin
      OpenCategoryDataSet;
    end;
  finally
    frmEditCategory.Free;
  end;
end;

procedure TfrmMain.btnDelBookClick(Sender: TObject);
var
  Book: TBook;
  Msg: string;
  BookController: TBookController;
begin
  Book := BooksDS.Current<TBook>;
  if ShowConfirmFmt(rsConfirmDeleteRecord, ['книгу', Book.BookName]) then
  begin
    BookController := TBookController.Create;
    try
      BookController.DeleteBook(Book);
      OpenBookDataSet;
    finally
      BookController.Free;
    end;
  end;
end;

procedure TfrmMain.btnDelCategoryClick(Sender: TObject);
var
  Category: TCategory;
  Msg: string;
begin
  Category := CategoriesDS.Current<TCategory>;

  if ShowConfirmFmt(rsConfirmDeleteRecord, ['категорию', Category.CategoryName]) then
  begin
    FCategoryController.DeleteCategory(Category);
    OpenCategoryDataSet;
  end;
end;

procedure TfrmMain.btnEditBookClick(Sender: TObject);
var
  frmEditBook: TfrmEditBook;
  Book: TBook;
begin
  Book := BooksDS.Current<TBook>;
  frmEditBook := TfrmEditBook.Create(Self);
  try
    frmEditBook.Header := Format('Редактирование книги: %s', [Book.BookName]);
    frmEditBook.SetParentCategory(Book.Category);
    if frmEditBook.ShowModal = mrOk then begin
      OpenCategoryDataSet;
      OpenBookDataSet;
    end;
  finally
    frmEditBook.Free;
  end;
end;

procedure TfrmMain.btnEditCategoryClick(Sender: TObject);
var
  frmEditCategory: TfrmEditCategory;
  Category: TCategory;
begin
  // Изменить категорию
  Category := CategoriesDS.Current<TCategory>;
  frmEditCategory := TfrmEditCategory.Create(Self);
  try
    frmEditCategory.SetCategory(Category.CategoryID);
    frmEditCategory.Header := Format('Редактирование категории: %s', [Category.CategoryName]);
    if frmEditCategory.ShowModal = mrOk then begin
      OpenCategoryDataSet;
    end;
  finally
    frmEditCategory.Free;
  end;
end;

procedure TfrmMain.btnRefreshBookClick(Sender: TObject);
begin
  OpenBookDataSet;
end;

procedure TfrmMain.btnRefreshClick(Sender: TObject);
begin
  OpenCategoryDataSet;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  FDBManager : TDatabaseManager;
begin
// Добавляем листенер для SQL мониторинга
  TDBConnection.GetInstance.AddCommandListener(TfrmSqlMonitoring.GetInstance);

// Обновление структуры БД
  FDBManager := TDBConnection.GetInstance.GetNewDatabaseManager;
  try
    FDBManager.UpdateDatabase;
  finally
    FDBManager.Free;
  end;

// Менеджер объектов
  FManager    := TDBConnection.GetInstance.CreateObjectManager;
  FCategoryController := TCategoryController.Create;

  sbMain.Panels[2].Text := Format('Всего книг зарегистрировано в базе данных: %d', [ FManager.FindAll<TBook>.Count ]);

// открытие источников данных
  OpenCategoryDataSet;
  CategoriesDS.First;

  OpenBookDataSet;

  // Информация о БД
  sbMain.Panels[1].Text := Format('База данных: %s', [ TDBConnection.GetDBName ]);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FManager.Free;
  FCategoryController.Free;
  inherited;
end;

procedure TfrmMain.OpenCategoryDataSet;
begin
  with CategoriesDS do begin
    Close;
    Manager := FManager;
    SetSourceList( FCategoryController.GetAllCategory );
    Open;
  end;
end;

procedure TfrmMain.SynhronizeLibrary;
var
  FilesList: TFileRecordList;
  StartDir: string;
begin
  // Синхронизация библиотеки
  with TMemIniFile.Create(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'conn.ini') do begin
    StartDir := ReadString('Path', 'LibraryPath', 'D:\Книги');
  end;

  if StartDir = '' then begin
    // вызов диалога для выбора каталога
    SelectDirectory('Выберите каталог', 'C:\', StartDir);
  end;

  FilesList := TFileRecordList.Create;
  try
    FindAllFiles(FilesList, StartDir, '*.*');
    sbMain.Panels[0].Text := Format('Найдено %d файла(ов)', [FilesList.Count]);
  finally
    FilesList.Free;
  end;
end;

procedure TfrmMain.OpenBookDataSet;
begin
  //  OpenBookDataSet;
  with BooksDS do begin
    Manager := FManager;
    DatasetField := CategoriesDS.FieldByName('Books') as TDataSetField;
    Open;
  end;
end;

end.
