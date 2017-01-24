inherited frmEditCategory: TfrmEditCategory
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1082#1072#1090#1077#1075#1086#1088#1080#1081
  ClientHeight = 182
  ClientWidth = 549
  Constraints.MinHeight = 210
  Constraints.MinWidth = 550
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 555
  ExplicitHeight = 210
  PixelsPerInch = 96
  TextHeight = 20
  inherited bvlTop: TBevel
    Top = 41
    Width = 549
    ExplicitTop = 41
    ExplicitWidth = 544
  end
  inherited bvlBottom: TBevel
    Top = 141
    Width = 549
    ExplicitTop = 141
    ExplicitWidth = 544
  end
  inherited pnlButton: TPanel
    Top = 143
    Width = 549
    ExplicitTop = 143
    ExplicitWidth = 544
    inherited btnOK: TcxButton
      Left = 298
      OnClick = btnOKClick
      ExplicitLeft = 293
    end
    inherited btnCancel: TcxButton
      Left = 423
      ExplicitLeft = 418
    end
  end
  inherited pnlHeader: TPanel
    Width = 549
    Height = 41
    ExplicitWidth = 544
    ExplicitHeight = 41
  end
  inherited pnlEditor: TPanel
    Top = 43
    Width = 549
    Height = 98
    ExplicitTop = 43
    ExplicitWidth = 544
    ExplicitHeight = 98
    object lblCategoryName: TcxLabel
      Left = 16
      Top = 16
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
      Transparent = True
    end
    object lblParentCategory: TcxLabel
      Left = 16
      Top = 56
      Caption = #1055#1088#1080#1085#1072#1076#1083#1077#1078#1080#1090' '#1082' '#1082#1072#1090#1077#1075#1086#1088#1080#1080':'
      Transparent = True
    end
    object edtCategoryName: TcxTextEdit
      Left = 136
      Top = 15
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      ExplicitWidth = 395
      Width = 400
    end
    object cbbParentCategory: TcxComboBox
      Left = 211
      Top = 55
      Anchors = [akLeft, akTop, akRight]
      Properties.AutoSelect = False
      TabOrder = 3
      ExplicitWidth = 320
      Width = 325
    end
  end
end
