inherited frmLibraryView: TfrmLibraryView
  Caption = #1041#1080#1073#1083#1080#1086#1090#1077#1082#1072
  ClientHeight = 615
  ClientWidth = 1135
  OnDestroy = FormDestroy
  OnShow = FormShow
  ExplicitWidth = 1151
  ExplicitHeight = 654
  PixelsPerInch = 96
  TextHeight = 20
  object pnlLeft: TPanel [0]
    Left = 0
    Top = 0
    Width = 449
    Height = 615
    Align = alLeft
    BevelOuter = bvLowered
    TabOrder = 0
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
        OnClick = btnAddCategoryClick
      end
      object btnEditCategory: TToolButton
        Left = 23
        Top = 0
        Hint = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' '#1079#1072#1087#1080#1089#1100
        Caption = 'btnEditCategory'
        ImageIndex = 2
        OnClick = btnEditCategoryClick
      end
      object btnDelCategory: TToolButton
        Left = 46
        Top = 0
        Hint = #1059#1076#1072#1083#1080#1090#1100' '#1079#1072#1087#1080#1089#1100
        Caption = 'btnDelCategory'
        ImageIndex = 1
        OnClick = btnDelCategoryClick
      end
      object btnRefresh: TToolButton
        Left = 69
        Top = 0
        Caption = 'btnRefreshCategory'
        ImageIndex = 3
        OnClick = btnRefreshClick
      end
    end
    object lstCategories: TcxDBTreeList
      AlignWithMargins = True
      Left = 4
      Top = 26
      Width = 441
      Height = 585
      Align = alClient
      Bands = <
        item
        end>
      DataController.DataSource = db.dsCategories
      DataController.ParentField = 'PARENT_ID'
      DataController.KeyField = 'ID'
      Navigator.Buttons.CustomButtons = <>
      OptionsBehavior.ExpandOnDblClick = False
      OptionsBehavior.IncSearch = True
      OptionsData.Editing = False
      OptionsData.Deleting = False
      OptionsSelection.CellSelect = False
      OptionsView.ColumnAutoWidth = True
      RootValue = -1
      TabOrder = 1
      OnDblClick = btnEditCategoryClick
      object lstCategoriesCategoryID: TcxDBTreeListColumn
        Caption.AlignHorz = taCenter
        Caption.Text = #1050#1086#1076
        DataBinding.FieldName = 'ID'
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
    Height = 615
  end
  object pnlRight: TPanel [2]
    Left = 461
    Top = 0
    Width = 674
    Height = 615
    Align = alClient
    BevelOuter = bvLowered
    TabOrder = 2
    ExplicitWidth = 604
    object grdBooks: TcxGrid
      AlignWithMargins = True
      Left = 4
      Top = 26
      Width = 666
      Height = 585
      Align = alClient
      TabOrder = 0
      ExplicitWidth = 596
      object grdBooksView: TcxGridDBTableView
        OnDblClick = grdBooksViewDblClick
        Navigator.Buttons.CustomButtons = <>
        FindPanel.DisplayMode = fpdmAlways
        FindPanel.FocusViewOnApplyFilter = True
        FindPanel.InfoText = #1042#1074#1077#1076#1080#1090#1077' '#1090#1077#1082#1089#1090' '#1076#1083#1103' '#1087#1086#1080#1089#1082#1072'...'
        FindPanel.UseExtendedSyntax = True
        DataController.DataSource = db.Books
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
        OptionsSelection.InvertSelect = False
        OptionsView.CellEndEllipsis = True
        OptionsView.NoDataToDisplayInfoText = #1053#1077#1090' '#1076#1072#1085#1085#1099#1093' '#1076#1083#1103' '#1086#1090#1086#1073#1088#1072#1078#1077#1085#1080#1103
        OptionsView.CellAutoHeight = True
        OptionsView.ColumnAutoWidth = True
        OptionsView.GroupByBox = False
        OptionsView.HeaderEndEllipsis = True
        OptionsView.Indicator = True
        object grdBooksViewID: TcxGridDBColumn
          Caption = #1050#1086#1076
          DataBinding.FieldName = 'ID'
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
      Width = 672
      Height = 22
      AutoSize = True
      Caption = #1055#1072#1085#1077#1083#1100' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1103' '#1082#1085#1080#1075#1080
      Images = ilEdit
      TabOrder = 1
      ExplicitWidth = 602
      object btnAddBook: TToolButton
        Left = 0
        Top = 0
        Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1079#1072#1087#1080#1089#1100
        Caption = 'btnAdd'
        ImageIndex = 0
        OnClick = btnAddBookClick
      end
      object btnEditBook: TToolButton
        Left = 23
        Top = 0
        Hint = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' '#1079#1072#1087#1080#1089#1100
        Caption = 'btnEdit'
        ImageIndex = 2
        OnClick = btnEditBookClick
      end
      object btnDelBook: TToolButton
        Left = 46
        Top = 0
        Hint = #1059#1076#1072#1083#1080#1090#1100' '#1079#1072#1087#1080#1089#1100
        Caption = 'btnDel'
        ImageIndex = 1
        OnClick = btnDelBookClick
      end
      object btnRefreshBook: TToolButton
        Left = 69
        Top = 0
        Caption = 'btnRefreshBook'
        ImageIndex = 3
        OnClick = btnRefreshBookClick
      end
    end
  end
  inherited ilSmall: TcxImageList
    FormatVersion = 1
  end
  inherited ilEdit: TcxImageList
    FormatVersion = 1
  end
end
