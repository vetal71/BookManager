unit Form.AuditLogViewer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Form.BaseForm, dxSkinsCore,
  dxSkinMetropolis, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus, cxCheckBox,
  Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls, cxTextEdit, cxMemo, System.ImageList,
  Vcl.ImgList, cxClasses, dxSkinsForm, System.Generics.Collections,
  Aurelius.Mapping.Explorer, Aurelius.Events.Manager;

type
  TfrmAuditLogViewer = class(TfrmBase)
    mmoLog: TcxMemo;
    pnlButton: TPanel;
    btnClear: TcxButton;
    chkEnableMonitor: TcxCheckBox;
    procedure btnClearClick(Sender: TObject);
    procedure chkEnableMonitorClick(Sender: TObject);
  private
    class var
      FInstance: TfrmAuditLogViewer;
  private
    FInsertedProc: TInsertedProc;
    FDeletedProc: TDeletedProc;
    FUpdatedProc: TUpdatedProc;
    FCollectionItemAddedProc: TCollectionItemAddedProc;
    FCollectionItemRemovedProc: TCollectionItemRemovedProc;
    procedure InsertedHandler(Args: TInsertedArgs);
    procedure DeletedHandler(Args: TDeletedArgs);
    procedure UpdatedHandler(Args: TUpdatedArgs);
    procedure CollectionItemAddedHandler(Args: TCollectionItemAddedArgs);
    procedure CollectionItemRemovedHandler(Args: TCollectionItemRemovedArgs);
  private
    procedure Log(const S: string);
    procedure BreakLine;
    function EntityDesc(Entity: TObject; Manager: TObject): string;
    procedure SubscribeListeners;
    procedure UnsubscribeListeners;
  public
    class function GetInstance: TfrmAuditLogViewer;
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmAuditLogViewer: TfrmAuditLogViewer;

implementation

{$R *.dfm}

uses
  Aurelius.Engine.ObjectManager, Aurelius.Global.Utils;

{ TfrmAuditLogViewer }

procedure TfrmAuditLogViewer.BreakLine;
begin
  mmoLog.Lines.Add('================================================');
end;

procedure TfrmAuditLogViewer.btnClearClick(Sender: TObject);
begin
  mmoLog.Clear;
end;

procedure TfrmAuditLogViewer.chkEnableMonitorClick(Sender: TObject);
begin
  if chkEnableMonitor.Checked then
    SubscribeListeners
  else
    UnsubscribeListeners;
end;

procedure TfrmAuditLogViewer.CollectionItemAddedHandler(
  Args: TCollectionItemAddedArgs);
begin
  Log(Format('Ёлемент коллекции %s добавлен к %s.%s',
    [EntityDesc(Args.Item, Args.Manager),
     EntityDesc(Args.Parent, Args.Manager),
     Args.MemberName]));
end;

procedure TfrmAuditLogViewer.CollectionItemRemovedHandler(
  Args: TCollectionItemRemovedArgs);
begin
  Log(Format('Ёлемент коллекции %s удален из %s.%s',
    [EntityDesc(Args.Item, Args.Manager),
     EntityDesc(Args.Parent, Args.Manager),
     Args.MemberName]));
end;

constructor TfrmAuditLogViewer.Create(AOwner: TComponent);
begin
  inherited;
  FInsertedProc := InsertedHandler;
  FDeletedProc := DeletedHandler;
  FUpdatedProc := UpdatedHandler;
  FCollectionItemAddedProc := CollectionItemAddedHandler;
  FCollectionItemRemovedProc := CollectionItemRemovedHandler;
  SubscribeListeners;
end;

procedure TfrmAuditLogViewer.DeletedHandler(Args: TDeletedArgs);
begin
  Log(Format('”даление: %s', [EntityDesc(Args.Entity, Args.Manager)]));
  BreakLine;
end;

function TfrmAuditLogViewer.EntityDesc(Entity, Manager: TObject): string;
var
  IdValue: Variant;
  IdString: string;
begin
  IdValue :=  TObjectManager(Manager).Explorer.GetIdValue(Entity);
  IdString := TUtils.VariantToString(IdValue);
  Result := Format('%s(%s)', [Entity.ClassName, IdString]);
end;

class function TfrmAuditLogViewer.GetInstance: TfrmAuditLogViewer;
begin
  if FInstance = nil then
    FInstance := TfrmAuditLogViewer.Create(Application);
  Result := FInstance;
end;

procedure TfrmAuditLogViewer.InsertedHandler(Args: TInsertedArgs);
begin
  Log(Format('¬ставка: %s', [EntityDesc(Args.Entity, Args.Manager)]));
  BreakLine;
end;

procedure TfrmAuditLogViewer.Log(const S: string);
begin
  mmoLog.Lines.Add(S);
end;

procedure TfrmAuditLogViewer.SubscribeListeners;
var
  E: TManagerEvents;
begin
  E := TMappingExplorer.Default.Events;
  E.OnInserted.Subscribe(FInsertedProc);
  E.OnUpdated.Subscribe(FUpdatedProc);
  E.OnDeleted.Subscribe(FDeletedProc);
  E.OnCollectionItemAdded.Subscribe(FCollectionItemAddedProc);
  E.OnCollectionItemRemoved.Subscribe(FCollectionItemRemovedProc);
end;

procedure TfrmAuditLogViewer.UnsubscribeListeners;
var
  E: TManagerEvents;
begin
  E := TMappingExplorer.Default.Events;
  E.OnInserted.Unsubscribe(FInsertedProc);
  E.OnUpdated.Unsubscribe(FUpdatedProc);
  E.OnDeleted.Unsubscribe(FDeletedProc);
  E.OnCollectionItemAdded.Unsubscribe(FCollectionItemAddedProc);
  E.OnCollectionItemRemoved.Unsubscribe(FCollectionItemRemovedProc);
end;

procedure TfrmAuditLogViewer.UpdatedHandler(Args: TUpdatedArgs);
var
  Pair: TPair<string, Variant>;
  OldValue: Variant;
begin
  Log(Format('ќбновлено: %s', [EntityDesc(Args.Entity, Args.Manager)]));
  for Pair in Args.NewColumnValues do
    if not (Args.OldColumnValues.TryGetValue(Pair.Key, OldValue) and (OldValue = Pair.Value)) then
      Log(Format('   %s Changed from "%s" to "%s"',
        [Pair.Key, TUtils.VariantToString(OldValue), TUtils.VariantToString(Pair.Value)]));
  BreakLine;
end;

end.
