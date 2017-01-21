program TestProject;

uses
  Vcl.Forms,
  TestForm in 'TestForm.pas' {Form1},
  Entities in 'Test\Entities.pas',
  ConnectionModule in 'Test\ConnectionModule.pas' {SQLiteConnectionModule: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TSQLiteConnectionModule, SQLiteConnectionModule);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
