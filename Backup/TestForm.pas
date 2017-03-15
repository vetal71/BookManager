unit TestForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  System.Generics.Collections,
  Aurelius.Drivers.Interfaces,
  Aurelius.Engine.DatabaseManager,
  Aurelius.Engine.ObjectManager,
  ConnectionModule, Vcl.StdCtrls,
  Entities, Data.DB, Vcl.Grids, Vcl.DBGrids, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxCustomData, cxStyles, cxTL,
  cxTLdxBarBuiltInMenu, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray,
  dxSkinOffice2013White, dxSkinOffice2016Colorful, dxSkinOffice2016Dark,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxInplaceContainer, cxTLData, cxDBTL, cxMaskEdit;

type
  TForm1 = class(TForm)
    btn1: TButton;
    dbg2: TDBGrid;
    lst1: TcxDBTreeList;
    lst1cxDBTreeListColumn1: TcxDBTreeListColumn;
    lst1cxDBTreeListColumn2: TcxDBTreeListColumn;
    lst1cxDBTreeListColumn3: TcxDBTreeListColumn;
    lst1cxDBTreeListColumn4: TcxDBTreeListColumn;
    procedure FormCreate(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FDBConnection: IDBConnection;
    FManager: TObjectManager;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btn1Click(Sender: TObject);
var
  Category: TCategory;
begin
  Category := TCategory.Create;
  Category.CategoryName := 'Все книги';
  FManager.Save(Category);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  FDBManager: TDatabaseManager;
  Categories: TList<TCategory>;
begin
  FDBConnection := TSQLiteConnectionModule.CreateConnection;
  FDBManager := TDatabaseManager.Create(FDBConnection);
  try
    FDBManager.UpdateDatabase;
  finally
    FDBManager.Free;
  end;

  FManager := TObjectManager.Create(FDBConnection);

  Categories := FManager.Find<TCategory>.List;
  SQLiteConnectionModule.AureliusDataset1.SetSourceList(Categories);
  SQLiteConnectionModule.AureliusDataset1.Manager := FManager;
  SQLiteConnectionModule.AureliusDataset1.Open;

  SQLiteConnectionModule.AureliusDataset2.DatasetField :=
    SQLiteConnectionModule.AureliusDataset1.FieldByName('Books') as TDataSetField;
//  SQLiteConnectionModule.AureliusDataset2.SetSourceList(FManager.Find<TBook>.List);
  SQLiteConnectionModule.AureliusDataset2.Open;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FManager.Free;
end;

end.
