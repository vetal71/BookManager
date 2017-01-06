unit Utilities.FolderLister;

interface

uses
  SYS_uCommon,
  System.Classes,
  System.Generics.Collections,
  Vcl.Dialogs,
  Vcl.FileCtrl;

type
  TFolderLister = class
  private
    FFolderList: TStringList;
    FStartDir  : string;
    FFileMask  : string;
  protected
    function GetFolderList: TStringList;
  public
    property FolderList : TStringList read GetFolderList;
    property StartDir   : string      read FStartDir write FStartDir;
    property FileMask   : string      read FFileMask write FFileMask;
  end;

implementation

{ FolderLister }

function TFolderLister.GetFolderList: TStringList;
begin
  if FStartDir = '' then begin
    // вызов диалога для выбора каталога
    SelectDirectory('Выберите каталог', 'C:\', FStartDir);
  end;

  if FFileMask = '' then
    FFileMask := '*.*';

  FindAllFiles(Result, FStartDir, FFileMask);

end;

end.
