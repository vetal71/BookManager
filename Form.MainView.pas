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
  System.Generics.Collections, Uni,
  ConnectionModule,
  cxContainer, cxTextEdit, Vcl.StdCtrls, System.Actions, Vcl.ActnList, cxMemo;

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
    lstCategoriesCntBook: TcxDBTreeListColumn;
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
    procedure grdBooksViewCustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure lstCategoriesCustomDrawDataCell(Sender: TcxCustomTreeList;
      ACanvas: TcxCanvas; AViewInfo: TcxTreeListEditCellViewInfo;
      var ADone: Boolean);
  private
    FBookID: Integer;
  private
    function GetBookCount: Integer;
    procedure BooksChange(Sender: TObject);
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
  Common.DatabaseUtils,
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
  if not btnRun.Enabled then Exit;

  with dm do begin
    FileName := qryBooks.FieldByName('BookLink').AsString;
    if FileName.IsEmpty then Exit;
  end;
  ShellExecute(0, '', FileName);
end;

procedure TfrmLibraryView.BooksChange(Sender: TObject);
var
  BookLink: string;
begin
  if not Assigned(Sender) then Exit;
  BookLink := DM.qryBooks.FieldByName('BookLink').AsString;
  btnRun.Enabled := FileExists(BookLink);
  btnDelBook.Enabled := btnRun.Enabled;
end;

procedure TfrmLibraryView.btnAddBookClick(Sender: TObject);
begin
  DM.qryBooks.Append;
  TfrmEditBook.Edit(emAppend);
end;

procedure TfrmLibraryView.btnAddCategoryClick(Sender: TObject);
begin
  with DM.qryCategories do begin
    Append;
    // генерим новый ID
    FieldByName('Id').AsInteger := GetFieldValue(['max(Id)+1', 'Categories', 'Id < 1000']);
    // по умолчанию категория 1
    FieldByName('Parent_Id').AsInteger := 1;
  end;
  TfrmEditCategory.Edit(emAppend);
end;

procedure TfrmLibraryView.btnDelBookClick(Sender: TObject);
var
  BookName, BookLink: string;
begin
  if not btnDelBook.Enabled then Exit;

  BookName := DM.qryBooks.FieldByName('BookName').asString;
  BookLink := DM.qryBooks.FieldByName('BookLink').AsString;
  if ShowConfirmFmt(rsConfirmDeleteRecord, ['книгу', BookName]) then begin
    DM.conn.StartTransaction;
    try
      DM.qryBooks.Delete;
      if FileExists(BookLink) then begin
        if ShowConfirm('Удалить файл с диска ?') then begin
          if not DeleteFile(BookLink) then begin
            raise Exception.CreateFmt('Не удалось удалить книгу. Код ошибки', [ GetLastError ]);
          end;
        end;
      end;
      DM.conn.Commit;
    except
      DM.conn.Rollback;
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

procedure TfrmLibraryView.FormCreate(Sender: TObject);
begin
  DM.RegChangeNotifier(BooksChange);
end;

procedure TfrmLibraryView.FormDestroy(Sender: TObject);
begin
  with dm do begin
    UnregChangeNotifier(BooksChange);
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
  with TUniQuery.Create(nil) do try
    Connection := DM.conn;
    SQL.Text := 'select count(*) as Cnt from Books';
    Open;
    if not IsEmpty then
      Result := FieldByName('Cnt').AsInteger;
    Close;
  finally
    Free;
  end;
end;

procedure TfrmLibraryView.grdBooksViewCustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
Var
  lTextToDraw: string;
  lColFont: TFont;
begin
  lColFont := ACanvas.Font;                                                     //сохраняем настройки шрифта по умолчанию для текущей ячейки
  lTextToDraw := trim(AViewInfo.GridRecord.DisplayTexts[ 2 ]);                  //считываем содержимое 2ого столбца
  if ( not lTextToDraw.IsEmpty ) and ( not FileExists( lTextToDraw ) ) then begin
    lColFont.Style := [ fsStrikeOut, fsItalic ];
    lColFont.Color := clRed;
  end;
  ACanvas.Font := lColFont;                                                     //устанавливаем получившиеся выделение для всей строки
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

procedure TfrmLibraryView.lstCategoriesCustomDrawDataCell(
  Sender: TcxCustomTreeList; ACanvas: TcxCanvas;
  AViewInfo: TcxTreeListEditCellViewInfo; var ADone: Boolean);
var
  lColFont: TFont;
begin
  lColFont := ACanvas.Font;
  if AViewInfo.Column.ItemIndex = 2 then begin
    lColFont.Color := clRed;
    lColFont.Style := [ fsBold ];
  end;
  ACanvas.Font := lColFont;
end;

end.
