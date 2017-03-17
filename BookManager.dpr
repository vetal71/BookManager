program BookManager;

uses
  Vcl.Forms,
  Vcl.Controls,
  Common.Utils in 'Common.Utils.pas',
  Form.MainForm in 'Form.MainForm.pas' {frmMain},
  Form.SQLMonitoring in 'Form.SQLMonitoring.pas' {frmSQLMonitoring},
  Form.BaseForm in 'Form.BaseForm.pas' {frmBase},
  Form.BaseEditForm in 'Form.BaseEditForm.pas' {frmBaseEditor},
  Form.MainView in 'Form.MainView.pas' {frmLibraryView},
  Common.DatabaseUtils in 'Common.DatabaseUtils.pas',
  Form.ConnectionDialog in 'Form.ConnectionDialog.pas' {frmDlgConnection},
  ConnectionModule in 'ConnectionModule.pas' {DM: TDataModule},
  Form.EditCategory in 'Form.EditCategory.pas' {frmEditCategory},
  Form.EditBook in 'Form.EditBook.pas' {frmEditBook},
  SplashScreenU in 'SplashScreenU.pas' {SplashForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  frmDlgConnection := TfrmDlgConnection.Create(Application);
  try
    if frmDlgConnection.ShowModal = mrOk then begin
      Application.CreateForm(TDM, DM);
  DM.DBFile := frmDlgConnection.DBFile;
      if not DM.ApplicationError then begin
        Application.CreateForm(TfrmMain, frmMain);
        Application.Run;
      end;
    end;
  finally
    frmDlgConnection.Free;
  end;

end.
