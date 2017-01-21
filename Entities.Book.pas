unit Entities.Book;

interface

uses
  Entities.Category,
  Aurelius.Mapping.Attributes,
  Aurelius.Mapping.Metadata,
  Aurelius.Types.Proxy,
  Aurelius.Types.Nullable;

type
  [Entity, Automapping]
  [Table('BOOKS')]
  [Id('FID', TIdGenerator.IdentityOrSequence)]
  TBook = class
  private
    [Column('BOOKID', [TColumnProp.Required, TColumnProp.NoInsert, TColumnProp.NoUpdate])]
    FID: Integer;

    [Column('BOOKNAME', [TColumnProp.Required])]
    [DBTypeMemo]
    FBookName: String;

    [Column('FILELINK', [])]
    [DBTypeMemo]
    FFileLink: Nullable<String>;

    [Association([TAssociationProp.Lazy], CascadeTypeAll - [TCascadeType.Remove])]
    [JoinColumn('CATEGORYID', [], 'ID')]
    FCategory: Proxy<TCategory>;
  private
    function GetCategory: TCategory;
    procedure SetCategory(const Value: TCategory);
  public
    property ID        : Integer   read FID write FID;
    property BookName  : String    read FBookName   write FBookName;
    property FileLink  : Nullable<String>    read FFileLink   write FFileLink;
    property CategoryID: TCategory read GetCategory write SetCategory;
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
