object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 508
  ClientWidth = 763
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object btnReceiveListFile: TButton
    Left = 114
    Top = 8
    Width = 150
    Height = 25
    Caption = #1055#1086#1083#1091#1095#1080#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1092#1072#1081#1083#1086#1074
    TabOrder = 0
    OnClick = btnReceiveListFileClick
  end
  object mmo1: TMemo
    Left = 295
    Top = 39
    Width = 460
    Height = 466
    TabOrder = 1
  end
  object btn2: TButton
    Left = 8
    Top = 8
    Width = 100
    Height = 25
    Caption = #1040#1074#1090#1086#1088#1080#1079#1072#1094#1080#1103
    TabOrder = 2
    OnClick = btn2Click
  end
  object lst1: TListBox
    Left = 8
    Top = 39
    Width = 281
    Height = 466
    ItemHeight = 13
    TabOrder = 3
    OnClick = lst1Click
  end
  object RESTClient1: TRESTClient
    Authenticator = OAuth2Authenticator1
    BaseURL = 'https://www.googleapis.com/drive/v2'
    Params = <>
    HandleRedirects = True
    Left = 416
    Top = 280
  end
  object RESTRequest1: TRESTRequest
    Client = RESTClient1
    Params = <>
    Response = RESTResponse1
    OnAfterExecute = RESTRequest1AfterExecute
    SynchronizedEvents = False
    Left = 416
    Top = 216
  end
  object RESTResponse1: TRESTResponse
    Left = 416
    Top = 160
  end
  object OAuth2Authenticator1: TOAuth2Authenticator
    AccessToken = 
      'ya29.GlsWBKGmJbL5mts7eIw3Yl1vjLiOIh1R4mwnuHzdd6ISBjIwn35tPw4tFTb' +
      'iMK0fGj2_iZ-CcjAc5rz_Zk7tT5e1VIrkQAsGAHXOobM2KWb3Cyi-XeB2tNJfxbe' +
      'N'
    AccessTokenEndpoint = 'https://accounts.google.com/o/oauth2/token'
    AccessTokenExpiry = 42816.437029108800000000
    AuthorizationEndpoint = 'https://accounts.google.com/o/oauth2/auth'
    ClientID = 
      '496929878224-n96vi711iu5buhki7m6p3r8ne5n14j66.apps.googleusercon' +
      'tent.com'
    ClientSecret = 'IbmtJrRD2GfJE6BKkAmGNFci'
    RedirectionEndpoint = 'urn:ietf:wg:oauth:2.0:oob'
    RefreshToken = '1/92U-jhXpInLb15kBbdFp947eiCnkCIgdGHFslv5cCLU'
    Scope = 'https://www.googleapis.com/auth/drive'
    TokenType = ttBEARER
    Left = 416
    Top = 104
    AccessTokenExpiryDate = 42816.4370291088d
  end
end
