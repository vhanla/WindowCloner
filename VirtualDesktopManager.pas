// Created by Alexey Andriukhin (dr. F.I.N.) http://www.delphisources.ru/forum/member.php?u=9721
// Tested on Win10 x32 (build 14393), Delphi7

unit VirtualDesktopManager;

interface

uses
  { CodeGear }
  Windows,  // used for many functions
  Classes,  // used for: TList
  SysUtils, // used for: FreeAndNil()
  ActiveX,  // used for: CoInitialize(), CoUninitialize, Succeeded(), Failed(), IsEqualGUID()
  ComObj,   // used for: GUIDToString()
  { VirtualDesktopAPI }
  VirtualDesktopAPI;

type
  TNonRefInterfacedObject = class(TObject, IInterface)
  private
    fRefCount: Integer;
    fDestroyed: Boolean;
  protected
    { IInterface }
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    function QueryInterface(const IID: TGUID; out Obj): HRESULT; stdcall;
    { Self }
    procedure DoFreeInstance; virtual;
  public
    procedure FreeInstance; override;
  end;

  TVirtualDesktopManager = class;

  TVirtualDesktop = class(TNonRefInterfacedObject, IVirtualDesktop)
  private
    fManager: TVirtualDesktopManager;
    fIDesktop: IVirtualDesktop;
    function _GetId: TGUID;
    function _GetIdAsString: AnsiString;
    function _GetIndex: Integer;
    function _GetIsCurrent: Boolean;
  protected
  { IVirtualDesktop }
    function IsViewVisible(View: IApplicationView; pfVisible: PBOOL): HRESULT; stdcall;
    function GetId(Id: PGUID): HRESULT; stdcall;
  { IInterface }
    function QueryInterface(const IID: TGUID; out Obj): HRESULT; stdcall;
  { Self }
    constructor Create(Manager: TVirtualDesktopManager; iDesktop: IVirtualDesktop);
    procedure DoFreeInstance; override;
  public
  { Methods }
    // Switch
    function SwitchHere: Boolean;
    // Remove
    function Remove: Boolean; overload;
    function Remove(FallbackDesktop: TVirtualDesktop): Boolean; overload;
    function Remove(FallbackDesktopIndex: Integer): Boolean; overload;
    function Remove(FallbackDesktopId: TGUID): Boolean; overload;
    // Additional
    function IsWindowVisible(Wnd: HWND): Boolean;
  { Properties }
    property Id: TGUID read _GetId;
    property IdAsString: AnsiString read _GetIdAsString;
    property Index: Integer read _GetIndex;
    property IsCurrent: Boolean read _GetIsCurrent;
  end;

  TErrorNotify = procedure(Sender: TObject; ErroCode: HRESULT) of object;

  TVirtualDesktopCreatedNotify = procedure(Sender: TObject; Desktop: TVirtualDesktop) of object;

  TVirtualDesktopDestroyNotify = procedure(Sender: TObject; Desktop, DesktopFallback: TVirtualDesktop) of object;

  TCurrentVirtualDesktopChangedNotify = procedure(Sender: TObject; OldDesktop, NewDesktop: TVirtualDesktop) of object;

  TVirtualDesktopManager = class(TNonRefInterfacedObject, IVirtualDesktopNotification)
  private
    fISP: IServiceProvider;
    fIVDM: IVirtualDesktopManager;
    fIVDMI: IVirtualDesktopManagerInternal;
    fIVNS: IVirtualNotificationService;
    fIAVC: IApplicationViewCollection;
    fIVDPA: IVirtualDesktopPinnedApps;
    fCookie: DWORD;
  protected
  { IVirtualDesktopNotification }
    function VirtualDesktopCreated(Desktop: IVirtualDesktop): HRESULT; stdcall;
    function VirtualDesktopDestroyBegin(Desktop: IVirtualDesktop; DesktopFallback: IVirtualDesktop): HRESULT; stdcall;
    function VirtualDesktopDestroyFailed(Desktop: IVirtualDesktop; DesktopFallback: IVirtualDesktop): HRESULT; stdcall;
    function VirtualDesktopDestroyed(Desktop: IVirtualDesktop; DesktopFallback: IVirtualDesktop): HRESULT; stdcall;
    function ViewVirtualDesktopChanged(View: IApplicationView): HRESULT; stdcall;
    function CurrentVirtualDesktopChanged(DesktopOld: IVirtualDesktop; DesktopNew: IVirtualDesktop): HRESULT; stdcall;
  { Self }
    procedure DoFreeInstance; override;
  private
    fEnabled: Boolean;
    fLastError: HRESULT;
    fDesktops: TList;
    fOnCurrentChanged: TCurrentVirtualDesktopChangedNotify;
    fOnCreated: TVirtualDesktopCreatedNotify;
    fOnDestroyBegin: TVirtualDesktopDestroyNotify;
    fOnDestroyFailed: TVirtualDesktopDestroyNotify;
    fOnDestroyed: TVirtualDesktopDestroyNotify;
    fOnError: TErrorNotify;
    procedure FreeDesktops;
    function CheckError(res: HRESULT): Boolean;
    procedure Initialize;
    procedure Finalize;
    function _GetCount: Integer;
    function _GetDesktop(Index: Integer): TVirtualDesktop;
    function _GetCurrentDesktop: TVirtualDesktop;
    function _GetCurrentDesktopIndex: Integer;
    procedure _SetCurrentDesktopIndex(const Value: Integer);
    function _GetCurrentDesktopId: TGUID;
  protected
    procedure SetLastError(error: HRESULT);
  public
    procedure AfterConstruction; override;
  { Methods }
    // DESKTOPS
    // Additional
    procedure Refresh;
    function GetDesktopIndexById(Id: TGUID): Integer;
    // Create
    function CreateDesktop: Boolean;
    function CreateDesktopAndSwitch: Boolean;
    // Switch
    function SwitchToDesktop(Desktop: TVirtualDesktop): Boolean; overload;
    function SwitchToDesktop(DesktopId: TGUID): Boolean; overload;
    function SwitchToDesktop(DesktopIndex: Integer): Boolean; overload;
    // Remove
    function RemoveDesktop(Desktop: TVirtualDesktop): Boolean; overload;
    function RemoveDesktop(Desktop, DesktopFallback: TVirtualDesktop): Boolean; overload;
    function RemoveDesktop(DesktopId: TGUID): Boolean; overload;
    function RemoveDesktop(DesktopId, DesktopFallbackId: TGUID): Boolean; overload;
    function RemoveDesktop(DesktopIndex: Integer): Boolean; overload;
    function RemoveDesktop(DesktopIndex, DesktopFallbackIndex: Integer): Boolean; overload;
    // WINDOWS AND APPS
    function IsWindowOnCurrentDesktop(Wnd: HWND): Boolean;
    function GetWindowDesktop(Wnd: HWND): TVirtualDesktop;
    // Visibility
    function IsWindowVisibleAtDesktop(Wnd: HWND; Desktop: TVirtualDesktop): Boolean; overload;
    function IsWindowVisibleAtDesktop(Wnd: HWND; DesktopId: TGUID): Boolean; overload;
    function IsWindowVisibleAtDesktop(Wnd: HWND; DesktopIndex: Integer): Boolean; overload;
    // Move
    function MoveWindowToDesktop(Wnd: HWND; Desktop: TVirtualDesktop): Boolean; overload;
    function MoveWindowToDesktop(Wnd: HWND; DesktopId: TGUID): Boolean; overload;
    function MoveWindowToDesktop(Wnd: HWND; DesktopIndex: Integer): Boolean; overload;
    // Additional
    function IsWindowHaveView(Wnd: HWND): Boolean;
    function FlashWindow(Wnd: HWND): Boolean;
    function SwithToWindow(Wnd: HWND): Boolean;
    // Pin
    function IsPinnedWindow(Wnd: HWND): Boolean;
    function IsPinnedApplication(Wnd: HWND): Boolean;
    function PinWindow(Wnd: HWND): Boolean;
    function PinApplication(Wnd: HWND): Boolean;
    function UnpinWindow(Wnd: HWND): Boolean;
    function UnpinApplication(Wnd: HWND): Boolean;
  { Properties }
    property Enabled: Boolean read fEnabled;
    property LastError: HRESULT read fLastError;
    property Count: Integer read _GetCount;
    property Desktops[Index: Integer]: TVirtualDesktop read _GetDesktop;
    property CurrentDesktop: TVirtualDesktop read _GetCurrentDesktop;
    property CurrentDesktopId: TGUID read _GetCurrentDesktopId;
    property CurrentDesktopIndex: Integer read _GetCurrentDesktopIndex write _SetCurrentDesktopIndex;
  { Events }
    property OnDesktopCreated: TVirtualDesktopCreatedNotify read fOnCreated write fOnCreated;
    property OnDesktopDestroyBegin: TVirtualDesktopDestroyNotify read fOnDestroyBegin write fOnDestroyBegin;
    property OnDesktopDestroyFailed: TVirtualDesktopDestroyNotify read fOnDestroyFailed write fOnDestroyFailed;
    property OnDesktopDestroyed: TVirtualDesktopDestroyNotify read fOnDestroyed write fOnDestroyed;
    property OnCurrentDesktopChanged: TCurrentVirtualDesktopChangedNotify read fOnCurrentChanged write fOnCurrentChanged;
    property OnError: TErrorNotify read fOnError write fOnError;
  end;

var
  DesktopManager: TVirtualDesktopManager;

implementation

{ TNonRefInterfacedObject }

function TNonRefInterfacedObject._AddRef: Integer;
begin
  Result := InterlockedIncrement(fRefCount);
end;

function TNonRefInterfacedObject._Release: Integer;
begin
  Assert(fRefCount > 0, 'Reference count must be greater than zero.');
  Result := InterlockedDecrement(fRefCount);
  if (fRefCount = 0) and fDestroyed then
    FreeInstance;
end;

procedure TNonRefInterfacedObject.FreeInstance;
begin
  fDestroyed := True;
  if fRefCount = 0 then
  begin
    DoFreeInstance;
    inherited FreeInstance;
  end;
end;

function TNonRefInterfacedObject.QueryInterface(const IID: TGUID; out Obj): HRESULT;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

procedure TNonRefInterfacedObject.DoFreeInstance;
begin
end;

{ TVirtualDesktop }

constructor TVirtualDesktop.Create(Manager: TVirtualDesktopManager; iDesktop: IVirtualDesktop);
begin
  Assert((Manager <> nil), 'Manager must be assigned!');
  Assert((iDesktop <> nil), 'Desktop interface must be assigned!');
  fManager := Manager;
  fIDesktop := iDesktop;
  fIDesktop._AddRef;
end;

procedure TVirtualDesktop.DoFreeInstance;
begin
  fIDesktop._Release;
end;

function TVirtualDesktop.GetId(Id: PGUID): HRESULT;
begin
  Result := fIDesktop.GetId(Id);
end;

function TVirtualDesktop.IsViewVisible(View: IApplicationView; pfVisible: PBOOL): HRESULT;
begin
  Result := fIDesktop.IsViewVisible(View, pfVisible);
end;

function TVirtualDesktop.IsWindowVisible(Wnd: HWND): Boolean;
begin
  Result := fManager.IsWindowVisibleAtDesktop(Wnd, Self);
end;

function TVirtualDesktop.QueryInterface(const IID: TGUID; out Obj): HRESULT;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := fIDesktop.QueryInterface(IID, Obj);
end;

function TVirtualDesktop.Remove: Boolean;
begin
  Result := fManager.RemoveDesktop(Self);
end;

function TVirtualDesktop.Remove(FallbackDesktop: TVirtualDesktop): Boolean;
begin
  Result := fManager.RemoveDesktop(Self, FallbackDesktop);
end;

function TVirtualDesktop.Remove(FallbackDesktopId: TGUID): Boolean;
begin
  Result := fManager.RemoveDesktop(_GetId, FallbackDesktopId);
end;

function TVirtualDesktop.Remove(FallbackDesktopIndex: Integer): Boolean;
begin
  Result := fManager.RemoveDesktop(_GetIndex, FallbackDesktopIndex);
end;

function TVirtualDesktop.SwitchHere: Boolean;
begin
  Result := fManager.SwitchToDesktop(Self);
end;

function TVirtualDesktop._GetId: TGUID;
var
  error_code: HRESULT;
begin
  error_code := fIDesktop.GetId(@Result);
  if Failed(error_code) then
    Result := EMPTY_GUID;
  fManager.SetLastError(error_code);
end;

function TVirtualDesktop._GetIdAsString: AnsiString;
begin
  Result := GUIDToString(_GetId);
end;

function TVirtualDesktop._GetIndex: Integer;
begin
  Result := fManager.GetDesktopIndexById(_GetId);
end;

function TVirtualDesktop._GetIsCurrent: Boolean;
begin
  Result := IsEqualGUID(fManager.CurrentDesktop.Id, _GetId);
end;

{ TVirtualDesktopManager }

procedure ReleaseAndNil(var Intf);
var
  Temp: IUnknown;
begin
  Temp := IUnknown(Intf);
  if Temp = nil then
    Exit;
  Temp._Release;
  Pointer(Intf) := nil;
end;

procedure TVirtualDesktopManager.AfterConstruction;
begin
  inherited AfterConstruction;
  Initialize;
  if fEnabled then
    Refresh;
end;

function TVirtualDesktopManager.CheckError(res: HRESULT): Boolean;
begin
  fLastError := Res;
  Result := Succeeded(Res);
  if (not Result) and Assigned(fOnError) then
    fOnError(Self, res);
end;

function TVirtualDesktopManager.CreateDesktop: Boolean;
var
  intf_desktop: IVirtualDesktop;
begin
  Result := CheckError(fIVDMI.CreateDesktopW(@intf_desktop));
end;

function TVirtualDesktopManager.CreateDesktopAndSwitch: Boolean;
var
  intf_desktop: IVirtualDesktop;
begin
  Result := CheckError(fIVDMI.CreateDesktopW(@intf_desktop));
  if Result then
    Result := CheckError(fIVDMI.SwitchDesktop(intf_desktop));
end;

function TVirtualDesktopManager.CurrentVirtualDesktopChanged(DesktopOld, DesktopNew: IVirtualDesktop): HRESULT;
var
  old_desktop_id, new_desktop_id: TGUID;
begin
  if Assigned(fOnCurrentChanged) then
  begin
    CheckError(DesktopOld.GetId(@old_desktop_id));
    CheckError(DesktopNew.GetId(@new_desktop_id));
    fOnCurrentChanged(Self, _GetDesktop(GetDesktopIndexById(old_desktop_id)), _GetDesktop(GetDesktopIndexById(new_desktop_id)));
  end;
  Result := S_OK;
end;

procedure TVirtualDesktopManager.DoFreeInstance;
begin
  if fEnabled then
    Finalize;
  FreeDesktops;
end;

procedure TVirtualDesktopManager.Finalize;
begin
  if fIVNS <> nil then
    fIVNS.Unregister(fCookie);
  ReleaseAndNil(fIVDM);
  ReleaseAndNil(fIVDMI);
  ReleaseAndNil(fIVNS);
  ReleaseAndNil(fIAVC);
  ReleaseAndNil(fIVDPA);
  ReleaseAndNil(fISP);
end;

procedure TVirtualDesktopManager.FreeDesktops;
var
  desktop_index: Integer;
begin
  if fDesktops <> nil then
  begin
    for desktop_index := fDesktops.Count - 1 downto 0 do
      TVirtualDesktop(fDesktops[desktop_index]).Free;
    FreeAndNil(fDesktops);
  end;
end;

function TVirtualDesktopManager.GetDesktopIndexById(Id: TGUID): Integer;
begin
  Result := 0;
  while (Result < Count) and (not IsEqualGUID(TVirtualDesktop(fDesktops[Result]).Id, Id)) do
    Inc(Result);
  if Result = Count then
    Result := -1;
end;

function TVirtualDesktopManager.GetWindowDesktop(Wnd: HWND): TVirtualDesktop;
var
  desktop_id: TGUID;
begin
  Result := nil;
  if fEnabled then
    if CheckError(fIVDM.GetWindowDesktopId(Wnd, @desktop_id)) then
      Result := _GetDesktop(GetDesktopIndexById(desktop_id));
end;

function TVirtualDesktopManager.FlashWindow(Wnd: HWND): Boolean;
var
  intf_view: IApplicationView;
begin
  Result := False;
  if fEnabled then
  begin
    CheckError(fIAVC.RefreshCollection);
    if CheckError(fIAVC.GetViewForHwnd(Wnd, @intf_view)) then
      Result := CheckError(intf_view.Flash);
  end;
end;

procedure TVirtualDesktopManager.Initialize;
begin
  fISP := nil;
  fIVDM := nil;
  fIVDMI := nil;
  fIVNS := nil;
  fIAVC := nil;
  fIVDPA := nil;
  fEnabled := CheckError(CoCreateInstance(CLSID_VirtualDesktopManager, nil, CLSCTX_INPROC_SERVER, IID_VirtualDesktopManager, fIVDM)) and //
    CheckError(CoCreateInstance(CLSID_ImmersiveShell, nil, CLSCTX_LOCAL_SERVER, IID_ServiceProvider, fISP));
  if fEnabled then
  begin
    fEnabled := CheckError(fISP.QueryService(CLSID_VirtualDesktopAPI_Unknown, IID_VirtualDesktopManagerInternal_14393, fIVDMI));
    if not fEnabled then
      fEnabled := CheckError(fISP.QueryService(CLSID_VirtualDesktopAPI_Unknown, IID_VirtualDesktopManagerInternal_10240, fIVDMI));
    if not fEnabled then
      fEnabled := CheckError(fISP.QueryService(CLSID_VirtualDesktopAPI_Unknown, IID_VirtualDesktopManagerInternal_10130, fIVDMI));
    fEnabled := fEnabled and //
      CheckError(fISP.QueryService(CLSID_VirtualNotificationService, IID_VirtualNotificationService, fIVNS)) and //
      CheckError(fISP.QueryService(CLSID_ApplicationViewCollection, IID_ApplicationViewCollection, fIAVC)) and //
      CheckError(fISP.QueryService(CLSID_VirtualDesktopPinnedApps, IID_VirtualDesktopPinnedApps, fIVDPA));
    if fEnabled then
      fEnabled := CheckError(fIVNS.Register(Self, @fCookie));
  end;
  if not fEnabled then
    Finalize;
end;

function TVirtualDesktopManager.IsWindowOnCurrentDesktop(Wnd: HWND): Boolean;
var
  bool_result: BOOL;
begin
  Result := False;
  if fEnabled then
    if CheckError(fIVDM.IsWindowOnCurrentVirtualDesktop(Wnd, @bool_result)) then
      Result := bool_result;
end;

function TVirtualDesktopManager.MoveWindowToDesktop(Wnd: HWND; Desktop: TVirtualDesktop): Boolean;
var
  intf_view: IApplicationView;
begin
  Result := False;
  if fEnabled then
    if GetWindowThreadProcessId(Wnd) = GetCurrentProcessId then
      Result := CheckError(fIVDM.MoveWindowToDesktop(Wnd, Desktop.Id))
    else
    begin
      CheckError(fIAVC.RefreshCollection);
      if CheckError(fIAVC.GetViewForHwnd(Wnd, @intf_view)) then
        Result := CheckError(fIVDMI.MoveViewToDesktop(intf_view, (Desktop as IVirtualDesktop)));
    end;
end;

function TVirtualDesktopManager.MoveWindowToDesktop(Wnd: HWND; DesktopId: TGUID): Boolean;
begin
  Result := MoveWindowToDesktop(Wnd, _GetDesktop(GetDesktopIndexById(DesktopId)));
end;

function TVirtualDesktopManager.MoveWindowToDesktop(Wnd: HWND; DesktopIndex: Integer): Boolean;
begin
  Result := MoveWindowToDesktop(Wnd, _GetDesktop(DesktopIndex));
end;

function TVirtualDesktopManager.IsWindowHaveView(Wnd: HWND): Boolean;
var
  intf_view: IApplicationView;
begin
  Result := False;
  if fEnabled then
  begin
    CheckError(fIAVC.RefreshCollection);
    Result := Succeeded(fIAVC.GetViewForHwnd(Wnd, @intf_view));
  end;
end;

function TVirtualDesktopManager.IsPinnedApplication(Wnd: HWND): Boolean;
var
  intf_view: IApplicationView;
  app_id: PLPWSTR;
  bool_result: BOOL;
begin
  Result := False;
  if fEnabled then
  begin
    CheckError(fIAVC.RefreshCollection);
    if CheckError(fIAVC.GetViewForHwnd(Wnd, @intf_view)) then
    begin
      GetMem(app_id, 1024);
      if CheckError(intf_view.GetAppUserModelId(app_id)) then
        if CheckError(fIVDPA.IsAppIdPinned(app_id^, @bool_result)) then
          Result := bool_result;
      FreeMem(app_id);
    end;
  end;
end;

function TVirtualDesktopManager.IsPinnedWindow(Wnd: HWND): Boolean;
var
  intf_view: IApplicationView;
  bool_result: BOOL;
begin
  Result := False;
  if fEnabled then
  begin
    CheckError(fIAVC.RefreshCollection);
    if CheckError(fIAVC.GetViewForHwnd(Wnd, @intf_view)) then
      if CheckError(fIVDPA.IsViewPinned(intf_view, @bool_result)) then
        Result := bool_result;
  end;
end;

function TVirtualDesktopManager.IsWindowVisibleAtDesktop(Wnd: HWND; Desktop: TVirtualDesktop): Boolean;
var
  intf_view: IApplicationView;
  bool_result: Boolean;
begin
  Result := False;
  if fEnabled then
  begin
    CheckError(fIAVC.RefreshCollection);
    if CheckError(fIAVC.GetViewForHwnd(Wnd, @intf_view)) then
      if CheckError((Desktop as IVirtualDesktop).IsViewVisible(intf_view, @bool_result)) then
        Result := bool_result;
  end;
end;

function TVirtualDesktopManager.IsWindowVisibleAtDesktop(Wnd: HWND; DesktopId: TGUID): Boolean;
begin
  Result := IsWindowVisibleAtDesktop(Wnd, _GetDesktop(GetDesktopIndexById(DesktopId)));
end;

function TVirtualDesktopManager.IsWindowVisibleAtDesktop(Wnd: HWND; DesktopIndex: Integer): Boolean;
begin
  Result := IsWindowVisibleAtDesktop(Wnd, _GetDesktop(DesktopIndex));
end;

procedure TVirtualDesktopManager.Refresh;
var
  desktop_count: UINT;
  desktop_index: Integer;
  desktop_new: TVirtualDesktop;
  intf_desktop: IVirtualDesktop;
  intf_desktops: IObjectArray;
begin
  FreeDesktops;
  if fEnabled then
    if CheckError(fIVDMI.GetDesktops(@intf_desktops)) then
      if CheckError(intf_desktops.GetCount(@desktop_count)) and (desktop_count > 0) then
      begin
        fDesktops := TList.Create;
        for desktop_index := 0 to desktop_count - 1 do
          if CheckError(intf_desktops.GetAt(desktop_index, @IID_VirtualDesktop, @intf_desktop)) then
          begin
            desktop_new := TVirtualDesktop.Create(Self, intf_desktop);
            fDesktops.Add(desktop_new);
          end;
      end;
end;

function TVirtualDesktopManager.RemoveDesktop(Desktop: TVirtualDesktop): Boolean;
var
  intf_desktop: IVirtualDesktop;
  candidate: Integer;
begin
  Result := False;
  if fEnabled then
    if Count = 1 then
    begin
      Result := CheckError(fIVDMI.CreateDesktopW(@intf_desktop));
      if Result then
        Result := CheckError(fIVDMI.RemoveDesktop((Desktop as IVirtualDesktop), intf_desktop));
    end
    else if Desktop.IsCurrent then
    begin
      candidate := 0;
      while IsEqualGUID(_GetDesktop(candidate).Id, Desktop.Id) do
        Inc(candidate);
      Result := CheckError(fIVDMI.RemoveDesktop((Desktop as IVirtualDesktop), (_GetDesktop(candidate) as IVirtualDesktop)));
    end
    else
      Result := CheckError(fIVDMI.RemoveDesktop((Desktop as IVirtualDesktop), (_GetCurrentDesktop as IVirtualDesktop)));
end;

function TVirtualDesktopManager.RemoveDesktop(DesktopId: TGUID): Boolean;
begin
  Result := RemoveDesktop(_GetDesktop(GetDesktopIndexById(DesktopId)));
end;

function TVirtualDesktopManager.RemoveDesktop(DesktopIndex: Integer): Boolean;
begin
  Result := RemoveDesktop(_GetDesktop(DesktopIndex));
end;

function TVirtualDesktopManager.RemoveDesktop(Desktop, DesktopFallback: TVirtualDesktop): Boolean;
begin
  Result := CheckError(fIVDMI.RemoveDesktop((Desktop as IVirtualDesktop), (DesktopFallback as IVirtualDesktop)));
end;

function TVirtualDesktopManager.RemoveDesktop(DesktopId, DesktopFallbackId: TGUID): Boolean;
begin
  Result := RemoveDesktop(_GetDesktop(GetDesktopIndexById(DesktopId)), _GetDesktop(GetDesktopIndexById(DesktopFallbackId)));
end;

function TVirtualDesktopManager.RemoveDesktop(DesktopIndex, DesktopFallbackIndex: Integer): Boolean;
begin
  Result := RemoveDesktop(_GetDesktop(DesktopIndex), _GetDesktop(DesktopFallbackIndex));
end;

function TVirtualDesktopManager.PinApplication(Wnd: HWND): Boolean;
var
  intf_view: IApplicationView;
  app_id: PLPWSTR;
begin
  Result := False;
  if fEnabled then
  begin
    CheckError(fIAVC.RefreshCollection);
    if CheckError(fIAVC.GetViewForHwnd(Wnd, @intf_view)) then
    begin
      GetMem(app_id, 1024);
      if CheckError(intf_view.GetAppUserModelId(app_id)) then
        Result := CheckError(fIVDPA.PinAppID(app_id^));
      FreeMem(app_id);
    end;
  end;
end;

function TVirtualDesktopManager.PinWindow(Wnd: HWND): Boolean;
var
  intf_view: IApplicationView;
begin
  Result := False;
  if fEnabled then
  begin
    CheckError(fIAVC.RefreshCollection);
    if CheckError(fIAVC.GetViewForHwnd(Wnd, @intf_view)) then
      Result := CheckError(fIVDPA.PinView(intf_view));
  end;
end;

procedure TVirtualDesktopManager.SetLastError(error: HRESULT);
begin
  fLastError := error;
end;

function TVirtualDesktopManager.SwitchToDesktop(Desktop: TVirtualDesktop): Boolean;
begin
  if fEnabled then
    Result := CheckError(fIVDMI.SwitchDesktop((Desktop as IVirtualDesktop)))
  else
    Result := False;
end;

function TVirtualDesktopManager.SwitchToDesktop(DesktopId: TGUID): Boolean;
begin
  Result := SwitchToDesktop(_GetDesktop(GetDesktopIndexById(DesktopId)));
end;

function TVirtualDesktopManager.SwitchToDesktop(DesktopIndex: Integer): Boolean;
begin
  Result := SwitchToDesktop(_GetDesktop(DesktopIndex));
end;

function TVirtualDesktopManager.SwithToWindow(Wnd: HWND): Boolean;
var
  intf_view: IApplicationView;
begin
  Result := False;
  if fEnabled then
  begin
    CheckError(fIAVC.RefreshCollection);
    if CheckError(fIAVC.GetViewForHwnd(Wnd, @intf_view)) then
      Result := CheckError(intf_view.SwitchTo);
  end;
end;

function TVirtualDesktopManager.UnpinApplication(Wnd: HWND): Boolean;
var
  intf_view: IApplicationView;
  app_id: PLPWSTR;
begin
  Result := False;
  if fEnabled then
  begin
    CheckError(fIAVC.RefreshCollection);
    if CheckError(fIAVC.GetViewForHwnd(Wnd, @intf_view)) then
    begin
      GetMem(app_id, 1024);
      if CheckError(intf_view.GetAppUserModelId(app_id)) then
        Result := CheckError(fIVDPA.UnpinAppID(app_id^));
      FreeMem(app_id);
    end;
  end;
end;

function TVirtualDesktopManager.UnpinWindow(Wnd: HWND): Boolean;
var
  intf_view: IApplicationView;
begin
  Result := False;
  if fEnabled then
  begin
    CheckError(fIAVC.RefreshCollection);
    if CheckError(fIAVC.GetViewForHwnd(Wnd, @intf_view)) then
      Result := CheckError(fIVDPA.UnpinView(intf_view));
  end;
end;

function TVirtualDesktopManager.ViewVirtualDesktopChanged(View: IApplicationView): HRESULT;
begin
  // to do
  Result := S_OK;
end;

function TVirtualDesktopManager.VirtualDesktopCreated(Desktop: IVirtualDesktop): HRESULT;
var
  new_desktop: TVirtualDesktop;
begin
  new_desktop := TVirtualDesktop.Create(Self, Desktop);
  fDesktops.Add(new_desktop);
  if Assigned(fOnCreated) then
    fOnCreated(Self, new_desktop);
  Result := S_OK;
end;

function TVirtualDesktopManager.VirtualDesktopDestroyBegin(Desktop, DesktopFallback: IVirtualDesktop): HRESULT;
var
  desktop_id, desktop_fallback_id: TGUID;
begin
  if Assigned(fOnDestroyBegin) then
  begin
    CheckError(Desktop.GetId(@desktop_id));
    CheckError(DesktopFallback.GetId(@desktop_fallback_id));
    fOnDestroyBegin(Self, _GetDesktop(GetDesktopIndexById(desktop_id)), _GetDesktop(GetDesktopIndexById(desktop_fallback_id)));
  end;
  Result := S_OK;
end;

function TVirtualDesktopManager.VirtualDesktopDestroyed(Desktop, DesktopFallback: IVirtualDesktop): HRESULT;
var
  desktop_id, desktop_fallback_id: TGUID;
  destroyed_desktop: TVirtualDesktop;
begin
  CheckError(Desktop.GetId(@desktop_id));
  destroyed_desktop := TVirtualDesktop(fDesktops.Extract(_GetDesktop(GetDesktopIndexById(desktop_id))));
  if Assigned(fOnDestroyed) then
  begin
    CheckError(DesktopFallback.GetId(@desktop_fallback_id));
    fOnDestroyed(Self, destroyed_desktop, _GetDesktop(GetDesktopIndexById(desktop_fallback_id)));
  end;
  destroyed_desktop.Free;
  Result := S_OK;
end;

function TVirtualDesktopManager.VirtualDesktopDestroyFailed(Desktop, DesktopFallback: IVirtualDesktop): HRESULT;
var
  desktop_id, desktop_fallback_id: TGUID;
begin
  if Assigned(fOnDestroyFailed) then
  begin
    CheckError(Desktop.GetId(@desktop_id));
    CheckError(DesktopFallback.GetId(@desktop_fallback_id));
    fOnDestroyFailed(Self, _GetDesktop(GetDesktopIndexById(desktop_id)), _GetDesktop(GetDesktopIndexById(desktop_fallback_id)));
  end;
  Result := S_OK;
end;

function TVirtualDesktopManager._GetCount: Integer;
begin
  if fDesktops = nil then
    Result := 0
  else
    Result := fDesktops.Count;
end;

function TVirtualDesktopManager._GetCurrentDesktop: TVirtualDesktop;
begin
  Result := _GetDesktop(_GetCurrentDesktopIndex);
end;

function TVirtualDesktopManager._GetCurrentDesktopIndex: Integer;
var
  intf_desktop: IVirtualDesktop;
  desktop_id: TGUID;
begin
  Result := -1;
  if fEnabled then
    if CheckError(fIVDMI.GetCurrentDesctop(@intf_desktop)) then
      if CheckError(intf_desktop.GetId(@desktop_id)) then
        Result := GetDesktopIndexById(desktop_id);
end;

function TVirtualDesktopManager._GetDesktop(Index: Integer): TVirtualDesktop;
begin
  if (fDesktops = nil) or (Index < 0) or (Index >= fDesktops.Count) then
    Result := nil
  else
    Result := TVirtualDesktop(fDesktops.Items[Index]);
end;

function TVirtualDesktopManager._GetCurrentDesktopId: TGUID;
begin
  Result := CurrentDesktop.Id;
end;

procedure TVirtualDesktopManager._SetCurrentDesktopIndex(const Value: Integer);
begin
  SwitchToDesktop(Value);
end;

initialization
  CoInitialize(nil);
  DesktopManager := TVirtualDesktopManager.Create;

finalization
  DesktopManager.Free;
  CoUninitialize;

end.

