object Form1: TForm1
  Left = 192
  Top = 114
  BorderStyle = bsSingle
  Caption = '::Kabooom Bot ::'
  ClientHeight = 246
  ClientWidth = 478
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Edit1: TEdit
    Left = 8
    Top = 217
    Width = 462
    Height = 21
    TabOrder = 0
    Text = 'Edit1'
    OnKeyDown = Edit1KeyDown
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 462
    Height = 203
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
  object cs: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnConnect = csConnect
    OnDisconnect = csDisconnect
    OnRead = csRead
    OnError = csError
    Left = 8
    Top = 408
  end
  object Timer1: TTimer
    Enabled = False
    Left = 48
    Top = 408
  end
end
