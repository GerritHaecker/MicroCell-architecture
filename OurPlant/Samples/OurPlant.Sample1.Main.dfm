object SDIAppForm: TSDIAppForm
  Left = 197
  Top = 111
  AlphaBlend = True
  Caption = 'SDI-Anwendung'
  ClientHeight = 482
  ClientWidth = 824
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 24
    Top = 11
    Width = 56
    Height = 23
    Caption = 'Name:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbl1: TLabel
    Left = 24
    Top = 56
    Width = 74
    Height = 16
    Caption = 'LongName:'
  end
  object lLongName: TLabel
    Left = 120
    Top = 56
    Width = 74
    Height = 16
    Caption = 'lLongName'
  end
  object Label3: TLabel
    Left = 24
    Top = 152
    Width = 70
    Height = 16
    Caption = 'Typ Name:'
  end
  object lTypeName: TLabel
    Left = 120
    Top = 152
    Width = 74
    Height = 16
    Caption = 'lTypeName'
  end
  object Label2: TLabel
    Left = 24
    Top = 96
    Width = 35
    Height = 16
    Caption = 'Wert:'
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 463
    Width = 824
    Height = 19
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    AutoHint = True
    Panels = <>
    SimplePanel = True
  end
  object eName: TEdit
    Left = 120
    Top = 8
    Width = 265
    Height = 31
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    Text = 'cell name'
  end
  object eString: TEdit
    Left = 120
    Top = 93
    Width = 673
    Height = 24
    TabOrder = 2
    Text = 'eString'
  end
  object MainMenu: TMainMenu
    Left = 424
    Top = 8
    object miDatei: TMenuItem
      Caption = 'Datei'
      object miNeu: TMenuItem
        Caption = 'Neu'
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object miEnde: TMenuItem
        Caption = 'Ende'
        OnClick = miEndeClick
      end
    end
  end
end
