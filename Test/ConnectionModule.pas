unit ConnectionModule;

interface

uses
  Aurelius.Drivers.Interfaces,
  Aurelius.Sql.SQLite,
  Aurelius.Schema.SQLite,
  Aurelius.Drivers.Base,
  Aurelius.Drivers.SQLite,
  System.SysUtils, System.Classes, Data.DB,
  Aurelius.Bind.Dataset;

type
  TSQLiteConnectionModule = class(TDataModule)
    AureliusDataset1: TAureliusDataset;
    ds1: TDataSource;
    AureliusDataset2: TAureliusDataset;
    ds2: TDataSource;
  private
  public
    class function CreateConnection: IDBConnection;
    class function CreateFactory: IDBConnectionFactory;
  end;

var
  SQLiteConnectionModule: TSQLiteConnectionModule;

implementation

uses
  Entities;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TSQLiteConnectionModule }

class function TSQLiteConnectionModule.CreateConnection: IDBConnection;
begin
  Result := TSQLiteNativeConnectionAdapter.Create( ExtractFilePath( ParamStr(0) ) + 'Simple.db' );
end;

class function TSQLiteConnectionModule.CreateFactory: IDBConnectionFactory;
begin
  Result := TDBConnectionFactory.Create(
    function: IDBConnection
    begin
      Result := CreateConnection;
    end
  );
end;

end.
