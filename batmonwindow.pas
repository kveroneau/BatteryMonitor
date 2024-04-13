unit BatMonWindow;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, process, dbf, DB, Forms, Controls, Graphics, Dialogs,
  StdCtrls, DBGrids, ExtCtrls, RTTICtrls, StrUtils, DateUtils;

type

  { TBatMonForm }

  TBatMonForm = class(TForm)
    ACPIProc: TProcess;
    BatteryDB: TDbf;
    BatteryDS: TDataSource;
    RecordBtn: TButton;
    DBGrid1: TDBGrid;
    TimerEnable: TTICheckBox;
    Timer1: TTimer;
    TrayIcon1: TTrayIcon;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure RecordBtnClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
  private
    procedure ParseACPI(out BatLevel: integer; out Status: string);
  public

  end;

var
  BatMonForm: TBatMonForm;

implementation

{$R *.lfm}

{ TBatMonForm }

procedure TBatMonForm.FormCreate(Sender: TObject);
begin
  DBGrid1.Top:=0;
  DBGrid1.Left:=0;
end;

procedure TBatMonForm.FormResize(Sender: TObject);
begin
  DBGrid1.Width:=ClientWidth;
  DBGrid1.Height:=ClientHeight-RecordBtn.Height-2;
  RecordBtn.Top:=DBGrid1.Height+2;
  TimerEnable.Top:=DBGrid1.Height+2;
end;

procedure TBatMonForm.RecordBtnClick(Sender: TObject);
var
  blevel: integer;
  status: string;
begin
  ParseACPI(blevel, status);
  TrayIcon1.Hint:='Battery: '+IntToStr(blevel)+'%, '+status;
  BatteryDB.Append;
  BatteryDB.FieldValues['WHEN']:=Now;
  BatteryDB.FieldValues['PERCENT']:=blevel;
  BatteryDB.FieldValues['STATUS']:=status;
  BatteryDB.Post;
end;

procedure TBatMonForm.Timer1Timer(Sender: TObject);
begin
  RecordBtnClick(Nil);
end;

procedure TBatMonForm.TrayIcon1Click(Sender: TObject);
begin
  if Visible then
    Hide
  else
    Show;
end;

procedure TBatMonForm.ParseACPI(out BatLevel: integer; out Status: string);
var
  s, tmp: string;
begin
  ACPIProc.Active:=True;
  repeat
    Sleep(100);
  until not ACPIProc.Running;
  SetLength(s, ACPIProc.Output.NumBytesAvailable);
  ACPIProc.Output.Read(s[1], ACPIProc.Output.NumBytesAvailable);
  ACPIProc.Active:=False;
  tmp:=Copy2SymbDel(s, ':');
  tmp:=Copy2SymbDel(s, ',');
  BatLevel:=StrToInt(Copy2SymbDel(s, '%'));
  Status:=RightStr(s, Length(s)-2);
end;

end.

