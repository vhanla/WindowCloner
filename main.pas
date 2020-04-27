unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UCL.Form, Vcl.ExtCtrls, UCL.ThemeManager, TUPopupMenu,
  Vcl.Menus, UCL.PopupMenu, System.ImageList, Vcl.ImgList;

type
  TForm1 = class(TUForm)
    tmrFSMouse: TTimer;
    TrayIcon1: TTrayIcon;
    PopupMenu1: TPopupMenu;
    Windows1: TMenuItem;
    Exit1: TMenuItem;
    SelectRegion1: TMenuItem;
    ClickThrough1: TMenuItem;
    Opacity1: TMenuItem;
    Fullscreen1: TMenuItem;
    Settings1: TMenuItem;
    N1: TMenuItem;
    About1: TMenuItem;
    Exit2: TMenuItem;
    N1001: TMenuItem;
    N901: TMenuItem;
    N801: TMenuItem;
    N701: TMenuItem;
    N601: TMenuItem;
    N501: TMenuItem;
    N401: TMenuItem;
    N301: TMenuItem;
    N201: TMenuItem;
    N101: TMenuItem;
    none1: TMenuItem;
    ImageList1: TImageList;
    procedure FormDblClick(Sender: TObject);
    procedure tmrFSMouseTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Exit2Click(Sender: TObject);
  private
    { Private declarations }
    fFullScreenState: Boolean;
    fPrevRect: TRect;
    fPrevStyle: TBorderStyle;
    fPrevFSCursor: TPoint;
    fPopupMenu: TUPopupMenu.TPopupMenu;
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

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Close
end;

procedure TForm1.Exit2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  I: Integer;
  AItem: TMenuItem;
begin
  tmrFSMouse.Enabled := False;
  ThemeManager.ThemeType := TUThemeType.ttDark;

  BorderIcons := [];
  DoubleBuffered := True;
//  fPopupMenu := TUPopupMenu.TPopupMenu.Create(Self);
//  fPopupMenu.PopupMode := pmCustom;
//  fPopupMenu.PopupForm := Self;
//  fPopupMenu.Items.Clear;
//  for I := 0 to PopupMenu1.Items.Count - 1 do
//  begin
//    AItem := TMenuItem.Create(PopupMenu1.Items[I]);
//    AItem.Caption := PopupMenu1.Items[I].Caption;
//    fPopupMenu.Items.Add(AItem);
//  end;
//  PopupMenu := fPopupMenu;
  FormStyle := fsStayOnTop;
end;

procedure TForm1.FormDblClick(Sender: TObject);
begin
  FullScreen := not FullScreen;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  fPopupMenu.Free;
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if not FullScreen then
  begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, $F012, 0);
  end;
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