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
  System.Generics.Collections,
  ConnectionModule,
  cxContainer, cxTextEdit, Vcl.StdCtrls, System.Actions, Vcl.ActnList;

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
    btnRun: TToolButton;
    procedure btnAddCategoryClick(Sender: TObject);
    procedure btnEditCategoryClick(Sender: TObject);
    procedure btnDelCategoryClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnAddBookClick(Sender: TObject);
    procedure btnEditBookClick(Sender: TObject);
    procedure btnRefreshBookClick(Sender: TObject);
    procedure btnDelBookClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnRunClick(Sender: TObject);
  private
    FBookID: Integer;
  private
    function GetBookCount: Integer;
  public
    procedure LoadData;
  public
    property BookCount: Integer read GetBookCount;
  end;

var
  frmLibraryView: TfrmLibraryView;

implementation

uses
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

procedure TfrmLibraryView.btnRunClick(Sender: TObject);
var
  FileName: string;
begin
  // вызов программы-читалки
  with dm do begin
    FileName := qryBooks.FieldByName('BookLink').AsString;
    if FileName.IsEmpty then Exit;
  end;
  ShellExecute(0, '', FileName);
end;

procedure TfrmLibraryView.btnAddBookClick(Sender: TObject);
begin
  DM.qryBooks.Append;
  TfrmEditBook.Edit(emAppend);
//  LoadData;
end;

procedure TfrmLibraryView.btnAddCategoryClick(Sender: TObject);
begin
  DM.qryCategories.Append;
  TfrmEditCategory.Edit(emAppend);
//  LoadData;
end;

procedure TfrmLibraryView.btnDelBookClick(Sender: TObject);
var
  BookName: string;
begin
  BookName := DM.qryBooks.FieldByName('BookName').asString;
  if ShowConfirmFmt(rsConfirmDeleteRecord, ['книгу', BookName]) then begin
    try
      DM.qryBooks.Delete;
    except
      ShowErrorFmt(rsErrorDeleteRecord, [BookName]);
    end;
  end;
end;

procedure TfrmLibraryView.btnDelCategoryClick(Sender: TObject);
var
  CategoryName: string;
begin
  CategoryName := DM.qryCategories.FieldByName('CategoryName').asString;
  if ShowConfirmFmt(rsConfirmDeleteRecord, ['категорию', CategoryName]) then
  begin
    try
      DM.qryCategories.Delete;
    except
      ShowErrorFmt(rsErrorDeleteRecord, [CategoryName]);
    end;
  end;
end;

procedure TfrmLibraryView.btnEditBookClick(Sender: TObject);
begin
  DM.qryBooks.Edit;
  TfrmEditBook.Edit(emEdit);
  btnRefreshClick(nil);
end;

procedure TfrmLibraryView.btnEditCategoryClick(Sender: TObject);
begin
  DM.qryCategories.Edit;
  TfrmEditCategory.Edit(emEdit);
  btnRefreshClick(nil);
end;

procedure TfrmLibraryView.btnRefreshBookClick(Sender: TObject);
begin
  btnRefreshClick(nil);
end;

procedure TfrmLibraryView.btnRefreshClick(Sender: TObject);
var
  CategoryBookmark, Bookmark: TBookmark;
begin
  with DM do begin
    if qryCategories.Active then
      CategoryBookmark := qryCategories.GetBookmark;
    if qryBooks.Active then
      Bookmark := qryBooks.GetBookmark;
    LoadData;
    qryCategories.GotoBookmark(CategoryBookmark);
    qryBooks.GotoBookmark(Bookmark);
  end;
end;

procedure TfrmLibraryView.FormDestroy(Sender: TObject);
begin
  with dm do begin
    qryCategories.Close;
    qryBooks.Close;
  end;
end;

procedure TfrmLibraryView.FormShow(Sender: TObject);
begin
  inherited;
  LoadData;
end;

function TfrmLibraryView.GetBookCount: Integer;
begin
  Result := DM.qryBooks.RecordCount;
end;

procedure TfrmLibraryView.LoadData;
begin
  with DM do begin
    if qryBooks.Active then
      qryBooks.Close;
    if qryCategories.Active then
      qryCategories.Close;
    qryCategories.Open;
    qryBooks.Open;
  end;
  lstCategories.FullExpand;
end;

end.
