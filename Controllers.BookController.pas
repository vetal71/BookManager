unit Controllers.BookController;

interface

uses
  Entities.Book;

type
  TBookController = class    
  public
    procedure SaveBook(Book: TBook);
  end;

implementation

uses
  Common.DBConnection, 
  Aurelius.Engine.ObjectManager;

{ TBookController }

procedure TBookController.SaveBook(Book: TBook);
var
  Manager: TObjectManager;
begin
  Manager := TDBConnection.GetInstance.CreateObjectManager;
  try
    Manager.SaveOrUpdate(Book);
    Manager.Flush;
  finally
    Manager.Free;
  end;
end;

end.
