unit Entities;

interface

type
  TBook = class
  private
    FId: Integer;
    FName: string;
  public
    property Id: Integer  read FId   write FId;
    property Name: string read FName write FName;
  end;

implementation

end.
