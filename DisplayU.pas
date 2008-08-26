unit DisplayU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  DSPack, CommonU;

type
  TDisplayF = class(TForm)
    VideoWindow: TVideoWindow;
    procedure VideoWindowDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  end;

var
  DisplayF: TDisplayF;

implementation

uses
  dmMainU, SettingsU;

{$R *.dfm}

procedure TDisplayF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  with dmMain.fgMain do
    if Active then begin
      Stop;
      Active := false;
    end;
end;

procedure TDisplayF.VideoWindowDblClick(Sender: TObject);
begin
  SettingsF.Show;
end;

procedure TDisplayF.FormCreate(Sender: TObject);
begin
  Left := 0;
  Top := 0;
end;

end.
