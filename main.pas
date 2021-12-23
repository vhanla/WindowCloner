unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UWP.Form, Vcl.ExtCtrls, UWP.ColorManager, TUPopupMenu,
  Vcl.Menus, UWP.PopupMenu, System.ImageList, Vcl.ImgList, DWMApi, PsAPI,
  System.Actions, Vcl.ActnList, Vcl.StdCtrls, ShellApi, madExceptVcl,
  System.Win.TaskbarCore, Vcl.Taskbar, Vcl.JumpList,
  // VirtualDesktopManager
  VirtualDesktopManager, AudioSessionService;

const
  WM_MOUSE_EVENT = WM_USER + 9;
  MOUSE_GAP_X = 10;
  MOUSE_GAP_Y = 14;
  DWMWA_CLOAKED = 14; // Windows 8 or superior only
  DWM_NOT_CLOAKED = 0; // i.e. Visible for real
  DWM_CLOAKED_APP = 1;
  DWM_CLOAKED_SHELL = 2;
  DWM_CLOAKED_INHERITED = 4;
  DWM_NORMAL_APP_NOT_CLOAKED = 8; // invented number, might have issues on newest versions of window 10 2020 or earlier not tested

type
  PChildWindowInfo = ^TChildWindowInfo;
  TChildWindowInfo = record
    ownerPid: UINT;
    childPid: UINT;
  end;

  TArrayMenu = array[0..0] of TMenuItem;
  PArrayMenu = ^TArrayMenu;

  PAppItem = ^TAppItem;
  TAppItem = record
    Handle: DWORD;
    Volume: Integer;
    Value : Integer;
    Caption: array[0..1000] of WideChar;
    FilePath: array[0..MAX_PATH] of WideChar;
  end;

  TListApp = class(TList)
  private
    function Get(Index: Integer):PAppItem;
  public
    destructor Destroy; override;
    function Add(Value: PAppItem): Integer;
    property Items[Index: Integer]: PAppItem read Get; default;
  end;

  TAspectRatio = (arNormal, ar1_1, ar4_3, ar16_9);

//  PAudioSessionModel = ^TAudioSessionModel;
//  TAudioSessionModel = record
//    DisplayName: String;
//    IconPath: String;
//    GroupingId: TGUID;
//    SessionId: LongWord;
//    ProcessId: LongWord;
//    BackgroundColor: LongWord;
//    Volume: Single;
//    IsDesktop: Boolean;
//    IsMuted: Boolean;
//    VolumePeak: Single;
//  end;

//  TListAudioSession = class (TList)
//  private
//    function Get(Index: Integer): PAudioSessionModel;
//  public
//    function Add(Value: PAudioSessionModel): Integer;
//    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
//    property Items[Index: Integer]: PAudioSessionModel read Get; default;
//  end;

  TForm1 = class(TUWPForm)
    tmrFSMouse: TTimer;
    TrayIcon1: TTrayIcon;
    PopupMenu1: TPopupMenu;
    ListWindows1: TMenuItem;
    mnuSwitchToWindow: TMenuItem;
    SelectRegion1: TMenuItem;
    ClickThrough1: TMenuItem;
    Opacity1: TMenuItem;
    Fullscreen1: TMenuItem;
    Settings1: TMenuItem;
    N1: TMenuItem;
    About1: TMenuItem;
    Exit2: TMenuItem;
    N1001: TMenuItem;
    N901: TMenuItem;
    N801: TMenuItem;
    N701: TMenuItem;
    N601: TMenuItem;
    N501: TMenuItem;
    N401: TMenuItem;
    N301: TMenuItem;
    N201: TMenuItem;
    N101: TMenuItem;
    imglstIcons: TImageList;
    ActionList1: TActionList;
    actF11: TAction;
    actF: TAction;
    actAltEnter: TAction;
    lblGuide: TLabel;
    Borderless1: TMenuItem;
    HidefromTaskbar1: TMenuItem;
    actMuteToggle: TAction;
    MouseCursorMode1: TMenuItem;
    MadExceptionHandler1: TMadExceptionHandler;
    Taskbar1: TTaskbar;
    JumpList1: TJumpList;
    actPlayPause: TAction;
    FollowVirtualdesktop1: TMenuItem;
    Hidewhentargetwindowosforeground1: TMenuItem;
    N2: TMenuItem;
    Showonmousehover1: TMenuItem;
    RecordWinAltR1: TMenuItem;
    mnuMinimize: TMenuItem;
    AlwaysOnTop1: TMenuItem;
    procedure FormDblClick(Sender: TObject);
    procedure tmrFSMouseTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure mnuSwitchToWindowClick(Sender: TObject);
    procedure Exit2Click(Sender: TObject);
    procedure Fullscreen1Click(Sender: TObject);
    procedure N1001Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure ClickThrough1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure TrayIcon1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Borderless1Click(Sender: TObject);
    procedure HidefromTaskbar1Click(Sender: TObject);
    procedure actMuteToggleExecute(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure MouseCursorMode1Click(Sender: TObject);
    procedure SelectRegion1Click(Sender: TObject);
    procedure actPlayPauseExecute(Sender: TObject);
    procedure FollowVirtualdesktop1Click(Sender: TObject);
    procedure RecordWinAltR1Click(Sender: TObject);
    procedure mnuMinimizeClick(Sender: TObject);
    procedure AlwaysOnTop1Click(Sender: TObject);
  private
    { Private declarations }
    fFullScreenState: Boolean;
    fClickThrough: Boolean;
    fPrevRect: TRect;
    fBorderStyle: TBorderStyle;
    fPrevFSCursor: TPoint;
    fPopupMenu: TUPopupMenu.TPopupMenu;
    fListApps: TListApp;
    fMenues: PArrayMenu;
    fMenuesCount: Integer;
    fThumbWindow: HTHUMBNAIL;
    fCurrentWindow: HWND;
    fCurrentExecutable: String;
    fCurrentCaption: String;
    fDefaultExStyle: Integer;
    fCurrentMonitor: TMonitor;
    AudioSession: TAudioSessionService;
    fSessions: TListSessions;
    FTopMost: Boolean;
    procedure SetFullScreen(Enabled: Boolean);
    procedure SetClickThrough(Enabled: Boolean);
    procedure SetOpacity(Sender: TObject);
    procedure ListWindows(var Menu: TMenuItem);
    procedure HandleWindowListClick(Sender: TObject);
    procedure SetWindowClone(AHandle: THandle; AspectRatio: TAspectRatio);
    procedure SetTopMost(const Value: Boolean);
  protected
    procedure MouseEvent(var Msg: TMessage); message WM_MOUSE_EVENT;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WM_WindowPosChanged(var Msg: TWMWindowPosChanged);message WM_WINDOWPOSCHANGED;
  public
    { Public declarations }
    procedure CurrentDesktopChanged(Sender: TObject; OldDesktop, NewDesktop: TVirtualDesktop);
  published
    property FullScreen: Boolean read fFullScreenState write SetFullScreen;
    property ClickThrough: Boolean read fClickThrough write SetClickThrough;
    property TopMost: Boolean read FTopMost write SetTopMost;
  end;

var
  Form1: TForm1;

procedure SwitchToThisWindow(h1: hWnd; x: bool); stdcall;
  external user32 Name 'SwitchToThisWindow';
//function RefreshAudioSessions: Integer; stdcall;
//  external 'AudioHelper.dll' name 'RefreshAudioSessions';
//function GetAudioSessionCount: Integer; stdcall;
//  external 'AudioHelper.dll' name 'GetAudioSessionCount';
//function GetAudioSessions(var sessions: IntPtr): Integer; stdcall;
//  external 'AudioHelper.dll' name 'GetAudioSessions';
//function SetAudioSessionVolume(sessionId: LongWord; volume: Single): Integer; stdcall;
//  external 'AudioHelper.dll' name 'SetAudioSessionVolume';
//function SetAudioSessionMute(sessionId: LongWord; isMuted: boolean): Integer; stdcall;
//  external 'AudioHelper.dll' name 'SetAudioSessionMute';
function RunHook(AHandle: HWND):BOOL; stdcall;
  external 'MouseHook.dll' name 'RunHook';
function IsHooked:BOOL; stdcall;
  external 'MouseHook.dll' name 'IsHooked';
function KillHook:BOOL; stdcall;
  external 'MouseHook.dll' name 'KillHook';
implementation

{$R *.dfm}

uses frmAreaSelector, frmAboutForm;

procedure TForm1.mnuMinimizeClick(Sender: TObject);
begin
  Perform(WM_SYSCOMMAND, SC_MINIMIZE, 0);
end;

procedure TForm1.mnuSwitchToWindowClick(Sender: TObject);
begin
  if fCurrentWindow <> 0 then
    SwitchToThisWindow(fCurrentWindow, True);
end;

procedure TForm1.MouseCursorMode1Click(Sender: TObject);
begin
  MouseCursorMode1.Checked := not MouseCursorMode1.Checked;
  // hides from alt-tab if it is hidden from taskbar
  if HidefromTaskbar1.Checked then
    SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_TOOLWINDOW);
end;

procedure TForm1.About1Click(Sender: TObject);
begin
  FormStyle := fsNormal;
  frmAbout.ShowModal;
  FormStyle := fsStayOnTop;
end;

procedure TForm1.actPlayPauseExecute(Sender: TObject);
var
  oldPoint: TPoint;
  aRect: TRect;
  aPoint: TPoint;
  aInput: array[0..1] of TInput;
  mouseInputs: array of TInput;
  KeyInputs: array of TInput;
  child: THandle;
  //--------------------------------------------
  procedure MouseInput(mPoint: TPoint; mFlags: DWORD);
  begin
    SetLength(mouseInputs, Length(mouseInputs)+1);
    mouseInputs[high(mouseInputs)].Itype := INPUT_MOUSE;
    with mouseInputs[high(mouseInputs)].mi do
    begin
//      dx := mPoint.X;
  //    dy := mPoint.Y;
      // zero for mouse clicks
      mouseData := 0; // https://docs.microsoft.com/es-mx/windows/win32/api/winuser/ns-winuser-mouseinput
      dwFlags := mFlags;
    end;
  end;

  procedure KeybdInput(VKey: Byte; Flags: DWORD);
  begin
    SetLength(KeyInputs, Length(KeyInputs)+1);
    KeyInputs[high(KeyInputs)].Itype := INPUT_KEYBOARD;
    with  KeyInputs[high(KeyInputs)].ki do
    begin
      wVk := VKey;
      wScan := MapVirtualKey(wVk, 0);
      dwFlags := Flags;
    end;
  end;
begin
  if IsWindow(fCurrentWindow) then
  begin
    PostMessage(fCurrentWindow, WM_KEYDOWN, VK_PLAY, 0);
    PostMessage(fCurrentWindow, WM_KEYUP, VK_PLAY, 0);
//    KeybdInput(VK_PLAY, 0);
//    KeybdInput(VK_PLAY, KEYEVENTF_KEYUP);
//    SendInput(Length(KeyInputs), KeyInputs[0], SizeOf(KeyInputs[0]));


    GetWindowRect(fCurrentWindow, aRect);
    aPoint.X := aRect.Width div 2;
    aPoint.Y := aRect.Height div 2;
//    Winapi.Windows.ClientToScreen(fCurrentWindow, aPoint);
    var curParent := fCurrentWindow;
    child := 0;
    while True do
    begin
//      Winapi.Windows.ScreenToClient(curParent, aPoint);
      child := RealChildWindowFromPoint(curParent, aPoint);
      if (child = 0) or (child = curParent) then
        Break;
    end;


    PostMessage(curParent, WM_LBUTTONDOWN, 1, MakeLParam(aRect.Width div 2, aRect.Height div 2));
//    PostMessage(fCurrentWindow, WM_LBUTTONDOWN, 1, MakeLParam(aRect.Width div 2, aRect.Height div 2));
    PostMessage(curParent, WM_LBUTTONUP, 1, MakeLParam(aRect.Width div 2, aRect.Height div 2));
//    PostMessage(fCurrentWindow, WM_LBUTTONUP, 1, MakeLParam(aRect.Width div 2, aRect.Height div 2));

//    SwitchToThisWindow(Handle, True);

//    oldPoint := mouse.CursorPos;
//    aPoint.X := aRect.Width div 2;
//    aPoint.Y := aRect.Height div 2;
//    Winapi.Windows.ClientToScreen(fCurrentWindow, aPoint);
//    mouse.CursorPos := Point(aPoint.X, aPoint.Y);
//    MouseInput(aPoint, MOUSEEVENTF_LEFTDOWN);
//    MouseInput(aPoint, MOUSEEVENTF_LEFTUP);
//    SendInput(Length(mouseInputs), mouseInputs[0], SizeOf(mouseInputs[0]));
//    mouse.CursorPos := oldPoint;
  end;
end;

procedure TForm1.AlwaysOnTop1Click(Sender: TObject);
begin
  TopMost := not TopMost;

  AlwaysOnTop1.Checked := TopMost;
end;

procedure TForm1.actMuteToggleExecute(Sender: TObject);
var
//  sessionCount: Integer;
//  rawSessionsPtr: IntPtr;
//  sizeOfAudioSessionPtr: Integer;
//  pSession: PAudioSessionModel;
//  window: IntPtr;
  I: Integer;
  fExecutable: String;
begin
  AudioSession.RefreshAudioSessions;
//  sessionCount := AudioSession.GetAudioSessionCount;

  if fSessions <> nil then
    fSessions.Clear
  else
    fSessions := TListSessions.Create;


//  fListAudioSessions.Clear;

//  AudioSession.GetAudioSessions(rawSessionsPtr);
  AudioSession.GetAudioSessions(fSessions);
//  sizeOfAudioSessionPtr := SizeOf(TAudioSessionModel);

//  for I := 0 to sessionCount - 1 do
  for I := 0 to fSessions.Count - 1 do
  begin
//    GetMem(pSession, sizeOfAudioSessionPtr);
//    window := rawSessionsPtr + sizeOfAudioSessionPtr * I;
//    window := fSessions + sizeOfAudioSessionPtr * I;
//    CopyMemory(pSession, Pointer(window), sizeOfAudioSessionPtr);
//    fListAudioSessions.Add(pSession);
//    if (fCurrentExecutable = PChar(pSession^.DisplayName))
    if (LowerCase(fCurrentExecutable) = LowerCase(fSessions[I].DisplayName))
    and (fSessions[I].PeekValue > 0)
    and (not fSessions[I].IsMuted)
    then
      AudioSession.SetAudioSessionMute(fSessions[I].SessionId, True)
    else
      AudioSession.SetAudioSessionMute(fSessions[I].SessionId, False);
  end;
end;

procedure TForm1.Borderless1Click(Sender: TObject);
begin
  if FullScreen then Exit;

  TMenuItem(Sender).Checked := not TMenuItem(Sender).Checked;
  if TMenuItem(Sender).Checked then
    BorderStyle := bsNone
  else
    BorderStyle := fBorderStyle;
end;

procedure TForm1.ClickThrough1Click(Sender: TObject);
begin
  ClickThrough := not ClickThrough;
  ClickThrough1.Checked := ClickThrough;
end;

procedure TForm1.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  Params.WinClassName := 'WindowClonerHwnd';
end;

procedure TForm1.CurrentDesktopChanged(Sender: TObject; OldDesktop,
  NewDesktop: TVirtualDesktop);
begin
  if FollowVirtualdesktop1.Checked then
  begin
    DesktopManager.MoveWindowToDesktop(Handle, NewDesktop);
  end;
end;

procedure TForm1.Exit2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.FollowVirtualdesktop1Click(Sender: TObject);
begin
  FollowVirtualdesktop1.Checked := not FollowVirtualdesktop1.Checked;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  ClickThrough := False;
  ClickThrough1.Checked := False;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  I: Integer;
  AItem: TMenuItem;
begin
  AudioSession := TAudioSessionService.Create;
  fSessions := TListSessions.Create;
  tmrFSMouse.Enabled := False;
  ColorizationManager.ColorizationType := TUWPColorizationType.ctDark;

  BorderIcons := [];
  fBorderStyle := BorderStyle;
  DoubleBuffered := True;
//  fPopupMenu := TUPopupMenu.TPopupMenu.Create(Self);
//  fPopupMenu.PopupMode := pmCustom;
//  fPopupMenu.PopupForm := Self;
//  fPopupMenu.Items.Clear;
//  for I := 0 to PopupMenu1.Items.Count - 1 do
//  begin
//    AItem := TMenuItem.Create(PopupMenu1.Items[I]);
//    AItem.Caption := PopupMenu1.Items[I].Caption;
//    fPopupMenu.Items.Add(AItem);
//  end;
//  PopupMenu := fPopupMenu;
  FormStyle := fsStayOnTop;

  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_LAYERED);
  SetWindowLong(Handle, GWL_STYLE, GetWindowLong(Handle, GWL_STYLE) or WS_MINIMIZEBOX or WS_SYSMENU);

  SetLayeredWindowAttributes(Handle, 0, 255, LWA_ALPHA);

  fListApps := TListApp.Create;

  fMenuesCount := 0;
  fCurrentWindow := 0;

  Application.OnActivate := FormActivate;

//  fListAudioSessions := TListAudioSession.Create;

  RunHook(Handle);

  // virtual desktop handling
  with DesktopManager do
  begin
    OnCurrentDesktopChanged := CurrentDesktopChanged;
  end;
end;

procedure TForm1.FormDblClick(Sender: TObject);
begin
  FullScreen := not FullScreen;

  Fullscreen1.Checked := FullScreen;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
//  fListAudioSessions.Free;
  fListApps.Free;
  fPopupMenu.Free;

  KillHook;

  if fSessions <> nil then
    fSessions.Free;
  AudioSession.Free;
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if not FullScreen then
  begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, $F012, 0);
  end;
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if FullScreen and (fPrevFSCursor <> Mouse.CursorPos) then
    ShowCursor(True);
end;

procedure TForm1.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
var
  newRect: TRect;
  aspect: Double;
  prevWidth, prevHeight: Integer;
begin
  if FullScreen then Exit;

  aspect := Height / Width;
  newRect := ClientRect;
  prevWidth := Width;
  prevHeight := Height;
  Width := Width - 10;
  Height := Round(aspect * Width);
  Left := Left + (prevWidth - Width) div 2;
  Top := Top + (prevHeight - Height) div 2;
end;

procedure TForm1.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
var
  newRect: TRect;
  aspect: Double;
  prevWidth, prevHeight: Integer;
begin
  if FullScreen then Exit;

  aspect := Height / Width;
  newRect := ClientRect;
  prevWidth := Width;
  prevHeight := Height;
  Width := Width + 10;
  Height := Round(aspect * Width);
  Left := Left - (Width - prevWidth) div 2;
  Top := Top - (Height - prevHeight) div 2;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  if IsWindow(fCurrentWindow) then
    SetWindowClone(fCurrentWindow, arNormal);
end;

procedure TForm1.Fullscreen1Click(Sender: TObject);
begin
  FullScreen := not FullScreen;

  Fullscreen1.Checked := FullScreen;
end;

// Handles clicks on created menues for listed windows
procedure TForm1.HandleWindowListClick(Sender: TObject);
begin
  fCurrentWindow := TMenuItem(Sender).Tag;
  fCurrentExecutable := ExtractFileName(fListApps[TMenuItem(Sender).ImageIndex].FilePath);
  fCurrentCaption := fListApps[TMenuItem(Sender).ImageIndex].Caption;
  TrayIcon1.Hint := 'Window Cloner - ' + Copy(fCurrentCaption, 1, 64) + '...';
  SetWindowClone(fCurrentWindow, arNormal);
end;

// We need to rehook since window handle recreates it with new one
procedure TForm1.HidefromTaskbar1Click(Sender: TObject);
begin
  KillHook;
  MouseCursorMode1.Checked := False;

  TMenuItem(Sender).Checked := not TMenuItem(Sender).Checked;
  if TMenuItem(Sender).Checked then
  begin
    fDefaultExStyle := GetWindowLong(Handle, GWL_EXSTYLE);
    Application.MainFormOnTaskBar := False;
    ShowWindow(Application.Handle, SW_HIDE);
  end
  else
  begin
    Application.MainFormOnTaskBar := True;
    ShowWindow(Application.Handle, SW_SHOWNORMAL);
    SetWindowLong(Handle,GWL_EXSTYLE, fDefaultExStyle);
  end;
  ClickThrough1.Enabled := not HidefromTaskbar1.Checked;
  Opacity1.Enabled := not HidefromTaskbar1.Checked;

  Sleep(500);
  RunHook(Handle);
end;

function EnumChildWindowsProc(Wnd: HWND; ChildInfo: PChildWindowInfo): BOOL; export; stdcall;
var
  aPID: DWORD;
begin
  Result := False;
  aPID := 0;
  GetWindowThreadProcessId(Wnd,aPID);
  if aPID <> ChildInfo.ownerPid then
  begin
    ChildInfo.childPid := aPID;
    Result := True;
  end;
end;

// Lists windows and also updates TMenuItem holding them
procedure TForm1.ListWindows(var Menu: TMenuItem);
type
  TQueryFullProcessImageName = function(hProcess: THandle; dwFlags: DWORD; lpExeName: PChar; nSize: PDWORD): BOOL; stdcall;
var
   LHDesktop: HWND;
   LHWindow: HWND;
   LHParent: HWND;
   LExStyle: DWORD;

   I: Int64;

   AppClassName: array[0..255] of char;

   Cloaked: Cardinal;

   titlelen: Integer;
   title: String;
   fAppItem: PAppItem;
   PID: DWORD;
   hProcess: THandle;
   fLen: Byte;
   WinFileName: String;
   FileName: array[0..MAX_PATH -1] of Char;
   QueryFullProcessImageName: TQueryFullProcessImageName;
   nSize: Cardinal;
   fMenuItem: PMenuItem;

   fIcon: HICON;
   aIcon: TIcon;
   lpsfi: SHFILEINFO;
   fIconIndex: WORD;

   windowInfo: TChildWindowInfo;
   GuiInfo: TGUIThreadInfo;
begin
  I := GetTickCount64;

  fListApps.Clear;
  imglstIcons.Clear;

  LHDesktop:=GetDesktopWindow;
  LHWindow:=GetWindow(LHDesktop,GW_CHILD);

  while LHWindow <> 0 do
  begin
    GetClassName(LHWindow, AppClassName, 255);
    LHParent:=GetWindowLong(LHWindow,GWL_HWNDPARENT);
    LExStyle:=GetWindowLong(LHWindow,GWL_EXSTYLE);

    // only works on windows superior to windows 7
    if AppClassName = 'ApplicationFrameWindow' then
      DwmGetWindowAttribute(LHWindow, DWMWA_CLOAKED, @cloaked, sizeof(Cardinal))
    else
      cloaked := DWM_NORMAL_APP_NOT_CLOAKED;

    if IsWindowVisible(LHWindow)
//    and (GetProp(LHWindow, 'ITaskList_Deleted') = 0)
    and (AppClassName <> 'Windows.UI.Core.CoreWindow')
    //and not ((AppClassName = 'ApplicationFrameWindow') and not uwpidle)
//    and ( {(AppClassName = 'ApplicationFrameWindow') and} (cloaked = DWM_NOT_CLOAKED) or (cloaked = DWM_NORMAL_APP_NOT_CLOAKED))
    and ( (cloaked = DWM_NOT_CLOAKED) or (cloaked = DWM_NORMAL_APP_NOT_CLOAKED) or (cloaked = DWM_CLOAKED_APP)  )
    and ((LHParent=0)or(LHParent=LHDesktop))
    and (Application.Handle<>LHWindow)
    and (Handle<>LHWindow)
    and ((LExStyle and WS_EX_TOOLWINDOW = 0)or(LExStyle and WS_EX_APPWINDOW <> 0))
    then
    begin
      titlelen := GetWindowTextLength(LHWindow);
      if titlelen > 0 then
      begin
        SetLength(title, titlelen);
        GetWindowText(LHWindow, PChar(title), titlelen + 1);

        GetMem(fAppItem, SizeOf(TAppItem));
        fAppItem.Handle := LHWindow;
        StrPLCopy(fAppItem.Caption, title, titlelen);

        GetWindowThreadProcessId(LHWindow, PID);
        //hProcess := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False, PID);
        hProcess := OpenProcess(PROCESS_ALL_ACCESS, False, PID);
        if hProcess <> 0 then
          try
            SetLength(WinFileName, MAX_PATH);
            {fLen := GetModuleFileNameEx(hProcess, 0, PChar(WinFileName), MAX_PATH);
            if fLen > 0 then
            begin
              SetLength(WinFileName, fLen);
              fAppItem.Path := WinFileName;
              fAppItem.Executable := ExtractFileName(WinFileName);
            end
            else if Win32MajorVersion >= 6 then}
            begin
              nSize := MAX_PATH;
              ZeroMemory(@FileName, MAX_PATH);
              // WinVista +
              @QueryFullProcessImageName := GetProcAddress(GetModuleHandle(kernel32), 'QueryFullProcessImageNameW');
              if Assigned(QueryFullProcessImageName) then
                if QueryFullProcessImageName(hProcess, 0, FileName, @nSize) then
                begin
                  SetString(WinFileName, PChar(@FileName[0]), nSize);
                  StrPLCopy(fAppItem.FilePath, WinFileName, High(fAppItem.FilePath));
                  if WinFileName.Contains('32\ApplicationFrameHost.exe') then
                  begin
                    // let's find the right UWP executable
                    fAppItem.FilePath := 'UWP APP';
                    windowInfo.ownerPid := PID;
                    windowInfo.childPid := PID;
                    GetGUIThreadInfo(PID,GuiInfo);
                    EnumChildWindows(LHWindow,@EnumChildWindowsProc,LParam(@windowInfo));
                    Sleep(1);
                  end;
                  //fAppItem.Executable := ExtractFileName(FileName);
                end;
            end;

            // get icon
            ZeroMemory(@lpsfi, SizeOf(SHFILEINFO));
            SHGetFileInfo(PChar(WinFileName),FILE_ATTRIBUTE_NORMAL,
              lpsfi, SizeOf(SHFILEINFO), SHGFI_ICON or SHGFI_LARGEICON);

            aIcon := TIcon.Create;
            try
              aIcon.Handle := GetClassLong(LHWindow, GCL_HICON);
              if aIcon.Handle = 0 then
                aIcon.Handle := GetClassLong(LHWindow, GCL_HICONSM);
                  if aIcon.Handle = 0 then
                    aIcon.Handle := lpsfi.hIcon;
                      if aIcon.Handle = 0 then
                        aIcon.Handle := ExtractAssociatedIcon(HInstance, PChar(WinFileName),fIconIndex);
              if aIcon.Handle <> 0 then
              begin
                imglstIcons.AddIcon(aIcon);
              end;

            finally
              aIcon.Free;
            end;
          finally
            CloseHandle(hProcess);
          end;
        fListApps.Add(fAppItem);
      end;
    end;
    LHWindow:=GetWindow(LHWindow, GW_HWNDNEXT);
  end;

  // Remove old menu items
  if fMenuesCount > 0 then
  begin
    for I := 0 to fMenuesCount - 1 do
    begin
      fMenues[I].Free;
    end;
    FreeMem(fMenues, fMenuesCount * SizeOf(TMenuItem));
  end;

  // Add menu items
  fMenuesCount := fListApps.Count;
  GetMem(fMenues, fMenuesCount * SizeOf(TMenuItem));

  for I := 0 to fListApps.Count - 1 do
  begin
    fMenues[I] := TMenuItem.Create(WindowMenu);
    fMenues[I].Caption := fListApps.Items[I].Caption; //.FilePath
    fMenues[I].Tag := fListApps.Items[I].Handle;
    fMenues[I].OnClick := HandleWindowListClick;
    fMenues[I].ImageIndex := I;
    Menu.Add(fMenues[I]);
  end;


//  Caption := 'Time Elapsed ' + FloatToStr(GetTickCount64 - I) + 'ms';
end;

procedure TForm1.N1001Click(Sender: TObject);
begin
  SetOpacity(Sender);
end;

procedure TForm1.PopupMenu1Popup(Sender: TObject);
begin
  ListWindows(ListWindows1);
end;

procedure TForm1.RecordWinAltR1Click(Sender: TObject);
begin
  if FullScreen then
  begin
    keybd_event(VK_LWIN,MapVirtualKey(VK_LWIN,0),0,0);
    Sleep(10);
    keybd_event(VK_MENU,MapVirtualKey(VK_MENU,0),0,0);
    Sleep(10);
    keybd_event(Ord('R'),MapVirtualKey(Ord('R'),0),0,0);
    Sleep(10);
    keybd_event(Ord('R'),MapVirtualKey(Ord('R'),0),KEYEVENTF_KEYUP,0);
    Sleep(100);
    keybd_event(VK_MENU,MapVirtualKey(VK_MENU,0),KEYEVENTF_KEYUP,0);
    Sleep(100);
    keybd_event(VK_LWIN,MapVirtualKey(VK_LWIN,0),KEYEVENTF_KEYUP,0);
    Sleep(100);
  end;
end;

procedure TForm1.SelectRegion1Click(Sender: TObject);
var
  prevBorder: TBorderStyle;
begin
  prevBorder := BorderStyle;
  BorderStyle := bsNone;
  FormStyle := fsNormal;
  formAreaSelector.FormStyle := fsStayOnTop;
  formAreaSelector.BorderStyle := bsNone;
  formAreaSelector.BoundsRect := BoundsRect;
  formAreaSelector.ShowModal;
  FormStyle := fsStayOnTop;
  BorderStyle := prevBorder;
end;

procedure TForm1.SetClickThrough(Enabled: Boolean);
begin
  fClickThrough := Enabled;
  if Enabled then
  begin
    SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_TRANSPARENT or WS_EX_TOOLWINDOW);
  end
  else
  begin
    SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) and not WS_EX_TRANSPARENT and not WS_EX_TOOLWINDOW);
  end;
end;

procedure TForm1.SetFullScreen(Enabled: Boolean);
begin
  fFullScreenState := Enabled;
  if Enabled then
  begin
    fCurrentMonitor := Screen.MonitorFromWindow(Handle);
    fPrevRect.Top := Top;
    fPrevRect.Left := Left;
    fPrevRect.Width := Width;
    fPrevRect.Height := Height;
    Left := fCurrentMonitor.Left;
    Top := fCurrentMonitor.Top;
    BorderStyle := bsNone;
    Width := fCurrentMonitor.Width;
    Height := fCurrentMonitor.Height;
    tmrFSMouse.Enabled := True;
  end
  else
  begin
    Left := fPrevRect.Left;
    Top := fPrevRect.Top;
    ClientWidth := fPrevRect.Width;
    ClientHeight := fPrevRect.Height;
    if not Borderless1.Checked then
      BorderStyle := fBorderStyle;
    tmrFSMouse.Enabled := False;
    ShowCursor(True);
  end;
end;

// Reads opacity level from MenuItem name e.g. "40%"
procedure TForm1.SetOpacity(Sender: TObject);
var
  FOpacity: String;
  IOpacity: Integer;
  I: Integer;
begin
  if Sender is TMenuItem then
  begin
    for I := 0 to Opacity1.Count - 1 do
      Opacity1.Items[I].Checked := False;
    FOpacity := StringReplace(TMenuItem(Sender).Caption,'%','',[rfReplaceAll]);
    FOpacity := StringReplace(FOpacity,'&','',[rfReplaceAll]);
    IOpacity := StrToInt(FOpacity);
    IOpacity := Round(IOpacity/100*255);
    SetLayeredWindowAttributes(Handle, 0, IOpacity, LWA_ALPHA);
    TMenuItem(Sender).Checked := True;
  end;
end;

procedure TForm1.SetTopMost(const Value: Boolean);
begin
  if FTopMost <> Value then
  begin
    FTopMost := Value;
    if FTopMost then
      FormStyle := fsStayOnTop
    else
      FormStyle := fsNormal;
  end;
end;

procedure TForm1.SetWindowClone(AHandle: THandle; AspectRatio: TAspectRatio);
var
  ThumbProp: DWM_THUMBNAIL_PROPERTIES;
  ThumbSize: SIZE;
  LHWindow: HWND;
begin
  if not IsWindow(AHandle) then Exit;

  lblGuide.Visible := False;

  if fThumbWindow <> 0 then
    DwmUnregisterThumbnail(fThumbWindow);

  if Succeeded(DwmRegisterThumbnail(Handle, AHandle, @fThumbWindow)) then
  begin
    DwmQueryThumbnailSourceSize(fThumbWindow, @ThumbSize);
    if (ThumbSize.cx <> 0) and (ThumbSize.cy <> 0) then
    begin
      ThumbProp.dwFlags := DWM_TNP_SOURCECLIENTAREAONLY
                           or DWM_TNP_VISIBLE
                           or DWM_TNP_OPACITY
                           or DWM_TNP_RECTDESTINATION;
      ThumbProp.fSourceClientAreaOnly := False;
      ThumbProp.fVisible := True;
      ThumbProp.opacity := 255;
      if Borderless1.Checked then
      ThumbProp.rcDestination := Rect(0,0,ClientWidth,ClientHeight)
      else
      ThumbProp.rcDestination := Rect(0,1,ClientWidth,ClientHeight);
      DwmUpdateThumbnailProperties(fThumbWindow, ThumbProp);
    end;

  end;
end;

procedure TForm1.tmrFSMouseTimer(Sender: TObject);
begin
  if FullScreen then
  begin
    if (fPrevFSCursor.X+2 >= Mouse.CursorPos.X)
    and (fPrevFSCursor.X-2 <= Mouse.CursorPos.X)
    and (fPrevFSCursor.Y+2 >= Mouse.CursorPos.Y)
    and (fPrevFSCursor.Y-2 <= Mouse.CursorPos.Y)
    then
    begin
      ShowCursor(False);
    end
    else
      ShowCursor(True);
    fPrevFSCursor := Mouse.CursorPos;
  end
  else ShowCursor(True);
end;

procedure TForm1.TrayIcon1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
    PopupMenu1.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
end;

// Fix Win+Shift+CursorKey moving on FullScreen
procedure TForm1.WM_WindowPosChanged(var Msg: TWMWindowPosChanged);
begin
  inherited;
  if fFullScreenState and (fCurrentMonitor <> Screen.MonitorFromWindow(Handle)) then
  begin
    fCurrentMonitor := Screen.MonitorFromWindow(Handle);
    Left := fCurrentMonitor.Left;
    Top := fCurrentMonitor.Top;
    ClientWidth := fCurrentMonitor.Width;
    ClientHeight := fCurrentMonitor.Height;
  end;
end;

procedure TForm1.MouseEvent(var Msg: TMessage);
var
  FMsg: PCopyDataStruct;
  Data: PMouseHookStruct;
begin

  if not MouseCursorMode1.Checked then Exit;
  if Fullscreen then Exit;
  if (GetAsyncKeyState(VK_CONTROL)<>0)
  and ((GetAsyncKeyState(VK_LSHIFT)<>0) or (GetAsyncKeyState(VK_RSHIFT)<>0))
  and (GetAsyncKeyState(VK_MENU)<>0)
  then Exit;



  Msg.Result := 0;
  FMsg := PCopyDataStruct(Msg.LParam);
  if FMsg = nil then
    Exit;

  Data := PMouseHookStruct(FMsg.lpData);

  Left := Data^.pt.X + MOUSE_GAP_X;
  Top := Data^.pt.Y + MOUSE_GAP_Y;

  Msg.Result := 1;
end;

{ TListApp }

function TListApp.Add(Value: PAppItem): Integer;
begin
  Result := inherited Add(Value);
end;

destructor TListApp.Destroy;
var
  I : Integer;
begin
  for I := 0 to Count - 1 do
    FreeMem(Items[I]);
  inherited;
end;

function TListApp.Get(Index: Integer): PAppItem;
begin
  Result := PAppItem(inherited Get(Index));
end;

{ TListAudioSession }

//function TListAudioSession.Add(Value: PAudioSessionModel): Integer;
//begin
//  Result := inherited Add(Value);
//end;
//
//function TListAudioSession.Get(Index: Integer): PAudioSessionModel;
//begin
//  Result := PAudioSessionModel(inherited Get(Index));
//end;
//
//procedure TListAudioSession.Notify(Ptr: Pointer; Action: TListNotification);
//begin
//  inherited;
//  if Action = lnDeleted then
//    FreeMem(Ptr);
//end;

end.
