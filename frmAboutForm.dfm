object frmAbout: TfrmAbout
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'About'
  ClientHeight = 372
  ClientWidth = 519
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object UCaptionBar1: TUCaptionBar
    Left = 0
    Top = 0
    Width = 519
    Caption = '   About Window Cloner'
    Color = 15921906
    TabOrder = 0
    CustomBackColor.Enabled = False
    CustomBackColor.Color = 15921906
    CustomBackColor.LightColor = 15921906
    CustomBackColor.DarkColor = 2829099
    ExplicitLeft = 96
    ExplicitTop = 112
    ExplicitWidth = 185
    object UQuickButton1: TUQuickButton
      Left = 474
      Top = 0
      Align = alRight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe MDL2 Assets'
      Font.Style = []
      ParentFont = False
      CustomBackColor.Enabled = False
      CustomBackColor.Color = clBlack
      CustomBackColor.LightColor = 13619151
      CustomBackColor.DarkColor = 3947580
      ButtonStyle = qbsQuit
      Caption = #57610
      ExplicitLeft = 488
    end
  end
  object UScrollBox1: TUScrollBox
    Left = 113
    Top = 32
    Width = 406
    Height = 286
    HorzScrollBar.Tracking = True
    VertScrollBar.Tracking = True
    Align = alClient
    TabOrder = 1
    AniSet.AniKind = akOut
    AniSet.AniFunctionKind = afkQuintic
    AniSet.DelayStartTime = 0
    AniSet.Duration = 120
    AniSet.Step = 11
    CustomBackColor.Enabled = False
    CustomBackColor.Color = 15132390
    CustomBackColor.LightColor = 15132390
    CustomBackColor.DarkColor = 2039583
    object CardPanel1: TCardPanel
      Left = 0
      Top = 0
      Width = 406
      Height = 286
      Align = alClient
      ActiveCard = Card2
      Caption = 'CardPanel1'
      TabOrder = 1
      ExplicitLeft = 89
      ExplicitTop = 69
      ExplicitWidth = 300
      ExplicitHeight = 200
      object Card1: TCard
        Left = 1
        Top = 1
        Width = 404
        Height = 284
        Caption = 'Card1'
        CardIndex = 0
        TabOrder = 0
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 185
        ExplicitHeight = 41
        object RichEdit1: TRichEdit
          Left = 0
          Top = 0
          Width = 404
          Height = 284
          Align = alClient
          BorderStyle = bsNone
          BorderWidth = 12
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Lines.Strings = (
            'Version: 1.3'
            ''
            'Author: Victor Alberto Gil <vhanla>'
            'Repository: https://github.com/vhanla/WindowCloner'
            ''
            'Credits:'
            ''
            '- OnTopReplica original idea'
            '- DelphiUCL https://github.com/VuioVuio/DelphiUCL'
            
              '- VirtualDesktopManager https://github.com/Andriukhin/VirtualDes' +
              'ktopManager'
            '- EarTrumpet https://github.com/File-New-Project/EarTrumpet'
            '  (stripped unmanaged code DLL to handle audio sessions)'
            '')
          ParentFont = False
          ReadOnly = True
          ScrollBars = ssBoth
          TabOrder = 0
          Zoom = 100
          ExplicitWidth = 298
          ExplicitHeight = 198
        end
      end
      object Card2: TCard
        Left = 1
        Top = 1
        Width = 404
        Height = 284
        Caption = 'Card2'
        CardIndex = 1
        TabOrder = 1
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 185
        ExplicitHeight = 41
        object RichEdit2: TRichEdit
          Left = 0
          Top = 0
          Width = 404
          Height = 284
          Align = alClient
          BorderStyle = bsNone
          BorderWidth = 12
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Lines.Strings = (
            'Help <F1>:'
            '----------'
            ''
            
              'Window Cloner is a tool to clone other windows, this will copy i' +
              'ts content using'
            'Desktop Window Manager API.'
            ''
            'Features:'
            ''
            '- Follow mouse cursor'
            '- Clickthrough'
            '- Translucent'
            '- Audio detection to un/mute'
            ''
            ''
            ''
            ''
            '')
          ParentFont = False
          ReadOnly = True
          ScrollBars = ssBoth
          TabOrder = 0
          Zoom = 100
        end
      end
    end
  end
  object UPanel1: TUPanel
    Left = 0
    Top = 318
    Width = 519
    Height = 54
    Align = alBottom
    Caption = 'UPanel1'
    Color = 15132390
    TabOrder = 2
    CustomBackColor.Enabled = False
    CustomBackColor.Color = 15132390
    CustomBackColor.LightColor = 15132390
    CustomBackColor.DarkColor = 2039583
    ExplicitTop = 320
    ExplicitWidth = 556
    DesignSize = (
      519
      54)
    object UButton1: TUButton
      Left = 184
      Top = 14
      Width = 156
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = 'OK'
      OnClick = UButton1Click
      CustomBackColor.Enabled = False
      CustomBackColor.LightNone = 13421772
      CustomBackColor.LightHover = 13421772
      CustomBackColor.LightPress = 10066329
      CustomBackColor.LightSelectedNone = 13421772
      CustomBackColor.LightSelectedHover = 13421772
      CustomBackColor.LightSelectedPress = 10066329
      CustomBackColor.DarkNone = 3355443
      CustomBackColor.DarkHover = 3355443
      CustomBackColor.DarkPress = 6710886
      CustomBackColor.DarkSelectedNone = 3355443
      CustomBackColor.DarkSelectedHover = 3355443
      CustomBackColor.DarkSelectedPress = 6710886
      CustomBorderColor.Enabled = False
      CustomBorderColor.LightNone = 13421772
      CustomBorderColor.LightHover = 8026746
      CustomBorderColor.LightPress = 10066329
      CustomBorderColor.LightSelectedNone = 8026746
      CustomBorderColor.LightSelectedHover = 8026746
      CustomBorderColor.LightSelectedPress = 10066329
      CustomBorderColor.DarkNone = 3355443
      CustomBorderColor.DarkHover = 8750469
      CustomBorderColor.DarkPress = 6710886
      CustomBorderColor.DarkSelectedNone = 8750469
      CustomBorderColor.DarkSelectedHover = 8750469
      CustomBorderColor.DarkSelectedPress = 6710886
      ExplicitWidth = 67
    end
  end
  object UPanel2: TUPanel
    Left = 0
    Top = 32
    Width = 113
    Height = 286
    Align = alLeft
    Color = 15132390
    TabOrder = 3
    CustomBackColor.Enabled = False
    CustomBackColor.Color = 15132390
    CustomBackColor.LightColor = 15132390
    CustomBackColor.DarkColor = 2039583
    ExplicitHeight = 231
    object UListButton2: TUListButton
      Left = 0
      Top = 245
      Width = 113
      Height = 41
      Align = alBottom
      Caption = '&About'
      TabOrder = 0
      OnClick = UListButton2Click
      IconFont.Charset = DEFAULT_CHARSET
      IconFont.Color = clWindowText
      IconFont.Height = -16
      IconFont.Name = 'Segoe MDL2 Assets'
      IconFont.Style = []
      CustomBackColor.Enabled = False
      CustomBackColor.LightNone = 15132390
      CustomBackColor.LightHover = 13619151
      CustomBackColor.LightPress = 12105912
      CustomBackColor.LightSelectedNone = 127
      CustomBackColor.LightSelectedHover = 103
      CustomBackColor.LightSelectedPress = 89
      CustomBackColor.DarkNone = 2039583
      CustomBackColor.DarkHover = 3487029
      CustomBackColor.DarkPress = 5000268
      CustomBackColor.DarkSelectedNone = 89
      CustomBackColor.DarkSelectedHover = 103
      CustomBackColor.DarkSelectedPress = 127
      FontIcon = #59267
      Detail = ''
      ExplicitLeft = -6
      ExplicitTop = 184
      ExplicitWidth = 185
    end
    object UListButton1: TUListButton
      Left = 0
      Top = 0
      Width = 113
      Height = 41
      Align = alTop
      Caption = 'Help'
      TabOrder = 1
      OnClick = UListButton1Click
      IconFont.Charset = DEFAULT_CHARSET
      IconFont.Color = clWindowText
      IconFont.Height = -16
      IconFont.Name = 'Segoe MDL2 Assets'
      IconFont.Style = []
      CustomBackColor.Enabled = False
      CustomBackColor.LightNone = 15132390
      CustomBackColor.LightHover = 13619151
      CustomBackColor.LightPress = 12105912
      CustomBackColor.LightSelectedNone = 127
      CustomBackColor.LightSelectedHover = 103
      CustomBackColor.LightSelectedPress = 89
      CustomBackColor.DarkNone = 2039583
      CustomBackColor.DarkHover = 3487029
      CustomBackColor.DarkPress = 5000268
      CustomBackColor.DarkSelectedNone = 89
      CustomBackColor.DarkSelectedHover = 103
      CustomBackColor.DarkSelectedPress = 127
      FontIcon = #59705
      Detail = ''
      ExplicitLeft = -5
      ExplicitTop = 6
    end
  end
  object ActionList1: TActionList
    Left = 88
    Top = 327
    object actCloseAbout: TAction
      Caption = 'actCloseAbout'
      ShortCut = 27
      OnExecute = actCloseAboutExecute
    end
  end
end
