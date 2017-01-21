unit Common.Utils;

interface

uses
  System.Classes, System.SysUtils, Vcl.Forms, Winapi.Windows;

procedure FindAllFiles(FilesList: TStringList; StartDir, FileMask: string);

procedure ShowError(AMsg: string);

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
  // ������������ ������ ������ (�� ���������!!!) �� �����
  IsFound := FindFirst(StartDir + FileMask, faAnyFile - faDirectory, SR) = 0;
  while IsFound do begin
    FilesList.Add( StartDir + SR.Name );
    IsFound := FindNext(SR) = 0;
  end;
  System.SysUtils.FindClose(SR);
  // ������������ ������ ������������
  DirList := TStringList.Create;
  IsFound := FindFirst(StartDir + '*.*', faAnyFile, SR) = 0;
  while IsFound do begin
    if ((SR.Attr = faDirectory)) and (SR.Name[ 1 ] <> '.') then
      DirList.Add( SR.Name );
    IsFound := FindNext(SR) = 0;
  end;
  System.SysUtils.FindClose(SR);
  // ����������� ������������ ������������
  for i := 0 to Pred(DirList.Count) do
    FindAllFiles( FilesList, StartDir + DirList[i], FileMask );
  DirList.Free;
end;

procedure ShowError(AMsg: string);
begin
  Application.MessageBox(PChar(AMsg), '������', MB_OK + MB_ICONSTOP);
end;

end.