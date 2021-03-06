unit Splash;

// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
// The Original Code is Splash.pas, released May 8, 2004.
//
// The Initial Developer of the Original Code is Alexandre Devilliers
// (elbereth@users.sourceforge.net, http://www.elberethzone.net).

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, main, Registry, lib_Utils, StdCtrls;
            
type
  TfrmSplash = class(TForm)
    TimerClose: TTimer;
    ImgSplash: TImage;
    lblLoading: TLabel;
    TimerFade: TTimer;
    imgBeta: TImage;
    imgRC: TImage;
    imgAlpha: TImage;
    imgWIP: TImage;
    procedure TimerCloseTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TimerFadeTimer(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmSplash: TfrmSplash;

implementation

uses SelectLanguage, lib_Language;

{$R *.dfm}
var
    IsLoaded : Boolean = False;

function CheckImportantFiles(): Boolean;
begin

//  CheckImportantFiles := FileExists(ExtractFilePath(Application.ExeName)+'data\default.dulk') and FileExists(ExtractFilePath(Application.ExeName)+'data\drivers\drv_default.dup5');
  CheckImportantFiles := FileExists(ExtractFilePath(Application.ExeName)+'data\default.dulk') and FileExists(ExtractFilePath(Application.ExeName)+'data\drivers\drv_giants.dup5');

end;

function CheckLanguage(): Boolean;
var Reg: TRegistry;
begin

  CheckLanguage := True;

  if ParamStr(1) = '/lng' then
  begin
    CheckLanguage := False;
  end
  else
  begin
    Reg := TRegistry.Create;
    Try
      Reg.RootKey := HKEY_CURRENT_USER;
      if Reg.OpenKey('\Software\Dragon Software\Dragon UnPACKer 5\StartUp',True) then
      begin
        CheckLanguage := Reg.ValueExists('Language');
        Reg.CloseKey;
      end;
    Finally
      FreeAndNil(Reg);
    end;
  end;

end;

function CheckByPass(): Boolean;
var Reg: TRegistry;
begin

  CheckByPass := False;

  if (ParamStr(1) = '/lng') or Not(CheckLanguage) or Not(CheckImportantFiles) then
  begin
    CheckByPass := False;
  end
  else
  begin
    Reg := TRegistry.Create;
    Try
      Reg.RootKey := HKEY_CURRENT_USER;
      if Reg.OpenKey('\Software\Dragon Software\Dragon UnPACKer 5\StartUp',True) then
      begin
        if Reg.ValueExists('NoSplash') then
          CheckByPass := Reg.ReadBool('NoSplash')
        else
          CheckByPass := false;
        Reg.CloseKey;
      end;
    Finally
      FreeAndNil(Reg);
    end;
  end;

end;


procedure TfrmSplash.TimerCloseTimer(Sender: TObject);
begin

  TimerClose.Enabled := False;
  if CheckOs then
    TimerFade.Enabled := True
  else
  begin
    Close;
    Free;
  end;

end;

procedure TfrmSplash.FormCreate(Sender: TObject);
begin

  if CheckOs then
  begin
    imgSplash.Picture.Bitmap.LoadFromResourceName(Hinstance,'DUP5W2K');
  end
  else
    imgSplash.Picture.Bitmap.LoadFromResourceName(Hinstance,'DUP5W9X');

end;

procedure TfrmSplash.TimerFadeTimer(Sender: TObject);
begin

  if AlphaBlendValue >= 10 then
    AlphaBlendValue := AlphaBlendValue - 10
  else
  begin
    TimerFade.Enabled := False;
    Close;
    Free;
  end;

end;

end.
