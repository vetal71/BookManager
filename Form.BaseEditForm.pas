unit Form.BaseEditForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Form.BaseForm, dxSkinsCore,
  dxSkinMetropolis, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  Vcl.Menus, Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls, cxClasses, dxSkinsForm;

type
  TfrmBaseEditor = class(TfrmBase)
    pnlButton: TPanel;
    btnOK: TcxButton;
    btnCancel: TcxButton;
    pnlHeader: TPanel;
    pnlEditor: TPanel;
    bvlTop: TBevel;
    bvlBottom: TBevel;
  private
    FHeader: string;
  private
    function GetHeader: string;
    procedure SetHeader(const Value: string);
  public
    property Header : string read GetHeader write SetHeader;
  end;

var
  frmBaseEditor: TfrmBaseEditor;

implementation

{$R *.dfm}

{ TfrmBaseEditor }

function TfrmBaseEditor.GetHeader: string;
begin
  Result := FHeader;
end;

procedure TfrmBaseEditor.SetHeader(const Value: string);
begin
  if FHeader <> Value then begin
    FHeader := Value;
    pnlHeader.Caption := FHeader;
  end;
end;

end.
