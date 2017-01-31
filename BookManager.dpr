program BookManager;

uses
  Vcl.Forms,
  Vcl.Controls,
  Common.Utils in 'Common.Utils.pas',
  Model.Entities in 'Model.Entities.pas',
  Form.MainForm in 'Form.MainForm.pas' {frmMain},
  Form.SQLMonitoring in 'Form.SQLMonitoring.pas' {frmSQLMonitoring},
  Form.BaseForm in 'Form.BaseForm.pas' {frmBase},
  Form.BaseEditForm in 'Form.BaseEditForm.pas' {frmBaseEditor},
  Form.EditCategory in 'Form.EditCategory.pas' {frmEditCategory},
  Form.EditBook in 'Form.EditBook.pas' {frmEditBook},
  Form.MainView in 'Form.MainView.pas' {frmLibraryView},
  Form.AuditLogViewer in 'Form.AuditLogViewer.pas' {frmAuditLogViewer},
  Common.DatabaseUtils in 'Common.DatabaseUtils.pas',
  WaitForm in 'WaitForm.pas' {Waiting},
  Form.ConnectionDialog in 'Form.ConnectionDialog.pas' {frmDlgConnection},
  ConnectionModule in 'ConnectionModule.pas' {db: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  frmDlgConnection := TfrmDlgConnection.Create(Application);
  try
    if frmDlgConnection.ShowModal = mrOk then begin
      Application.CreateForm(Tdb, dm);
      Application.CreateForm(TfrmMain, frmMain);
      frmMain.DBFile := frmDlgConnection.DBFile;
      Application.Run;
    end;
  finally
    frmDlgConnection.Free;
  end;

end.
