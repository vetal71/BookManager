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
  ConnectionModule,
  Model.Entities;

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
    adsCategories: TAureliusDataset;
    adsCategoriesSelf: TAureliusEntityField;
    adsCategoriesID: TIntegerField;
    adsCategoriesCategoryName: TStringField;
    adsCategoriesParent: TAureliusEntityField;
    adsCategoriesBooks: TDataSetField;
    adsBooks: TAureliusDataset;
    adsBooksSelf: TAureliusEntityField;
    adsBooksID: TIntegerField;
    adsBooksBookName: TStringField;
    adsBooksBookLink: TStringField;
    dsCategories: TDataSource;
    dsBooks: TDataSource;
    procedure btnAddCategoryClick(Sender: TObject);
    procedure btnEditCategoryClick(Sender: TObject);
    procedure btnDelCategoryClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnAddBookClick(Sender: TObject);
    procedure btnEditBookClick(Sender: TObject);
    procedure btnRefreshBookClick(Sender: TObject);
    procedure btnDelBookClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure grdBooksViewDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    class var
      FInstance: TfrmLibraryView;
  private
    FManager : TObjectManager;
    FCategories: TList<TCategory>;
    FOwnsManager: Boolean;
  private
    procedure LoadData(SelectedId: Integer = 0);
    function GetBookCount: Integer;
  public
    constructor Create(AOwner: TComponent; AManager: TObjectManager; AOwnsManager: Boolean); reintroduce;

    property BookCount: Integer read GetBookCount;
  end;

var
  frmLibraryView: TfrmLibraryView;

implementation

uses
  Aurelius.Criteria.Base,
  Common.Utils,
  Form.EditCategory,
  Form.EditBook,
  System.IniFiles,
  Vcl.FileCtrl;

{$R *.dfm}

resourcestring
  rsConfirmDeleteRecord = 'Вы действительно хотите удалить %s "%s"?';
  rsErrorDeleteRecord   = 'Не удалось удалить запись "%s"';

{ TfrmLibraryView }

procedure TfrmLibraryView.btnAddBookClick(Sender: TObject);
begin
  //
end;

procedure TfrmLibraryView.btnAddCategoryClick(Sender: TObject);
var
  Category: TCategory;
  Book: TBook;
begin
  Category := TCategory.Create;
  try
    Category.Parent := adsCategories.Current<TCategory>;
    if TfrmEditCategory.Edit(Category, FManager) then begin
      FManager.Save(Category);
    end;
  finally
    for Book in Category.Books do
      if not FManager.IsAttached(Book) then
        Book.Free;

    if not FManager.IsAttached(Category) then
      Category.Free;
  end;
  LoadData(Category.ID);
end;

procedure TfrmLibraryView.btnDelBookClick(Sender: TObject);
var
  BookName: string;
begin
  BookName := adsBooks.Current<TBook>.BookName;
  if ShowConfirmFmt(rsConfirmDeleteRecord, ['книгу', BookName]) then begin
    try
      adsBooks.Delete;
      LoadData(adsCategories.Current<TCategory>.ID);
    except
      ShowErrorFmt(rsErrorDeleteRecord, [BookName]);
    end;
  end;
end;

procedure TfrmLibraryView.btnDelCategoryClick(Sender: TObject);
var
  CategoryName: string;
begin
  CategoryName := adsCategories.Current<TCategory>.CategoryName;
  if ShowConfirmFmt(rsConfirmDeleteRecord, ['категорию', CategoryName]) then
  begin
    try
      LoadData(adsCategories.Current<TCategory>.ID);
    except
      ShowErrorFmt(rsErrorDeleteRecord, [CategoryName]);
    end;
  end;
end;

procedure TfrmLibraryView.btnEditBookClick(Sender: TObject);
var
  Book: TBook;
  Edit: Boolean;
begin
  Book := adsBooks.Current<TBook>;
  if Book = nil then Exit;
  try
    Edit := TfrmEditBook.Edit(Book, FManager);
    if Edit then begin
      FManager.Flush(Book);
    end;
  finally
    if not FManager.IsAttached(Book) then
      Book.Free;
  end;
  if Edit then LoadData(Book.BooksCategory.ID);
end;

procedure TfrmLibraryView.btnEditCategoryClick(Sender: TObject);
var
  Category: TCategory;
  Book: TBook;
  Edit: Boolean;
begin
  Category := adsCategories.Current<TCategory>;
  if Category = nil then Exit;
  Edit := TfrmEditCategory.Edit(Category, FManager);
  if Edit then begin
    FManager.Flush(Category);
  end else begin
    for Book in Category.Books do
      if not FManager.IsAttached(Book) then
        Book.Free;
  end;
  if Edit then LoadData(Category.ID);
end;

procedure TfrmLibraryView.btnRefreshBookClick(Sender: TObject);
begin
  LoadData(adsCategories.Current<TCategory>.ID);
end;

procedure TfrmLibraryView.btnRefreshClick(Sender: TObject);
begin
  LoadData(adsCategories.Current<TCategory>.ID);
end;

constructor TfrmLibraryView.Create(AOwner: TComponent; AManager: TObjectManager;
  AOwnsManager: Boolean);
begin
  inherited Create(AOwner);
  FManager     := AManager;
  FOwnsManager := AOwnsManager;
end;

procedure TfrmLibraryView.FormDestroy(Sender: TObject);
begin
  with dm do begin
    adsCategories.Close;
    adsBooks.Close;
  end;
  if FOwnsManager then
    FManager.Free;
end;

procedure TfrmLibraryView.FormShow(Sender: TObject);
begin
  inherited;
  LoadData;
end;

function TfrmLibraryView.GetBookCount: Integer;
begin
  Result := FManager.Find<TBook>.List.Count;
end;

procedure TfrmLibraryView.grdBooksViewDblClick(Sender: TObject);
var
  FileName: string;
begin
  // вызов программы-читалки
  with dm do begin
    if adsBooks.Current<TBook> = nil then Exit;
    FileName := adsBooks.Current<TBook>.BookLink;
  end;

  ShellExecute(0, '', FileName);
end;

procedure TfrmLibraryView.LoadData(SelectedId: Integer);
var
  Criteria: TCriteria;
begin
  if (SelectedId = 0) and (adsCategories.Current<TCategory> <> nil) then
    SelectedId := adsCategories.Current<TCategory>.ID;
  adsCategories.Close;
  adsBooks.Close;
  FManager.Clear;

  Criteria := FManager.Find<TCategory>.OrderBy('ID');
  adsCategories.SetSourceCriteria(Criteria);

  adsCategories.Open;
  if SelectedId <> 0 then
    adsCategories.Locate('ID', SelectedId, []);
  adsBooks.DatasetField := (adsCategories.FieldByName('Books') as TDataSetField);
  adsBooks.Open;

  lstCategories.FullExpand;
end;

end.
