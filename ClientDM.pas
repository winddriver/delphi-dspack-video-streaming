unit ClientDM;

interface

uses
  Windows, SysUtils, Classes, ExtCtrls, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient,
  VideoCoDec, CommonU;

type
  TdmClient = class(TDataModule)
    TCPClient: TIdTCPClient;
    tmrDisplay: TTimer;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure TCPClientConnected(Sender: TObject);
    procedure TCPClientDisconnected(Sender: TObject);
  private
    VideoCoDec: TVideoCoDec;
    FFrames, FKeyFrames: Cardinal;
    procedure UpdateVideoFormat(InputFormat: TBitmapInfoHeader);
  end;

var
  dmClient: TdmClient;

implementation

uses SettingsU, DisplayU;

{$R *.dfm}

procedure TdmClient.DataModuleCreate(Sender: TObject);
begin
  VideoCoDec := TVideoCoDec.Create;
end;

procedure TdmClient.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(VideoCoDec);
end;

procedure TdmClient.TCPClientConnected(Sender: TObject);
var
  bmih: TBitmapInfoHeader;
  CH: TCommHeader;
begin
  FFrames := 0;
  FKeyFrames := 0;
  SettingsF.btnConnect.Enabled := False;
  SettingsF.btnDisconnect.Enabled := True;
  ZeroMemory(@CH, SizeOf(CH));
  CH.DPType := 1;  // request for frame format
  TCPClient.WriteBuffer(CH, SizeOf(CH), True);
  TCPClient.ReadBuffer(CH, SizeOf(CH));
  if CH.DPType <> 1 then
    Exit;  // not the right packet
  if CH.DPSize <> SizeOf(bmih) then
    Exit;  // not what we expected
  // Read the format
  TCPClient.ReadBuffer(bmih, SizeOf(bmih));
  // Update the format
  UpdateVideoFormat(bmih);
  tmrDisplay.Interval := 1000 div CH.DPExtra;
  tmrDisplay.Enabled := True;

  DisplayF.lbClientSt.Caption := 'CONNECTED';
end;

procedure TdmClient.TCPClientDisconnected(Sender: TObject);
begin
  tmrDisplay.Enabled := False;
  SettingsF.btnConnect.Enabled := True;
  SettingsF.btnDisconnect.Enabled := False;

  DisplayF.lbClientSt.Caption := 'DISCONNECTED';
end;

end.
