unit WaitForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore, dxSkinMetropolis,
  cxLabel, dxActivityIndicator;

type
  TWaiting = class(TForm)
    WaitTitle: TcxLabel;
    aiProgress: TdxActivityIndicator;
    WaitMessage: TcxLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  strict private
    class var FException: Exception;
  private
    class var WaitForm : TWaiting;
    class procedure OnTerminateTask(Sender: TObject);
    class procedure HandleException;
    class procedure DoHandleException;
  public
    class procedure Start(const ATitle: String; const ATask: TProc);
    class procedure Status(AMessage : String);
  end;

var
  Waiting: TWaiting;

implementation

{$R *.dfm}

procedure TWaiting.FormCreate(Sender: TObject);
begin
  aiProgress.Active := True;
  Sleep(2000);
end;

procedure TWaiting.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

class procedure TWaiting.Start(const ATitle: String; const ATask: TProc);
var
  T : TThread;
begin
  if (not Assigned(WaitForm))then
    WaitForm := TWaiting.Create(nil);

  T := TThread.CreateAnonymousThread(
  procedure
  begin
    try
      ATask;
    except
      HandleException;
    end;
  end);

  T.OnTerminate := OnTerminateTask;
  T.Start;

  WaitForm.WaitTitle.Caption := ATitle;
  WaitForm.ShowModal;

  DoHandleException;
end;

class procedure TWaiting.Status(AMessage: String);
begin
  TThread.Synchronize(TThread.CurrentThread,
  procedure
  begin
    if (Assigned(WaitForm)) then
    begin
      WaitForm.WaitMessage.Caption := AMessage;
      WaitForm.Update;
    end;
  end);
end;

class procedure TWaiting.OnTerminateTask(Sender: TObject);
begin
  if (Assigned(WaitForm)) then
  begin
    WaitForm.Close;
    WaitForm := nil;
  end;
end;

class procedure TWaiting.HandleException;
begin
  FException := Exception(AcquireExceptionObject);
end;

class procedure TWaiting.DoHandleException;
begin
  if (Assigned(FException)) then
  begin
    try
      if (FException is Exception) then
        raise FException at ReturnAddress;
    finally
      FException := nil;
      ReleaseExceptionObject;
    end;
  end;
end;

end.
