library MouseHook;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  View-Project Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the DELPHIMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using DELPHIMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  Windows,
  Classes;

const
  MemMapFile = 'WindowCloner';
  WM_USER             = $0400;
  WM_MOUSEMOVE        = $0200;
  WM_COPYDATA         = $004A;
  WH_MOUSE_LL         = $000E;
  WM_MOUSE_EVENT = WM_USER + 9;
type
  PDLLGlobal = ^TDLLGlobal;
  TDLLGlobal = packed record
    HookHandle: HHOOK;
  end;

var
  GlobalData: PDLLGlobal;
  MMF: THandle;
  OwnerHandle: HWND;

{$R *.res}

function HookProc(Code: Integer; wParam: WPARAM; lParam: LPARAM): HRESULT; stdcall;
var
  Msg: PCopyDataStruct;
  Res: Integer;
  AppClassName: array[0..255] of char;
begin
  if (Code < 0) or (Code = HC_NOREMOVE) then
  begin
    Result := CallNextHookEx(GlobalData^.HookHandle, Code, wParam, lParam);
    Exit;
  end;

  if (wParam = WM_MOUSEMOVE) then
  begin
    GetClassName(OwnerHandle, AppClassName, 255);
    if IsWindow(OwnerHandle) and (AppClassName = 'WindowClonerHwnd') then
    begin
      New(Msg);
      Msg^.dwData := 0;
      Msg^.cbData := SizeOf(TMouseHookStruct) + 1;
      Msg^.lpData := PMouseHookStruct(lParam);
      SendMessageTimeout(OwnerHandle, WM_MOUSE_EVENT, 0, Integer(Msg), SMTO_ABORTIFHUNG, 50, @Res);
      Dispose(Msg);
    end;
  end;

  Result := CallNextHookEx(GlobalData^.HookHandle, Code, wParam, lParam);
end;

procedure CreateGlobalHeap;
begin
  MMF := CreateFileMapping(INVALID_HANDLE_VALUE, nil, PAGE_READWRITE, 0,
         SizeOf(TDLLGlobal), MemMapFile);

  if MMF = 0 then Exit;

  GlobalData := MapViewOfFile(MMF, FILE_MAP_ALL_ACCESS, 0, 0, SizeOf(TDLLGlobal));
  if GlobalData = nil then
  begin
    CloseHandle(MMF);
  end;
end;

procedure DeleteGlobalHeap;
begin
  if GlobalData <> nil then UnmapViewOfFile(GlobalData);

  if MMF <> INVALID_HANDLE_VALUE then CloseHandle(MMF);
end;

function IsHooked:BOOL; stdcall;
begin
  Result := False;
  if (GlobalData <> nil) and (GlobalData^.HookHandle <> INVALID_HANDLE_VALUE) then
    Result := True;
end;

function RunHook(AHandle: HWND):BOOL; stdcall;
begin
  Result := False;
  OwnerHandle := AHandle;
  GlobalData^.HookHandle := SetWindowsHookEx(WH_MOUSE_LL, @HookProc, HInstance, 0);

  if GlobalData^.HookHandle = INVALID_HANDLE_VALUE then Exit;
  Result := True;
end;

function KillHook:BOOL; stdcall;
begin
  Result := False;
  if (GlobalData <> nil) and (GlobalData^.HookHandle <> INVALID_HANDLE_VALUE) then
  begin
    Result := UnhookWindowsHookEx(GlobalData^.HookHandle);
    if not Result then
      Result := UnhookWindowsHookEx(GlobalData^.HookHandle);
  end;
end;

procedure DLLEntry(dwReason: DWORD);
begin
  case dwReason of
    DLL_PROCESS_ATTACH: CreateGlobalHeap;
    DLL_PROCESS_DETACH: DeleteGlobalHeap;
  end;
end;

exports
  KillHook,
  IsHooked,
  RunHook;

begin
  DllProc := @DLLEntry;
  DLLEntry(DLL_PROCESS_ATTACH);
end.

