object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 467
  ClientWidth = 1090
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object btn1: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'btn1'
    TabOrder = 0
    OnClick = btn1Click
  end
  object dbg2: TDBGrid
    Left = 528
    Top = 40
    Width = 554
    Height = 419
    DataSource = SQLiteConnectionModule.ds2
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object lst1: TcxDBTreeList
    Left = 8
    Top = 39
    Width = 514
    Height = 420
    Bands = <
      item
      end>
    DataController.DataSource = SQLiteConnectionModule.ds1
    DataController.ParentField = 'ParentID'
    DataController.KeyField = 'Self'
    Navigator.Buttons.CustomButtons = <>
    TabOrder = 2
    object lst1cxDBTreeListColumn3: TcxDBTreeListColumn
      DataBinding.FieldName = 'CategoryID'
      Width = 60
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object lst1cxDBTreeListColumn1: TcxDBTreeListColumn
      Caption.AlignHorz = taCenter
      Caption.GlyphAlignHorz = taCenter
      Caption.Text = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1082#1072#1090#1077#1075#1086#1088#1080#1080
      DataBinding.FieldName = 'CategoryName'
      Width = 270
      Position.ColIndex = 1
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object lst1cxDBTreeListColumn2: TcxDBTreeListColumn
      DataBinding.FieldName = 'ParentID'
      Width = 60
      Position.ColIndex = 2
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object lst1cxDBTreeListColumn4: TcxDBTreeListColumn
      DataBinding.FieldName = 'Self'
      Position.ColIndex = 3
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
  end
end
