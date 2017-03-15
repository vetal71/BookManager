unit Model.Entity.Book;

interface

uses
  SysUtils;

type
  TBook = class
  private
    FID: Integer;
    FBookName: String;
    FBookLink: String;
    FCategoryID: Integer;
  public
    property ID: Integer         read FID         write FID;
    property BookName: string    read FBookName   write FBookName;
    property BookLink: string    read FBookLink   write FBookLink;
    property CategoryID: Integer read FCategoryID write FCategoryID;
  public
    constructor Create(ABookName: string; ACategoryID: Integer); overload;
    constructor Create(ABookName: string; ABookLink: string; ACategoryID: Integer); overload;
  end;

implementation

{ TBook }

constructor TBook.Create(ABookName: string; ACategoryID: Integer);
begin
  FBookName := ABookName;
  FCategoryID := ACategoryID;
end;

constructor TBook.Create(ABookName, ABookLink: string; ACategoryID: Integer);
begin
  FBookName := ABookName;
  FBookLink := ABookLink;
  FCategoryID := ACategoryID;
end;

end.
