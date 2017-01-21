inherited frmBaseEditor: TfrmBaseEditor
  BorderStyle = bsDialog
  Caption = 'frmBaseEditor'
  ClientHeight = 278
  ClientWidth = 632
  Font.Height = -15
  ExplicitWidth = 638
  ExplicitHeight = 306
  PixelsPerInch = 96
  TextHeight = 20
  object bvlTop: TBevel [0]
    Left = 0
    Top = 49
    Width = 632
    Height = 2
    Align = alTop
  end
  object bvlBottom: TBevel [1]
    Left = 0
    Top = 237
    Width = 632
    Height = 2
    Align = alBottom
    ExplicitTop = 189
  end
  object pnlButton: TPanel [2]
    Left = 0
    Top = 239
    Width = 632
    Height = 39
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      632
      39)
    object btnOK: TcxButton
      Left = 381
      Top = 4
      Width = 120
      Height = 30
      Anchors = [akTop, akRight, akBottom]
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TcxButton
      Left = 506
      Top = 4
      Width = 120
      Height = 30
      Anchors = [akTop, akRight, akBottom]
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
  end
  object pnlHeader: TPanel [3]
    Left = 0
    Top = 0
    Width = 632
    Height = 49
    Align = alTop
    BevelOuter = bvNone
    Caption = #1055#1086#1076#1087#1080#1089#1100
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
  end
  object pnlEditor: TPanel [4]
    Left = 0
    Top = 51
    Width = 632
    Height = 186
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitTop = 144
    ExplicitHeight = 95
  end
  inherited sknMain: TdxSkinController
    Left = 221
    Top = 40
  end
end
