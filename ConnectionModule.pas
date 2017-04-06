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
    procedure qryBooksAfterDelete(DataSet: TDataSet);
    procedure dsCategoriesDataChange(Sender: TObject; Field: TField);
  private
    FDBFile: string;
    FOnSQL: TOnSQLEvent;
    FActiveMonitoring: Boolean;
    FApplicationError: Boolean;
    FOnAfterDelete: TDataSetNotifyEvent;
    FNotifiers: array of TNotifyEvent;
  private
    procedure SetDBFile(Value: string);
    procedure SetActiveMonitoring(Value: Boolean);
    procedure DoBookChangeNotifier;
  public
    property DBFile: string          read FDBFile write SetDBFile;
    property OnSQLEvent: TOnSQLEvent read FOnSQL  write FOnSQL;
    property ActiveMonitoring: Boolean read FActiveMonitoring write SetActiveMonitoring;
    property ApplicationError: Boolean read FApplicationError default False;
    property OnDeleteBook: TDataSetNotifyEvent read FOnAfterDelete write FOnAfterDelete;

    // обработка подписки на события
    procedure RegChangeNotifier(const aProc: TNotifyEvent);
    procedure UnregChangeNotifier(const aProc: TNotifyEvent);
    function NotifierRegistered(const aProc: TNotifyEvent): Boolean;
  end;


var
  DM: TDM;

implementation

uses
  Common.DatabaseUtils,
  OtlParallel,
  System.IniFiles;

{$R *.dfm}

{ Tdb }

procedure TDM.SetDBFile(Value: string);
var
  vFuture: IOmniFuture<integer>;
  SilentMode: Boolean;
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
    with TIniFile.Create(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'conn.ini') do try
    // параметр конфигурации "Тихий режим"
      SilentMode := ReadBool('Config', 'SilentMode', False);
    finally
      Free;
    end;
    if SilentMode then begin
      // Запускаем вычисления в параллельном потоке
      vFuture := Parallel.Future<integer>(
        function: integer
        begin
          Result := 0;
          FillData;
        end
      )
    end else FillData;
  except on E: Exception do
    ShowErrorFmt('Ошибка подключения к базе данных %s'#13'%s', [FDBFile, E.Message]);
  end;
end;

procedure TDM.BooksDataChange(Sender: TObject; Field: TField);
begin
  DoBookChangeNotifier;
end;

procedure TDM.DataModuleDestroy(Sender: TObject);
begin
  SQLMonitor.Active := False;
end;

procedure TDM.DoBookChangeNotifier;
var
  i: Integer;
begin
  for i := 0 to High(FNotifiers) do
    FNotifiers[ i ](Self);
end;

procedure TDM.dsCategoriesDataChange(Sender: TObject; Field: TField);
begin
  // Для категории 1 - Все книги Master := nil
  if qryCategories.FieldValues['ID'] = 1 then begin
    qryBooks.MasterSource := nil;
  end else begin
    qryBooks.MasterSource := dsCategories;
    qryBooks.MasterFields := 'ID';
    qryBooks.DetailFields := 'CATEGORY_ID';
    qryBooks.KeyFields    := 'ID';
  end;
end;

function TDM.NotifierRegistered(const aProc: TNotifyEvent): Boolean;
var
  i: Integer;
begin
  // Методы объектов вполне допустимо приводить к TMethod для сравнения
  for i := 0 to High(FNotifiers) do
    if (TMethod(aProc).Code = TMethod(FNotifiers[i]).Code) and
       (TMethod(aProc).Data = TMethod(FNotifiers[i]).Data) then
    begin
      Result := True;
      Exit;
    end;
  Result := False;
end;

procedure TDM.qryBooksAfterDelete(DataSet: TDataSet);
begin
  if Assigned(FOnAfterDelete) then
    FOnAfterDelete(DataSet);
end;

procedure TDM.RegChangeNotifier(const aProc: TNotifyEvent);
var
  i: Integer;
begin
  if NotifierRegistered(aProc) then
    Exit;
  i := Length(FNotifiers);
  SetLength(FNotifiers, i + 1);
  FNotifiers[ i ] := aProc;
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

procedure TDM.UnregChangeNotifier(const aProc: TNotifyEvent);
var
  i: Integer;
  vDel: Boolean;
begin
 // Пользуясь фактом, что дублей обработчиков быть не может
 //(эта проверка реализуется в RegChangeNotifier),
 //слегка оптимизирую операцию удаления
  vDel := False;
  for i := 0 to High(FNotifiers) do
    if vDel then
      FNotifiers[i - 1] := FNotifiers[ i ]
    else
      if (TMethod(aProc).Code = TMethod(FNotifiers[ i ]).Code) and
         (TMethod(aProc).Data = TMethod(FNotifiers[ i ]).Data) then
        vDel := True;

  if vDel then
    SetLength(FNotifiers, Length(FNotifiers) - 1);
end;

end.
