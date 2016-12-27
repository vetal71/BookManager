unit Entities;

interface

uses
  Aurelius.Mapping.Attributes;

type
  [Entity, Automapping]
  TBook = class
  private
    FId: Integer;
    FName: string;
  public
    property Id: Integer  read FId   write FId;
    property Name: string read FName write FName;
//    property Category: TList<TCategory>  read F write F;
  end;

implementation
  //RegisterEntity(TBook);
end.
