object Form1: TForm1
  Left = 234
  Top = 132
  Width = 450
  Height = 254
  Caption = 'Threaded Splashscreen Demo'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 17
  object StatusBar: TStatusBar
    Left = 0
    Top = 196
    Width = 442
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object Closebutton: TButton
    Left = 24
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 1
    OnClick = ClosebuttonClick
  end
  object AboutButton: TButton
    Left = 24
    Top = 56
    Width = 75
    Height = 25
    Caption = 'About...'
    TabOrder = 2
    OnClick = AboutButtonClick
  end
end
