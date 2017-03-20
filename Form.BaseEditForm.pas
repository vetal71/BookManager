unit Form.BaseEditForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Form.BaseForm, dxSkinsCore,
  dxSkinMetropolis, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  Vcl.Menus, Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls, cxClasses, dxSkinsForm,
  System.ImageList, Vcl.ImgList;

type
  TfrmBaseEditor = class(TfrmBase)
    pnlButton: TPanel;
    btnOK: TcxButton;
    btnCancel: TcxButton;
    pnlHeader: TPanel;
    pnlEditor: TPanel;
    bvlTop: TBevel;
    bvlBottom: TBevel;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TfrmBaseEditor.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmBaseEditor.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfrmBaseEditor.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = 13) and (ssCtrl in Shift) then
    btnOKClick(nil);
  if (Key = 27) then
    btnCancelClick(nil);
end;

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
