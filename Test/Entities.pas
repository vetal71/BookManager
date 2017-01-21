unit Entities;

interface

uses
  SysUtils,
  Generics.Collections,
  Aurelius.Mapping.Attributes,
  Aurelius.Mapping.Metadata,
  Aurelius.Types.Blob,
  Aurelius.Types.DynamicProperties,
  Aurelius.Types.Nullable,
  Aurelius.Types.Proxy;

type
  TBook = class;
  TCategory = class;

  [Entity]
  [Table('BOOKS')]
  [Id('FBookID', TIdGenerator.IdentityOrSequence)]
  TBook = class
  private
    [Column('BOOKID', [TColumnProp.Required, TColumnProp.NoInsert, TColumnProp.NoUpdate])]
    FBookID: Integer;

    [Column('BOOKNAME', [TColumnProp.Required])]
    [DBTypeMemo]
    FBookName: String;

    [Column('BOOKLINK', [])]
    [DBTypeMemo]
    FBookLink: Nullable<String>;

    [Association([TAssociationProp.Lazy], CascadeTypeAll - [TCascadeType.Remove])]
    [JoinColumn('CATEGORYID', [], 'CATEGORYID')]
    FCategoryID: Proxy<TCategory>;

  private
    function GetCategoryID: TCategory;
    procedure SetCategoryID(const Value: TCategory);
  public
    property BookID: Integer read FBookID write FBookID;
    property BookName: String read FBookName write FBookName;
    property BookLink: Nullable<String> read FBookLink write FBookLink;
    property CategoryID: TCategory read GetCategoryID write SetCategoryID;
  end;

  [Entity]
  [Table('CATEGORIES')]
  [Id('FCategoryID', TIdGenerator.IdentityOrSequence)]
  TCategory = class
  private
    [Column('CATEGORYID', [TColumnProp.Required, TColumnProp.NoInsert, TColumnProp.NoUpdate])]
    FCategoryID: Integer;

    [Column('CATEGORYNAME', [TColumnProp.Required])]
    [DBTypeMemo]
    FCategoryName: String;

    [Association([TAssociationProp.Lazy], CascadeTypeAll - [TCascadeType.Remove])]
    [JoinColumn('PARENTID', [], 'CATEGORYID')]
    FParentID: Proxy<TCategory>;

    [ManyValuedAssociation([TAssociationProp.Lazy], [TCascadeType.SaveUpdate, TCascadeType.Merge], 'FCategoryID')]
    FBooks: Proxy<TList<TBook>>;

  private
    function GetParentID: TCategory;
    procedure SetParentID(const Value: TCategory);
    function GetBooks: TList<TBook>;
  public
    constructor Create;
    destructor Destroy; override;
    property CategoryID: Integer read FCategoryID write FCategoryID;
    property CategoryName: String read FCategoryName write FCategoryName;
    property ParentID: TCategory read GetParentID write SetParentID;
    property Books: TList<TBook> read GetBooks;
  end;


implementation

{ TBook}

function TBook.GetCategoryID: TCategory;
begin
  result := FCategoryID.Value;
end;

procedure TBook.SetCategoryID(const Value: TCategory);
begin
  FCategoryID.Value := Value;
end;

{ TCategory}

function TCategory.GetParentID: TCategory;
begin
  result := FParentID.Value;
end;

procedure TCategory.SetParentID(const Value: TCategory);
begin
  FParentID.Value := Value;
end;

constructor TCategory.Create;
begin
  inherited;
  FBooks.SetInitialValue(TList<TBook>.Create);
end;

destructor TCategory.Destroy;
begin
  FBooks.DestroyValue;
  inherited;
end;

function TCategory.GetBooks: TList<TBook>;
begin
  result := FBooks.Value;
end;

end.
