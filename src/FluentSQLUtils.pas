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
procedure CatIfTrue(var Text: string; Condition: Boolean; TextAdd: string);

implementation

uses
  FluentSQLConventions, SysUtils, FluentSQLExceptions;

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

function VarToSQL(Value: Variant; ValueEmpty: TValueEmpty): string;
begin
  if (ValueEmpty = SetNull) and EmptyValue(Value) then
  begin
    Result := 'NULL';
    Exit;
  end;
  if VarType(Value) = varDate then
    Result := QuotedStr(FormatDateTime(SQLConventions.FormatDateTimeSQL, VarToDateTime(Value)))
  else if VarIsStr(Value) then
    Result := QuotedStr(VarToStr(Value))
  else if VarIsNumeric(Value) then
    Result := VarToStr(Value)
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
