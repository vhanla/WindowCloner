object formAreaSelector: TformAreaSelector
  Left = 0
  Top = 0
  Cursor = crCross
  AlphaBlendValue = 120
  Caption = 'Region Selector'
  ClientHeight = 201
  ClientWidth = 447
  Color = clWhite
  TransparentColorValue = clFuchsia
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  PixelsPerInch = 96
  TextHeight = 13
  object Shape1: TShape
    Left = 96
    Top = 8
    Width = 33
    Height = 33
    Brush.Color = clFuchsia
    Pen.Style = psDash
  end
  object ImageList1: TImageList
    Left = 216
    Top = 104
  end
end
