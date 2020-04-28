object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Window Cloner'
  ClientHeight = 238
  ClientWidth = 430
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDblClick = FormDblClick
  OnDestroy = FormDestroy
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseWheelDown = FormMouseWheelDown
  OnMouseWheelUp = FormMouseWheelUp
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object lblGuide: TLabel
    Left = 0
    Top = 0
    Width = 430
    Height = 238
    Align = alClient
    Alignment = taCenter
    Caption = 'Pick a window'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Font.Quality = fqClearTypeNatural
    ParentFont = False
    PopupMenu = PopupMenu1
    Layout = tlCenter
    OnDblClick = FormDblClick
    OnMouseDown = FormMouseDown
    ExplicitWidth = 66
    ExplicitHeight = 13
  end
  object tmrFSMouse: TTimer
    Interval = 100
    OnTimer = tmrFSMouseTimer
    Left = 144
    Top = 72
  end
  object TrayIcon1: TTrayIcon
    Icons = imglstIcons
    Visible = True
    OnMouseUp = TrayIcon1MouseUp
    Left = 216
    Top = 104
  end
  object PopupMenu1: TPopupMenu
    Images = imglstIcons
    OnPopup = PopupMenu1Popup
    Left = 312
    Top = 80
    object ListWindows1: TMenuItem
      Caption = 'Pick Window'
    end
    object mnuSwitchToWindow: TMenuItem
      Caption = 'Switch to Window'
      OnClick = mnuSwitchToWindowClick
    end
    object SelectRegion1: TMenuItem
      Caption = 'Select Region'
    end
    object ClickThrough1: TMenuItem
      Caption = 'Click Through'
      OnClick = ClickThrough1Click
    end
    object Opacity1: TMenuItem
      Caption = 'Opacity'
      object N1001: TMenuItem
        Caption = '100%'
        OnClick = N1001Click
      end
      object N901: TMenuItem
        Caption = '90%'
        OnClick = N1001Click
      end
      object N801: TMenuItem
        Caption = '80%'
        OnClick = N1001Click
      end
      object N701: TMenuItem
        Caption = '70%'
        OnClick = N1001Click
      end
      object N601: TMenuItem
        Caption = '60%'
        OnClick = N1001Click
      end
      object N501: TMenuItem
        Caption = '50%'
        OnClick = N1001Click
      end
      object N401: TMenuItem
        Caption = '40%'
        OnClick = N1001Click
      end
      object N301: TMenuItem
        Caption = '30%'
        OnClick = N1001Click
      end
      object N201: TMenuItem
        Caption = '20%'
        OnClick = N1001Click
      end
      object N101: TMenuItem
        Caption = '10%'
        OnClick = N1001Click
      end
    end
    object Fullscreen1: TMenuItem
      Caption = 'Fullscreen'
      OnClick = Fullscreen1Click
    end
    object Borderless1: TMenuItem
      Caption = 'Borderless'
      OnClick = Borderless1Click
    end
    object HidefromTaskbar1: TMenuItem
      Caption = 'Hide from Taskbar'
      OnClick = HidefromTaskbar1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Settings1: TMenuItem
      Caption = 'Settings'
    end
    object About1: TMenuItem
      Caption = 'About'
    end
    object Exit2: TMenuItem
      Caption = 'Exit'
      OnClick = Exit2Click
    end
  end
  object imglstIcons: TImageList
    Left = 72
    Top = 128
  end
  object ActionList1: TActionList
    Left = 56
    Top = 48
    object actF11: TAction
      Caption = 'actF11'
      ShortCut = 122
      OnExecute = Fullscreen1Click
    end
    object actF: TAction
      Caption = 'actF'
      ShortCut = 70
      OnExecute = Fullscreen1Click
    end
    object actAltEnter: TAction
      Caption = 'actAltEnter'
      ShortCut = 32781
      OnExecute = Fullscreen1Click
    end
    object actMuteToggle: TAction
      Caption = 'actMuteToggle'
      ShortCut = 77
      OnExecute = actMuteToggleExecute
    end
  end
end
