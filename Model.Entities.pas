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

  [Entity, Automapping]
  [Table('BOOKS')]
  TBook = class
  strict private
    FID: Integer;

    [Column('BOOKNAME', [TColumnProp.Required])]
    [DBTypeMemo]
    FBookName: String;

    [Column('BOOKLINK', [])]
    [DBTypeMemo]
    FBookLink: Nullable<String>;

    [Association([TAssociationProp.Lazy], CascadeTypeAll - [TCascadeType.Remove])]
    [JoinColumn('BOOKS_CATEGORY_ID', [], 'ID')]
    FBooksCategory: Proxy<TCategory>;
    function GetBooksCategory: TCategory;
    procedure SetBooksCategory(const Value: TCategory);

  public
    property ID: Integer read FID write FID;
    property BookName: String read FBookName write FBookName;
    property BookLink: Nullable<String> read FBookLink write FBookLink;
    property BooksCategory: TCategory read GetBooksCategory write SetBooksCategory;
  public
    constructor Create(ABookName: string); overload;
    constructor Create(ABookName: string; ABookLink: Nullable<string>); overload;
  end;

  [Entity, Automapping]
  [Table('CATEGORIES')]
  TCategory = class
  strict private
    FID: Integer;

    [Column('CATEGORYNAME', [TColumnProp.Required])]
    [DBTypeMemo]
    FCategoryName: String;

    [Association([TAssociationProp.Lazy], CascadeTypeAll - [TCascadeType.Remove])]
    FParent: Proxy<TCategory>;

    [ManyValuedAssociation([TAssociationProp.Lazy], Aurelius.Mapping.Metadata.CascadeTypeAllRemoveOrphan)]
    FBooks: Proxy<TList<TBook>>;
    function GetBooks: TList<TBook>;
    function GetParent: TCategory;
    procedure SetParent(const Value: TCategory);
  public
    constructor Create; overload;
    constructor Create(AName: string); overload;
    destructor Destroy; override;
    property ID: Integer read FID write FID;
    property CategoryName: String read FCategoryName write FCategoryName;
    property Parent: TCategory read GetParent write SetParent;
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

function TBook.GetBooksCategory: TCategory;
begin
  Result := FBooksCategory.Value;
end;

procedure TBook.SetBooksCategory(const Value: TCategory);
begin
  FBooksCategory.Value := Value;
end;

{ TCategory}

function TCategory.GetParent: TCategory;
begin
  Result := FParent.Value;
end;

procedure TCategory.SetParent(const Value: TCategory);
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
