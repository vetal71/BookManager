unit Controllers.EditBookController;

interface

uses
  Entities.Book,
  Aurelius.Engine.ObjectManager;

type
  TEditBookController = class
  private
    FManager: TObjectManager;
    FBook: TBook;
  public
    procedure SaveBook(Book: TBook);
    procedure Load(BookID: Variant);
  public
    constructor Create;
    destructor Destroy; override;
  private
    property Book: TBook read FBook;
  end;


implementation

uses
  Common.DBConnection;

{ TBookController }

constructor TEditBookController.Create;
begin
  FManager := TDBConnection.GetInstance.CreateObjectManager;
  FBook := TBook.Create;
end;

destructor TEditBookController.Destroy;
begin
  if not FManager.IsAttached(FBook) then
    FBook.Free;
  FManager.Free;
  inherited;
end;

procedure TEditBookController.Load(BookID: Variant);
begin
  if not FManager.IsAttached(FBook) then
    FBook.Free;
  FBook := FManager.Find<TBook>(BookId);
end;

procedure TEditBookController.SaveBook(Book: TBook);
begin
  if not FManager.IsAttached(FBook) then
    FManager.SaveOrUpdate(Book);
  FManager.Flush;
end;

end.
