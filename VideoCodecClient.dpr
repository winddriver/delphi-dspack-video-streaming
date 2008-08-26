program VideoCodecClient;

uses
  Forms,
  ClientU in 'ClientU.pas' {ClientF};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TClientF, ClientF);
  Application.Run;
end.
