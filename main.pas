unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UCL.Form, Vcl.ExtCtrls;

type
  TForm1 = class(TUForm)
    tmrFSMouse: TTimer;
    procedure FormDblClick(Sender: TObject);
    procedure tmrFSMouseTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    fFullScreenState: Boolean;
    fPrevRect: TRect;
    fPrevStyle: TBorderStyle;
    fPrevFSCursor: TPoint;
    procedure SetFullScreen(Enabled: Boolean);
  public
    { Public declarations }
  published
    property FullScreen: Boolean read fFullScreenState write SetFullScreen;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  tmrFSMouse.Enabled := False;
end;

procedure TForm1.FormDblClick(Sender: TObject);
begin
  FullScreen := not FullScreen;
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if FullScreen and (fPrevFSCursor <> Mouse.CursorPos) then
    ShowCursor(True);
end;

procedure TForm1.SetFullScreen(Enabled: Boolean);
begin
  fFullScreenState := Enabled;
  if Enabled then
  begin
    fPrevRect.Top := Top;
    fPrevRect.Left := Left;
    fPrevRect.Width := Width;
    fPrevRect.Height := Height;
    Left := Screen.Monitors[0].Left;
    Top := Screen.Monitors[0].Top;
    ClientWidth := Screen.Monitors[0].Width;
    ClientHeight := Screen.Monitors[0].Height;
    fPrevStyle := BorderStyle;
    BorderStyle := bsNone;
    tmrFSMouse.Enabled := True;
  end
  else
  begin
    Left := fPrevRect.Left;
    Top := fPrevRect.Top;
    ClientWidth := fPrevRect.Width;
    ClientHeight := fPrevRect.Height;
    BorderStyle := fPrevStyle;
    tmrFSMouse.Enabled := False;
    ShowCursor(True);
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

end.
