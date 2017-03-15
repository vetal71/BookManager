unit Model.Entity.Category;

interface

type
  TCategory = class
  private
    FID: Integer;
    FCategoryName: string;
    FParentID: Integer;
  public
    constructor Create(AName: string); overload;
  public
    property ID: Integer read FID write FID;
    property CategoryName: string read FCategoryName write FCategoryName;
  end;

implementation

{ TCategory }

constructor TCategory.Create(AName: string);
begin
  FCategoryName := AName;
end;

end.
