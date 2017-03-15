unit Controller.Category;

interface

uses
  Uni, Model.Entity.Category;

type
  TCategoryController = class
  private
    FConn: TUniConnection;

  private
    function GenerateID: Integer;
  public
    function AddCategory(ACategory: TCategory): Boolean;
  public
    constructor Create(AConn: TUniConnection);
  end;

implementation

{ TCategoryController }

function TCategoryController.AddCategory(ACategory: TCategory): Boolean;
const
  cSQL =
    'insert into Categories(ID, CategoryName, Parent_ID) ' + #13 +
    '  values (:ID, :CategoryName, :ParentID)';
begin
  if ACategory.ID = 0 then
    ACategory.ID := GenerateID;
  with TUniQuery.Create(nil) do try
    Connection := FConn;

  finally
    Free;
  end;
end;

constructor TCategoryController.Create(AConn: TUniConnection);
begin
  FConn := AConn;
end;

function TCategoryController.GenerateID: Integer;
const
  cSQL =
    'select max(ID) + 1 as NewID from ' + #13 +
    '  (select ID from Categories where ID < 1000)';

begin
  Result := 0;
  with TUniQuery.Create(nil) do try
    Connection := FConn;
    SQL.Text := cSQL;
    ExecSQL;
    if not IsEmpty then
      Result := FieldByName('NewID').AsInteger;
  finally
    Free;
  end;
end;

end.
