{*******************************************************}
{                                                       }
{       FluentSQL                                       }
{                                                       }
{       Copyright (C) 2013 Allan Gomes                  }
{                                                       }
{*******************************************************}

unit FluentSQLUtils;

interface

uses
  Variants, FluentSQLTypes;

function EmptyValue(Value: Variant): Boolean;
function VarToSQL(Value: Variant; ValueEmpty: TValueEmpty): string;
function VarToBool(Value: Variant): Boolean;
function BoolToInt(Value: Boolean): Integer;
function BoolToSQL(Value: Boolean): string;
procedure CatIfTrue(var Text: string; Condition: Boolean; TextAdd: string);

implementation

uses
  FluentSQLConventions, SysUtils, FluentSQLExceptions,
  Math, StrUtils;

function EmptyValue(Value: Variant): Boolean;
begin
  Result := False;
  if VarType(Value) = varDate then
    Result := VarToDateTime(Value) <= 1
  else if VarIsStr(Value) then
    Result := VarToStr(Value) = ''
  else if VarIsNumeric(Value) then
    Result := VarToStr(Value) = '0';
end;

function VarToBool(Value: Variant): Boolean;
begin
  Result:= StrToBool(VarToStr(Value));
end;

function BoolToInt(Value: Boolean): Integer;
const
  cSimpleBoolInt: array [boolean] of Integer = (0, 1);
begin
  Result:= cSimpleBoolInt[Value];
end;

function BoolToSQL(Value: Boolean): string;
begin
  Result:= IntToStr(BoolToInt(Value));
end;

function VarToSQL(Value: Variant; ValueEmpty: TValueEmpty): string;
var
  DateValue: TDateTime;
begin
  if (ValueEmpty = veSetNull) and EmptyValue(Value) then
  begin
    Result := 'NULL';
    Exit;
  end;

  if VarType(Value) = varDate then
  begin
    DateValue := VarToDateTime(Value);
    Result := QuotedStr(FormatDateTime(SQLConventions.FormatDateSQL, DateValue) + IfThen(DateValue <> Trunc(DateValue),' '+TimeToStr(DateValue)));
  end else if VarIsStr(Value) then
    Result := QuotedStr(VarToStr(Value))
  else if VarType(Value) = varBoolean  then
    Result := BoolToSQL(VarToBool(Value))
  else if VarIsNumeric(Value) then
    Result:=StringReplace(FloatToStr(Value),DecimalSeparator,'.',[rfReplaceAll,rfIgnoreCase])
  else
    raise ESQLException.Create('VarToSQL',
                               [Param('Value', VarToStr(Value))],
                               '',
                               'Tipo de Valor não implementado. '+ VarTypeAsText(VarType(Value)));
end;

procedure CatIfTrue(var Text: string; Condition: Boolean; TextAdd: string);
begin
  if Condition then
    Text := Text + TextAdd;
end;

end.
