unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UCL.Form, Vcl.ExtCtrls;

type
  TForm1 = class(TUForm)
    Timer1: TTimer;
    procedure FormDblClick(Sender: TObject);
  private
    { Private declarations }
    fFullScreenState: Boolean;
    fPrevRect: TRect;
    fPrevStyle: TBorderStyle;
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

procedure TForm1.FormDblClick(Sender: TObject);
begin
  FullScreen := not FullScreen;
end;

procedure TForm1.SetFullScreen(Enabled: Boolean);
begin
  if Enabled then
  begin
    fFullScreenState := Enabled;
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
  end
  else
  begin
    fFullScreenState := Enabled;
    Left := fPrevRect.Left;
    Top := fPrevRect.Top;
    ClientWidth := fPrevRect.Width;
    ClientHeight := fPrevRect.Height;
    BorderStyle := fPrevStyle;
  end;
end;

end.
