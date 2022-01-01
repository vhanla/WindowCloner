// Translated by Alexey Andriukhin (dr. F.I.N.) http://www.delphisources.ru/forum/member.php?u=9721
// Tested on Win10 x32 (build 14393), Delphi7
//
// Great thanks:
//   Caintic   - https://github.com/Ciantic/VirtualDesktopAccessor
//   NikoTin   - http://www.cyberforum.ru/blogs/105416/blog3671.html
//   Grabacr07 - https://github.com/Grabacr07/VirtualDesktop
//   jlubea    - https://github.com/jlubea/VirtualDesktop

unit VirtualDesktopAPI;

interface

uses
  Windows, UITypes;

const
  EMPTY_GUID: TGUID = '{00000000-0000-0000-0000-000000000000}';

const
  CLSID_ImmersiveShell: TGUID = '{C2F03A33-21F5-47FA-B4BB-156362A2F239}';
  IID_ServiceProvider: TGUID = '{6D5140C1-7436-11CE-8034-00AA006009FA}';
//
  CLSID_ApplicationViewCollection: TGUID = '{1841C6D7-4F9D-42C0-AF41-8747538F10E5}'; // <--- CLSID same as IID? not shure, but it's works
  IID_ApplicationViewCollection: TGUID = '{1841C6D7-4F9D-42C0-AF41-8747538F10E5}';
//
  IID_ApplicationView: TGUID = '{9AC0B5C8-1484-4C5B-9533-4134A0F97CEA}';
//
  CLSID_VirtualDesktopManager: TGUID = '{AA509086-5CA9-4C25-8F95-589D3C07B48A}';
  IID_VirtualDesktopManager: TGUID = '{A5CD92FF-29BE-454C-8D04-D82879FB3F1B}';
//
  CLSID_VirtualDesktopAPI_Unknown: TGUID = '{C5E0CDCA-7B6E-41B2-9FC4-D93975CC467B}';
  IID_VirtualDesktopManagerInternal_14393: TGUID = '{F31574D6-B682-4CDC-BD56-1827860ABEC6}'; // build 14393 or later
  IID_VirtualDesktopManagerInternal_10240: TGUID = '{AF8DA486-95BB-4460-B3B7-6E7A6B2962B5}'; // build 10240 or later
  IID_VirtualDesktopManagerInternal_10130: TGUID = '{EF9F1A6C-D3CC-4358-B712-F84B635BEBE7}'; // build 10130 or later
  IID_VirtualDesktopManagerInternal_22000: TGUID = '{B2F925B9-5A0F-4D2E-9F4D-2B1507593C10}'; // build 22000 or later
//
  IID_VirtualDesktop: TGUID = '{FF72FFDD-BE7E-43FC-9C03-AD81681E88E4}';
//
  CLSID_VirtualNotificationService: TGUID = '{A501FDEC-4A09-464C-AE4E-1B9C21B84918}';
  IID_VirtualNotificationService: TGUID = '{0CD45E71-D927-4F15-8B0A-8FEF525337BF}';
//
  IID_VirtualDesktopNotification: TGUID = '{C179334C-4295-40D3-BEA1-C654D965605A}';
//
  CLSID_VirtualDesktopPinnedApps: TGUID = '{B5A399E7-1C87-46B8-88E9-FC5747B171BD}';
  IID_VirtualDesktopPinnedApps: TGUID = '{4CE81583-1E4C-4632-A621-07A53543148F}';

{ ApplicationViewCompatibilityPolicy }
  AVCP_NONE = 0;
  AVCP_SMALL_SCREEN = 1;
  AVCP_TABLET_SMALL_SCREEN = 2;
  AVCP_VERY_SMALL_SCREEN = 3;
  AVCP_HIGH_SCALE_FACTOR = 4;

type
  { IVirtualDesktopManager }

  IVirtualDesktopManager = interface(IUnknown)
    ['{A5CD92FF-29BE-454C-8D04-D82879FB3F1B}']
    function IsWindowOnCurrentVirtualDesktop(Wnd: HWND; pIsTrue: PBOOL): HResult; stdcall; // ok {INFORMATION: this only works with the current process windows}
    function GetWindowDesktopId(Wnd: HWND; pDesktopID: PGUID): HResult; stdcall; // ok
    function MoveWindowToDesktop(Wnd: HWND; const DesktopID: TGUID): HResult; stdcall; // ok
  end;

  { IObjectArray }

  PIUnknown = ^IUnknown;

  PIObjectArray = ^IObjectArray;

  IObjectArray = interface
    function GetCount(pCount: PUINT): HRESULT; stdcall; // ok
    function GetAt(uiIndex: UINT; riid: PGUID; ppv: PIUnknown): HRESULT; stdcall; // ok
  end;

  { IApplicationView }

  PLONGLONG = ^LONGLONG;

  PHWND = ^HWND;

  PIApplicationView = ^IApplicationView;

  IApplicationView = interface(IUnknown)
    ['{9AC0B5C8-1484-4C5B-9533-4134A0F97CEA}']
    function SetFocus: HRESULT; stdcall; // ok
    function SwitchTo: HRESULT; stdcall; // ok
    function notimpl1(): HRESULT; stdcall; //int TryInvokeBack(IntPtr /* IAsyncCallback* */ callback);
    function GetThumbnailWindow(pWnd: PHWND): HRESULT; stdcall; // ok
    function notimpl2(): HRESULT; stdcall; //int GetMonitor(out IntPtr /* IImmersiveMonitor */ immersiveMonitor);
    function notimpl3(): HRESULT; stdcall; //int GetVisibility(out int visibility);
    function notimpl4(): HRESULT; stdcall; //int SetCloak(ApplicationViewCloakType cloakType, int unknown);
    function notimpl5(): HRESULT; stdcall; //int GetPosition(ref Guid guid /* GUID for IApplicationViewPosition */, out IntPtr /* IApplicationViewPosition** */ position);
    function notimpl6(): HRESULT; stdcall; //int SetPosition(ref IntPtr /* IApplicationViewPosition* */ position);
    function InsertAfterWindow(Wnd: HWND): HRESULT; stdcall; // not tested
    function GetExtendedFramePosition(Rect: PRect): HRESULT; stdcall; // ok
    function GetAppUserModelId(Id: PLPWSTR): HRESULT; stdcall; // ok
    function SetAppUserModelId(Id: LPWSTR): HRESULT; stdcall; // not tested
    function IsEqualByAppUserModelId(Id: LPWSTR; isequal: BOOL): HRESULT; stdcall; // not tested
    function notimpl7(): HRESULT; stdcall; //int GetViewState(out uint state);
    function notimpl8(): HRESULT; stdcall; //int SetViewState(uint state);
    function notimpl9(): HRESULT; stdcall; //int GetNeediness(out int neediness);
    function GetLastActivationTimestamp(ptimestamp: PLONGLONG): HRESULT; stdcall; // <--- don't understand how convert to datetime (or it's works incorrectly)
    function SetLastActivationTimestamp(timestamp: LONGLONG): HRESULT; stdcall;   // <--- don't understand how convert from datetime (or it's works incorrectly)
    function GetVirtualDesktopId(pguid: PGUID): HRESULT; stdcall; // ok
    function SetVirtualDesktopId(pguid: PGUID): HRESULT; stdcall; // ok
    function GetShowInSwitchers(pflag: PBOOL): HRESULT; stdcall; // ok
    function SetShowInSwitchers(flag: BOOL): HRESULT; stdcall; // not supported at build 14393 and lower
    function notimpl10(): HRESULT; stdcall; //int GetScaleFactor(out int factor);
    function CanReceiveInput(pcanReceiveInput: PBOOL): HRESULT; stdcall; // not tested
    function GetCompatibilityPolicyType(pflag: PUINT): HRESULT; stdcall; // It seems that works ok
    function SetCompatibilityPolicyType(flag: UINT): HRESULT; stdcall; // not tested
    function notimpl11(): HRESULT; stdcall; //int GetPositionPriority(out IntPtr /* IShellPositionerPriority** */ priority);
    function notimpl12(): HRESULT; stdcall; //int SetPositionPriority(IntPtr /* IShellPositionerPriority* */ priority);
    function notimpl13(): HRESULT; stdcall; //int GetSizeConstraints(IntPtr /* IImmersiveMonitor* */ monitor, out Size size1, out Size size2);
    function notimpl14(): HRESULT; stdcall; //int GetSizeConstraintsForDpi(uint uint1, out Size size1, out Size size2);
    function notimpl15(): HRESULT; stdcall; //int SetSizeConstraintsForDpi(ref uint uint1, ref Size size1, ref Size size2);
    function notimpl16(): HRESULT; stdcall; //int QuerySizeConstraintsFromApp(); // It leads to a crash
    function OnMinSizePreferencesUpdated(Wnd: HWND): HRESULT; stdcall; // not tested
    function notimpl17(): HRESULT; stdcall; //int ApplyOperation(IntPtr /* IApplicationViewOperation* */ operation);
    function IsTray(pisTray: PBOOL): HRESULT; stdcall; // allways return TRUE
    function IsInHighZOrderBand(pisInHighZOrderBand: PBOOL): HRESULT; stdcall; // It seems that works ok
    function IsSplashScreenPresented(pisSplashScreenPresented: PBOOL): HRESULT; stdcall; // allways return FALSE
    function Flash: HRESULT; stdcall; // ok
    function GetRootSwitchableOwner(rootSwitchableOwner: PIApplicationView): HRESULT; stdcall; // not tested
    function EnumerateOwnershipTree(ownershipTree: PIObjectArray): HRESULT; stdcall; // not tested
    function GetEnterpriseId(Id: PLPWSTR): HRESULT; stdcall; // build 10584 or later // allwaus return empty value
    function IsMirrored(pisMirrored: PBOOL): HRESULT; stdcall; // build 10584 or later // allways return FALSE
  end;

  { IApplicationViewCollection }

  IApplicationViewCollection = interface(IUnknown)
    ['{1841C6D7-4F9D-42C0-AF41-8747538F10E5}']
    function GetViews(pViews: PIObjectArray): HRESULT; stdcall; // ok
    function GetViewsByZOrder(pViews: PIObjectArray): HRESULT; stdcall; // ok
    function GetViewsByAppUserModelId(Id: LPWSTR; pViews: PIObjectArray): HRESULT; stdcall; // not tested, but i think it works normaly
    function GetViewForHwnd(Wnd: HWND; pView: PIApplicationView): HRESULT; stdcall; // ok
    function notimpl1(): HRESULT; stdcall; //int GetViewForApplication(object application, out IApplicationView view);
    function GetViewForAppUserModelId(Id: LPWSTR; View: IApplicationView): HRESULT; stdcall; // not tested, but i think it works normaly
    function GetViewInFocus(pView: PIApplicationView): HRESULT; stdcall; // ok
    function RefreshCollection(): HRESULT; stdcall; // It seems that works ok
    function notimpl2(): HRESULT; stdcall; //int RegisterForApplicationViewChanges(object listener, out int cookie);
    function notimpl3(): HRESULT; stdcall; //int RegisterForApplicationViewPositionChanges(object listener, out int cookie);
    function notimpl4(): HRESULT; stdcall; //int UnregisterForApplicationViewChanges(int cookie);
  end;

  { IVirtualDesktop }

  PIVirtualDesktop = ^IVirtualDesktop;

  IVirtualDesktop = interface(IUnknown)
    ['{FF72FFDD-BE7E-43FC-9C03-AD81681E88E4}']
    function IsViewVisible(View: IApplicationView; pfVisible: PBOOL): HRESULT; stdcall; // ok
    function GetId(Id: PGUID): HRESULT; stdcall; // ok
  end;

  { IVirtualDesktopManagerInternal }

  IVirtualDesktopManagerInternal = interface(IUnknown)
//  ['{F31574D6-B682-4CDC-BD56-1827860ABEC6}'] // build 14393 or later
//  ['{AF8DA486-95BB-4460-B3B7-6E7A6B2962B5}'] // build 10240 or later
//  ['{EF9F1A6C-D3CC-4358-B712-F84B635BEBE7}'] // build 10130 or later
    function GetCount(pCount: PUINT): HRESULT; stdcall; // ok
    function MoveViewToDesktop(View: IApplicationView; Desktop: IVirtualDesktop): HRESULT; stdcall; // ok
    function CanViewMoveDesktops(View: IApplicationView; pfCanViewMoveDesktops: PBOOL): HRESULT; stdcall; // build 10240 or later // not tested
    function GetCurrentDesctop(pVD: PIVirtualDesktop): HRESULT; stdcall; // ok
    function GetDesktops(pDesktops: PIObjectArray): HRESULT; stdcall; // ok
    function GetAdjacentDesktop(Desktop: IVirtualDesktop; AdjacentDesktop: UINT; pAdjacentDesktop: PIVirtualDesktop): HRESULT; stdcall; // ok
    function SwitchDesktop(Desktop: IVirtualDesktop): HRESULT; stdcall; // ok
    function CreateDesktopW(pNewDesctop: PIVirtualDesktop): HRESULT; stdcall; // ok
    function RemoveDesktop(Desktop: IVirtualDesktop; FallbackDesktop: IVirtualDesktop): HRESULT; stdcall; // ok
    function FindDesktop(pId: PGUID; Desktop: PIVirtualDesktop): HRESULT; stdcall; // build 10240 or later // ok
  end;

  { IVirtualDesktopNotification }

  IVirtualDesktopNotification = interface(IUnknown) //10240
    ['{C179334C-4295-40D3-BEA1-C654D965605A}']
    function VirtualDesktopCreated(Desktop: IVirtualDesktop): HRESULT; stdcall; // ok
    function VirtualDesktopDestroyBegin(Desktop: IVirtualDesktop; DesktopFallback: IVirtualDesktop): HRESULT; stdcall; // ok
    function VirtualDesktopDestroyFailed(Desktop: IVirtualDesktop; DesktopFallback: IVirtualDesktop): HRESULT; stdcall; // ok
    function VirtualDesktopDestroyed(Desktop: IVirtualDesktop; DesktopFallback: IVirtualDesktop): HRESULT; stdcall; // ok
    function ViewVirtualDesktopChanged(View: IApplicationView): HRESULT; stdcall; // ok
    function CurrentVirtualDesktopChanged(DesktopOld: IVirtualDesktop; DesktopNew: IVirtualDesktop): HRESULT; stdcall; // ok
  end;

  IVirtualDesktopNotification20231 = interface(IUnknown) //build 20231
    ['{C179334C-4295-40D3-BEA1-C654D965605A}']
    function VirtualDesktopCreated(Desktop: IVirtualDesktop): HRESULT; stdcall; // ok
    function VirtualDesktopDestroyBegin(Desktop: IVirtualDesktop; DesktopFallback: IVirtualDesktop): HRESULT; stdcall; // ok
    function VirtualDesktopDestroyFailed(Desktop: IVirtualDesktop; DesktopFallback: IVirtualDesktop): HRESULT; stdcall; // ok
    function VirtualDesktopDestroyed(Desktop: IVirtualDesktop; DesktopFallback: IVirtualDesktop): HRESULT; stdcall; // ok
    function ViewVirtualDesktopChanged(View: IApplicationView): HRESULT; stdcall; // ok
    function CurrentVirtualDesktopChanged(DesktopOld: IVirtualDesktop; DesktopNew: IVirtualDesktop): HRESULT; stdcall; // ok
  end;

  IVirtualDesktopNotification21313 = interface(IUnknown) //build 21313
    ['{C179334C-4295-40D3-BEA1-C654D965605A}']
    function VirtualDesktopCreated(Desktop: IVirtualDesktop): HRESULT; stdcall; // ok
    function VirtualDesktopDestroyBegin(Desktop: IVirtualDesktop; DesktopFallback: IVirtualDesktop): HRESULT; stdcall; // ok
    function VirtualDesktopDestroyFailed(Desktop: IVirtualDesktop; DesktopFallback: IVirtualDesktop): HRESULT; stdcall; // ok
    function VirtualDesktopDestroyed(Desktop: IVirtualDesktop; DesktopFallback: IVirtualDesktop): HRESULT; stdcall; // ok
    function Unknown1(Number: Integer): HRESULT; stdcall;
    function VirtualDesktopMoved(Desktop: IVirtualDesktop; nFromIndex: Integer; nToIndex: Integer): HRESULT; stdcall;
    function VirtualDesktopRenamed(Desktop: IVirtualDesktop; chName: STRING): HRESULT; stdcall;
    function ViewVirtualDesktopChanged(View: IApplicationView): HRESULT; stdcall; // ok
    function CurrentVirtualDesktopChanged(DesktopOld: IVirtualDesktop; DesktopNew: IVirtualDesktop): HRESULT; stdcall; // ok
    function VirtualDesktopWallpaperChanged(Desktop: IVirtualDesktop; chPath: STRING): HRESULT; stdcall;
  end;

  { IVirtualNotificationService }

  IVirtualNotificationService = interface(IUnknown)
    ['{0CD45E71-D927-4F15-8B0A-8FEF525337BF}']
    function Register(Notification: IVirtualDesktopNotification; pdwCookie: PDWORD): HRESULT; stdcall; // ok
    function Unregister(dwCookie: DWORD): HRESULT; stdcall; // ok
  end;

  { IVirtualDesktopPinnedApps }

  IVirtualDesktopPinnedApps = interface(IUnknown)
    ['{4CE81583-1E4C-4632-A621-07A53543148F}']
    function IsAppIdPinned(appId: LPWSTR; pfPinned: PBOOL): HRESULT; stdcall; // ok
    function PinAppID(appId: LPWSTR): HRESULT; stdcall; // ok
    function UnpinAppID(appId: LPWSTR): HRESULT; stdcall; // ok
    function IsViewPinned(View: IApplicationView; pfPinned: PBOOL): HRESULT; stdcall; // ok
    function PinView(View: IApplicationView): HRESULT; stdcall; // ok
    function UnpinView(View: IApplicationView): HRESULT; stdcall; // ok
  end;

implementation

end.

