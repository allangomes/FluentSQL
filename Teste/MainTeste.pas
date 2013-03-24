{*******************************************************}
{                                                       }
{       FluentSQL                                       }
{                                                       }
{       Copyright (C) 2013 Allan Gomes                  }
{                                                       }
{*******************************************************}

unit MainTeste;

interface

uses
  Forms, Classes, StdCtrls, Controls, ExtCtrls;

type
  TForm7 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Memo1: TMemo;
    Panel2: TPanel;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form7: TForm7;

implementation

{$R *.dfm}

uses FluentSQL, Dialogs, DateUtils, FluentSQLTypes;

procedure TForm7.Button1Click(Sender: TObject);
begin
  Memo1.Text := TSQL.Select('CLIENTE.ID, CLIENTE.NOME, CLIENTE.CIDADE_ID, CIDADE.NOME')
                    .From('CLIENTE')
                    .Inner('CIDADE', 'CID')
                    .Where
                        .Eq('CLIENTE.CARGO', 'DESENVOLVEDOR')
                        .Eq('CLIENTE.IDADE', 21)
                        .Eq('CLIENTE.SALARIO', 3200)
                        .Eq('CLIENTE.DATANASC', EncodeDateTime(1992, 03, 01, 09, 0, 0, 0))
                        .Inn('CLIENTE.ID', [1,2,3,4])
                    .Order('CLIENTE.NOME')
                    .ToSQL;
end;

procedure TForm7.Button2Click(Sender: TObject);
begin
  Memo1.Text := TSQL.Select('CLIENTE.ID, CLIENTE.NOME, CLIENTE.CIDADE_ID, CIDADE.NOME')
                    .From('CLIENTE')
                    .Left('CIDADE')
                    .Where
                        .BeginIF(False)
                          .Eq('CLIENTE.CARGO', 'DESENVOLVEDOR') //Não Add
                        .ElseIF(True)
                          .Inn('CLIENTE.ID', 'SELECT ID FROM CLIENTE_EM_ATRASO')
                          .Between('CLIENTE.IDADE', 18, 65)
                          .IfThen(True).Eq('CLIENTE.CIDADE_ID')
                        .EndIF
                    .Group('CLIENTE.ID, CLIENTE.NOME, CLIENTE.CIDADE_ID, CIDADE.NOME')
                    .Order('CIDADE.NOME')
                    .ToSQL;
end;

procedure TForm7.Button3Click(Sender: TObject);
begin
  Memo1.Text := TSQL.Update('CLIENTE')
                      .Value('NOME', 'Allan Maia Gomes')
                      .Value('IDADE', 21)
                      .Value('DATANASC', EncodeDateTime(1992, 03, 01, 0, 0, 0, 0))
                      .Value('SALARIO', 3500)
                    .Where
                      .Eq('ID', 17).ToSQL;
end;

procedure TForm7.Button4Click(Sender: TObject);
begin
  Memo1.Text := TSQL.Update('CLIENTE')
                      .Param('NOME')
                      .Value('IDADE', 0, SetNull) //SE VAZIO COLOCA COMO NULL
                      .Value('DATANASC', 0, DidEmpty) // ACEITA VAZIO
                      .Value('DATANASC', 0, IgnoreEmpty) // ACEITA VAZIO NAO ADD
                    .Where
                      .Eq('ID').ToSQL;
end;

procedure TForm7.Button5Click(Sender: TObject);
begin
  Memo1.Text := TSQL.Insert('CLIENTE')
                       .Value('ID', 17)
                       .Value('NOME', 'ALLAN')
                       .Value('IDADE', 21)
                       .Value('CIDADE', 'FORTALEZA')
                       .Value('UF', 'CEARÁ')
                       .Param('DATANASC')
                    .ToSQL;
end;

procedure TForm7.Button7Click(Sender: TObject);
begin
  Memo1.Text :=TSQL.Delete('CLIENTE')
      .Where
         .Inn('ID', [1,2,3,4,5,6,7])
      .ToSQL;

end;

end.
