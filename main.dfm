object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 201
  ClientWidth = 447
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDblClick = FormDblClick
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
end
