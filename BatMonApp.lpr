program BatMonApp;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, runtimetypeinfocontrols, BatMonWindow
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Title:='Battery Monitor';
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TBatMonForm, BatMonForm);
  Application.Run;
end.

