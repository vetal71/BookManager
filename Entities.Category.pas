unit Entities.Category;

interface

uses
  Aurelius.Mapping.Attributes;

type
  [Entity, Automapping]
  [Table('CATEGORIES')]
  TCategory = class
  private
    FId: Integer;
    FCategoryName: string;
  public
    property Id: Integer  read FId write FId;
    property CategoryName: string  read FCategoryName write FCategoryName;
  public
    constructor Create(ACategoryName: string);
  end;

implementation

{ TCategory }

constructor TCategory.Create(ACategoryName: string);
begin
  CategoryName := ACategoryName;
end;

end.
