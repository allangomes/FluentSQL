unit FluentSQLUnion;

interface

type
  IUnion = interface
    function UnionAll(SQL: String): IUnion; overload;
    function UnionAll(Condtion: Boolean; SQL: String): IUnion; overload;
    function ToSQL: String;
  end;

  TUnion = class(TInterfacedObject, IUnion)
  private
    FSQL: String;
  public    
    function UnionAll(SQL: String): IUnion; overload;
    function UnionAll(Condtion: Boolean; SQL: String): IUnion; overload;
    function ToSQL: String;
  end;

implementation

uses SysUtils;

{ TUnion }

function TUnion.UnionAll(SQL: String): IUnion;
begin
  Result := Self;
  if SQL <> EmptyStr then
  begin
    if FSQL <> EmptyStr then
      FSQL := FSQL + ' UNION ALL ';
    FSQL := FSQL + SQL;
  end;
end;

function TUnion.UnionAll(Condtion: Boolean; SQL: String): IUnion;
begin
  Result := Self;
  if Condtion then
    UnionAll(SQL)
end;

function TUnion.ToSQL: String;
begin
  Result := FSQL;
end;

end.
