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
  strict private
    [Column('BOOKID', [TColumnProp.Required, TColumnProp.NoInsert, TColumnProp.NoUpdate])]
    FBookID: Integer;

    [Column('BOOKNAME', [TColumnProp.Required])]
    [DBTypeMemo]
    FBookName: String;

    [Column('BOOKLINK', [])]
    [DBTypeMemo]
    FBookLink: Nullable<String>;

  public
    property BookID: Integer read FBookID write FBookID;
    property BookName: String read FBookName write FBookName;
    property BookLink: Nullable<String> read FBookLink write FBookLink;
  public
    constructor Create(ABookName: string); overload;
    constructor Create(ABookName: string; ABookLink: Nullable<string>); overload;
  end;

  [Entity]
  [Table('CATEGORIES')]
  [Id('FCategoryID', TIdGenerator.IdentityOrSequence)]
  TCategory = class
  strict private
    [Column('CATEGORYID', [TColumnProp.Required, TColumnProp.NoInsert, TColumnProp.NoUpdate])]
    FCategoryID: Integer;

    [Column('CATEGORYNAME', [TColumnProp.Required])]
    [DBTypeMemo]
    FCategoryName: String;

    [Association([TAssociationProp.Lazy], CascadeTypeAll - [TCascadeType.Remove])]
    [JoinColumn('PARENTID', [], 'CATEGORYID')]
    FParent: Proxy<TCategory>;

    [ManyValuedAssociation([TAssociationProp.Lazy], CascadeTypeAllRemoveOrphan)]
    FBooks: Proxy<TList<TBook>>;

  private
    function GetParentID: TCategory;
    procedure SetParentID(const Value: TCategory);
    function GetBooks: TList<TBook>;
  public
    constructor Create; overload;
    constructor Create(AName: string); overload;
    destructor Destroy; override;
    property CategoryID: Integer read FCategoryID write FCategoryID;
    property CategoryName: String read FCategoryName write FCategoryName;
    property Parent: TCategory read GetParentID write SetParentID;
    property Books: TList<TBook> read GetBooks;
  end;


implementation

{ TBook}

constructor TBook.Create(ABookName: string);
begin
  FBookName := ABookName;
end;

constructor TBook.Create(ABookName: string; ABookLink: Nullable<string>);
begin
  Create(ABookName);
  FBookLink := ABookLink;
end;

{ TCategory}

function TCategory.GetParentID: TCategory;
begin
  Result := FParent.Value;
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

constructor TCategory.Create(AName: string);
begin
  Create;
  FCategoryName := AName;
end;

destructor TCategory.Destroy;
begin
  FBooks.DestroyValue;
  inherited;
end;

function TCategory.GetBooks: TList<TBook>;
begin
  Result := FBooks.Value;
end;

end.
