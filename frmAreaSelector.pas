unit frmAreaSelector;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ToolWin,
  System.ImageList, Vcl.ImgList, Vcl.ExtCtrls;

type
  TformAreaSelector = class(TForm)
    ImageList1: TImageList;
    Shape1: TShape;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formAreaSelector: TformAreaSelector;
  fPrevClip: TRect;
  fMouseIsDown: Boolean = False;

implementation

{$R *.dfm}

uses main;

procedure TformAreaSelector.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  ClipCursor(@fPrevClip);
end;

procedure TformAreaSelector.FormCreate(Sender: TObject);
begin
  BorderStyle := bsNone;
  Color := clWhite;
  AlphaBlend := True;
  AlphaBlendValue := 150;
  KeyPreview := True;
  TransparentColor := True;
  TransparentColorValue := clFuchsia;
  DoubleBuffered := True;

  GetClipCursor(fPrevClip);
end;

procedure TformAreaSelector.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close
end;

procedure TformAreaSelector.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  R: TRect;
begin
  if Button = mbLeft then
  begin
    R := BoundsRect;
    ClipCursor(@R);
    Shape1.Left := X;
    Shape1.Top := Y;
    fMouseIsDown := True;
  end;
end;

procedure TformAreaSelector.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if fMouseIsDown then
  begin
    Shape1.Width := X - Shape1.Left;
    Shape1.Height := Y - Shape1.Top;
  end;
end;

procedure TformAreaSelector.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    fMouseIsDown := False;
    ClipCursor(@fPrevClip);
  end;

end;

end.
