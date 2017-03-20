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
  WaitForm, SplashScreenU, Vcl.Forms;

var
  AutoReplicate, SilentMode: Boolean;

function RecordFind(TableName, SQLCond: string; AParams: array of Variant): Boolean; overload;
var
  Q: TUniQuery;
  I : Integer;
begin
  Q := TUniQuery.Create(nil);
  with Q do try
    Connection := DM.conn;
    if SQLCond > '' then
      SQLCond := 'where ' + SQLCond;
    SQL.Text := Format('select count(*) from %s %s',
      [TableName, SQLCond]);
    if Length(AParams) > 0 then begin
      for I := Low(AParams) to High(AParams) do
        Params[I].Value := AParams[i];
    end;

    ExecSQL;
    Result := Fields[0].AsInteger > 0;
  finally
    Free;
  end;
end;

function GetFieldValue(AParams: array of Variant): Variant;
const
  cSQLBody =
    'select %s from %s %s';
var
  eSQLWhere: string;
begin
  with TUniQuery.Create(nil) do try
    Connection := DM.conn;
    eSQLWhere := '';
    if Length(AParams) = 3 then
      eSQLWhere := Format('where %s', [ AParams[2] ]);
    SQL.Text := Format(cSQLBody, [AParams[0], AParams[1], eSQLWhere]);
    ExecSQL;
    Result := Fields[0].Value;
  finally
    Free;
  end;
end;

procedure AddRecordsToDatabase(FR: TFileRecordList; AMode: TCreateMode);
var
  I: Integer;
  ID: Integer;
  SQLCond, eFileName: string;
begin
  if (AMode = cmCreate) then begin
    if (not RecordFind('Categories', 'ID=:ID', [ 1 ])) then begin
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
    end;
    DM.qryBooks.Active := True;
    for I := 0 to FR.Count - 1 do begin
      ShowSplashScreenMessage(Format('Добавление записи: %s', [ FR[ I ].FileName ]));
      Sleep(5);
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
  end else if (AMode = cmReplicate) then begin
    if (not RecordFind('Categories', 'ID=:ID', [ 1000 ])) then begin
      with DM.qryCategories do try
        Active := True;
        Append;
        FieldByName('ID').AsInteger := 1000;
        FieldByName('CategoryName').AsString := 'Новые книги';
        Post;
      except on E: Exception do begin
        ShowErrorFmt('Не удалось добавить категорию.'#13'%s', [E.Message]);
        Exit;
        end;
      end;
    end;
    DM.qryBooks.Active := True;
    for I := 0 to FR.Count - 1 do begin
      ShowSplashScreenMessage(Format('Обработка записи: %s', [ FR[ I ].FileName ]));
      Sleep(5);
      eFileName := StringReplace(FR[ I ].FileName, #39, #39#39, [rfReplaceAll]);
      if (not (RecordFind('Books', 'BookLink like :BL', [ '%' + FR[ I ].FileName ]))) then begin
        with DM.qryBooks do try
          Append;
          //FieldByName('ID').AsInteger          := I + 1;
          FieldByName('BookName').AsString     := FR[ I ].FileName;
          FieldByName('BookLink').AsString     := FR[ I ].FilePath;
          FieldByName('Category_ID').AsInteger := 1000;
          Post;
        except on E: Exception do begin
          ShowErrorFmt('Не удалось добавить книгу.'#13'%s', [E.Message]);
          Exit;
          end;
        end;
      end else begin
        SQLCond := Format('BookLink like ''%s''', [ '%' + eFileName ]);
        ID := GetFieldValue(['ID', 'Books', SQLCond]);
        if ID > 0 then
          with TUniQuery.Create(nil) do try
            try
              Connection := DM.conn;
              SQL.Text := 'update Books set BookLink = :BL where ID = :ID';
              ParamByName('BL').AsString  := FR[ I ].FilePath;
              ParamByName('ID').AsInteger := ID;
              ExecSQL;
            except on E: Exception do begin
              ShowErrorFmt('Не удалось обновить книгу.'#13'%s', [E.Message]);
              Exit;
              end;
            end;
          finally
            Free;
          end;
      end;
    end;
  end;
end;

procedure CreateDataFromFiles(AMode: TCreateMode);
var
  FilesList: TFileRecordList;
  StartDir: string;
  I: Integer;
begin
  // Синхронизация библиотеки
  with TIniFile.Create(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'conn.ini') do try
    StartDir := ReadString('Path', 'SearchPath', 'D:\Книги');
  finally
    Free;
  end;

  if (StartDir = '') or (not DirectoryExists(StartDir)) then begin
    // вызов диалога для выбора каталога
    if not SelectDirectory('Выберите каталог', '', StartDir) then Exit;
  end;

  with TIniFile.Create(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'conn.ini') do try
    WriteString('Path', 'SearchPath', StartDir);
  finally
    Free;
  end;

  FilesList := TFileRecordList.Create;
  try
    FindAllFiles(FilesList, StartDir, ['pdf', 'djvu', 'fb2', 'epub', 'chm']);
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
  with TIniFile.Create(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'conn.ini') do try
    // параметр конфигурации "Авторепликация базы"
    AutoReplicate := ReadBool('Config', 'AutoReplicate', False);
    SilentMode    := ReadBool('Config', 'SilentMode', False);
  finally
    Free;
  end;

  with DM do begin
    conn.StartTransaction;
    try
      if GetFieldValue(['count(*)','Books']) = 0 then
        UpdateMode := cmCreate
      else
        UpdateMode := cmReplicate;
      if (UpdateMode = cmReplicate) and not AutoReplicate then Exit;
      if not SilentMode then begin
        ShowSplashscreen;
        try
          CreateDataFromFiles(UpdateMode);
        finally
          HideSplashScreen;
        end;
      end else begin
        CreateDataFromFiles(UpdateMode);
      end;
      conn.Commit;
    except
      conn.Rollback;
      raise;
    end;
  end;
end;

end.
