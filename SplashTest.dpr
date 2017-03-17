program SplashTest;

uses
  Forms,
  SplashTestU1 in 'SplashTestU1.pas' {Form1},
  SplashScreenU in 'SplashScreenU.pas' {SplashForm};

{$R *.res}

begin
  Application.Initialize;
  ShowSplashScreen;
  try
    Application.CreateForm(TForm1, Form1);
  finally
    HideSplashScreen;
  end;
  Application.Run;
end.
