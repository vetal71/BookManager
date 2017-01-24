unit Common.DBConnection;

interface

uses
  Generics.Collections,
  Classes, IniFiles,
  Aurelius.Commands.Listeners,
  Aurelius.Drivers.Interfaces,
  Aurelius.Engine.AbstractManager,
  Aurelius.Engine.ObjectManager,
  Aurelius.Engine.DatabaseManager,
  Aurelius.Drivers.SQLite,
  Aurelius.Schema.SQLite,
  Aurelius.Sql.SQLite;

type
  TDBConnection = class sealed
  private
    class var FInstance: TDBConnection;
    class var FDBName: string;
  private
    FConnection: IDBConnection;
    FListeners: TList<ICommandExecutionListener>;

    procedure PrivateCreate;
    procedure PrivateDestroy;

    function ConnectionFileName: string;
    function CreateConnectionFromIniFile: IDBConnection;
    function CreateSQLiteAdapterFromIniFile(AIniFile: TMemIniFile): IDBConnection;

    function CreateConnection: IDBConnection;
    function GetConnection: IDBConnection;
    procedure AddListeners(AManager: TAbstractManager);
  public
    class function GetInstance: TDBConnection;
    class function GetDBName: string;
    procedure AddCommandListener(Listener: ICommandExecutionListener);
    class procedure AddLines(List: TStrings; SQL: string; Params: TEnumerable<TDBParam>);

    property Connection: IDBConnection read GetConnection;

    function HasConnection: boolean;
    function CreateObjectManager: TObjectManager;
    function GetNewDatabaseManager: TDatabaseManager;
    procedure UnloadConnection;

    procedure SaveSQLiteSettings(ASQLiteFile: string);
    function DefaultSQLiteDatabase: string;
    function IsSQLiteSupported: boolean;
  end;

implementation
uses
  Variants, DB, SysUtils, TypInfo;

{ TDBConnection }

procedure TDBConnection.AddCommandListener(
  Listener: ICommandExecutionListener);
begin
  FListeners.Add(Listener);
end;

//------------------------------------------------------------------------------
// Процедура для добавления параметров и их значений в SQL листинг
//------------------------------------------------------------------------------
class procedure TDBConnection.AddLines(List: TStrings; SQL: string;
  Params: TEnumerable<TDBParam>);
var
  P: TDBParam;
  ValueAsString: string;
  HasParams: Boolean;
begin
  List.Add(SQL);

  if Params <> nil then
  begin
    HasParams := False;
    for P in Params do
    begin
      if not HasParams then
      begin
        List.Add('');
        HasParams := True;
      end;

      if P.ParamValue = Variants.Null then
        ValueAsString := 'NULL'
      else
      if P.ParamType = ftDateTime then
        ValueAsString := '"' + DateTimeToStr(P.ParamValue) + '"'
      else
      if P.ParamType = ftDate then
        ValueAsString := '"' + DateToStr(P.ParamValue) + '"'
      else
        ValueAsString := '"' + VarToStr(P.ParamValue) + '"';

      List.Add(P.ParamName + ' = ' + ValueAsString + ' (' +
        GetEnumName(TypeInfo(TFieldType), Ord(P.ParamType)) + ')');
    end;
  end;

  List.Add('');
  List.Add('================================================');
end;

procedure TDBConnection.AddListeners(AManager: TAbstractManager);
var
  Listener: ICommandExecutionListener;
begin
  for Listener in FListeners do
    AManager.AddCommandListener(Listener);
end;

function TDBConnection.ConnectionFileName: string;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'conn.ini';
end;

function TDBConnection.CreateConnectionFromIniFile: IDBConnection;
var
  IniFile: TMemIniFile;
  AureliusDriver: string;
begin
  Result := nil;
  if not FileExists(ConnectionFileName) then
    Exit;

  IniFile := TMemIniFile.Create(ConnectionFileName);
  try
    AureliusDriver := LowerCase(IniFile.ReadString('Config', 'AureliusDriver', ''));
    if (AureliusDriver = 'sqlite') then
      Result := CreateSQLiteAdapterFromIniFile(IniFile);
  finally
    IniFile.Free;
  end;
end;

procedure TDBConnection.UnloadConnection;
begin
  if FConnection <> nil then
  begin
    FConnection.Disconnect;
    FConnection := nil;
  end;
end;

function TDBConnection.CreateConnection: IDBConnection;
begin
  if FConnection <> nil then
    Exit(FConnection);

  if FConnection = nil then
    FConnection := CreateConnectionFromIniFile;
  if FConnection = nil then
    Exit;
  Result := FConnection;
end;

function TDBConnection.GetConnection: IDBConnection;
begin
  Result := CreateConnection;
  if Result = nil then
    raise Exception.Create('Неверные настройки соединения. Соединение с базой данных невозможно.');
  if not Result.IsConnected then
    Result.Connect;
end;

class function TDBConnection.GetDBName: string;
begin
  Result := FDBName;
end;

class function TDBConnection.GetInstance: TDBConnection;
begin
  if FInstance = nil then
  begin
    FInstance := TDBConnection.Create;
    FInstance.PrivateCreate;
  end;
  Result := FInstance;
end;

function TDBConnection.GetNewDatabaseManager: TDatabaseManager;
begin
  Result := TDatabaseManager.Create(Connection);
  AddListeners(Result);
end;

function TDBConnection.CreateObjectManager: TObjectManager;
begin
  Result := TObjectManager.Create(Connection);
  Result.OwnsObjects := True;
  AddListeners(Result);
end;

function TDBConnection.CreateSQLiteAdapterFromIniFile(
  AIniFile: TMemIniFile): IDBConnection;
var
  SQLiteFile: string;
begin
  Result := nil;
  SQLiteFile := AIniFile.ReadString('Config', 'SQLiteFile', '');
  FDBName := SQLiteFile;
  Result := TSQLiteNativeConnectionAdapter.Create(SQLiteFile);
end;

function TDBConnection.DefaultSQLiteDatabase: string;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'Simple.db';
end;

function TDBConnection.HasConnection: boolean;
begin
  Result := CreateConnection <> nil;
end;

function TDBConnection.IsSQLiteSupported: boolean;
begin
  Result := true;
end;

procedure TDBConnection.PrivateCreate;
begin
  FListeners := TList<ICommandExecutionListener>.Create;
end;

procedure TDBConnection.PrivateDestroy;
begin
  UnloadConnection;
  FListeners.Free;
end;

procedure TDBConnection.SaveSQLiteSettings(ASQLiteFile: string);
var
  IniFile: TMemIniFile;
begin
  IniFile := TMemIniFile.Create(ConnectionFileName);
  try
    IniFile.WriteString('Config', 'AureliusDriver', 'SQLite');
    IniFile.WriteString('Config', 'SQLiteFile', ASQLiteFile);
    IniFile.UpdateFile;
  finally
    IniFile.Free;
  end;
end;

initialization

finalization
  if TDBConnection.FInstance <> nil then
  begin
    TDBConnection.FInstance.PrivateDestroy;
    TDBConnection.FInstance.Free;
    TDBConnection.FInstance := nil;
  end;

end.

