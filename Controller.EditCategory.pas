unit Controller.EditCategory;

interface

uses
  Generics.Collections,
  Aurelius.Engine.ObjectManager,
  Controller.Base,
  Model.Entities;

type
  TEditCategoryController = class(BaseController)
  private
    FCategory: TCategory;
  public
    constructor Create(AManager: TObjectManager); overload;
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

constructor TEditCategoryController.Create(AManager: TObjectManager);
begin
  inherited Create(AManager);
  FCategory := TCategory.Create;
end;

destructor TEditCategoryController.Destroy;
begin
  if not FManager.IsAttached(FCategory) then
    FCategory.Free;
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
