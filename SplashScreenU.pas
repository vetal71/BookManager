unit SplashScreenU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, dxGDIPlusClasses;

type
  TSplashForm = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Procedure ShowSplashscreen;
Procedure HideSplashScreen;
Procedure ShowSplashScreenMessage( const S: String );

implementation

uses PBThreadedSplashscreenU;

{$R *.dfm}
var
  ThreadedSplashForm: TPBThreadedSplashscreen;

{: Create a hidden instance of the TSplashForm class and use it as a
   template for the real splash form. The template is only a convenience
   to be able to design the splash from in the IDE, it may serve as
   an about box as well, however. }
Procedure ShowSplashscreen;
  Var
    SplashForm: TSplashForm;
    bmp: TBitmap;
  Begin
    If Assigned( ThreadedSplashForm ) Then Exit;

    Splashform := TSplashform.Create( Application );
    try
      ThreadedSplashForm:= TPBThreadedSplashscreen.Create( nil );
      Try
        ThreadedSplashform.Left  := Splashform.Left;
        ThreadedSplashform.Top   := Splashform.Top;
        ThreadedSplashform.Center:=
           Splashform.Position in [ poScreenCenter, poMainFormCenter,
                                    poDesktopCenter ];
        bmp:= Splashform.GetFormImage;
        try
          ThreadedSplashform.Image := bmp;
        finally
          bmp.Free;
        end;
        ThreadedSplashForm.UseStatusbar  := True;
        // ThreadedSplashForm.TopMost := true;

        ThreadedSplashForm.Show;
      Except
        FreeAndNil(ThreadedSplashForm);
        raise;
      End; { Except }
    finally
      Splashform.Free;
    end;
  End;

Procedure HideSplashScreen;
  Begin
    FreeAndNil(ThreadedSplashForm);
  End;

Procedure ShowSplashScreenMessage( const S: String );
  Begin
    If Assigned( ThreadedSplashForm ) Then
      ThreadedSplashForm.ShowStatusMessage( S );
  End;

end.
