unit frmAboutForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UCL.Form, UCL.Classes, UCL.QuickButton,
  Vcl.ExtCtrls, UCL.CaptionBar, UCL.Panel, Vcl.StdCtrls, Vcl.ComCtrls,
  UCL.ScrollBox, UCL.Button, System.Actions, Vcl.ActnList, UCL.ListButton,
  Vcl.WinXPanels;

type
  TfrmAbout = class(TUForm)
    UCaptionBar1: TUCaptionBar;
    UQuickButton1: TUQuickButton;
    UButton1: TUButton;
    UScrollBox1: TUScrollBox;
    RichEdit1: TRichEdit;
    UPanel1: TUPanel;
    ActionList1: TActionList;
    actCloseAbout: TAction;
    UPanel2: TUPanel;
    UListButton1: TUListButton;
    UListButton2: TUListButton;
    CardPanel1: TCardPanel;
    Card1: TCard;
    Card2: TCard;
    RichEdit2: TRichEdit;
    procedure UButton1Click(Sender: TObject);
    procedure actCloseAboutExecute(Sender: TObject);
    procedure UListButton1Click(Sender: TObject);
    procedure UListButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.dfm}

procedure TfrmAbout.actCloseAboutExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmAbout.UButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmAbout.UListButton1Click(Sender: TObject);
begin
  CardPanel1.ActiveCard := Card2;
end;

procedure TfrmAbout.UListButton2Click(Sender: TObject);
begin
  CardPanel1.ActiveCard := Card1;
end;

end.
