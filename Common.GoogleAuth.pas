unit Common.GoogleAuth;

interface

uses
  ibggdrive, ibgoauth, ibgcore, Common.Utils,
  System.Classes,
  System.SysUtils;

const
  AuthKeysArray: array[0..1] of string =
  (
    'Bearer ya29.GlsUBKDsCD6SbtcN8J9JTdMszZLjLrsHxQmnzZ6GWPXXP00ky7t5fDLEFmFO7yEnKZpe9dZsK801VBxTPNy4FAaigvRo-h3sim9EMCV5XU4A6aANYPEwfQNoIrGY',
    'Bearer ya29.GlsUBAgw23z37pHrliQjH2ro0s59haDvLW42E0qjQ6sfh_eMPb2hzkiOOrlbamiBv6EFPmhG-j4QREM6SRzCZElLUdh61NlHPZKo6-bO-11_Oi0LbbBE3XEEaWj-'
  );

  cClientID           = '157623334268-pdch1uarb3180t5hq2s16ash9ei315j0.apps.googleusercontent.com';
  cClientSecret       = 'k4NSk71U-p2sU8lB8Qv3G24R';
  cServerAuthURL      = 'https://accounts.google.com/o/oauth2/auth';
  cServerTokenURL     = 'https://accounts.google.com/o/oauth2/token';
  cAuthorizationScope = 'https://www.googleapis.com/auth/drive';


type
  TGoogleAuth = class
  private
    class var AuthKeys: TStringList;
    class var LastKey: string;
    class function GenerateAuthKey: string;
    class procedure AuthKeysInit(AStrings: TStringList);
  public
    class procedure DownloadFile(ALocalFile: string);
    class procedure UploadFile(ALocalFile: string);
    class function Authorization(AGD: TibgGDrive): Boolean;
    class function FindFile(AGD: TibgGDrive; AFileName: string): Integer;
  end;

implementation

uses
  System.IniFiles;

{ TGoogleAuth }

function Auth(AGD: TibgGDrive; AKey: string): Boolean;
begin
  AGD.Authorization := AKey;
  try
    AGD.ListResources;
    Result := True;
  except
    Result := False;
  end;
end;

// параметр ALocalFile - полный путь к файлу
class procedure TGoogleAuth.AuthKeysInit(AStrings: TStringList);
var
  I: Integer;
  StoreKey: string;
begin
  for I := 0 to High(AuthKeysArray) do
    AStrings.Add(AuthKeysArray[ I ]);
  with TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'auth.key') do try
    StoreKey := ReadString('AUTH', 'AUTHKEY', '');
  finally
    Free;
  end;
  if not StoreKey.IsEmpty then
    AStrings.Add(StoreKey);
end;

class function TGoogleAuth.Authorization(AGD: TibgGDrive): Boolean;
var
  I: Integer;
begin
  for I := 0 to AuthKeys.Count - 1 do begin
    Result := Auth(AGD, AuthKeys[ I ]);
    if Result then Break;
  end;
  if not Result then begin
    LastKey := GenerateAuthKey;
    Result := Auth(AGD, LastKey);
  end;
end;

class procedure TGoogleAuth.DownloadFile(ALocalFile: string);
var
  GD: TibgGDrive;
  I: Integer;
  FName: string;
begin
  GD := TibgGDrive.Create(nil);
  try
    // инициализируем коллекцию ключей
    AuthKeys := TStringList.Create;
    AuthKeysInit(AuthKeys);
    try
      if not Authorization(GD) then
        raise Exception.Create('Не удалось подключить Google Drive.')
      else begin
        with TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'auth.key') do try
          WriteString('AUTH', 'AUTHKEY', LastKey);
        finally
          Free;
        end;
      end;
    finally
      AuthKeys.Free;
    end;

    if GD.ResourceCount = 0 then
        raise Exception.Create('Не удалось получить список файлов с Google Drive.');

    FName := ExtractFileName(ALocalFile);
    // поиск файла
    GD.ResourceIndex := FindFile(GD, FName);

    if GD.ResourceIndex = -1 then
      raise Exception.CreateFmt('Не удалось найти файл %s Google Drive.', [FName]);

    GD.LocalFile := ALocalFile;
    GD.Overwrite := True;
    try
      GD.DownloadFile('');
      ShowInfoFmt('Файл %s успешно загружен c Google Drive.', [FName]);
    except on ex: EInGoogle do
      ShowError('Ошибка загрузки файла с Google Drive: ' + ex.Message);
    end;

  finally
    GD.Free;
  end;
end;

class function TGoogleAuth.FindFile(AGD: TibgGDrive;
  AFileName: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to AGD.ResourceCount - 1 do begin
    AGD.ResourceIndex := i;
    if CompareText(AFileName, Utf8ToAnsi(AGD.ResourceTitle)) = 0 then begin
      Result := AGD.ResourceIndex;
      Break;
    end;
  end;
end;

class function TGoogleAuth.GenerateAuthKey: string;
var
  OAuth: TibgOAuth;
begin
  OAuth := TibgOAuth.Create(nil);
  try
    OAuth.ClientId           := cClientID;
    OAuth.ClientSecret       := cClientSecret;
    OAuth.ServerAuthURL      := cServerAuthURL;
    OAuth.ServerTokenURL     := cServerTokenURL;
    OAuth.AuthorizationScope := cAuthorizationScope;
    Result := OAuth.GetAuthorization;
  finally
    OAuth.Free;
  end;
end;

class procedure TGoogleAuth.UploadFile(ALocalFile: string);
var
  GD: TibgGDrive;
  I: Integer;
  FName: string;
begin
  GD := TibgGDrive.Create(nil);
  try
    // инициализируем коллекцию ключей
    AuthKeys := TStringList.Create;
    AuthKeysInit(AuthKeys);
    try
      if not Authorization(GD) then
        raise Exception.Create('Не удалось подключить Google Drive.')
      else begin
        with TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'auth.key') do try
          WriteString('AUTH', 'AUTHKEY', LastKey);
        finally
          Free;
        end;
      end;
    finally
      AuthKeys.Free;
    end;

    if GD.ResourceCount = 0 then
      raise Exception.Create('Не удалось получить список файлов с Google Drive.');

    FName := ExtractFileName(ALocalFile);
    // поиск файла
    GD.ResourceIndex := FindFile(GD, FName);
    // нашли - удалим
    if GD.ResourceIndex <> -1 then begin
      GD.DeleteResource();
    end;

    GD.ResourceIndex := -1;
    GD.LocalFile := ALocalFile;
    try
      GD.UploadFile(FName);
      ShowInfoFmt('Файл %s успешно загружен на Google Drive.', [FName]);
    except on ex: EInGoogle do
      ShowError('Ошибка сохранения файла в Google Drive: ' + ex.Message);
    end;
  finally
    GD.Free;
  end;
end;

end.
