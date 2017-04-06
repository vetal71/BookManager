object DM: TDM
  OldCreateOrder = True
  OnDestroy = DataModuleDestroy
  Height = 422
  Width = 602
  object conn: TUniConnection
    ProviderName = 'SQLite'
    Database = 'd:\DevProjects\BookManager\WorkLibrary.db'
    Options.KeepDesignConnected = False
    LoginPrompt = False
    Left = 32
    Top = 16
  end
  object SQLiteProvider: TSQLiteUniProvider
    Left = 112
    Top = 16
  end
  object SQLMonitor: TUniSQLMonitor
    Options = [moDialog, moSQLMonitor, moDBMonitor, moCustom, moHandled]
    TraceFlags = [tfQPrepare, tfQExecute, tfQFetch, tfError, tfStmt, tfConnect, tfTransact, tfBlob, tfService, tfMisc, tfParams, tfObjDestroy, tfPool]
    OnSQL = SQLMonitorSQL
    Left = 200
    Top = 16
  end
  object Books: TUniDataSource
    DataSet = qryBooks
    OnDataChange = BooksDataChange
    Left = 110
    Top = 120
  end
  object qryBooks: TUniQuery
    KeyFields = 'ID'
    SQLInsert.Strings = (
      'INSERT INTO Books'
      '  (ID, BOOKNAME, BOOKLINK, CATEGORY_ID)'
      'VALUES'
      '  (:ID, :BOOKNAME, :BOOKLINK, :CATEGORY_ID)')
    SQLDelete.Strings = (
      'DELETE FROM Books'
      'WHERE'
      '  ID = :Old_ID')
    SQLUpdate.Strings = (
      'UPDATE Books'
      'SET'
      
        '  ID = :ID, BOOKNAME = :BOOKNAME, BOOKLINK = :BOOKLINK, CATEGORY' +
        '_ID = :CATEGORY_ID'
      'WHERE'
      '  ID = :Old_ID')
    SQLRefresh.Strings = (
      'SELECT ID, BOOKNAME, BOOKLINK, CATEGORY_ID FROM Books'
      'WHERE'
      '  ID = :ID')
    SQLRecCount.Strings = (
      'SELECT count(*) FROM (SELECT * FROM Books'
      ')')
    Connection = conn
    SQL.Strings = (
      'select * from Books'
      'order by id')
    MasterSource = dsCategories
    MasterFields = 'ID'
    DetailFields = 'CATEGORY_ID'
    Debug = True
    Options.RequiredFields = False
    AfterDelete = qryBooksAfterDelete
    Left = 40
    Top = 120
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'ID'
        Value = nil
      end>
  end
  object dsCategories: TUniDataSource
    DataSet = qryCategories
    OnDataChange = dsCategoriesDataChange
    Left = 110
    Top = 184
  end
  object qryCategories: TUniQuery
    KeyFields = 'ID'
    SQLInsert.Strings = (
      'INSERT INTO categories'
      '  (ID, CATEGORYNAME, PARENT_ID)'
      'VALUES'
      '  (:ID, :CATEGORYNAME, :PARENT_ID)')
    SQLDelete.Strings = (
      'DELETE FROM categories'
      'WHERE'
      '  ID = :Old_ID')
    SQLUpdate.Strings = (
      'UPDATE categories'
      'SET'
      '  ID = :ID, CATEGORYNAME = :CATEGORYNAME, PARENT_ID = :PARENT_ID'
      'WHERE'
      '  ID = :Old_ID')
    SQLRefresh.Strings = (
      'select '
      '  c.id, '
      '  c.categoryname, '
      '  c.parent_id, '
      
        '  (select count(*) from books b where b.category_id = c.id) as c' +
        'nt_book '
      'from categories c'
      'WHERE'
      '  ID = :ID')
    SQLRecCount.Strings = (
      'SELECT count(*) FROM (SELECT * FROM categories'
      ')')
    Connection = conn
    SQL.Strings = (
      'select '
      '  c.id, '
      '  c.categoryname, '
      '  c.parent_id, '
      '  case c.id'
      '  when 1 then (select count(*) from books b)'
      '  else (select count(*) from books b where b.category_id = c.id)'
      '  end as cnt_book '
      'from categories c '
      'order by id')
    Options.RequiredFields = False
    Left = 40
    Top = 184
  end
end
