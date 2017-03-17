unit ConnectionModule;

interface

uses
  System.SysUtils, System.Classes, Data.DB, DBAccess, Uni, DASQLMonitor,
  UniSQLMonitor, UniProvider, SQLiteUniProvider, Common.Utils, MemDS;

type   	     		 	   	     	 	   	    		  	 
  TDM = class(TDataModule)
    conn: TUniConnection;
    SQLiteProvider: TSQLiteUniProvider;
    SQLMonitor: TUniSQLMonitor;
    Books: TUniDataSource;
    qryBooks: TUniQuery;
    dsCategories: TUniDataSource;
    qryCategories: TUniQuery;
    procedure SQLMonitorSQL(Sender: TObject; Text: string; Flag: TDATraceFlag);
    procedure BooksDataChange(Sender: TObject; Field: TField);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FDBFile: string;
    FOnSQL: TOnSQLEvent;
    FActiveMonitoring: Boolean;
    FApplicationError: Boolean;
    FOnDataChange: TDataChangeEvent;
  private
    procedure SetDBFile(Value: string);
    procedure SetActiveMonitoring(Value: Boolean);
  public
    property DBFile: string          read FDBFile write SetDBFile;
    property OnSQLEvent: TOnSQLEvent read FOnSQL  write FOnSQL;
    property ActiveMonitoring: Boolean read FActiveMonitoring write SetActiveMonitoring;
    property ApplicationError: Boolean read FApplicationError default False;
    property OnDataChange: TDataChangeEvent read FOnDataChange write FOnDataChange;
  end;

var
  DM: TDM;

implementation

uses
  Common.DatabaseUtils;

{$R *.dfm}

{ Tdb }

procedure TDM.SetDBFile(Value: string);
begin
  FDBFile := Value;
  // нет такой базы - создадим
  if not UpdateDatabaseShema(FDBFile) then begin
    ShowError('Неисправимая ошибка. Приложение будет закрыто.');
    FApplicationError := True;
  end;
  conn.Database := FDBFile;
  try
    conn.Connect;
    FillData;
  except on E: Exception do
    ShowErrorFmt('Ошибка подключения к базе данных %s'#13'%s', [E.Message]);
  end;
end;

procedure TDM.BooksDataChange(Sender: TObject; Field: TField);
begin
  if Assigned(FOnDataChange) then
    FOnDataChange(Sender, Field);
end;

procedure TDM.DataModuleDestroy(Sender: TObject);
begin
  SQLMonitor.Active := False;
end;

procedure TDM.SetActiveMonitoring(Value: Boolean);
begin
  SQLMonitor.Active := Value;
end;

procedure TDM.SQLMonitorSQL(Sender: TObject; Text: string; Flag: TDATraceFlag);
begin
  if Assigned(FOnSQL) then
    FOnSQL(Sender, Text, Flag);
end;

end.
