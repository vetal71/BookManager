unit Controller.Base;

interface

uses
  Aurelius.Engine.ObjectManager;

type
  BaseController = class
  protected
    FManager: TObjectManager;
  public
    constructor Create(AManager: TObjectManager);
  end;

implementation

{ BaseController }

constructor BaseController.Create(AManager: TObjectManager);
begin
  FManager := AManager;
end;

end.
