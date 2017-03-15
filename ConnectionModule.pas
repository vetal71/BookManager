unit ConnectionModule;

interface

uses
  System.SysUtils, System.Classes, Data.DB, DBAccess, Uni, DASQLMonitor,
  UniSQLMonitor, UniProvider, SQLiteUniProvider, Common.Utils, MemDS;

type   	     		 	   	     	 	   	    		  	 
  Tdb = class(TDataModule)
    conn: TUniConnection;
    SQLiteProvider: TSQLiteUniProvider;
    SQLMonitor: TUniSQLMonitor;
    Books: TUniDataSource;
    qryBooks: TUniQuery;
    dsCategories: TUniDataSource;
    qryCategories: TUniQuery;
    procedure SQLMonitorSQL(Sender: TObject; Text: string; Flag: TDATraceFlag);
  private
    FDBFile: string;
    FOnSQL: TOnSQLEvent;
    FActiveMonitoring: Boolean;

  private
    procedure SetDBFile(Value: string);
    procedure SetActiveMonitoring(Value: Boolean);
  public
    property DBFile: string          read FDBFile write SetDBFile;
    property OnSQLEvent: TOnSQLEvent read FOnSQL  write FOnSQL;
    property ActiveMonitoring: Boolean read FActiveMonitoring write SetActiveMonitoring;
  end;

var
  DM: Tdb;

implementation

{$R *.dfm}

{ Tdb }

procedure Tdb.SetDBFile(Value: string);
begin
  FDBFile := Value;
  conn.Database := FDBFile;
  try
    conn.Connect;
  except on E: Exception do
    ShowErrorFmt('Ошибка подключения к базе данных %s'#13'%s', [E.Message]);
  end;
end;

procedure Tdb.SetActiveMonitoring(Value: Boolean);
begin
  SQLMonitor.Active := Value;
end;

procedure Tdb.SQLMonitorSQL(Sender: TObject; Text: string; Flag: TDATraceFlag);
begin
  if Assigned(FOnSQL) then
    FOnSQL(Sender, Text, Flag);
end;

end.
