{== PBThreadedSplashscreenU ===========================================}
{: This unit implements a component that can be used to show a splash
  screen in a different thread.
@author Dr. Peter Below
@desc   Version 1.0 created 2003-05-29<br/>
        Last modified       2003-06-01<p/>
While it is possible to install this component and drop it on a form
or datamodule to configure it at design-time a more typical use will
be to create an instance of the component in code, to show the splash
screen before the main form has even been created. A genuine form may
be used as template for the splash screen, the template is created but
not shown (do not use Application.FormCreate for this, call the
constructor directly!), its GetFormImage is used to obtain the image to
show in the real splash screen. <br/>
The splash screen can be configured to show a statusbar, in which
progress messages can be displayed.    }
{======================================================================}
{$BOOLEVAL OFF}{Unit depends on shortcut boolean evaluation}
Unit PBThreadedSplashscreenU;

Interface

Uses
  Windows, SysUtils, Classes, Graphics, Controls, StdCtrls;

Type
  {: This component is the interface of the splash screen to the
     outside world. All its methods will execute in the context of
     the main thread. You will typically set up the properties of
     a TPBThreadedSplashscreen object and then call its Show method
     to show the splashscreen. This method creates a secondary thread
     and passes it the relevant property values. The thread will then
     create an API-level window and show the image you put into the
     components Image property. Calling the Hide method will stop and
     destroy the secondary thread and its window. <br/>
     <b>Note:</b> Changes made to the components properties after the
     Show method has been called will have no effect on the secondary
     threads splash window! The only exception is the Image property,
     changes to it will be reflected in the splash screen. But it is
     assumed that the new image will have the same size than the old
     one. <br/>
     You can call the components ShowStatusMessage to show a string
     in the splash screens status bar (if it has one, that is). }
  TPBThreadedSplashscreen = class(TComponent)
  private
    FShowThread: TThread;
    FUseStatusbar: Boolean;
    FTopmost: Boolean;
    FCenter: Boolean;
    FVisible: Boolean;
    FTop: Integer;
    FLeft: Integer;
    FImage: TBitmap;

    { property write methods }
    procedure SetCenter(const Value: Boolean);
    procedure SetImage(const Value: TBitmap);
    procedure SetLeft(const Value: Integer);
    procedure SetTop(const Value: Integer);
    procedure SetTopmost(const Value: Boolean);
    procedure SetUseStatusbar(const Value: Boolean);
    procedure SetVisible(const Value: Boolean);
  protected
    {: Handler for the images OnChange event, forwards changes to the
       show thread. }
    Procedure ContentChanged( sender: TObject );
  public
    {: Create the internal bitmap for the image property. }
    Constructor Create(AOwner: TComponent); override;
    {: Hide the splash screen, if it is visible, destroy the internal
      bitmap for the image property. }
    Destructor Destroy; override;
    {: Create the secondary thread and run it to show the splash screen. }
    Procedure Show;
    {: Stop and destroy the secondary thread and its splash screen window. }
    Procedure Hide;
    {: Show a message in the splash screens status bar. If there is
      none the procedure does nothing. }
    Procedure ShowStatusMessage( const msg: String );
  published

    {: X coordinate of splash screen windows upper left corner, ignored
       if Center is set to true. }
    property Left: Integer read FLeft write SetLeft;

    {: Y coordinate of splash screen windows upper left corner, ignored
       if Center is set to true. }
    property Top: Integer read FTop write SetTop;

    {: If set to true the splash screen will be centered in the workarea.
      If set to false the Left and Top properties determine the position
      of the splash screen. }
    property Center: Boolean read FCenter write SetCenter;

    {: The background image to show in the splash screen. The size of the
       image determines the size of the splash screen window. }
    property Image: TBitmap read FImage write SetImage;

    {: Determines whether the splash screen should be a topmost window. }
    property Topmost: Boolean read FTopmost write SetTopmost;

    {: Determines whether the splash screen window has a status bar
      to show status messages on. }
    property UseStatusbar: Boolean read FUseStatusbar write SetUseStatusbar;

    {: Shows or hides the splash screen. If set to true at design-time
      the splash screen will be shown automatically. }
    property Visible: Boolean read FVisible write SetVisible;

  end;


Procedure Register;

Implementation

Uses
  Messages, SyncObjs, CommCtrl, Types;

Procedure Register;
  Begin
    RegisterComponents('PBGoodies', [TPBThreadedSplashscreen]);
  End;

Type
  {: Specialized thread class used to show a splash window holding
    a bitmap and optionally a status bar in the context of a secondary
    thread. The window is created using API methods only, the VCL is
    not involved since it is not thread-safe. }
  TPBSplashThread = class( TThread )
  private
    FWnd: HWND;               // handle of splash screen window
    FStatusbar: HWND;         // handle of its statusbar
    FCallstub: Pointer;       // window proc stub for the splash screen
    FSplash : TPBThreadedSplashscreen;  // reference to component
    FGuardian: TCriticalSection; // guards access to the FSurface bitmap
    FSurface: TBitmap;        // holds the image to show
    FWndClass: ATOM;          // holds window class for the splash window
    FUseStatusbar: Boolean;   // copy of FSplashs property
    FTopmost: Boolean;        // copy of FSplashs property
    FCenter: Boolean;         // copy of FSplashs property
    FOrigin: TPoint;          // upper left position of splash window
    FStatusMessage: String;   // buffer for status message
  private
    {: This method handles all messages after WM_NCCREATE for the
      splash window. It uses the standard Dispatch mechanims build
      into TObject for most of them. This method executes in the
      secondary threads context. It trap and reports any exceptions
      happening during message processing. }
    Procedure WndProc( Var msg: TMessage );

    {: Creates the splash screen window class. This method executes in
      the main threads context since it is called from the constructor.  }
    Procedure CreateWindowclass;

    {: Destroys the splash screen window class. This method executes in
      the main threads context since it is called from the destructor.  }
    Procedure DestroyWindowClass;

    {: Create the splash screen window. This method executes in the
      secondary threads context since it is called from Execute. }
    Procedure CreateSplashWindow;

    {: Create the splash windows statusbar. This method executes in
      the secondary threads context. }
    Procedure CreateStatusBar;

    {: Center the splash screen window in the workarea.  This method
       executes in the secondary threads context. }
    Procedure CenterSplashScreen;

    {: Copy property values from the splash screen components. This
      method executes in the main threads context since it is called
      from the constructor. }
    Procedure Init;

    { All message handlers execute in the secondary threads context. }
    {: On WM_CREATE we size and position the splash window and create
     its status bar, if one was requested. }
    Procedure WMCreate( var msg: TWMCreate ); message WM_CREATE;

    {: On WM_ERASEBKGND we paint the image in FSurface onto the window. }
    Procedure WMEraseBkGnd( var msg:TWMEraseBkGnd ); message WM_ERASEBKGND;

    {: We return HTCAPTION for hit tests in the windows client area so
      the user can move it with the mouse. }
    Procedure WMNCHittest( var msg: TWMNCHITTEST ); message WM_NCHitTest;
  protected
    {: Helper routine to show an exception message using Windows.MessageBox.
      This function is thread-safe, so we can use it to report exceptions
      happening in the secondary thread. }
    Procedure ReportException( E: Exception );

    {: The threads work method creates the splash window, shows it and
      then enters a message loop. The loop will be left when the splash
      window is closed. Executes in the secondary threads context, of
      course.}
    procedure Execute; override;
  public
    {: Store the passed component reference, copy a number of its
      properties to internal fields, create the window class and image,
      resume the thread. Executes in the main threads context.
     @precondition aSplashScreen <> nil }
    Constructor Create( aSplashScreen: TPBThreadedSplashscreen );

    {: If the splash window is still up close it to make the message
      loop exit, then destroy the image and the thread object. Executes
      in the main threads context. }
    destructor Destroy; override;

    {: Show a message in the splash windows status bar. Executes in the
     main thread context. }
    Procedure ShowStatusMessage( const msg: String );

    {: Copy the image from the splash component again and redraw the
      splash window to show the new image. Executes in the main threads
      context. }
    Procedure UpdateContent( sender: Tobject );

    {: Pass all received messages to DefWindowProc. Executes in the
      secondary threads context. }
    Procedure DefaultHandler(var Message); override;
  End;


{—— TPBThreadedSplashscreen ———————————————————————————————————————————}

procedure TPBThreadedSplashscreen.ContentChanged( sender: TObject );
begin
  If Visible Then
    TPBSplashThread( FShowThread ).UpdateContent( sender );
end;

constructor TPBThreadedSplashscreen.Create(AOwner: TComponent);
begin
  inherited;
  FImage := TBitmap.Create;
  FImage.OnChange := ContentChanged;
end;

destructor TPBThreadedSplashscreen.Destroy;
begin
  If Visible Then
    Hide;
  Fimage.Free;
  inherited;
end;

procedure TPBThreadedSplashscreen.Hide;
begin
  If Visible Then Begin
    FreeAndNil( FShowThread );
    FVisible := false;
  End; { If }
end;

procedure TPBThreadedSplashscreen.SetCenter(const Value: Boolean);
begin
  If FCenter  <> Value Then
    FCenter  := Value;
end;

procedure TPBThreadedSplashscreen.SetImage(const Value: TBitmap);
begin
  FImage.Assign( Value );  // will fire images OnChange event
end;

procedure TPBThreadedSplashscreen.SetLeft(const Value: Integer);
begin
  If FLeft  <> Value Then
    FLeft  := Value;
end;

procedure TPBThreadedSplashscreen.SetTop(const Value: Integer);
begin
  If FTop  <> Value Then
    FTop  := Value;
end;

procedure TPBThreadedSplashscreen.SetTopmost(const Value: Boolean);
begin
  If FTopmost  <> Value Then
    FTopmost  := Value;
end;

procedure TPBThreadedSplashscreen.SetUseStatusbar(const Value: Boolean);
begin
  If FUseStatusbar  <> Value Then
    FUseStatusbar  := Value;
end;

{ CAUTION! The way this property setter is written now setting visible
  to true *at design time* will show the splash screen! This may be
  valuable as a preview feature but may cause problems in the IDE.

  I HAVE NOT TESTED THE COMPONENT AT DESIGN-TIME!

  If you experience problems add a If csDesigning in ComponentState test
  to show the splash screen only at run-time and just store the value
  at design-time. }
procedure TPBThreadedSplashscreen.SetVisible(const Value: Boolean);
begin
  If FVisible  <> Value Then Begin
    If Value Then
      Show
    Else
      Hide;
  End; { If }
end;

procedure TPBThreadedSplashscreen.Show;
begin
  If not Visible Then Begin
    FVisible := true;
    try
      FShowThread := TPBSplashThread.Create( self );
    except
      FVisible := false;
      raise
    end;
  End; { If }
end;

procedure TPBThreadedSplashscreen.ShowStatusMessage(const msg: String);
begin
  If UseStatusbar and Visible Then
    TPBSplashThread( FShowThread ).ShowStatusMessage( msg );
end;

{—— TPBSplashThread ———————————————————————————————————————————————————}

{ This is a helper function that will be used as window proc for the
 splash screen class. Its only reason for existence is the sad fact
 that the TMessage record passed to the threads WndProc does not contain
 the window handle of the splash screen. This is a problem for all
 messages that are send during the windows creation (the call to
 CreateWindowEx), since for those the thread objects FWnd field will not
 have a value yet. We need the handle during WM_CREATE processing, however.

 This function only handles WM_NCCREATE, the very first message a window
 will receive. We store the window handle into the thread object and then
 subclass the window to use the threads WindowProc for any further
 messages. The thread objects reference is handed to CreateWIndowEx as
 user parameter, so we can retrieve it from the createstruct passed via
 lparam here. }
Function CreateWndProc( wnd: HWND; msg: Cardinal; wparam: WPARAM; lparam: LPARAM ): LRESULT; stdcall;
  Var
    thread: TPBSplashThread;
  Begin
    If msg = WM_NCCREATE Then Begin
      thread := TPBSplashThread( PCreateStruct( lparam )^.lpCreateParams );
      thread.FWnd := wnd;
      SetWindowLong( wnd, GWL_WNDPROC, Integer( thread.FCallstub ));
      result := 1;
    End
    Else // will actually never get here, but better safe than sorry
      result := DefWindowProc( wnd, msg, wparam, lparam );
  End;

procedure TPBSplashThread.CenterSplashScreen;
var
  r, workarea: TRect;
  x, y: Integer;
begin
  Win32Check( GetWindowRect( FWnd, r ));
  SystemParametersInfo( SPI_GETWORKAREA, sizeof( workarea ), @workarea, 0 );
  x:= ((workarea.Right - workarea.Left) - (r.Right - r.Left )) div 2;
  y:= ((workarea.Bottom - workarea.Top) - (r.Bottom - r.Top )) div 2;
  SetWindowPos( FWnd, 0, x, y, 0, 0, SWP_NOSIZE or SWP_NOZORDER );
end;

constructor TPBSplashThread.Create(aSplashScreen: TPBThreadedSplashscreen);
begin
  Assert( Assigned( aSplashscreen ) );
  inherited Create( true );
  FSplash := aSplashScreen;
  FCallstub:= MakeObjectInstance( WndProc );
  FGuardian:= TCriticalSection.Create;
  Init;
  CreateWindowclass;
  Resume;
end;

procedure TPBSplashThread.CreateSplashWindow;
const
  TopmostStyle: Array [Boolean] of DWORD = (0, WS_EX_TOPMOST );
  NoActivateStyle : Array [Boolean] of DWORD = (0, WS_EX_NOACTIVATE );
var
  wsize: TSize;
begin
  wsize.cx := FSurface.Width + GetSystemMetrics( SM_CXEDGE ) * 2;
  wsize.cy := FSurface.Height + GetSystemMetrics( SM_CYEDGE ) * 2;
  FWnd := CreateWindowEx(
            TopmostStyle[ FTopmost ] or WS_EX_TOOLWINDOW
            or WS_EX_STATICEDGE or WS_EX_CLIENTEDGE
            or NoActivateStyle[ Win32MajorVersion >= 5 ],
            MakeIntResource( FWndClass ),
            nil,
            WS_POPUP or WS_BORDER,
            Forigin.x, Forigin.y,
            wsize.cx, wsize.cy,
            0, 0, hInstance, self );
  If FWnd = 0 Then
    raise exception.create('TPBSplashThread.CreateSplashWindow: CreateWindowEx failed');
    // RaiseLastOSError;
end;

procedure TPBSplashThread.CreateStatusBar;
var
  initrec: TInitCommonControlsEx;
  ncInfo: TNonClientMetrics;
  h: Integer;
  r: TRect;
begin
  initrec.dwSize := sizeof( initrec );
  initrec.dwICC  := ICC_BAR_CLASSES;
  Win32Check( InitCommonControlsEx( initrec ));
  ncInfo.cbSize := sizeof( ncInfo );
  SystemParametersInfo( SPI_GETNONCLIENTMETRICS, ncinfo.cbsize,
                        @ncinfo, 0 );
  h:= Abs(ncinfo.lfStatusFont.lfHeight)+ ncinfo.iBorderWidth * 2 + 4;
  Win32Check( GetWindowRect( FWnd, r ));
  SetWindowPos( Fwnd, 0, 0, 0, r.Right-r.left,
               r.Bottom-r.top+h,
               SWP_NOMOVE or SWP_NOZORDER );
  FStatusbar := CreateWindow(
              STATUSCLASSNAME,
              nil,
              WS_CHILD or WS_VISIBLE,
              0, FSurface.Height,
              FSurface.Width, h,
              FWnd, 0, hInstance, nil );
  If FStatusbar = 0 THen
    RaiseLastOSError;

  SendMessage( FStatusbar, SB_SIMPLE, 1, 0 );
  FGuardian.Acquire;
  try
    If FStatusMessage <> '' Then
      SendMessage( FStatusbar,
                   SB_SETTEXT,
                   255,
                   Integer( Pchar( FStatusMessage )));
  finally
    FGuardian.Release;
  end;
end;

procedure TPBSplashThread.CreateWindowclass;
var
  wndclass: TWndClass;
  S: String;
begin
  fillchar( wndclass, sizeof( wndclass ), 0 );
  wndclass.style := CS_NOCLOSE or CS_OWNDC or CS_VREDRAW or CS_HREDRAW;
  wndclass.lpfnWndProc := @CreateWndProc;
  wndclass.hInstance := hInstance;
  wndclass.hCursor := LoadCursor( 0, IDC_WAIT );
  wndclass.hbrBackground := HBRUSH( COLOR_WINDOW );
  S:= Format( '%s_wnd_%x',[ classname, getcurrentthreadid() ] );
  wndclass.lpszClassName := Pchar( S );
  FWndClass:= Windows.Registerclass( wndclass );
  If FWndClass = 0 Then
    RaiseLastOSError;
end;

procedure TPBSplashThread.DefaultHandler(var Message);
begin
  With TMessage( Message ) Do
    Result := DefWindowProc( FWnd, Msg, wparam, lparam );
end;

destructor TPBSplashThread.Destroy;
begin
  If FWnd <> 0 Then
    PostMessage( FWnd, WM_CLOSE, 0, 0 );
  inherited;
  FreeObjectInstance( FCallstub );
  FGuardian.Free;
  FSurface.Free;
  DestroyWindowClass;
end;

procedure TPBSplashThread.DestroyWindowClass;
begin
  If FWndClass <> 0 Then
    Windows.UnregisterCLass( MakeIntResource( FWndClass ), hInstance );
end;

procedure TPBSplashThread.Execute;
var
  msg: TMsg;
begin
  // create the threads message queue
  PeekMessage( msg, 0, 0, 0, PM_NOREMOVE );
  Try
    CreateSplashWindow;
    ShowWindow( FWnd, SW_SHOWNORMAL );
    While GetMessage( msg, 0, 0, 0 ) Do Begin
      TranslateMessage( msg );
      DispatchMessage( msg );
    End; { While }
  Except
    On E: Exception Do
      ReportException( E );
  End; { Except }
end;

procedure TPBSplashThread.Init;
begin
  FUseStatusbar := FSplash.UseStatusbar;
  FCenter       := FSplash.Center;
  FOrigin       := Point( FSplash.Left, FSplash.Top );
  If not Assigned( FSurface ) Then
    FSurface  := TBitmap.Create;
  FSurface.Assign( FSplash.Image );
  FTopmost      := FSplash.FTopmost;
end;

procedure TPBSplashThread.ReportException(E: Exception);
var
  s: String;
begin
  S:= Format( 'Error in TPBSplashThread, class %s:'#13#10'%s',
              [E.classname, E.Message] );
  Messagebox( 0,Pchar(S), 'Error', MB_OK or MB_ICONHAND );
end;

procedure TPBSplashThread.ShowStatusMessage(const msg: String);
begin
  If FStatusbar <> 0 Then
    SendMessage( FStatusbar,
                 SB_SETTEXT,
                 255,
                 Integer( Pchar( msg )))
  Else Begin
    FGuardian.Acquire;
    try
      FStatusMessage := msg;
    finally
      Fguardian.Release;
    end
  End; { Else }
end;

procedure TPBSplashThread.UpdateContent(sender: Tobject);
begin
  FGuardian.Acquire;
  Try
    FSurface.Assign( FSplash.Image );
    { We could provide for changes of the image size as well here,
      but since that will be rarely needed let's skip it for now. }
  Finally
    FGuardian.Release;
  End; { Finally }
  InvalidateRect( FWnd, nil, true );
end;

procedure TPBSplashThread.WMCreate(var msg: TWMCreate);
begin
  msg.result := 1;
  If FUseStatusbar Then
    CreateStatusbar;
  If FCenter Then
    CenterSplashScreen;
end;

procedure TPBSplashThread.WMEraseBkGnd(var msg: TWMEraseBkGnd);
begin
  msg.Result := 1;
  FGuardian.Acquire;
  try
    FSurface.Canvas.Lock;
    Bitblt( msg.DC, 0, 0, Fsurface.Width, FSurface.Height,
            FSurface.Canvas.Handle, 0, 0, SRCCOPY );
    FSurface.Canvas.UnLock;
  finally
    FGuardian.Release;
  end;
end;

procedure TPBSplashThread.WMNCHittest(var msg: TWMNCHITTEST);
begin
  inherited;
  If msg.Result = HTCLIENT Then
    msg.Result := HTCAPTION;
end;

procedure TPBSplashThread.WndProc(var msg: TMessage);
begin
  try
    msg.result := 0;
    Case msg.Msg Of
      WM_CLOSE   : DestroyWindow( FWnd );
      WM_DESTROY : PostQuitMessage( 0 );
      WM_NCDESTROY: FWnd := 0;
    Else
      Dispatch( msg );
    End;
  except
    On E:Exception Do
      ReportException( E );
  end;
end;

End.
