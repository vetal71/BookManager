program BookManager;

uses
  Vcl.Forms,
  BM_FMain in 'BM_FMain.pas' {frmMain},
  Entities in 'Entities.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
