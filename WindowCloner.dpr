program WindowCloner;

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Vcl.Forms,
  main in 'main.pas' {Form1},
  TUPopupMenu in 'TUPopupMenu.pas' {PopupForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TPopupForm, PopupForm);
  //  Application.CreateForm(TPopupForm, PopupForm);
  Application.Run;
end.
