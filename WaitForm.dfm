object Waiting: TWaiting
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Waiting'
  ClientHeight = 94
  ClientWidth = 686
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 18
  object WaitTitle: TcxLabel
    Left = 0
    Top = 0
    Align = alTop
    Properties.Alignment.Horz = taCenter
    Properties.Alignment.Vert = taVCenter
    Transparent = True
    AnchorX = 343
    AnchorY = 11
  end
  object aiProgress: TdxActivityIndicator
    Left = 0
    Top = 22
    Width = 686
    Height = 50
    Align = alClient
    PropertiesClassName = 'TdxActivityIndicatorHorizontalDotsProperties'
    Properties.AnimationTime = 500
    Transparent = True
  end
  object WaitMessage: TcxLabel
    Left = 0
    Top = 72
    Align = alBottom
    Properties.Alignment.Horz = taCenter
    Properties.Alignment.Vert = taVCenter
    Transparent = True
    AnchorX = 343
    AnchorY = 83
  end
end
