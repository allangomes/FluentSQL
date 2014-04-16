unit DBXFluentSQLConnection;

interface

uses
  FluentSQLConnection, Classes, DB, SqlExpr, DBXCommon, Contnrs;

type
  TDBXFluentSQLConnection = class;

  TDBXFluentSQLQuery = class(TFluentSQLQuery)
  protected
    FQuery: TComponent;
    function AsSQLQuery: TSQLQuery;
  public
    function CreateQuery: TComponent; override;
    function Open: TFluentSQLQuery; override;
    function FieldByName(FieldName: string): TField; override;
    function Fields: TFields; override;
    procedure SetSQL(const ASQL: string); override;
    constructor Create(AOwner: TDBXFluentSQLConnection); reintroduce;
  end;

  TDBXFluentSQLConnection = class(TFluentSQLConnection)
  private
    FTransactions: TStack;
    function AsSQLConnection: TSQLConnection;
  protected
    FluentQuery: TFluentSQLQuery;
    function CreateQuery: TFluentSQLQuery; override;
  public
    procedure ExecuteDirect(const ASQL: string); override;
    procedure Execute(const ASQL: string); override;
    procedure CreateTransaction; override;
    procedure CommitTransaction; override;
    procedure RollbackTransaction; override;
    constructor Create(AOwner: TSQLConnection); reintroduce;
  end;

implementation

{ TDBXFluentSQLQuery }

function TDBXFluentSQLQuery.AsSQLQuery: TSQLQuery;
begin
  Result := TSQLQuery(FQuery);
end;

constructor TDBXFluentSQLQuery.Create(AOwner: TDBXFluentSQLConnection);
begin
  inherited Create(AOwner);
end;

function TDBXFluentSQLQuery.CreateQuery: TComponent;
var
  Qry: TSQLQuery;
begin
  Qry := TSQLQuery.Create(nil);
  Qry.SQLConnection := TSQLConnection(FFluentSQLConnection.Connection);
  Result := Qry;
end;

function TDBXFluentSQLQuery.FieldByName(FieldName: string): TField;
begin
  Result := AsSQLQuery.FieldByName(FieldName);
end;

function TDBXFluentSQLQuery.Fields: TFields;
begin

end;

function TDBXFluentSQLQuery.Open: TFluentSQLQuery;
begin
  AsSQLQuery.Open;
  Result := Self;
end;

procedure TDBXFluentSQLQuery.SetSQL(const ASQL: string);
begin
  inherited;

end;

{ TDBXFluentSQLConnection }

function TDBXFluentSQLConnection.AsSQLConnection: TSQLConnection;
begin
  Result := TSQLConnection(FluentSQLConnection);
end;

procedure TDBXFluentSQLConnection.CommitTransaction;
var
  Trans: TDBXTransaction;
begin
  inherited;
  Trans := FTransactions.Pop;
  AsSQLConnection.CommitFreeAndNil(Trans);
end;

constructor TDBXFluentSQLConnection.Create(AOwner: TSQLConnection);
begin
  inherited Create(AOwner);
end;

function TDBXFluentSQLConnection.CreateQuery: TFluentSQLQuery;
begin
  Result := TDBXFluentSQLQuery.Create;
end;

procedure TDBXFluentSQLConnection.CreateTransaction;
begin
  inherited;
  FTransactions.Push(AsSQLConnection.BeginTransaction);
end;

procedure TDBXFluentSQLConnection.Execute(const ASQL: string);
begin
  inherited;
  AsSQLConnection.Execute(ASQL);
end;

procedure TDBXFluentSQLConnection.ExecuteDirect(const ASQL: string);
begin
  inherited;
  AsSQLConnection.ExecuteDirect(ASQL);
end;

procedure TDBXFluentSQLConnection.RollbackTransaction;
var
  Trans: TDBXTransaction;
begin
  inherited;
  Trans := FTransactions.Pop;
  AsSQLConnection.RollbackFreeAndNil(Trans);
end;

end.
