inherited frmAuditLogViewer: TfrmAuditLogViewer
  Caption = #1040#1091#1076#1080#1090#1086#1088
  ClientHeight = 542
  ClientWidth = 748
  ExplicitWidth = 764
  ExplicitHeight = 580
  PixelsPerInch = 96
  TextHeight = 20
  object mmoLog: TcxMemo [0]
    Left = 0
    Top = 0
    Align = alClient
    Properties.ScrollBars = ssVertical
    TabOrder = 0
    ExplicitWidth = 717
    ExplicitHeight = 489
    Height = 496
    Width = 748
  end
  object pnlButton: TPanel [1]
    Left = 0
    Top = 496
    Width = 748
    Height = 46
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 1
    ExplicitTop = 489
    ExplicitWidth = 717
    DesignSize = (
      748
      46)
    object btnClear: TcxButton
      Left = 622
      Top = 9
      Width = 120
      Height = 30
      Anchors = [akTop, akRight]
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      TabOrder = 0
      ExplicitLeft = 591
    end
    object chkEnableMonitor: TcxCheckBox
      Left = 13
      Top = 13
      Caption = #1040#1082#1090#1080#1074#1080#1088#1086#1074#1072#1090#1100' '#1072#1091#1076#1080#1090' '#1089#1086#1073#1099#1090#1080#1081
      State = cbsChecked
      TabOrder = 1
    end
  end
  inherited ilSmall: TcxImageList
    FormatVersion = 1
  end
  inherited ilEdit: TcxImageList
    FormatVersion = 1
  end
end
