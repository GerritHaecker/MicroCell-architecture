﻿unit OurPlant.Sample1.Main;

interface

uses Winapi.Windows, System.Classes, Vcl.Forms, Vcl.ComCtrls, Vcl.Menus,
  Vcl.Controls, Vcl.StdCtrls;

type
  TSDIAppForm = class(TForm)
    StatusBar: TStatusBar;
    MainMenu: TMainMenu;
    Label1: TLabel;
    lbl1: TLabel;
    miDatei: TMenuItem;
    miEnde: TMenuItem;
    miNeu: TMenuItem;
    N1: TMenuItem;
    eName: TEdit;
    lLongName: TLabel;
    Label3: TLabel;
    lTypeName: TLabel;
    Label2: TLabel;
    eString: TEdit;
    procedure miEndeClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

implementation

{$R *.dfm}

procedure TSDIAppForm.miEndeClick(Sender: TObject);
begin
  Close;
end;

end.
