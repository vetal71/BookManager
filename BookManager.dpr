program BookManager;

uses
  Vcl.Forms,
  BM_FMain in 'BM_FMain.pas' {frmMain},
  Entities.Book in 'Entities.Book.pas',
  SYS_uCommon in 'SYS_uCommon.pas',
  SYS_uConnectionModule in 'SYS_uConnectionModule.pas' {SQLiteConnection: TDataModule},
  FolderLister in 'FolderLister.pas',
  Entities.Category in 'Entities.Category.pas',
  LoggerProConfig in 'LoggerProConfig.pas',
  MainController in 'MainController.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TSQLiteConnection, SQLiteConnection);
  Application.Run;
end.
