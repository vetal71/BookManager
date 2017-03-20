object DM: TDM
  OldCreateOrder = True
  OnDestroy = DataModuleDestroy
  Height = 422
  Width = 602
  object conn: TUniConnection
    ProviderName = 'SQLite'
    Database = 'd:\DevProjects\BookManager\WorkLibrary.db'
    Options.KeepDesignConnected = False
    Connected = True
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
    Left = 110
    Top = 184
  end
  object qryCategories: TUniQuery
    KeyFields = 'ID'
    SQLInsert.Strings = (
      'INSERT INTO Categories'
      '  (ID, CATEGORYNAME, PARENT_ID)'
      'VALUES'
      '  (:ID, :CATEGORYNAME, :PARENT_ID)')
    SQLDelete.Strings = (
      'DELETE FROM Categories'
      'WHERE'
      '  ID = :Old_ID')
    SQLUpdate.Strings = (
      'UPDATE Categories'
      'SET'
      '  ID = :ID, CATEGORYNAME = :CATEGORYNAME, PARENT_ID = :PARENT_ID'
      'WHERE'
      '  ID = :Old_ID')
    SQLRefresh.Strings = (
      'SELECT ID, CATEGORYNAME, PARENT_ID FROM Categories'
      'WHERE'
      '  ID = :ID')
    SQLRecCount.Strings = (
      'SELECT count(*) FROM (SELECT * FROM Categories'
      ')')
    Connection = conn
    SQL.Strings = (
      'select * from Categories'
      'order by id')
    Debug = True
    Options.RequiredFields = False
    Left = 40
    Top = 184
  end
end
