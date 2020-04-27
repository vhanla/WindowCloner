unit TUPopupMenu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UCL.Form, UCL.ThemeManager,
  Vcl.Menus, Vcl.StdCtrls, UCL.ScrollBox, Vcl.ExtCtrls, UCL.ListButton, UCL.Colors;

type
  TPopupMode = (pmStandard, pmCustom);
  TPopupMenu = class (Vcl.Menus.TPopupMenu)
  private
    FPopupForm: TUForm;
    FPopupMode: TPopupMode;
    FPopupCount: Integer;
    FMonitor: TMonitor;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Popup(X,Y: Integer); override;
    property PopupForm: TUForm read FPopupForm write FPopupForm;
    property PopupMode: TPopupMode read FPopupMode write FPopupMode;
    property PopupCount: Integer read FPopupCount write FPopupCount;
  end;

type
//  TMenuItem = class(Vcl.Menus.TMenuItem)
//  end;
  TPopupForm = class(TUForm)
    UScrollBox1: TUScrollBox;
  private
    { Private declarations }
    FPopupForm: TUForm;
    FPopupMenu: TPopupMenu;
    FPopupCount: Integer;
    procedure WMActivate(var AMessage: TWMActivate); message WM_ACTIVATE;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; APopupForm: TUForm;
      APopupMenu: TPopupMenu; APopupCount: Integer); reintroduce;
  end;

var
  PopupForm: TPopupForm;

implementation

{$R *.dfm}

{ TPopupMenu }

constructor TPopupMenu.Create(AOwner: TComponent);
begin
  Inherited;
  FPopupMode := pmStandard;
  FPopupCount := 5;
end;

procedure TPopupMenu.Popup(X, Y: Integer);
var
  I: Integer;
  AForm: TPopupForm;
  AItem: TUListButton;
begin
  case FPopupMode of
    pmCustom:
    begin
      AForm := TPopupForm.Create(nil, FPopupForm, Self, FPopupCount);
      with AForm do
      begin
        FMonitor := Screen.MonitorFromWindow(GetParentHandle);
        Top := Y;
        Left := X;
        Width := 180;
        Height := 200;
        if FMonitor.Top > Top then
          Top := FMonitor.Top;
        if FMonitor.Left > Left then
          Left := FMonitor.Left;
        if FMonitor.BoundsRect.Bottom < (Top+Height) then
          Top := FMonitor.BoundsRect.Bottom - Height;
        if FMonitor.BoundsRect.Right < (Left+Width) then
          Left := FMonitor.BoundsRect.Right - Width;
        BorderIcons := [];
        DoubleBuffered := True;
        FormStyle := fsStayOnTop;
        BorderStyle := bsDialog;
        ThemeManager.ThemeType := ttDark;
        Show;

        for I := Items.Count - 1 downto 0 do
        begin
          AItem := TUListButton.Create(nil);
          with AItem do
          begin
            Align := alTop;
            Detail := '';
            ImageIndex := I;
            FontIcon := '';
            Caption := Items[I].Caption;
            Parent := AForm.UScrollBox1;
          end;
        end;
      end;
    end;
    pmStandard: inherited;
  end;
end;

{ TPopupForm }

constructor TPopupForm.Create(AOwner: TComponent; APopupForm: TUForm;
  APopupMenu: TPopupMenu; APopupCount: Integer);
begin
  inherited Create(AOwner);

  FPopupForm := APopupForm;
  FPopupMenu := APopupMenu;
  FPopupCount := APopupCount;


end;

procedure TPopupForm.WMActivate(var AMessage: TWMActivate);
begin
  SendMessage(FPopupForm.Handle, WM_NCACTIVATE, 1, 0);
  Inherited;
  if AMessage.Active = WA_INACTIVE then
    Release;
end;

end.
