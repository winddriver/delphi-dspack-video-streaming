object SettingsF: TSettingsF
  Left = 292
  Top = 377
  Width = 500
  Height = 220
  Caption = 'Settings'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    492
    182)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 34
    Height = 13
    Caption = 'Device'
  end
  object Label2: TLabel
    Left = 8
    Top = 56
    Width = 32
    Height = 13
    Caption = 'Format'
  end
  object Label3: TLabel
    Left = 8
    Top = 104
    Width = 31
    Height = 13
    Caption = 'Codec'
  end
  object cbxCameras: TComboBox
    Left = 8
    Top = 24
    Width = 476
    Height = 21
    BevelKind = bkFlat
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 0
    OnChange = cbxCamerasChange
  end
  object cbxFormats: TComboBox
    Left = 8
    Top = 72
    Width = 476
    Height = 21
    BevelKind = bkFlat
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 1
  end
  object btnOK: TButton
    Left = 8
    Top = 152
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'OK'
    Default = True
    TabOrder = 2
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 96
    Top = 152
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = btnCancelClick
  end
  object btnApply: TButton
    Left = 184
    Top = 152
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Apply'
    TabOrder = 4
    OnClick = btnApplyClick
  end
  object cbxCodecs: TComboBox
    Left = 8
    Top = 120
    Width = 476
    Height = 21
    BevelKind = bkFlat
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 5
  end
end
