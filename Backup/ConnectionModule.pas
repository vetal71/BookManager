unit ConnectionModule;

interface

uses
  Aurelius.Drivers.Interfaces,
  Aurelius.SQL.SQLite,
  Aurelius.Schema.SQLite,   	     		 	   	     	 	   	    		  	 
  Aurelius.Drivers.SQLite,
  System.SysUtils, System.Classes, Data.DB, Aurelius.Bind.Dataset;

type   	     		 	   	     	 	   	    		  	 
  Tdb = class(TDataModule)
  private
    class var FDBFile: string;
  public
    class function CreateConnection(DBFile: string = ''): IDBConnection;
    class function CreateFactory: IDBConnectionFactory;
  end;

var
  DM: Tdb;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses 
  Aurelius.Drivers.Base;

{$R *.dfm}
   	     		 	   	     	 	   	    		  	 
{ Tdb }

class function Tdb.CreateConnection(DBFile: string = ''): IDBConnection;
begin
  FDBFile := DBFile;
  Result := TSQLiteNativeConnectionAdapter.Create(FDBFile);
  (Result as TSQLiteNativeConnectionAdapter).EnableForeignKeys;
end;

class function Tdb.CreateFactory: IDBConnectionFactory;
begin
  Result := TDBConnectionFactory.Create(
    function: IDBConnection
    begin
      Result := CreateConnection(FDBFile);
    end
  );
end;

end.
