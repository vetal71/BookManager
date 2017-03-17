unit SplashTestU1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls;

const
  UM_ACTIVATE = WM_APP + 123;
type

  TForm1 = class(TForm)
    StatusBar: TStatusBar;
    Closebutton: TButton;
    AboutButton: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ClosebuttonClick(Sender: TObject);
    procedure AboutButtonClick(Sender: TObject);
  private
    { Private declarations }
    procedure UMActivate( var msg: TMessage ); message UM_ACTIVATE;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
uses splashscreenU;

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
var
  I: INteger;
begin
  For i:= 1 to 10 do Begin
    ShowSplashScreenMessage(
      Format( 'Step %d of 10', [i] ));
    Sleep( 1000 );
  End;
  PostMessage( handle, UM_ACTIVATE, 0, 0 );
end;

procedure TForm1.ClosebuttonClick(Sender: TObject);
begin
  close;
end;

procedure TForm1.UMActivate(var msg: TMessage);
begin
  { HACK ALERT! Without this the main form will come up not active
    after the splash screen has been destroyed. }
  SetForegroundWindow( handle );
end;

procedure TForm1.AboutButtonClick(Sender: TObject);
begin
  With TSplashform.Create( nil ) Do
  Try
    Showmodal;
  Finally
    Free;
  End; { Finally }
end;

end.
