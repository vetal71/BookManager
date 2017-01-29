unit Common.DatabaseUtils;

interface

uses
  Aurelius.Criteria.Base,
  Aurelius.Drivers.Interfaces,
  Aurelius.Engine.DatabaseManager,
  Aurelius.Engine.ObjectManager,
  Model.Entities;

procedure UpdateDatabaseShema(Conn: IDBConnection);
procedure FillData(Conn: IDBConnection);

implementation

uses
  System.IniFiles,
  System.SysUtils,
  Vcl.FileCtrl,
  Common.Utils,
  WaitForm;

procedure AddRecordsToDatabase(FR: TFileRecordList; AManager: TObjectManager);
var
  Category: TCategory;
  Book: TBook;
  I: Integer;
begin
  Category := AManager.Find<TCategory>(1);
  if Category = nil then begin
    Category := TCategory.Create;
    try
      Category.ID := 1;
      Category.CategoryName := 'Все книги';
      AManager.Replicate<TCategory>(Category);
    finally
      Category.Free;
    end;

    for I := 0 to FR.Count - 1 do begin
      TWaiting.Status(Format('Добавление записи: %s', [ FR[ I ].FileName ]));
      Book := TBook.Create;
      try
        Book.ID   := I + 1;
        Book.BookName := FR[ I ].FileName;
        Book.BookLink := FR[ I ].FilePath;
        Category := AManager.Find<TCategory>(1);
        Category.Books.Add(AManager.Replicate<TBook>(Book));
      finally
        Book.Free;
      end;
    end;
    AManager.Flush;
  end;
end;

procedure CreateDataFromFiles(AManager: TObjectManager);
var
  FilesList: TFileRecordList;
  StartDir: string;
begin
  // Синхронизация библиотеки
  with TMemIniFile.Create(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'conn.ini') do begin
    StartDir := ReadString('Path', 'SearchPath', 'D:\Книги');
  end;

  if (StartDir = '') or (not DirectoryExists(StartDir)) then begin
    // вызов диалога для выбора каталога
    if not SelectDirectory('Выберите каталог', 'C:\', StartDir) then Exit;
  end;

  FilesList := TFileRecordList.Create;
  try
    FindAllFiles(FilesList, StartDir, '*.*');
    AddRecordsToDatabase(FilesList, AManager);
  finally
    FilesList.Free;
  end;
end;

procedure UpdateDatabaseShema(Conn: IDBConnection);
var
  DB: TDatabaseManager;
begin
  DB := TDatabaseManager.Create(Conn);
  try
    DB.UpdateDatabase;
  finally
    DB.Free;
  end;
end;

procedure FillData(Conn: IDBConnection);
var
  Manager: TObjectManager;
  Trans: IDBTransaction;
begin
  Manager := TObjectManager.Create(Conn);
  try
    if Manager.FindAll<TBook>.Count = 0 then
    begin
      Trans := conn.BeginTransaction;
      try
        TWaiting.Start('Обновление библиотеки',
          procedure
          begin
            CreateDataFromFiles(Manager);
          end);
        Trans.Commit;
      except
        Trans.Rollback;
        raise;
      end;
    end;
  finally
    Manager.Free;
  end;
end;

end.
