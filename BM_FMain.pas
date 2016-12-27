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
  Entities,
  SYS_uConnectionModule, Vcl.Menus, Vcl.StdCtrls, cxButtons;

type
  TfrmMain = class(TForm)
    brMain: TdxBarManager;
    brmMainToolbar: TdxBar;
    btnFind: TdxBarLargeButton;
    ilBig: TcxImageList;
    sbMain: TdxStatusBar;
    sknMain: TdxSkinController;
    dxBevel1: TdxBevel;
    btnCreateObject: TcxButton;
    procedure FormCreate(Sender: TObject);
    procedure btnCreateObjectClick(Sender: TObject);
  private
    FDBConnection: IDBConnection;
    FDBManager: TDatabaseManager;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.btnCreateObjectClick(Sender: TObject);
var
  Manager: TObjectManager;
  Book: TBook;
begin
  Manager := TObjectManager.Create(FDBConnection);
  try
    Book := TBook.Create;
    Book.Name := 'First Book record';
    Manager.Save(Book);
  finally
    Manager.Free;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FDBConnection := TSQLiteConnection.CreateConnection;
  FDBManager    := TDatabaseManager.Create(FDBConnection);
  FDBManager.UpdateDatabase;
  FDBManager.Free;
end;

end.
