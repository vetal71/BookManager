unit SYS_uConnectionModule;

interface

uses
  Aurelius.Drivers.Interfaces,
  Aurelius.Sql.SQLite,
  Aurelius.Drivers.SQLite,
  Aurelius.Schema.SQLite,
  Aurelius.Drivers.Base,
  System.SysUtils, System.Classes;

type
  TSQLiteConnection = class(TDataModule)
  public
    class function CreateConnection: IDBConnection;
    class function CreateFactory: IDBConnectionFactory;
  end;

var
  SQLiteConnection: TSQLiteConnection;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TSQLiteConnection }

class function TSQLiteConnection.CreateConnection: IDBConnection;
begin
  Result := TSQLiteNativeConnectionAdapter.Create(ParamStr(0) + '.db');
end;

class function TSQLiteConnection.CreateFactory: IDBConnectionFactory;
begin
  Result := TDBConnectionFactory.Create(
    function: IDBConnection
    begin
      Result := CreateConnection;
    end
  );
end;

end.
