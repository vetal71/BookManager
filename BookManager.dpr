program BookManager;

uses
  Vcl.Forms,
  BM_FMain in 'BM_FMain.pas' {frmMain},
  Entities in 'Entities.pas',
  SYS_uCommon in 'SYS_uCommon.pas',
  SYS_uConnectionModule in 'SYS_uConnectionModule.pas' {SQLiteConnection: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TSQLiteConnection, SQLiteConnection);
  Application.Run;
end.
