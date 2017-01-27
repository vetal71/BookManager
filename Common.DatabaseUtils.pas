unit Common.DatabaseUtils;

interface

uses
  Aurelius.Criteria.Base,
  Aurelius.Drivers.Interfaces,
  Aurelius.Engine.DatabaseManager,
  Aurelius.Engine.ObjectManager,
  Model.Entities;

procedure UpdateDatabaseShema(Conn: IDBConnection);
procedure FillData(Conn: IDBConnection);

implementation

procedure UpdateDatabaseShema(Conn: IDBConnection);
var
  DB: TDatabaseManager;
begin
  DB := TDatabaseManager.Create(Conn);
  try
    DB.UpdateDatabase;
  finally
    DB.Free;
  end;
end;

procedure FillData(Conn: IDBConnection);
var
  Manager: TObjectManager;
  Trans: IDBTransaction;
begin
  Manager := TObjectManager.Create(Conn);
  try
    if Manager.Find<TBook>.Take(1).UniqueResult = nil then
    begin
      Trans := conn.BeginTransaction;
      try
        if not CreateDataFromFiles(Manager) then
          CreateDataManually(Manager);
        Trans.Commit;
      except
        Trans.Rollback;
        raise;
      end;
    end;
  finally
    Manager.Free;
  end;
end;

end.
