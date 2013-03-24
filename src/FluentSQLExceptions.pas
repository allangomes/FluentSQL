{*******************************************************}
{                                                       }
{       FluentSQL                                       }
{                                                       }
{       Copyright (C) 2013 Allan Gomes                  }
{                                                       }
{*******************************************************}

unit FluentSQLExceptions;

interface

uses
  SysUtils, Variants;

type
  IParam = interface
    function getName: string;
    function getValue: string;
    procedure setName(const Value: string);
    procedure setValue(const Value: string);
    property Name: string read getName write setName;
    property Value: string read getValue write setValue;
  end;

  TParam = class(TInterfacedObject, IParam)
  private
    function getName: string;
    function getValue: string;
    procedure setName(const Value: string);
    procedure setValue(const Value: string);
  public
    property Name: string read getName write setName;
    property Value: string read getValue write setValue;
  end;

  ESQLException = class(Exception)
  public
    constructor Create(Method: string; ParamsValue: array of IParam; SQL: string; Description: string); reintroduce;
  end;

  ESQLValueEmpty = class(ESQLException)
    constructor Create(ParamsValue: array of IParam); reintroduce;
  end;

function Param(Name: string; Value: Variant): IParam;

implementation

{ ESQLException }

constructor ESQLException.Create(Method: string; ParamsValue: array of IParam; SQL, Description: string);
begin

end;

{ TParam }

function TParam.getName: string;
begin

end;

function TParam.getValue: string;
begin

end;

procedure TParam.setName(const Value: string);
begin

end;

procedure TParam.setValue(const Value: string);
begin

end;

function Param(Name: string; Value: Variant): IParam;
begin
  Result := TParam.Create;
  Result.Name := Name;
  Result.Value := VarToStr(Value);
end;

{ ESQLValueEmpty }

constructor ESQLValueEmpty.Create(ParamsValue: array of IParam);
begin

end;

end.
