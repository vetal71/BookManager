unit BM_FMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dxSkinsCore, dxBevel, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinMetropolis,
  dxSkinsdxStatusBarPainter, dxSkinsdxBarPainter, dxSkinsForm, System.ImageList,
  Vcl.ImgList, dxBar, cxClasses, dxStatusBar,
  Aurelius.Drivers.Interfaces,
  Aurelius.Engine.DatabaseManager,
  Aurelius.Engine.ObjectManager,
  Entities.Book, Entities.Category,
  SYS_uConnectionModule, Vcl.Menus, Vcl.StdCtrls, cxButtons, System.Actions,
  Vcl.ActnList, cxSplitter, Vcl.ExtCtrls, Data.DB, Aurelius.Bind.Dataset;

type
  TfrmMain = class(TForm)
    brMain: TdxBarManager;
    brmMainToolbar: TdxBar;
    btnRefreshLib: TdxBarLargeButton;
    sbMain: TdxStatusBar;
    sknMain: TdxSkinController;
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
    AureliusDataset1: TAureliusDataset;
    pnlLeft: TPanel;
    MainSplitter: TcxSplitter;
    pnlRight: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure btnCreateObjectClick(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actRefreshLibraryExecute(Sender: TObject);
  private
    FDBConnection: IDBConnection;
    FDBManager: TDatabaseManager;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  LoggerProConfig, MainController;

{$R *.dfm}

procedure TfrmMain.actExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.actRefreshLibraryExecute(Sender: TObject);
begin
  // Обновление библиотеки
  TController.SynhronizeLibrary;
end;

procedure TfrmMain.btnCreateObjectClick(Sender: TObject);
(*
var
  Manager: TObjectManager;
  Book: TBook;
  Cat: TCategory;
  CategoryID : Integer;
*)
begin
(*
  Manager := TObjectManager.Create(FDBConnection);
  try
    { Новая категория }
    Cat := TCategory.Create('Прочие');
    Manager.Save(Cat);
    CategoryID := Cat.Id;

    Book := TBook.Create;
    Book.BookName := 'First Book record';
    Book.Category := Manager.Find<TCategory>(CategoryID);

    Manager.Save(Book);
  finally
    Manager.Free;
  end;
*)
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FDBConnection := TController.DBConnection;
  FDBManager    := TDatabaseManager.Create(FDBConnection);
  try
    FDBManager.UpdateDatabase;
  finally
    FDBManager.Free;
  end;
end;

end.
