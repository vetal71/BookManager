inherited frmSQLMonitoring: TfrmSQLMonitoring
  BorderStyle = bsSingle
  Caption = 'SQL '#1084#1086#1085#1080#1090#1086#1088#1080#1085#1075
  ClientHeight = 535
  ClientWidth = 717
  ExplicitWidth = 723
  ExplicitHeight = 563
  PixelsPerInch = 96
  TextHeight = 20
  object mmoLog: TcxMemo [0]
    Left = 0
    Top = 0
    Align = alClient
    Properties.ScrollBars = ssVertical
    TabOrder = 0
    ExplicitWidth = 525
    ExplicitHeight = 332
    Height = 489
    Width = 717
  end
  object pnlButton: TPanel [1]
    Left = 0
    Top = 489
    Width = 717
    Height = 46
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 1
    ExplicitTop = 332
    ExplicitWidth = 525
    DesignSize = (
      717
      46)
    object btnExit: TcxButton
      Left = 589
      Top = 8
      Width = 120
      Height = 30
      Anchors = [akTop, akRight]
      Caption = #1042#1099#1093#1086#1076
      TabOrder = 0
      OnClick = btnExitClick
      ExplicitLeft = 397
    end
    object btnClear: TcxButton
      Left = 463
      Top = 8
      Width = 120
      Height = 30
      Anchors = [akTop, akRight]
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      TabOrder = 1
      ExplicitLeft = 271
    end
  end
end
