unit Controller.Book;

interface

uses
  System.Generics.Collections,
  Aurelius.Engine.ObjectManager,
  Model.Entities;

type
  TBookController = class
  private
    FManager: TObjectManager;
  public
    procedure DeleteBook(ABook: TBook);
    function GetAllBook: TList<TBook>;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  Common.DBConnection;

{ TBookController }

constructor TBookController.Create;
begin
  FManager := TDBConnection.GetInstance.CreateObjectManager;
end;

procedure TBookController.DeleteBook(ABook: TBook);
begin
  if not FManager.IsAttached(ABook) then
    ABook := FManager.Find<TBook>(ABook.BookID);
  FManager.Remove(ABook);
end;

destructor TBookController.Destroy;
begin
  FManager.Free;
  inherited;
end;

function TBookController.GetAllBook: TList<TBook>;
begin
  FManager.Clear;
  Result := FManager.FindAll<TBook>;
end;

end.
