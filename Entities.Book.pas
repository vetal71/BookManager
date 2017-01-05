unit Entities.Book;

interface

uses
  Entities.Category,
  Aurelius.Mapping.Attributes,
  Aurelius.Types.Proxy,
  Aurelius.Types.Nullable;

type
  [Entity, Automapping]
  [Table('BOOKS')]
  TBook = class
  private
    FId: Integer;
    FBookName: string;
    FFileLink: Nullable<string>;

    [Association([TAssociationProp.Lazy], [])]
    [JoinColumn('CATEGORY_ID', [])]
    FCategory: Proxy<TCategory>;
    function GetCategory: TCategory;
    procedure SetCategory(const Value: TCategory);
  public
    property Id: Integer  read FId   write FId;
    property BookName: string read FBookName write FBookName;
    property FileLink: Nullable<string> read FFileLink write FFileLink;

    property Category: TCategory  read GetCategory write SetCategory;
  end;

implementation

{ TBook }

function TBook.GetCategory: TCategory;
begin
  Result := FCategory.Value;
end;

procedure TBook.SetCategory(const Value: TCategory);
begin
  FCategory.Value := Value;
end;

end.
