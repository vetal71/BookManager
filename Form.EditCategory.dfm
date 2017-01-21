inherited frmEditCategory: TfrmEditCategory
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1082#1072#1090#1077#1075#1086#1088#1080#1081
  ClientWidth = 544
  Constraints.MinWidth = 550
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 550
  PixelsPerInch = 96
  TextHeight = 20
  inherited bvlTop: TBevel
    Top = 41
    Width = 544
  end
  inherited bvlBottom: TBevel
    Width = 544
  end
  inherited pnlButton: TPanel
    Width = 544
    inherited btnOK: TcxButton
      Left = 293
    end
    inherited btnCancel: TcxButton
      Left = 418
    end
  end
  inherited pnlHeader: TPanel
    Width = 544
    Height = 41
    ExplicitHeight = 41
  end
  inherited pnlEditor: TPanel
    Top = 43
    Width = 544
    Height = 194
    ExplicitTop = 43
    ExplicitHeight = 194
    object cxLabel1: TcxLabel
      Left = 40
      Top = 24
      Caption = 'cxLabel1'
    end
    object cxLabel2: TcxLabel
      Left = 40
      Top = 64
      Caption = 'cxLabel2'
    end
    object cxTextEdit1: TcxTextEdit
      Left = 144
      Top = 32
      TabOrder = 2
      Text = 'cxTextEdit1'
      Width = 121
    end
    object cbb1: TcxComboBox
      Left = 144
      Top = 80
      TabOrder = 3
      Text = 'cbb1'
      Width = 121
    end
  end
end
