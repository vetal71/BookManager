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
  Uni, SQLiteUniProvider, IPPeerClient, REST.Client, REST.Authenticator.OAuth,
  Data.Bind.Components, Data.Bind.ObjectScope, System.JSON, System.StrUtils;

type
  TForm1 = class(TForm)
    btnReceiveListFile: TButton;
    mmo1: TMemo;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    OAuth2Authenticator1: TOAuth2Authenticator;
    btn2: TButton;
    lst1: TListBox;
    procedure btnReceiveListFileClick(Sender: TObject);
    procedure RESTRequest1AfterExecute(Sender: TCustomRESTRequest);
    procedure lst1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
  private
    procedure ParseFile(AJSONObject: TJSONObject);
    procedure ParseFileList(AJSONObject: TJSONObject);
    procedure TitleChanged(const ATitle: string; var DoCloseWebView : boolean);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  Vcl.FileCtrl, REST.Types, REST.Authenticator.OAuth.WebForm.Win;

{$R *.dfm}

procedure TForm1.btn2Click(Sender: TObject);
var wf: Tfrm_OAuthWebForm;
begin
  //создаем окно с браузером для перенаправления пользователя на страницу Google
  wf:=Tfrm_OAuthWebForm.Create(self);
  try
    //определяем обработчик события смены Title
    wf.OnTitleChanged := TitleChanged;
    //показываем окнои открываем в браузере URL с формой подтверждения доступа
    wf.ShowModalWithURL(OAuth2Authenticator1.AuthorizationRequestURI);
  finally
    wf.Release;
  end;
  //меняем AuthCode на AccessToken
  OAuth2Authenticator1.ChangeAuthCodeToAccesToken;
  //выводим значения ключей в Memo
  mmo1.Lines.Add(OAuth2Authenticator1.AccessToken);
  mmo1.Lines.Add(OAuth2Authenticator1.RefreshToken);
  mmo1.Lines.Add(DateTimeToStr(OAuth2Authenticator1.AccessTokenExpiry));
end;

procedure TForm1.btnReceiveListFileClick(Sender: TObject);
begin
  RESTRequest1.Method   := rmGET;    //определяем HTTP-метод - GET
  RESTRequest1.Resource :='/files';  //путь к ресурсу API
  RESTRequest1.Execute;              //выполняем запрос
end;

procedure TForm1.RESTRequest1AfterExecute(Sender: TCustomRESTRequest);
const
  //тип ответа сервера
  cResponseKind : array [0..3] of string = ('drive#fileList','drive#file','drive#about','drive#revision');
var
  JSONObject: TJSONObject;
  Kind: string;
begin
  if Assigned(Sender.Response.JSONValue) then
  begin
    JSONObject := Sender.Response.JSONValue as TJSONObject;
    //узнаем тип ответа сервера
    Sender.Response.GetSimpleValue('kind', Kind);
    case AnsiIndexStr(Kind, cResponseKind) of
      0:ParseFileList(JSONObject);
      1:ParseFile(JSONObject);
    end;
  end;
end;

procedure TForm1.TitleChanged(const ATitle: string;
  var DoCloseWebView: boolean);
begin
  if (StartsText('Success code', ATitle)) then
  begin
    OAuth2Authenticator1.AuthCode:= Copy(ATitle, 14, Length(ATitle));
    if (OAuth2Authenticator1.AuthCode <> '') then
      DoCloseWebView := TRUE;
  end;
end;

procedure TForm1.lst1Click(Sender: TObject);
var Id: string;
begin
  Id:=Copy(lst1.Items[lst1.ItemIndex],
           pos('//',lst1.Items[lst1.ItemIndex])+2,
           Length(lst1.Items[lst1.ItemIndex]));
  RESTRequest1.Resource:='/files/{fileId}';
  RESTRequest1.Method:=rmGET;
  RESTRequest1.Params.AddItem('fileId', Id, TRESTRequestParameterKind.pkURLSEGMENT);
  {или так
    RESTRequest1.Params.AddUrlSegment('fileId', Id);
  }
  RESTRequest1.Execute;
end;

procedure TForm1.ParseFile(AJSONObject: TJSONObject);
begin
  mmo1.Lines.Clear;
  mmo1.Lines.Add('Title: '+AJSONObject.Get('title').JsonValue.Value);
  mmo1.Lines.Add('Mime-Type: '+AJSONObject.Get('mimeType').JsonValue.Value);
  mmo1.Lines.Add('Created Date: '+AJSONObject.Get('createdDate').JsonValue.Value);
end;

procedure TForm1.ParseFileList(AJSONObject: TJSONObject);
var FileObject: TJSONObject;
    Pair: TJSONPair;
    NextToken: string;
    ListItems: TJSONArray;
    I: Integer;
begin
  //получаем параметр URL для получения следующей части списка файлов
  Pair:=AJSONObject.Get('nextPageToken');
  if Assigned(Pair) then
    NextToken:=Pair.JsonValue.Value;
  //получаем список файлов
  ListItems:=AJSONObject.Get('items').JsonValue as TJSONArray;
  //парсим элементы массива
  for I := 0 to ListItems.Size-1 do
    begin
      FileObject:=ListItems.Get(i)as TJSONObject;
      //получаем название файла
      lst1.Items.Add(FileObject.Get('title').JsonValue.Value+'//'+FileObject.Get('id').JsonValue.Value);
      //....
    end;
   //если получены не все файлы, то повторяем запрос, включая в URL параметр pageToken
   if Length(NextToken)>0 then
     begin
       RESTRequest1.Params.Clear;
       RESTRequest1.Params.AddItem('pageToken',NextToken, pkGETorPOST);
       RESTRequest1.Execute;
    end;
end;

end.
