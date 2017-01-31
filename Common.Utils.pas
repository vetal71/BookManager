unit Common.Utils;

interface

uses
  System.Classes, System.SysUtils, Vcl.Forms, Winapi.Windows, Vcl.Controls,
  System.Generics.Collections, Winapi.ShellAPI, Winapi.ActiveX;

type
  TFileRecord = record
    FileName: string;
    FilePath: string;
  end;

  TFileRecordList = TList<TFileRecord>;

procedure FindAllFiles(FilesList: TFileRecordList; StartDir, FileMask: string);

procedure ShowError(AMsg: string);
procedure ShowErrorFmt(AMsg: string; Params: array of const);
function ShowConfirm(AMsg: string): Boolean;
function ShowConfirmFmt(AMsg: string; Params: array of const): Boolean;
procedure ShowInfo(AMsg: string);
procedure ShowInfoFmt(AMsg: string; Params: array of const);

procedure ShellExecute(const AWnd: HWND; const AOperation, AFileName: String;
                       const AParameters: String = ''; const ADirectory: String = '';
                       const AShowCmd: Integer = SW_SHOWNORMAL);

implementation

procedure ShellExecute(const AWnd: HWND; const AOperation, AFileName: String;
                       const AParameters: String = ''; const ADirectory: String = '';
                       const AShowCmd: Integer = SW_SHOWNORMAL);
var
  ExecInfo: TShellExecuteInfo;
  NeedUnitialize: Boolean;
begin
  Assert(AFileName <> '');

  NeedUnitialize := Succeeded(CoInitializeEx(nil, COINIT_APARTMENTTHREADED or COINIT_DISABLE_OLE1DDE));
  try
    FillChar(ExecInfo, SizeOf(ExecInfo), 0);
    ExecInfo.cbSize := SizeOf(ExecInfo);

    ExecInfo.Wnd := AWnd;
    ExecInfo.lpVerb := Pointer(AOperation);
    ExecInfo.lpFile := PChar(AFileName);
    ExecInfo.lpParameters := Pointer(AParameters);
    ExecInfo.lpDirectory := Pointer(ADirectory);
    ExecInfo.nShow := AShowCmd;
    ExecInfo.fMask := SEE_MASK_NOASYNC { = SEE_MASK_FLAG_DDEWAIT для старых версий Delphi }
                   or SEE_MASK_FLAG_NO_UI;
    {$IFDEF UNICODE}
    // Необязательно, см. http://www.transl-gunsmoker.ru/2015/01/what-does-SEEMASKUNICODE-flag-in-ShellExecuteEx-actually-do.html
    ExecInfo.fMask := ExecInfo.fMask or SEE_MASK_UNICODE;
    {$ENDIF}

    {$WARN SYMBOL_PLATFORM OFF}
    Win32Check(ShellExecuteEx(@ExecInfo));
    {$WARN SYMBOL_PLATFORM ON}
  finally
    if NeedUnitialize then
      CoUninitialize;
  end;
end;

procedure FindAllFiles(FilesList: TFileRecordList; StartDir, FileMask: string);
var
  SR: TSearchRec;
  DirList: TStringList;
  IsFound: Boolean;
  i: integer;
  FR: TFileRecord;
begin
  if (StartDir[Length(StartDir)] <> '\') then
    StartDir := StartDir + '\';
  // Формирование списка файлов (не каталогов!!!) по маске
  IsFound := FindFirst(StartDir + FileMask, faAnyFile - faDirectory, SR) = 0;
  while IsFound do begin
    FR.FileName := SR.Name;
    FR.FilePath := StartDir + SR.Name;
    FilesList.Add( FR );
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

procedure ShowError(AMsg: string);
begin
  Application.MessageBox(PChar(AMsg), 'Ошибка', MB_OK + MB_ICONSTOP);
end;

procedure ShowErrorFmt(AMsg: string; Params: array of const);
begin
  Application.MessageBox(PChar(Format(AMsg, Params)), 'Ошибка', MB_OK + MB_ICONSTOP);
end;

function ShowConfirm(AMsg: string): Boolean;
begin
  Result := Application.MessageBox(PChar(AMsg), 'Подтверждение', MB_OKCANCEL + MB_ICONQUESTION) = mrOK;
end;

function ShowConfirmFmt(AMsg: string; Params: array of const): Boolean;
begin
  Result := Application.MessageBox(PChar(Format(AMsg, Params)), 'Подтверждение', MB_OKCANCEL + MB_ICONQUESTION) = mrOk;
end;

procedure ShowInfo(AMsg: string);
begin
  Application.MessageBox(PChar(AMsg), 'Информация', MB_OK + MB_ICONINFORMATION);
end;

procedure ShowInfoFmt(AMsg: string; Params: array of const);
begin
  Application.MessageBox(PChar(Format(AMsg, Params)), 'Информация', MB_OK + MB_ICONINFORMATION);
end;

end.
