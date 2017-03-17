unit Common.DatabaseUtils;

interface

uses
  System.Classes, Uni;

type
  TCreateMode = (cmCreate, cmReplicate);

function UpdateDatabaseShema(ADBFile: string): Boolean;
procedure FillData;

implementation

uses
  System.IniFiles,
  System.SysUtils,
  Vcl.FileCtrl,
  Common.Utils,
  ConnectionModule,
  WaitForm, SplashScreenU;

var
  AutoReplicate: Boolean;

procedure AddRecordsToDatabase(FR: TFileRecordList; AMode: TCreateMode);
var
  I: Integer;

  function RecordFind(AParams: array of Variant): Boolean;
  begin
    with TUniQuery.Create(nil) do try
      Connection := DM.conn;
      SQL.Text := Format('select count(%0:s) as Cnt from %s where %0:s = :ID',
        [AParams[0], AParams[1]]);
      ParamByName('ID').AsInteger := AParams[2];
      ExecSQL;
      Result := FieldByName('Cnt').AsInteger > 0;
    finally
      Free;
    end;
  end;

begin
  if (AMode = cmCreate) then begin
    if (not RecordFind(['ID', 'Categories', 1])) and (AMode = cmCreate) then begin
      with DM.qryCategories do try
        Active := True;
        Append;
        FieldByName('ID').AsInteger := 1;
        FieldByName('CategoryName').AsString := 'Все книги';
        Post;
      except on E: Exception do begin
        ShowErrorFmt('Не удалось добавить категрию.'#13'%s', [E.Message]);
        Exit;
        end;
      end;
      DM.qryBooks.Active := True;
      for I := 0 to FR.Count - 1 do begin
        ShowSplashScreenMessage(Format('Добавление записи: %s', [ FR[ I ].FileName ]));
        Sleep(100);
        with DM.qryBooks do try
          Append;
          FieldByName('ID').AsInteger          := I + 1;
          FieldByName('BookName').AsString     := FR[ I ].FileName;
          FieldByName('BookLink').AsString     := FR[ I ].FilePath;
          FieldByName('Category_ID').AsInteger := 1;
          Post;
        except on E: Exception do begin
          ShowErrorFmt('Не удалось добавить книгу.'#13'%s', [E.Message]);
          Exit;
          end;
        end;
      end;
    end;
  end else if (AMode = cmReplicate) then begin
    if (not RecordFind(['ID', 'Categories', 1000])) then begin
      with DM.qryCategories do try
        Active := True;
        Append;
        FieldByName('ID').AsInteger := 1000;
        FieldByName('CategoryName').AsString := 'Новые книги';
        Post;
      except on E: Exception do begin
        ShowErrorFmt('Не удалось добавить категрию.'#13'%s', [E.Message]);
        Exit;
        end;
      end;
    end;
    DM.qryBooks.Active := True;
    for I := 0 to FR.Count - 1 do begin
      ShowSplashScreenMessage(Format('Обработка записи: %s', [ FR[ I ].FileName ]));
      Sleep(100);
      if (not (RecordFind(['BookLink', 'Books', FR[ I ].FilePath]))) then begin
        with DM.qryBooks do try
          Append;
          FieldByName('ID').AsInteger          := I + 1;
          FieldByName('BookName').AsString     := FR[ I ].FileName;
          FieldByName('BookLink').AsString     := FR[ I ].FilePath;
          FieldByName('Category_ID').AsInteger := 1000;
          Post;
        except on E: Exception do begin
          ShowErrorFmt('Не удалось добавить книгу.'#13'%s', [E.Message]);
          Exit;
          end;
        end;
      end;
    end;
  end;
end;

procedure CreateDataFromFiles(AMode: TCreateMode);
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
    FindAllFiles(FilesList, StartDir, ['pdf', 'djvu', 'fb2', 'epab', 'chm']);
    AddRecordsToDatabase(FilesList, AMode);
  finally
    FilesList.Free;
  end;
end;

function UpdateDatabaseShema(ADBFile: string): Boolean;
const
  cSQLScript =
  'CREATE TABLE [BOOKS]( '#13#10 +
  '    [ID] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,  '#13#10 +
  '    [BOOKNAME] VARCHAR(250) NOT NULL,  '#13#10 +
  '    [BOOKLINK] VARCHAR(250),  '#13#10 +
  '    [CATEGORY_ID] INTEGER CONSTRAINT [FK_BOOKS_CATEGORY_ID] REFERENCES CATEGORIES([ID])); '#13#10 +
  ' '#13#10 +
  'CREATE TABLE [CATEGORIES]( '#13#10 +
  '    [ID] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,  '#13#10 +
  '    [CATEGORYNAME] VARCHAR(250) NOT NULL,  '#13#10 +
  '    [PARENT_ID] INTEGER CONSTRAINT [FK_CATEGORIES_PARENTID] REFERENCES CATEGORIES([ID]));';
begin
  if not FileExists(ADBFile) then begin
    with DM.conn do try
      Database := ADBFile;
      SpecificOptions.Values['ForceCreateDatabase'] := 'True';
      Connect;
      ExecSQL('PRAGMA auto_vacuum = 1');
      ExecSQL(cSQLScript);
      Disconnect;
      Result := True;
    except on E: Exception do begin
      ShowErrorFmt('При создании базы данных возникла ошибка'#13'%s', [E.Message]);
      Result := False;
      end;
    end;
  end else Result := True;
end;

procedure FillData;
var
  UpdateMode: TCreateMode;
begin
  with TMemIniFile.Create(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'conn.ini') do begin
    // параметр конфигурации "Авторепликация базы"
    AutoReplicate := ReadBool('Config', 'AutoReplicate', False);
  end;

  with DM do begin
    conn.StartTransaction;
    try
      qryBooks.Active := True;
      if qryBooks.RecordCount = 0 then
        UpdateMode := cmCreate
      else
        UpdateMode := cmReplicate;
      qryBooks.Active := False;

      if (UpdateMode = cmReplicate) and not AutoReplicate then Exit;

      ShowSplashscreen;
      try
        CreateDataFromFiles(UpdateMode);
      finally
        HideSplashScreen;
      end;

      conn.Commit;
    except
      conn.Rollback;
      raise;
    end;
  end;
end;

end.
