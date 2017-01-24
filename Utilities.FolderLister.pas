unit Utilities.FolderLister;

interface

uses
  Common.Utils,
  System.Classes,
  System.Generics.Collections,
  Vcl.Dialogs,
  Vcl.FileCtrl;

type
  TFolderLister = class
  private
    FFolderList: TFileRecordList;
  public
    class function GetFolderList(const StartDir: string; const FileMask: string = ''): TFileRecordList;
  end;

implementation

{ FolderLister }

class function TFolderLister.GetFolderList(const StartDir: string; const FileMask: string = ''): TFileRecordList;
var
  eMask: string;
  tmpList: TFileRecordList;
begin
  eMask := FileMask;
  if eMask = '' then
     eMask := '*.*';
  tmpList := TFileRecordList.Create;
  try
    FindAllFiles(tmpList, StartDir, eMask);
    Result := tmpList;
  finally
    tmpList.Free;
  end;
end;

end.
