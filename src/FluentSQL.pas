{*******************************************************}
{                                                       }
{       FluentSQL                                       }
{                                                       }
{       Copyright (C) 2013 Allan Gomes                  }
{                                                       }
{*******************************************************}

unit FluentSQL;

interface

uses
  DB, Classes, FluentSQLWhere, SysUtils, StrUtils,
  FluentSQLInterfaces, FluentSQLTypes, SqlExpr, DBXCommon;

type
  TFrom = class
  public
    Table: string;
    Alias: string;
    function FromName: string;
  end;

  TFluentSQL = class(TInterfacedObject, IMetaDataSQL, ISelectSQL, IFromSQL, IWhereSQL, IJoinSQL, IGroupSQL, IOrderSQL, IUpdateSQL, IInsertSQL, IDeleteSQL)
  private
    FFields: TStrings;
    FInsertValues: TStrings;
    FFrom: TFrom;
    FCurrentJoin: TFrom;
    FCurrentFieldsJoin: TStrings;
    FJoin: TStrings;
    FWhere: TMountWhere;
    FGroup: TStrings;
    FOrder: TStrings;
    FQuery: TSQLQuery;
    FOperation: TSQLOperation;
    procedure SetFieldsJoin;
    function Join(Table: string; Alias: string; TypeJoin: TTypeJoin): IJoinSQL;
    procedure ExceptionEmptyValue(Field: string; Value: Variant; ValueEmpty: TValueEmpty);
  protected
    function Select(Fields: string): ISelectSQL;
    function Update(Table: string): IUpdateSQL;
    function Insert(Table: string): IInsertSQL;
    function Delete(Table: string): IDeleteSQL;

    {*** ISelectSQL ***}
    function From(Table: string; Alias: string = ''): IFromSQL;

    {*** IUpdateSQL ***}
    function IUpdateSQL_Value(Field: string; Value: Variant; ValueEmpty: TValueEmpty = SetNull): IUpdateSQL; overload;
    function IUpdateSQL_Param(Field: string): IUpdateSQL; overload;
    function IUpdateSQL.Value = IUpdateSQL_Value;
    function IUpdateSQL.Param = IUpdateSQL_Param;

    {*** IInsertSQL ***}
    function IInsertSQL_Value(Field: string; Value: Variant; ValueEmpty: TValueEmpty = SetNull): IInsertSQL; overload;
    function IInsertSQL_Param(Field: string): IInsertSQL; overload;
    function IInsertSQL.Value = IInsertSQL_Value;
    function IInsertSQL.Param = IInsertSQL_Param;

    {*** IFromSQL, IJoinSQL ***}
    function Inner(Table: string; Alias: string = ''): IJoinSQL;
    function Left(Table: string; Alias: string = ''): IJoinSQL;
    function Outher(Table: string; Alias: string = ''): IJoinSQL;

    {*** IJoinSQL ***}
    function IJoinSQL_Eq(FieldInner: string; FieldFrom: string): IJoinSQL;
    function IJoinSQL.Eq = IJoinSQL_Eq;

    {*** IWhereSQL ***}
    function Where: IWhereSQL;
    function BeginIF(Condition: Boolean): IWhereSQL;
    function ElseIF(Condition: Boolean = True): IWhereSQL;
    function EndIF: IWhereSQL;
    function IfThen(Condition: Boolean): IWhereSQL;
    function Andd(Condition: string): IWhereSQL;
    function Inn(Field: string; Values: string): IWhereSQL; overload;
    function Inn(Field: string; Values: array of Variant): IWhereSQL; overload;
    function Eq(Field: string): IWhereSQL; overload;
    function Gt(Field: string): IWhereSQL; overload;
    function Lt(Field: string): IWhereSQL; overload;
    function GtOrEq(Field: string): IWhereSQL; overload;
    function LtOrEq(Field: string): IWhereSQL; overload;
    function Lk(Field: string): IWhereSQL; overload;
    function Eq(Field: string; Value: Variant; ValueEmpty: TValueEmpty = IgnoreEmpty): IWhereSQL; overload;
    function Gt(Field: string; Value: Variant; ValueEmpty: TValueEmpty = IgnoreEmpty): IWhereSQL; overload;
    function Lt(Field: string; Value: Variant; ValueEmpty: TValueEmpty = IgnoreEmpty): IWhereSQL; overload;
    function GtOrEq(Field: string; Value: Variant; ValueEmpty: TValueEmpty = IgnoreEmpty): IWhereSQL; overload;
    function LtOrEq(Field: string; Value: Variant; ValueEmpty: TValueEmpty = IgnoreEmpty): IWhereSQL; overload;
    function Between(Field: string; MinValue, MaxValue: Variant): IWhereSQL; overload;
    function Lk(Field: string; Value: string; ValueEmpty: TValueEmpty = IgnoreEmpty): IWhereSQL; overload;

    function Group(Fields: string): IGroupSQL;
    function Order(Fields: string): IOrderSQL;

    {*** IBaseSQL ***}
    function ToSQL: string;
    procedure ExecSQL(ExecOptions: TExecSqlOptions);
    function Open: TSQLQuery;
    function Query: TSQLQuery;
    function Metadata: IMetaDataSQL;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  end;

  TSQL = class
    class function Select(Fields: string): ISelectSQL;
    class function Insert(Table: string): IInsertSQL;
    class function Update(Table: string): IUpdateSQL;
    class function Delete(Table: string): IDeleteSQL;
  end;

var
  FluentConnection: TSQLConnection;

implementation

uses
  FluentSQLUtils, FluentSQLExceptions, Variants, FluentSQLConventions;

{ TFluentSQL }

procedure TFluentSQL.AfterConstruction;
begin
  inherited;
  FFields:= TStringList.Create;
  FInsertValues:= TStringList.Create;
  FFrom:= TFrom.Create;
  FCurrentJoin:= TFrom.Create;
  FCurrentFieldsJoin:= TStringList.Create;
  FJoin:= TStringList.Create;
  FWhere:= TMountWhere.Create;
  FGroup:= TStringList.Create;
  FOrder:= TStringList.Create;
end;

function TFluentSQL.Andd(Condition: string): IWhereSQL;
begin
  FWhere.CatSQLAnd(Condition);
  Result := Self;
end;

procedure TFluentSQL.BeforeDestruction;
begin
  inherited;
  FFields.Free;
  FInsertValues.Free;
  FFrom.Free;
  FCurrentJoin.Free;
  FCurrentFieldsJoin.Free;
  FJoin.Free;
  FWhere.Free;
  FGroup.Free;
  FOrder.Free;
  if FQuery <> nil then
    FQuery.Free;
end;

function TFluentSQL.BeginIF(Condition: Boolean): IWhereSQL;
begin
  FWhere.BeginIF(Condition);
  Result := Self;
end;

function TFluentSQL.Between(Field: string; MinValue,
  MaxValue: Variant): IWhereSQL;
begin
  FWhere.CatSQLAnd(Field, MinValue, MaxValue);
  Result := Self;
end;

function TFluentSQL.Delete(Table: string): IDeleteSQL;
begin
  FOperation := soDelete;
  FFrom.Table := Table;
  Result := Self;
end;

function TFluentSQL.ElseIF(Condition: Boolean): IWhereSQL;
begin
  FWhere.ElseIF(Condition);
  Result := Self;
end;

function TFluentSQL.EndIF: IWhereSQL;
begin
  FWhere.EndIF;
  Result := Self;
end;

function TFluentSQL.Eq(Field: string): IWhereSQL;
begin
  FWhere.CatSQLAnd(Field, Equal);
  Result := Self;
end;

function TFluentSQL.Eq(Field: string; Value: Variant;
  ValueEmpty: TValueEmpty): IWhereSQL;
begin
  FWhere.CatSQLAnd(Field, Value, Equal, ValueEmpty);
  Result := Self;
end;

procedure TFluentSQL.ExceptionEmptyValue(Field: string; Value: Variant;
  ValueEmpty: TValueEmpty);
begin
  if (ValueEmpty = ExceptEmpty) and EmptyValue(Value) then
    raise ESQLValueEmpty.Create([Param('Method', 'IUpdateSQL_Value'),
                                 Param('  Field', Field),
                                 Param('  Value', Value),
                                 Param('ValueType', VarTypeAsText(VarType(Value))),
                                 Param('SQL Parcial', ToSQL)]);
end;

procedure TFluentSQL.ExecSQL(ExecOptions: TExecSqlOptions);
var
  Qry: TSQLQuery;
  Trans: TDBXTransaction;
begin
  Qry := Query;
  try
    if ExecOptions = CreateTransaction then
    begin
      Trans := Qry.SQLConnection.BeginTransaction;
      try
        Qry.ExecSQL;
      finally
        Trans.Free;
      end;
    end
    else
      Qry.ExecSQL(ExecOptions = ExecuteDirect);
  finally
    Qry.Free;
  end;
end;

function TFluentSQL.From(Table, Alias: string): IFromSQL;
begin
  FFrom.Table := Table;
  FFrom.Alias := Alias;
  Result := Self;
end;

function TFluentSQL.Group(Fields: string): IGroupSQL;
const
  GROUP = 'GROUP BY %s';
begin
  FGroup.Add(Format(GROUP, [Fields]));
  Result := Self;
end;

function TFluentSQL.Gt(Field: string; Value: Variant;
  ValueEmpty: TValueEmpty): IWhereSQL;
begin
  FWhere.CatSQLAnd(Field, Value, GranThan, ValueEmpty);
  Result := Self;
end;

function TFluentSQL.Gt(Field: string): IWhereSQL;
begin
  FWhere.CatSQLAnd(Field, GranThan);
  Result := Self;
end;

function TFluentSQL.GtOrEq(Field: string): IWhereSQL;
begin
  FWhere.CatSQLAnd(Field, GranThanOrEqual);
  Result := Self;
end;

function TFluentSQL.GtOrEq(Field: string; Value: Variant;
  ValueEmpty: TValueEmpty): IWhereSQL;
begin
  FWhere.CatSQLAnd(Field, Value, GranThanOrEqual, ValueEmpty);
  Result := Self;
end;

function TFluentSQL.IfThen(Condition: Boolean): IWhereSQL;
begin
  FWhere.IfThen(Condition);
  Result := Self;
end;

function TFluentSQL.IInsertSQL_Param(Field: string): IInsertSQL;
begin
  FFields.Add(Field);
  FInsertValues.Add(':'+Field);
  Result := Self;
end;

function TFluentSQL.IInsertSQL_Value(Field: string; Value: Variant;
  ValueEmpty: TValueEmpty): IInsertSQL;
begin
  Result := Self;
  ExceptionEmptyValue(Field, Value, ValueEmpty);
  if (ValueEmpty = IgnoreEmpty) and EmptyValue(Value) then
    Exit;
  FFields.Add(Field);
  FInsertValues.Add(VarToSQL(Value, ValueEmpty));
end;

function TFluentSQL.IJoinSQL_Eq(FieldInner, FieldFrom: string): IJoinSQL;
const
  FORMAT_FIELD = '%s.%s';
  FORMAT_CONDITION = '%s = %s';
begin
  if not ContainsText(FieldInner, '.') then
    FieldInner := Format(FORMAT_FIELD, [FCurrentJoin.FromName, FieldInner]);
  if not ContainsText(FieldFrom, '.') then
    FieldFrom := Format(FORMAT_FIELD, [FFrom.FromName, FieldFrom]);
  FCurrentFieldsJoin.Add(Format(FORMAT_CONDITION, [FieldInner, FieldFrom]));
  Result := Self;
end;

function TFluentSQL.Inn(Field, Values: string): IWhereSQL;
const
  FORMAT_INN = ' %s IN %s';
begin
  if Values[1] <> '(' then
    Values := '('+Values+')';
  Result := Andd(Format(FORMAT_INN, [Field, Values]));
end;

function TFluentSQL.Inn(Field: string; Values: array of Variant): IWhereSQL;
var
  I: Integer;
  InValues: string;
begin
  for I := Low(Values) to High(Values) do
  begin
    CatIfTrue(InValues, InValues <> EmptyStr, ',');
    InValues := InValues + VarToSQL(Values[I], IgnoreEmpty);
  end;
  Result := Inn(Field, InValues);
end;

function TFluentSQL.Inner(Table, Alias: string): IJoinSQL;
begin
  Result := Join(Table, Alias, TTypeJoin.Inner);
end;

function TFluentSQL.Insert(Table: string): IInsertSQL;
begin
  FOperation := soInsert;
  FFrom.Table := Table;
  Result := Self;
end;

function TFluentSQL.IUpdateSQL_Param(Field: string): IUpdateSQL;
const
  FORMAT_SET = '    %s = :%s';
begin
  FFields.Add(Format(FORMAT_SET, [Field, Field]));
  Result := Self;
end;

function TFluentSQL.IUpdateSQL_Value(Field: string; Value: Variant;
  ValueEmpty: TValueEmpty): IUpdateSQL;
const
  FORMAT_SET = '    %s = %s';
begin
  Result := Self;
  ExceptionEmptyValue(Field, Value, ValueEmpty);
  if (ValueEmpty = IgnoreEmpty) and  EmptyValue(Value) then
    Exit;
  FFields.Add(Format(FORMAT_SET, [Field, VarToSQL(Value, ValueEmpty)]));
end;

function TFluentSQL.Join(Table, Alias: string; TypeJoin: TTypeJoin): IJoinSQL;
const
  JoinStr = '%s JOIN %s %s ON (#FIELDS#)';
var
  TypeJoinStr: string;
begin
  SetFieldsJoin;
  case TypeJoin of
    TTypeJoin.Inner: TypeJoinStr := 'INNER';
    TTypeJoin.Left: TypeJoinStr := 'LEFT';
    TTypeJoin.Outher: TypeJoinStr := 'OUTHER';
  end;
  FCurrentJoin.Table := Table;
  FCurrentJoin.Alias := Alias;
  FJoin.Add(Format(JoinStr, [TypeJoinStr, Table, Alias]));
  Result := Self;
end;

function TFluentSQL.Left(Table, Alias: string): IJoinSQL;
begin
  Result := Join(Table, Alias, TTypeJoin.Left);
end;

function TFluentSQL.Lk(Field: string): IWhereSQL;
begin
  FWhere.CatSQLAnd(Field, Like);
  Result := Self;
end;

function TFluentSQL.Lk(Field, Value: string; ValueEmpty: TValueEmpty): IWhereSQL;
begin
  FWhere.CatSQLAnd(Field, Value, Like, ValueEmpty);
  Result := Self;
end;

function TFluentSQL.Lt(Field: string; Value: Variant;
  ValueEmpty: TValueEmpty): IWhereSQL;
begin
  FWhere.CatSQLAnd(Field, Value, LessThan, ValueEmpty);
  Result := Self;
end;

function TFluentSQL.Lt(Field: string): IWhereSQL;
begin
  FWhere.CatSQLAnd(Field, LessThan);
  Result := Self;
end;

function TFluentSQL.LtOrEq(Field: string): IWhereSQL;
begin
  FWhere.CatSQLAnd(Field, LessThanOrEqual);
  Result := Self;
end;

function TFluentSQL.LtOrEq(Field: string; Value: Variant;
  ValueEmpty: TValueEmpty): IWhereSQL;
begin
  FWhere.CatSQLAnd(Field, Value, LessThanOrEqual, ValueEmpty);
  Result := Self;
end;

function TFluentSQL.Metadata: IMetaDataSQL;
begin
  Result := Self;
end;

function TFluentSQL.Open: TSQLQuery;
begin
  Query.Open;
  Result := Query;
end;

function TFluentSQL.Order(Fields: string): IOrderSQL;
const
  ORDER = 'ORDER BY %s';
begin
  FOrder.Add(Format(ORDER, [Fields]));
  Result := Self;
end;

function TFluentSQL.Outher(Table, Alias: string): IJoinSQL;
begin
  Result := Join(Table, Alias, TTypeJoin.Outher);
end;

function TFluentSQL.Query: TSQLQuery;
begin
  if FQuery = nil then
  begin
    FQuery := TSQLQuery.Create(nil);
    FQuery.SQLConnection := FluentConnection;
  end;
  FQuery.SQL.Text := ToSQL;
  Result := FQuery;
end;

function TFluentSQL.Select(Fields: string): ISelectSQL;
begin
  FOperation := soSelect;
  FFields.Text := Fields;
  Result := Self;
end;

procedure TFluentSQL.SetFieldsJoin;
const
  FORMAT_COND = '%s.%s = %s.%s';
var
  Fields: string;
  LeftField: string;
  RigthField: string;
begin
  if FJoin.Count > 0 then
  begin
    if FCurrentFieldsJoin.Count > 0 then
    begin
      Fields := StringReplace(FCurrentFieldsJoin.CommaText, ',', ' AND ', [rfReplaceAll]);
      Fields := StringReplace(Fields, '"', '', [rfReplaceAll]);
      FJoin.Text := StringReplace(FJoin.Text, '#FIELDS#', Fields, [rfReplaceAll]);
      FCurrentFieldsJoin.Clear;
    end
    else
    begin
      LeftField := StringReplace(SQLConventions.PrimaryKeyName, VAR_TABLE, FCurrentJoin.Table, [rfReplaceAll]);
      RigthField := StringReplace(SQLConventions.ForeingKeyName, VAR_TABLE, FCurrentJoin.Table, [rfReplaceAll]);
      Fields := Format(FORMAT_COND, [FCurrentJoin.FromName, LeftField, FFrom.FromName, RigthField]);
      FJoin.Text := StringReplace(FJoin.Text, '#FIELDS#', Fields, [rfReplaceAll]);
    end;
  end
end;

function TFluentSQL.ToSQL: string;
const
  SELECT = 'SELECT %s';
  FROM = 'FROM %s %s';
  UPDATE = 'UPDATE %s SET ';
  DELETE = 'DELETE FROM %s ';
  INSERT = 'INSERT INTO %s (%s) VALUES (%s)';
var
  Sql: TStrings;
begin
  SetFieldsJoin;
  Sql := TStringList.Create;
  try
    case FOperation of
      soSelect:
      begin
        if FFields.Count > 0 then
          Sql.Text := Sql.Text + (Format(SELECT, [FFields.Text]));
        if FFrom.Table <> EmptyStr then
          Sql.Add(Format(FROM, [FFrom.Table, FFrom.Alias]));
        if FJoin.Count > 0 then
          Sql.Text := Sql.Text + (FJoin.Text);
        if FWhere.Count > 0 then
          Sql.Text := Sql.Text + (FWhere.GetWhere);
        if FGroup.Count > 0 then
          Sql.Text := Sql.Text + (FGroup.Text);
        if FOrder.Count > 0 then
          Sql.Text := Sql.Text + (FOrder.Text);
      end;
      soInsert:
      begin
        Sql.Text := Format(INSERT, [FFrom.Table, StringReplace(FFields.CommaText, '"', '', [rfReplaceAll]),
                                                 StringReplace(FInsertValues.CommaText, '"', '', [rfReplaceAll])]);
      end;
      soUpdate:
      begin
        Sql.Text := Format(UPDATE, [FFrom.Table]);
        Sql.Text := Sql.Text + StringReplace(StringReplace(FFields.CommaText, '"', '', [rfReplaceAll]), ',', ','+#13#10, [rfReplaceAll]);
        if FWhere.Count > 0 then
          Sql.Text := Sql.Text + (FWhere.GetWhere);
      end;
      soDelete:
      begin
        Sql.Text := Format(DELETE, [FFrom.Table]);
        if FWhere.Count > 0 then
          Sql.Text := Sql.Text + (FWhere.GetWhere);
      end;
    end;
    Result := Sql.Text;
  finally
    Sql.Free;
  end;
end;

function TFluentSQL.Update(Table: string): IUpdateSQL;
begin
  FOperation := soUpdate;
  FFrom.Table := Table;
  Result := Self;
end;

function TFluentSQL.Where: IWhereSQL;
begin
  Result := Self;
end;

{ TFrom }

function TFrom.FromName: string;
begin
  Result := IfThen(Alias = EmptyStr, Table, Alias);
end;

{ TSQL }

class function TSQL.Delete(Table: string): IDeleteSQL;
begin
  Result := TFluentSQL.Create.Delete(Table);
end;

class function TSQL.Insert(Table: string): IInsertSQL;
begin
  Result := TFluentSQL.Create.Insert(Table);
end;

class function TSQL.Select(Fields: string): ISelectSQL;
begin
  Result := TFluentSQL.Create.Select(Fields);
end;

class function TSQL.Update(Table: string): IUpdateSQL;
begin
  Result := TFluentSQL.Create.Update(Table);
end;

end.
