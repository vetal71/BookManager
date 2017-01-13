program BookManager;

uses
  Vcl.Forms,
  Entities.Book in 'Entities.Book.pas',
  Common.FileUtils in 'Common.FileUtils.pas',
  Controllers.MainController in 'Controllers.MainController.pas' {SQLiteConnection: TDataModule},
  Utilities.FolderLister in 'Utilities.FolderLister.pas',
  Entities.Category in 'Entities.Category.pas',
  LoggerProConfig in 'LoggerProConfig.pas',
  MainControllerOld in 'MainControllerOld.pas',
  Controllers.EditBookController in 'Controllers.EditBookController.pas',
  Common.DBConnection in 'Common.DBConnection.pas',
  MainForm in 'View\MainForm.pas' {frmMain},
  SQLMonitoring in 'View\SQLMonitoring.pas' {frmSQLMonitoring},
  BaseForm in 'View\BaseForm.pas' {frmBase},
  Controllers.CategoryController in 'Controllers.CategoryController.pas',
  Controllers.EditCategoryController in 'Controllers.EditCategoryController.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmBase, frmBase);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
