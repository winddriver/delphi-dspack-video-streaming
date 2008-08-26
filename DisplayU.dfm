object DisplayF: TDisplayF
  Left = 663
  Top = 516
  Width = 328
  Height = 267
  Caption = 'VideoCoDec Demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object VideoWindow: TVideoWindow
    Left = 0
    Top = 0
    Width = 320
    Height = 229
    FilterGraph = dmMain.fgMain
    VMROptions.Mode = vmrWindowed
    VMROptions.Streams = 1
    VMROptions.Preferences = []
    Color = clBlack
    Align = alClient
    OnDblClick = VideoWindowDblClick
  end
end
