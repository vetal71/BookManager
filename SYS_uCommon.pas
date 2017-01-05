unit SYS_uCommon;

interface

uses
  System.Classes, System.SysUtils;

procedure FindAllFiles(FilesList: TStringList; StartDir, FileMask: string);

implementation

procedure FindAllFiles(FilesList: TStringList; StartDir, FileMask: string);
var
  SR: TSearchRec;
  DirList: TStringList;
  IsFound: Boolean;
  i: integer;
begin
  if (StartDir[Length(StartDir)] <> '\') then
    StartDir := StartDir + '\';
  // Формирование списка файлов (не каталогов!!!) по маске
  IsFound := FindFirst(StartDir + FileMask, faAnyFile - faDirectory, SR) = 0;
  while IsFound do begin
    FilesList.Add( StartDir + SR.Name );
    IsFound := FindNext(SR) = 0;
  end;
  System.SysUtils.FindClose(SR);
  // Формирование списка подкаталогов
  DirList := TStringList.Create;
  IsFound := FindFirst(StartDir + '*.*', faAnyFile, SR) = 0;
  while IsFound do begin
    if ((SR.Attr = faDirectory)) and (SR.Name[ 1 ] <> '.') then
      DirList.Add( SR.Name );
    IsFound := FindNext(SR) = 0;
  end;
  System.SysUtils.FindClose(SR);
  // Рекурсивное сканирование подкаталогов
  for i := 0 to Pred(DirList.Count) do
    FindAllFiles( FilesList, StartDir + DirList[i], FileMask );
  DirList.Free;
end;

end.
