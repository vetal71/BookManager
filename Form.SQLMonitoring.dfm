inherited frmSQLMonitoring: TfrmSQLMonitoring
  BorderStyle = bsSingle
  Caption = 'SQL '#1084#1086#1085#1080#1090#1086#1088#1080#1085#1075
  ClientHeight = 378
  ClientWidth = 525
  ExplicitWidth = 531
  ExplicitHeight = 406
  PixelsPerInch = 96
  TextHeight = 13
  object mmoLog: TcxMemo [0]
    Left = 0
    Top = 0
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 3
    ExplicitTop = 3
    Height = 332
    Width = 525
  end
  object pnlButton: TPanel [1]
    Left = 0
    Top = 332
    Width = 525
    Height = 46
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 1
    DesignSize = (
      525
      46)
    object btnExit: TcxButton
      Left = 397
      Top = 8
      Width = 120
      Height = 30
      Anchors = [akTop, akRight]
      Caption = #1042#1099#1093#1086#1076
      TabOrder = 0
      OnClick = btnExitClick
    end
    object btnClear: TcxButton
      Left = 271
      Top = 8
      Width = 120
      Height = 30
      Anchors = [akTop, akRight]
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      TabOrder = 1
    end
  end
end