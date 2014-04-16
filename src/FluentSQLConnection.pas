unit FluentSQLConnection;

interface

uses
  DB, Classes;

type
  TFluentSQLConnection = class;

  TFluentSQLQuery = class
  protected
    FQuery: TComponent;
    FFluentSQLConnection: TFluentSQLConnection;
  public
    function CreateQuery: TComponent; virtual; abstract;
    function Open: TFluentSQLQuery; virtual; abstract;
    function FieldByName(FieldName: string): TField; virtual; abstract;
    function Fields: TFields; virtual; abstract;
    procedure SetSQL(const ASQL: string); virtual; abstract;
    constructor Create(AOwner: TFluentSQLConnection);
  end;

  TFluentSQLConnection = class
  public
    Connection: TComponent;
    FluentQuery: TFluentSQLQuery;
    function Open: TFluentSQLQuery; virtual;
    function Query: TFluentSQLQuery; virtual;
    function CreateQuery: TFluentSQLQuery; virtual; abstract;
    procedure ExecuteDirect(const ASQL: string); virtual; abstract;
    procedure Execute(const ASQL: string); virtual; abstract;
    procedure CreateTransaction; virtual; abstract;
    procedure CommitTransaction; virtual; abstract;
    procedure RollbackTransaction; virtual; abstract;
    function AsString: string; virtual;
    function AsFloat: Double; virtual;
    function AsDateTime: TDateTime; virtual;
    constructor Create(AOwner: TComponent);
  end;

implementation

{ TFluentSQLConnection }

function TFluentSQLConnection.AsDateTime: TDateTime;
begin
  Open;
  Query.Fields[0].AsDateTime;
end;

function TFluentSQLConnection.AsFloat: Double;
begin
  Open;
  Query.Fields[0].AsFloat;
end;

function TFluentSQLConnection.AsString: string;
begin
  Open;
  Query.Fields[0].AsString;
end;

constructor TFluentSQLConnection.Create(AOwner: TComponent);
begin
  Connection := AOwner;
end;

function TFluentSQLConnection.Open: TFluentSQLQuery;
begin
  Result := FluentQuery.Open;
end;

function TFluentSQLConnection.Query: TFluentSQLQuery;
begin
  Result := FluentQuery;
end;

{ TFluentSQLQuery }

constructor TFluentSQLQuery.Create(AOwner: TFluentSQLConnection);
begin
  FFluentSQLConnection := AOwner;
end;

end.
