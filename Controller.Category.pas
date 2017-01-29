unit Controller.Category;

interface

uses
  System.Generics.Collections,
  Controller.Base,
  Model.Entities;

type
  TCategoryController = class(BaseController)
  public
    procedure DeleteCategory(ACategory: TCategory);
    function GetAllCategory: TList<TCategory>;
  end;

implementation

uses
  Common.DBConnection;

{ TCategoryController }

procedure TCategoryController.DeleteCategory(ACategory: TCategory);
begin
  if not FManager.IsAttached(ACategory) then
    ACategory := FManager.Find<TCategory>(ACategory.ID);
  FManager.Remove(ACategory);
end;

function TCategoryController.GetAllCategory: TList<TCategory>;
begin
  FManager.Clear;
  Result := FManager.Find<TCategory>.List;
end;

end.
