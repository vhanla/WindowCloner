program WindowCloner;

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Vcl.Forms,
  main in 'main.pas' {Form1},
  TUPopupMenu in 'TUPopupMenu.pas' {PopupForm},
  frmAreaSelector in 'frmAreaSelector.pas' {formAreaSelector},
  VirtualDesktopManager in 'VirtualDesktopManager.pas',
  VirtualDesktopAPI in 'VirtualDesktopAPI.pas',
  frmAboutForm in 'frmAboutForm.pas' {frmAbout};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TPopupForm, PopupForm);
  Application.CreateForm(TformAreaSelector, formAreaSelector);
  Application.CreateForm(TfrmAbout, frmAbout);
  //  Application.CreateForm(TPopupForm, PopupForm);
  Application.Run;
end.
