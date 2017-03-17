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
  dxSkinXmas2008Blue, cxInplaceContainer, cxTLData, cxDBTL, cxMaskEdit,
  Uni, SQLiteUniProvider;

type
  TForm1 = class(TForm)
    btn1: TButton;
    mmo1: TMemo;
    procedure btn1Click(Sender: TObject);
  private

  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btn1Click(Sender: TObject);
var
  UniConnection: TUniConnection;
  UniQuery: TUniQuery;
begin
  UniConnection := TUniConnection.Create(nil);
  try
    UniConnection.ConnectString := 'Provider Name=SQLite;Data Source=:memory:';
    UniConnection.Connect;
    mmo1.Lines.Add('SQLite version: ' +  UniConnection.ClientVersion); //3.8.5
    mmo1.Lines.Add('UniDAC Version: ' + UniDACVersion); //5.5.12
    UniConnection.ExecSQL('create table visits(id integer, from_visit integer)');
    UniConnection.ExecSQL('create table path(id integer, from_visit integer)');
    UniConnection.ExecSQL('insert into visits values(27585, 1)');
    UniConnection.ExecSQL('insert into path values(1, 1)');
    UniQuery := TUniQuery.Create(nil);
    try
      UniQuery.Connection := UniConnection;
      UniQuery.SQL.Text := 'with recursive path as (select id, from_visit from visits where visits.id=27585 union all select visits.id, visits.from_visit from path join visits on (path.from_visit = visits.id) ) select * from path';
      UniQuery.Open;
      mmo1.Lines.Add('Record Count: ' + IntToStr(UniQuery.RecordCount)); //1
    finally
      UniQuery.Free;
    end;
  finally
    UniConnection.Free;
  end;
end;

end.
