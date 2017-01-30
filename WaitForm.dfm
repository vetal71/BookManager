object Waiting: TWaiting
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Waiting'
  ClientHeight = 94
  ClientWidth = 367
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 18
  object WaitTitle: TcxLabel
    Left = 0
    Top = 0
    Align = alTop
    Caption = 'WaitTitle'
    Properties.Alignment.Horz = taCenter
    Properties.Alignment.Vert = taVCenter
    AnchorX = 184
    AnchorY = 11
  end
  object aiProgress: TdxActivityIndicator
    Left = 0
    Top = 22
    Width = 367
    Height = 50
    Align = alClient
    PropertiesClassName = 'TdxActivityIndicatorHorizontalDotsProperties'
    Transparent = True
  end
  object WaitMessage: TcxLabel
    Left = 0
    Top = 72
    Align = alBottom
    Caption = 'WaitMessage'
    Properties.Alignment.Horz = taCenter
    Properties.Alignment.Vert = taVCenter
    AnchorX = 184
    AnchorY = 83
  end
end
