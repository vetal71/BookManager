unit TestObservers;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, contnrs;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  end;
//----------------------------------------------------
TObserver = class;
TObservable = class
  private
    FObservers: TObjectList;
  public
    procedure RegisterObserver (AObserver: TObserver);
    procedure UnregisterObserver(AObserver: TObserver);
    procedure object_is_changed;
    constructor create;
    destructor destroy;
end;

TObserver = class
  private
    FObservable: TObservable;
  public
    procedure action; // метод слушателя вызываемый субъектом после того как состояние изменилось
    constructor Create(AObservable: TObservable);
    destructor Destroy;
end;

TClassA = class  //класс субъект
  observable: TObservable; // делегируем
  procedure change_state;
  constructor create;
  destructor destroy;
end;

type
  TClassB = class (TObserver) //класс слушатель (наследник)
end;

var
  Form1: TForm1;

implementation {$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  objA: TClassA;objB, objB2: TClassB;
begin
  objA:=TClassA.Create;  //Субъект
  objB:=TClassB.Create(objA.observable);  //Слушатель 1
  objB2:=TClassB.Create(objA.observable);  //Слушатель 2

  objA.change_state;   // изменение состояние объекта

  objB2.Destroy;  //исключение возникает здесь
  objB.Destroy;   //быть может и здесь
  objA.Destroy;
end;

{ TObservable }

constructor TObservable.create;
begin
  FObservers:=TObjectList.Create;
end;

destructor TObservable.destroy;
begin
  FObservers.Destroy;
end;

procedure TObservable.object_is_changed;
var
  i: Integer;
begin
  for i:=0 to FObservers.Count-1 do TObserver(FObservers[i]).action; //вызываем методы слушателей
end;

procedure TObservable.RegisterObserver (AObserver: TObserver);
begin
  FObservers.Add(AObserver);
end;

procedure TObservable.UnregisterObserver(AObserver: TObserver);
begin
  FObservers.Remove(AObserver);
end;

{ TObserver }

constructor TObserver.Create(AObservable: TObservable);
begin
  inherited Create;
  AObservable.RegisterObserver(Self);
  FObservable := AObservable;
end;

destructor TObserver.Destroy;
begin
  FObservable.UnregisterObserver(Self);
end;

procedure TObserver.action;
begin
  Form1.Caption:= Form1.Caption + '+'; // каждый слушатель добавит к заголовку окна '+'
end;

{ TClassA }

procedure TClassA.change_state;
begin
  observable.object_is_changed; //вызываем метод чтобы оповестить слушателей
end;

constructor TClassA.create;
begin
  observable:=TObservable.create;
end;

destructor TClassA.destroy;
begin
  observable.destroy;
end;

end.
