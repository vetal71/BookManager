inherited frmLibraryView: TfrmLibraryView
  Caption = #1041#1080#1073#1083#1080#1086#1090#1077#1082#1072
  ClientHeight = 615
  ClientWidth = 1039
  OnCreate = FormCreate
  ExplicitWidth = 1055
  ExplicitHeight = 653
  PixelsPerInch = 96
  TextHeight = 20
  object pnlLeft: TPanel [0]
    Left = 0
    Top = 0
    Width = 449
    Height = 575
    Align = alLeft
    BevelOuter = bvLowered
    TabOrder = 0
    ExplicitTop = 65
    ExplicitHeight = 550
    object tbCategoryEdit: TToolBar
      Left = 1
      Top = 1
      Width = 447
      Height = 22
      AutoSize = True
      Caption = #1055#1072#1085#1077#1083#1100' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1103' '#1082#1072#1090#1077#1075#1086#1088#1080#1080
      Images = ilEdit
      TabOrder = 0
      object btnAddCategory: TToolButton
        Left = 0
        Top = 0
        Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1079#1072#1087#1080#1089#1100
        Caption = 'btnAddCategory'
        ImageIndex = 0
      end
      object btnEditCategory: TToolButton
        Left = 23
        Top = 0
        Hint = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' '#1079#1072#1087#1080#1089#1100
        Caption = 'btnEditCategory'
        ImageIndex = 2
      end
      object btnDelCategory: TToolButton
        Left = 46
        Top = 0
        Hint = #1059#1076#1072#1083#1080#1090#1100' '#1079#1072#1087#1080#1089#1100
        Caption = 'btnDelCategory'
        ImageIndex = 1
      end
      object btnRefresh: TToolButton
        Left = 69
        Top = 0
        Caption = 'btnRefreshCategory'
        ImageIndex = 3
      end
    end
    object lstCategories: TcxDBTreeList
      AlignWithMargins = True
      Left = 4
      Top = 26
      Width = 441
      Height = 545
      Align = alClient
      Bands = <
        item
        end>
      DataController.ParentField = 'Parent'
      DataController.KeyField = 'Self'
      Navigator.Buttons.CustomButtons = <>
      OptionsSelection.CellSelect = False
      RootValue = -1
      TabOrder = 1
      ExplicitHeight = 520
      object lstCategoriesCategoryID: TcxDBTreeListColumn
        Caption.AlignHorz = taCenter
        Caption.Text = #1050#1086#1076
        DataBinding.FieldName = 'CategoryID'
        Width = 80
        Position.ColIndex = 0
        Position.RowIndex = 0
        Position.BandIndex = 0
        Summary.FooterSummaryItems = <>
        Summary.GroupFooterSummaryItems = <>
      end
      object lstCategoriesCategoryName: TcxDBTreeListColumn
        Caption.AlignHorz = taCenter
        Caption.Text = #1050#1072#1090#1077#1075#1086#1088#1080#1103
        DataBinding.FieldName = 'CategoryName'
        Width = 336
        Position.ColIndex = 1
        Position.RowIndex = 0
        Position.BandIndex = 0
        Summary.FooterSummaryItems = <>
        Summary.GroupFooterSummaryItems = <>
      end
    end
  end
  object MainSplitter: TcxSplitter [1]
    Left = 449
    Top = 0
    Width = 12
    Height = 575
    ExplicitTop = 65
    ExplicitHeight = 550
  end
  object pnlRight: TPanel [2]
    Left = 461
    Top = 0
    Width = 578
    Height = 575
    Align = alClient
    BevelOuter = bvLowered
    TabOrder = 2
    ExplicitLeft = 224
    ExplicitTop = 65
    ExplicitWidth = 815
    ExplicitHeight = 550
    object grdBooks: TcxGrid
      AlignWithMargins = True
      Left = 4
      Top = 26
      Width = 570
      Height = 545
      Align = alClient
      TabOrder = 0
      ExplicitWidth = 807
      ExplicitHeight = 520
      object grdBooksView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        FindPanel.InfoText = #1042#1074#1077#1076#1080#1090#1077' '#1090#1077#1082#1089#1090' '#1076#1083#1103' '#1087#1086#1080#1089#1082#1072'...'
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        FilterRow.InfoText = #1050#1083#1080#1082#1085#1080#1090#1077' '#1079#1076#1077#1089#1100' '#1076#1083#1103' '#1076#1086#1073#1072#1074#1083#1077#1085#1080#1103' '#1092#1080#1083#1100#1090#1088#1072
        OptionsBehavior.IncSearch = True
        OptionsCustomize.ColumnGrouping = False
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnMoving = False
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsSelection.CellSelect = False
        OptionsView.CellEndEllipsis = True
        OptionsView.NoDataToDisplayInfoText = #1053#1077#1090' '#1076#1072#1085#1085#1099#1093' '#1076#1083#1103' '#1086#1090#1086#1073#1088#1072#1078#1077#1085#1080#1103
        OptionsView.CellAutoHeight = True
        OptionsView.GroupByBox = False
        OptionsView.HeaderEndEllipsis = True
        OptionsView.Indicator = True
        object grdBooksViewID: TcxGridDBColumn
          Caption = #1050#1086#1076
          DataBinding.FieldName = 'BookID'
          HeaderAlignmentHorz = taCenter
        end
        object grdBooksViewBOOK_NAME: TcxGridDBColumn
          Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1082#1085#1080#1075#1080
          DataBinding.FieldName = 'BookName'
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          Width = 401
        end
        object grdBooksViewFILE_LINK: TcxGridDBColumn
          Caption = #1055#1091#1090#1100' '#1082' '#1092#1072#1081#1083#1091
          DataBinding.FieldName = 'BookLink'
          HeaderAlignmentHorz = taCenter
          Width = 397
        end
      end
      object grdBooksLevel: TcxGridLevel
        GridView = grdBooksView
      end
    end
    object tbBookEdit: TToolBar
      Left = 1
      Top = 1
      Width = 576
      Height = 22
      AutoSize = True
      Caption = #1055#1072#1085#1077#1083#1100' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1103' '#1082#1085#1080#1075#1080
      Images = ilEdit
      TabOrder = 1
      ExplicitWidth = 813
      object btnAddBook: TToolButton
        Left = 0
        Top = 0
        Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1079#1072#1087#1080#1089#1100
        Caption = 'btnAdd'
        ImageIndex = 0
      end
      object btnEditBook: TToolButton
        Left = 23
        Top = 0
        Hint = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' '#1079#1072#1087#1080#1089#1100
        Caption = 'btnEdit'
        ImageIndex = 2
      end
      object btnDelBook: TToolButton
        Left = 46
        Top = 0
        Hint = #1059#1076#1072#1083#1080#1090#1100' '#1079#1072#1087#1080#1089#1100
        Caption = 'btnDel'
        ImageIndex = 1
      end
      object btnRefreshBook: TToolButton
        Left = 69
        Top = 0
        Caption = 'btnRefreshBook'
        ImageIndex = 3
      end
    end
  end
  object aiProgress: TdxActivityIndicator [3]
    Left = 0
    Top = 575
    Width = 1039
    Height = 40
    Align = alBottom
    PropertiesClassName = 'TdxActivityIndicatorHorizontalDotsProperties'
    Visible = False
    ExplicitLeft = -237
    ExplicitWidth = 1276
  end
  inherited ilSmall: TcxImageList
    FormatVersion = 1
  end
  inherited ilEdit: TcxImageList
    FormatVersion = 1
  end
  object CategoriesDS: TAureliusDataset
    FieldDefs = <>
    Left = 416
    Top = 257
  end
  object dsCategories: TDataSource
    DataSet = CategoriesDS
    Left = 509
    Top = 257
  end
  object BooksDS: TAureliusDataset
    FieldDefs = <>
    Left = 416
    Top = 313
  end
  object dsBooks: TDataSource
    DataSet = BooksDS
    Left = 509
    Top = 313
  end
end
