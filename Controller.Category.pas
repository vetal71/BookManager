unit Controller.Category;

interface

uses
  System.Generics.Collections,
  Aurelius.Engine.ObjectManager,
  Model.Entities;

type
  TCategoryController = class
  private
    FManager: TObjectManager;
  public
    procedure DeleteCategory(ACategory: TCategory);
    function GetAllCategory: TList<TCategory>;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  Common.DBConnection;

{ TCategoryController }

constructor TCategoryController.Create;
begin
  FManager := TDBConnection.GetInstance.CreateObjectManager;
end;

procedure TCategoryController.DeleteCategory(ACategory: TCategory);
begin
  if not FManager.IsAttached(ACategory) then
    ACategory := FManager.Find<TCategory>(ACategory.CategoryID);
  FManager.Remove(ACategory);
end;

destructor TCategoryController.Destroy;
begin
  FManager.Free;
  inherited;
end;

function TCategoryController.GetAllCategory: TList<TCategory>;
begin
  FManager.Clear;
  Result := FManager.FindAll<TCategory>;
end;

end.
