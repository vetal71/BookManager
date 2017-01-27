unit Form.MainView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Form.BaseForm, dxSkinsCore,
  dxSkinMetropolis, System.ImageList, Vcl.ImgList, cxGraphics, cxClasses,
  cxLookAndFeels, dxSkinsForm, cxControls, cxLookAndFeelPainters, cxCustomData,
  cxStyles, cxTL, cxMaskEdit, cxTLdxBarBuiltInMenu, dxSkinscxPCPainter,
  cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxSplitter, cxInplaceContainer, cxDBTL, cxTLData,
  Vcl.ComCtrls, Vcl.ToolWin, Vcl.ExtCtrls, dxActivityIndicator,
  Aurelius.Bind.Dataset,
  System.Generics.Collections,
  Aurelius.Engine.ObjectManager,

  Model.Entities,
  Controller.Category,
  Controller.Book;

type
  TfrmLibraryView = class(TfrmBase)
    pnlLeft: TPanel;
    tbCategoryEdit: TToolBar;
    btnAddCategory: TToolButton;
    btnEditCategory: TToolButton;
    btnDelCategory: TToolButton;
    btnRefresh: TToolButton;
    lstCategories: TcxDBTreeList;
    lstCategoriesCategoryID: TcxDBTreeListColumn;
    lstCategoriesCategoryName: TcxDBTreeListColumn;
    MainSplitter: TcxSplitter;
    pnlRight: TPanel;
    grdBooks: TcxGrid;
    grdBooksView: TcxGridDBTableView;
    grdBooksViewID: TcxGridDBColumn;
    grdBooksViewBOOK_NAME: TcxGridDBColumn;
    grdBooksViewFILE_LINK: TcxGridDBColumn;
    grdBooksLevel: TcxGridLevel;
    tbBookEdit: TToolBar;
    btnAddBook: TToolButton;
    btnEditBook: TToolButton;
    btnDelBook: TToolButton;
    btnRefreshBook: TToolButton;
    aiProgress: TdxActivityIndicator;
    CategoriesDS: TAureliusDataset;
    dsCategories: TDataSource;
    BooksDS: TAureliusDataset;
    dsBooks: TDataSource;
    procedure btnAddCategoryClick(Sender: TObject);
    procedure btnEditCategoryClick(Sender: TObject);
    procedure btnDelCategoryClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure BooksDSBeforeOpen(DataSet: TDataSet);
    procedure btnAddBookClick(Sender: TObject);
    procedure btnEditBookClick(Sender: TObject);
    procedure btnRefreshBookClick(Sender: TObject);
    procedure btnDelBookClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    class var
      FInstance: TfrmLibraryView;
  private
    FManager : TObjectManager;
    FCategories: TList<TCategory>;
    FCategoryController: TCategoryController;
    FOwnsManager: Boolean;

    procedure OpenCategoryDataSet;
    procedure OpenBookDataSet;
    procedure SynhronizeLibrary;
    class function GetInstance: TfrmLibraryView; static;
  public
    constructor Create(AOwner: TComponent; AManager: TObjectManager; AOwnsManager: Boolean); reintroduce;
  end;

var
  frmLibraryView: TfrmLibraryView;

implementation

uses
  Common.DBConnection,
  Aurelius.Criteria.Base,
  Common.Utils,
  Form.EditCategory,
  Form.EditBook,
  System.IniFiles,
  Vcl.FileCtrl;

{$R *.dfm}

resourcestring
  rsConfirmDeleteRecord = 'Вы действительно хотите удалить %s "%s"?';

{ TfrmLibraryView }

procedure TfrmLibraryView.FormCreate(Sender: TObject);
begin
  inherited;

// открытие источников данных
  OpenCategoryDataSet;
  CategoriesDS.First;

  OpenBookDataSet;
end;

class function TfrmLibraryView.GetInstance: TfrmLibraryView;
begin
  if FInstance = nil then
    FInstance := TfrmLibraryView.Create(Application);
  Result := FInstance;
end;

procedure TfrmLibraryView.BooksDSBeforeOpen(DataSet: TDataSet);
begin
  //ShowInfo('Метод BeforeOpen');
end;

procedure TfrmLibraryView.btnAddBookClick(Sender: TObject);
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

procedure TfrmLibraryView.btnAddCategoryClick(Sender: TObject);
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

procedure TfrmLibraryView.btnDelBookClick(Sender: TObject);
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

procedure TfrmLibraryView.btnDelCategoryClick(Sender: TObject);
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

procedure TfrmLibraryView.btnEditBookClick(Sender: TObject);
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

procedure TfrmLibraryView.btnEditCategoryClick(Sender: TObject);
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

procedure TfrmLibraryView.btnRefreshBookClick(Sender: TObject);
begin
  OpenBookDataSet;
end;

procedure TfrmLibraryView.btnRefreshClick(Sender: TObject);
begin
  OpenCategoryDataSet;
end;

constructor TfrmLibraryView.Create(AOwner: TComponent; AManager: TObjectManager;
  AOwnsManager: Boolean);
begin
  inherited Create(AOwner);
  FManager := AManager;
  FOwnsManager := AOwnsManager;
end;

(*
procedure TfrmLibraryView.actRefreshLibraryExecute(Sender: TObject);
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
*)

procedure TfrmLibraryView.OpenCategoryDataSet;
begin
  with CategoriesDS do begin
    Close;
    Manager := FManager;
    SetSourceList( FCategoryController.GetAllCategory );
    Open;
  end;
end;

procedure TfrmLibraryView.SynhronizeLibrary;
var
  FilesList: TFileRecordList;
  StartDir: string;
begin
  // Синхронизация библиотеки
  with TMemIniFile.Create(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'conn.ini') do begin
    StartDir := ReadString('Path', 'SearchPath', 'D:\Книги');
  end;

  if StartDir = '' then begin
    // вызов диалога для выбора каталога
    SelectDirectory('Выберите каталог', 'C:\', StartDir);
  end;

  FilesList := TFileRecordList.Create;
  try
    FindAllFiles(FilesList, StartDir, '*.*');
    //sbMain.Panels[0].Text := Format('Найдено %d файла(ов)', [FilesList.Count]);
  finally
    FilesList.Free;
  end;
end;

procedure TfrmLibraryView.OpenBookDataSet;
begin
  //  OpenBookDataSet;
  with BooksDS do begin
    Manager := FManager;
    DatasetField := CategoriesDS.FieldByName('Books') as TDataSetField;
    Open;
  end;
end;

end.
