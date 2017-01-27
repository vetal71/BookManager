unit Form.BaseForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dxSkinsCore, dxSkinMetropolis,
  cxClasses, cxLookAndFeels, dxSkinsForm, System.ImageList, Vcl.ImgList,
  cxGraphics;

type
  TfrmBase = class(TForm)
    sknMain: TdxSkinController;
    ilSmall: TcxImageList;
    ilEdit: TcxImageList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBase: TfrmBase;

implementation

{$R *.dfm}

end.
