unit SettingsU;

interface

{$I Defines.inc}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  DSPack, DSUtil, DirectShow9;

type
  TSettingsF = class(TForm)
    cbxCameras: TComboBox;
    Label1: TLabel;
    cbxFormats: TComboBox;
    Label2: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    btnApply: TButton;
    Label3: TLabel;
    cbxCodecs: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbxCamerasChange(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
  private
    DevEnum: TSysDevEnum;
    VideoMediaTypes: TEnumMediaType;
  end;

var
  SettingsF: TSettingsF;

implementation

uses
  dmMainU, DisplayU, ActiveX;

{$R *.dfm}

function PinListForMoniker(Moniker: IMoniker): TPinList;
var
  BF: TBaseFilter;
  IBF: IBaseFilter;
begin
  BF := TBaseFilter.Create;
  try
    BF.Moniker := Moniker;
    IBF := BF.CreateFilter;
    Result := TPinList.Create(IBF);
  finally
    IBF := nil;
    BF.Free;
  end;
end;

procedure TSettingsF.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  DevEnum := TSysDevEnum.Create(CLSID_VideoInputDeviceCategory);
  VideoMediaTypes := TEnumMediaType.Create;

  for I := 0 to DevEnum.CountFilters - 1 do
    cbxCameras.Items.Add(DevEnum.Filters[I].FriendlyName);

  dmMain.VideoCoDec.EnumCodecs(cbxCodecs.Items);
end;

procedure TSettingsF.FormDestroy(Sender: TObject);
begin
  FreeAndNil(DevEnum);
  FreeAndNil(VideoMediaTypes);
end;

procedure TSettingsF.cbxCamerasChange(Sender: TObject);
var
  PinList: TPinList;
  I: Integer;
begin
    if cbxCameras.ItemIndex < 0 then
      Exit;

    DevEnum.SelectGUIDCategory(CLSID_VideoInputDeviceCategory);
    PinList := PinListForMoniker(DevEnum.GetMoniker(cbxCameras.ItemIndex));
    try
      cbxFormats.Clear;
      VideoMediaTypes.Assign(PinList.First);
      for I := 0 to VideoMediaTypes.Count - 1 do
        cbxFormats.Items.Add(VideoMediaTypes.MediaDescription[I]);
    finally
       PinList.Free;
    end;
end;

procedure TSettingsF.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TSettingsF.btnOKClick(Sender: TObject);
begin
  btnApply.Click;
  Close;
end;

procedure TSettingsF.btnApplyClick(Sender: TObject);
var
  PinList: TPinList;
  ok: Boolean;
  bmih: TBitmapInfoHeader;
begin
  if (cbxCameras.ItemIndex > -1) and (cbxFormats.ItemIndex > -1) then
    with dmMain do begin
      if fgMain.Active then begin
        fgMain.Stop;
        fgMain.Active := False;
      end;

      dsfCam.BaseFilter.Moniker := DevEnum.GetMoniker(cbxCameras.ItemIndex);
      sgVideo.MediaType := VideoMediaTypes.Items[cbxFormats.ItemIndex];
      with VideoMediaTypes.Items[cbxFormats.ItemIndex].AMMediaType^ do
        case formattype.D1 of
          $05589F80: bmih := PVideoInfoHeader(pbFormat)^.bmiHeader;
          $F72A76A0: bmih := PVideoInfoHeader2(pbFormat)^.bmiHeader;
        end;

      if cbxCodecs.ItemIndex > -1 then
        bmih.biCompression := Cardinal(cbxCodecs.Items.Objects[cbxCodecs.ItemIndex]);
      UpdateVideoFormat(bmih);

      FrameHeight := bmih.biHeight;
      FrameWidth := bmih.biWidth;

      dsfCam.FilterGraph := fgMain;
      sgVideo.FilterGraph := fgMain;
      fgMain.Active := True;

      //PinList:=PinListForMoniker(DevEnum.GetMoniker(cbxCameras.ItemIndex));  // Erro!!!
      PinList := TPinList.Create(dmMain.dsfCam as IBaseFilter);
      try
        with (PinList.First as IAMStreamConfig) do
          ok := Succeeded(SetFormat(VideoMediaTypes.Items[cbxFormats.ItemIndex].AMMediaType^));
        if not ok then begin
          MessageBox(0, 'aaaaaa', nil, 0);
          Exit;
        end;
      finally
        PinList.Free;
      end;

      // Now render streams
      with fgMain as ICaptureGraphBuilder2 do
        try
          // render the grabber - must be here to get rendered at all
          RenderStream(@PIN_CATEGORY_CAPTURE, nil, dsfCam as IBaseFilter, nil, sgVideo as IBaseFilter);

          // Connect Video preview (VideoWindow)
          if dsfCam.BaseFilter.DataLength > 0 then
            RenderStream(@PIN_CATEGORY_PREVIEW, nil, dsfCam as IBaseFilter,
              nil, DisplayF.VideoWindow as IBaseFilter);
        except
        end;

      fgMain.Play;
    end;
end;

end.
