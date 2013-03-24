object Form7: TForm7
  Left = 0
  Top = 0
  Caption = 'Form7'
  ClientHeight = 449
  ClientWidth = 969
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 408
    Width = 969
    Height = 41
    Align = alBottom
    TabOrder = 0
    object Button1: TButton
      Left = 16
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Simple Select'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 97
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Full Select'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 208
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Simple Update'
      TabOrder = 2
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 289
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Full Update'
      TabOrder = 3
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 424
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Simple Insert'
      TabOrder = 4
      OnClick = Button5Click
    end
    object Button6: TButton
      Left = 505
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Full Insert'
      TabOrder = 5
    end
    object Button7: TButton
      Left = 640
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Simple Delete'
      TabOrder = 6
      OnClick = Button7Click
    end
    object Button8: TButton
      Left = 721
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Full Delete'
      TabOrder = 7
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 820
    Height = 408
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'Consolas'
    Font.Style = []
    Lines.Strings = (
      'Memo1')
    ParentFont = False
    TabOrder = 1
  end
  object Panel2: TPanel
    Left = 820
    Top = 0
    Width = 149
    Height = 408
    Align = alRight
    Caption = 'Panel2'
    TabOrder = 2
  end
end
