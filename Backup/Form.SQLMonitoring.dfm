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
    DesignSize = (
      717
      46)
    object btnClear: TcxButton
      Left = 591
      Top = 9
      Width = 120
      Height = 30
      Anchors = [akTop, akRight]
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      TabOrder = 0
      OnClick = btnClearClick
    end
    object chkEnableMonitor: TcxCheckBox
      Left = 13
      Top = 13
      Caption = #1040#1082#1090#1080#1074#1080#1088#1086#1074#1072#1090#1100' SQL '#1084#1086#1085#1080#1090#1086#1088#1080#1085#1075
      State = cbsChecked
      TabOrder = 1
      OnClick = chkEnableMonitorClick
    end
  end
  inherited ilSmall: TcxImageList
    FormatVersion = 1
  end
  inherited ilEdit: TcxImageList
    FormatVersion = 1
  end
end
