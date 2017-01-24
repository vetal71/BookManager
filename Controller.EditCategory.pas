unit Controller.EditCategory;

interface

uses
  Generics.Collections,
  Aurelius.Engine.ObjectManager,
  Model.Entities;

type
  TEditCategoryController = class
  private
    FManager: TObjectManager;
    FCategory: TCategory;
  public
    constructor Create;
    destructor Destroy; override;
  public
    procedure SaveCategory(Category: TCategory);
    procedure Load(CategoryID: Variant);
    function GetCategories: TList<TCategory>;
  public
    property Category: TCategory read FCategory;
  end;

implementation

uses
  Common.DBConnection;

{ TEditCategoryController }

constructor TEditCategoryController.Create;
begin
  FManager := TDBConnection.GetInstance.CreateObjectManager;
  FCategory := TCategory.Create;
end;

destructor TEditCategoryController.Destroy;
begin
  if not FManager.IsAttached(FCategory) then
    FCategory.Free;
  FManager.Free;
  inherited;
end;

function TEditCategoryController.GetCategories: TList<TCategory>;
begin
  Result := FManager.FindAll<TCategory>;
end;

procedure TEditCategoryController.Load(CategoryID: Variant);
begin
  if not FManager.IsAttached(FCategory) then
    FCategory.Free;
  FCategory := FManager.Find<TCategory>(CategoryId);
end;

procedure TEditCategoryController.SaveCategory(Category: TCategory);
begin
  if not FManager.IsAttached(Category) then
    FManager.SaveOrUpdate(Category);
  FManager.Flush;
end;

end.
