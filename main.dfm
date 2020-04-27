object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
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
  OnCreate = FormCreate
  OnDblClick = FormDblClick
  OnDestroy = FormDestroy
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  PixelsPerInch = 96
  TextHeight = 13
  object tmrFSMouse: TTimer
    Interval = 100
    OnTimer = tmrFSMouseTimer
    Left = 144
    Top = 72
  end
  object TrayIcon1: TTrayIcon
    Visible = True
    Left = 216
    Top = 104
  end
  object PopupMenu1: TPopupMenu
    Left = 312
    Top = 80
    object Windows1: TMenuItem
      Caption = 'Pick Window'
      object none1: TMenuItem
        Caption = '<none>'
      end
    end
    object Exit1: TMenuItem
      Caption = 'Switch to Window'
    end
    object SelectRegion1: TMenuItem
      Caption = 'Select Region'
    end
    object ClickThrough1: TMenuItem
      Caption = 'Click Through'
    end
    object Opacity1: TMenuItem
      Caption = 'Opacity'
      object N1001: TMenuItem
        Caption = '100%'
      end
      object N901: TMenuItem
        Caption = '90%'
      end
      object N801: TMenuItem
        Caption = '80%'
      end
      object N701: TMenuItem
        Caption = '70%'
      end
      object N601: TMenuItem
        Caption = '60%'
      end
      object N501: TMenuItem
        Caption = '50%'
      end
      object N401: TMenuItem
        Caption = '40%'
      end
      object N301: TMenuItem
        Caption = '30%'
      end
      object N201: TMenuItem
        Caption = '20%'
      end
      object N101: TMenuItem
        Caption = '10%'
      end
    end
    object Fullscreen1: TMenuItem
      Caption = 'Fullscreen'
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
  object ImageList1: TImageList
    Left = 72
    Top = 128
  end
end
