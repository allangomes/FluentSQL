{*******************************************************}
{                                                       }
{       FluentSQL                                       }
{                                                       }
{       Copyright (C) 2013 Allan Gomes                  }
{                                                       }
{*******************************************************}

unit FluentSQLWhere;

interface

uses
  Classes, SysUtils, FluentSQLTypes, Variants, VarUtils, DateUtils;

type
  TMountWhere = class
  private
    FWhere: TStrings;
    FInCondition: Boolean;
    FTrueCondition: Boolean;
    FExitCondition: Boolean;
    FIfThenCondition: Boolean;
    function GetCondition(Field: string; Value: string; ConditionOperator: TConditionOperator): string;
    procedure ConditionMaxDate(var Value: Variant; var ConditionOperator: TConditionOperator);
  public
    procedure CatSQLAnd(Condition: string); overload;
    procedure CatSQLAnd(Field: string; ConditionOperator: TConditionOperator); overload;
    procedure CatSQLAnd(Field: string; Value: Variant; ConditionOperator: TConditionOperator; ValueEmpty: TValueEmpty); overload;
    procedure CatSQLAnd(Field: string; MinValue, MaxValue: Variant); overload;
    procedure BeginIF(Condition: Boolean);
    procedure ElseIF(Condition: Boolean = True);
    procedure EndIF;
    procedure IfThen(Condition: Boolean);
    property Where: TStrings read FWhere;
    function Count: Integer;
    function GetWhere: string;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  FluentSQLExceptions, FluentSQLConventions, FluentSQLUtils;

{ TMountWhere }

procedure TMountWhere.CatSQLAnd(Condition: string);
begin
  if FTrueCondition or (not FInCondition) then
  begin
    if FWhere.Count = 0 then
      FWhere.Add('WHERE' + Condition)
    else
      FWhere.Add('  AND' + Condition);
  end;
  if FIfThenCondition then
    FInCondition := False;
end;

procedure TMountWhere.BeginIF(Condition: Boolean);
begin
  FInCondition := True;
  FTrueCondition := Condition;
end;

procedure TMountWhere.CatSQLAnd(Field: string; Value: Variant; ConditionOperator: TConditionOperator; ValueEmpty: TValueEmpty);
begin
  ConditionMaxDate(Value, ConditionOperator);
  if EmptyValue(Value) and (ValueEmpty = IgnoreEmpty) then
    Exit;
  if EmptyValue(Value) and (ValueEmpty = ExceptEmpty) then
    raise ESQLValueEmpty.Create([Param('Where', FWhere.Text),
                                 Param('Field', Field),
                                 Param('Value', Value),
                                 Param('ConditionOperator', ConditionOperator)]);
  CatSQLAnd(GetCondition(Field, VarToSQL(Value, ValueEmpty), ConditionOperator));
end;

procedure TMountWhere.ConditionMaxDate(var Value: Variant; var ConditionOperator: TConditionOperator);
begin
  if VarType(Value) = varDate then
  begin
    if (DateOf(Value) = Value) and (ConditionOperator in [LessThan, LessThanOrEqual]) then
    begin
      Value := Value + 1;
      ConditionOperator := LessThan;
    end;
  end;
end;

function TMountWhere.Count: Integer;
begin
  Result := FWhere.Count;
end;

constructor TMountWhere.Create;
begin
  FWhere := TStringList.Create;
end;

destructor TMountWhere.Destroy;
begin
  FWhere.Free;
  inherited;
end;

procedure TMountWhere.ElseIF(Condition: Boolean);
begin
  FInCondition := True;
  if FTrueCondition then
  begin
    FTrueCondition := False;
    FExitCondition := True;
  end;
  if not FExitCondition then
    FTrueCondition := Condition;
end;

procedure TMountWhere.EndIF;
begin
  FInCondition := False;
end;

function TMountWhere.GetCondition(Field, Value: string; ConditionOperator: TConditionOperator): string;
const
  Condition = ' %s %s %s';
var
  OperatorStr: string;
begin
  case ConditionOperator of
    Equal: OperatorStr := '=';
    GranThan: OperatorStr := '>';
    LessThan: OperatorStr := '<';
    GranThanOrEqual: OperatorStr := '>=';
    LessThanOrEqual: OperatorStr := '<=';
    Like: OperatorStr := 'LIKE';
  end;
  Result := Format(Condition, [Field, OperatorStr, Value]);
end;

function TMountWhere.GetWhere: string;
begin
  Result := FWhere.Text;
end;

procedure TMountWhere.IfThen(Condition: Boolean);
begin
  FTrueCondition := Condition;
  FInCondition := True;
  FIfThenCondition := True;
end;

procedure TMountWhere.CatSQLAnd(Field: string; MinValue, MaxValue: Variant);
const
  BETWEEN = ' %s BETWEEN %s AND %s';
var
  Cond: TConditionOperator;
begin
  if EmptyValue(MinValue) and EmptyValue(MaxValue) then
    Exit
  else if EmptyValue(MinValue) and not EmptyValue(MaxValue) then
    CatSQLAnd(Field, MaxValue, LessThanOrEqual, ExceptEmpty)
  else if not EmptyValue(MinValue) and EmptyValue(MaxValue) then
    CatSQLAnd(Field, MaxValue, GranThanOrEqual, ExceptEmpty)
  else
  begin
    Cond := LessThan;
    ConditionMaxDate(MaxValue, Cond);
    CatSQLAnd(Format(BETWEEN, [Field, VarToSQL(MinValue, IgnoreEmpty), VarToSQL(MaxValue, IgnoreEmpty)]));
  end;
end;

procedure TMountWhere.CatSQLAnd(Field: string; ConditionOperator: TConditionOperator);
begin
  CatSQLAnd(GetCondition(Field, ':'+StringReplace(Field, '.', '_', [rfReplaceAll]), ConditionOperator));
end;

end.
