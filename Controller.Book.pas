unit Controller.Book;

interface

uses
  System.Generics.Collections,
  Controller.Base,
  Model.Entities;

type
  TBookController = class(BaseController)
  public
    procedure DeleteBook(ABook: TBook);
    function GetAllBook: TList<TBook>;
  end;

implementation

uses
  Common.DBConnection;

{ TBookController }

procedure TBookController.DeleteBook(ABook: TBook);
begin
  if not FManager.IsAttached(ABook) then
    ABook := FManager.Find<TBook>(ABook.ID);
  FManager.Remove(ABook);
end;

function TBookController.GetAllBook: TList<TBook>;
begin
  FManager.Clear;
  Result := FManager.Find<TBook>.List;
end;

end.
