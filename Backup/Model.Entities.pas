unit Model.Entities;

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
    FCategory: Proxy<TCategory>;

  private
    function GetCategoryID: TCategory;
    procedure SetCategoryID(const Value: TCategory);
  public
    property BookID: Integer read FBookID write FBookID;
    property BookName: String read FBookName write FBookName;
    property BookLink: Nullable<String> read FBookLink write FBookLink;
    property Category: TCategory read GetCategoryID write SetCategoryID;
  public
    constructor Create(ABookName: string); overload;
    constructor Create(ABookName: string; ABookLink: Nullable<string>); overload;
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
    FParent: Proxy<TCategory>;

    [ManyValuedAssociation([TAssociationProp.Lazy], [TCascadeType.SaveUpdate, TCascadeType.Merge], 'FCategory')]
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
    property Parent: TCategory read GetParentID write SetParentID;
    property Books: TList<TBook> read GetBooks;
  end;


implementation

{ TBook}

function TBook.GetCategoryID: TCategory;
begin
  result := FCategory.Value;
end;

procedure TBook.SetCategoryID(const Value: TCategory);
begin
  FCategory.Value := Value;
end;

{ TCategory}

function TCategory.GetParentID: TCategory;
begin
  result := FParent.Value;
end;

procedure TCategory.SetParentID(const Value: TCategory);
begin
  FParent.Value := Value;
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
