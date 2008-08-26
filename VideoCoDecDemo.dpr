program VideoCoDecDemo;

{%File 'Defines.inc'}

uses
  Forms,
  SysUtils,
  Windows,
  VideoCoDec in 'VideoCoDec.pas',
  AviFileHandler in 'AviFileHandler.pas',
  dmMainU in 'dmMainU.pas' {dmMain: TDataModule},
  DisplayU in 'DisplayU.pas' {DisplayF},
  SettingsU in 'SettingsU.pas' {SettingsF},
  CommonU in 'CommonU.pas';

{$R *.res}


begin
  with Application do
  begin
    Initialize;
    CreateForm(TdmMain, dmMain);
    CreateForm(TDisplayF, DisplayF);
    CreateForm(TSettingsF, SettingsF);
    Run;
  end;
end.

