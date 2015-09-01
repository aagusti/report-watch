program reportwatch;

uses
  Forms,
  ReportFrm in 'FastReport\ReportFrm.pas' {frmFastReport},
  DirWatch in '..\..\..\master\delphi\DirWatch.pas',
  prtmodule in '..\..\test_report\source\prtmodule.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmFastReport, frmFastReport);
  Application.Run;
end.
