unit Form.ConnectionDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Form.BaseEditForm, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore,
  dxSkinMetropolis, System.ImageList, Vcl.ImgList, cxClasses, dxSkinsForm,
  Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxPropertiesStore;

type
  TfrmDlgConnection = class(TfrmBaseEditor)
    cbbConnections: TcxComboBox;
    psDefaultParams: TcxPropertiesStore;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    function GetDBFile: string;
  public
    property DBFile: string read GetDBFile;
  end;

var
  frmDlgConnection: TfrmDlgConnection;

implementation

uses
  System.IniFiles, synautil, Common.Utils, ibggdrive, ibgcore;

{$R *.dfm}

procedure TfrmDlgConnection.FormCreate(Sender: TObject);
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'conn.ini');
  try
    ini.ReadSectionValues('Database', cbbConnections.Properties.Items);
  finally
    ini.Free;
  end;
  psDefaultParams.RestoreFrom;
end;

procedure TfrmDlgConnection.FormDestroy(Sender: TObject);
begin
  inherited;
  psDefaultParams.StoreTo();
end;

function TfrmDlgConnection.GetDBFile: string;
var
  DBFile, DBFileType, LocalDBFile: string;
  I: Integer;
begin
  DBFileType := SeparateLeft(cbbConnections.Text, '=');
  DBFile     := SeparateRight(cbbConnections.Text, '=');
  if CompareText('GDrive', DBFileType) = 0 then begin
    // 1. Соединяемся с Google Drive
    // 2. Скачиваем файл БД
    with TibgGDrive.Create(nil) do try
      try
        Screen.Cursor := crHourGlass;
        Authorization := cGDriveKey;

        ResourceIndex := -1;
        ListResources();

        for i := 0 to ResourceCount - 1 do begin
          ResourceIndex := i;
          if CompareText(DBFile, Utf8ToAnsi(ResourceTitle)) = 0 then Break;
        end;

        // резервная копия локального файла
        LocalDBFile := ExtractFilePath(ParamStr(0)) + DBFile;
        if FileExists(LocalDBFile) then begin
          if not RenameFile(LocalDBFile, ChangeFileExt(LocalDBFile, '.bak')) then
            ShowErrorFmt('Резервная копия файла базы данных не создана. Код ошибки %d', [GetLastError]);
        end;

        LocalFile := LocalDBFile;
        DownloadFile('');

      except on ex: EInGoogle do
        ShowError('Ошибка загрузки файла из Google Drive: ' + ex.Message);
      end;
    finally
      Screen.Cursor := crDefault;
      Free;
    end;
  end;
  Result := DBFile;
end;

end.
