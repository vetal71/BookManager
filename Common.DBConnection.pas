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
  class var
    FDBFile: string;
  public
    class function CreateConnection(DBFile: string = ''): IDBConnection;
    class function CreateFactory: IDBConnectionFactory;
  end;

implementation

uses
  Variants, DB, SysUtils, TypInfo, Aurelius.Drivers.Base;

{ TDBConnection }

class function TDBConnection.CreateConnection(DBFile: string = ''): IDBConnection;
const
  cDefaultDB = 'BooksLibrary.db';
begin
//  if DBFile = '' then
//    DBFile := cDefaultDB;
  FDBFile := DBFile;
  Result := TSQLiteNativeConnectionAdapter.Create(FDBFile);
  (Result as TSQLiteNativeConnectionAdapter).EnableForeignKeys;
end;

class function TDBConnection.CreateFactory: IDBConnectionFactory;
begin
  Result := TDBConnectionFactory.Create(
    function: IDBConnection
    begin
      Result := CreateConnection(FDBFile);
    end
  );
end;

end.

