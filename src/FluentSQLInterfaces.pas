{*******************************************************}
{                                                       }
{       FluentSQL                                       }
{                                                       }
{       Copyright (C) 2013 Allan Gomes                  }
{                                                       }
{*******************************************************}

unit FluentSQLInterfaces;

interface

uses
  FluentSQLTypes, SqlExpr;

type
  IMetaDataSQL = interface;

  IBaseSQL = interface
  ['{7D201638-38ED-4044-927E-CD6431FB174B}']
    function ToSQL: string;
    function Metadata: IMetaDataSQL;
  end;

  IOrderSQL = interface(IBaseSQL)
  ['{9443813F-2C74-479E-9E67-68F56569B6F8}']
  end;

  IGroupSQL = interface(IBaseSQL)
  ['{1F7C99F0-0051-4D3B-AF32-23AD718D95A0}']
    function Order(Fields: string): IOrderSQL;
  end;

  IWhereSQL = interface(IBaseSQL)
  ['{8A15FEDB-DB18-4247-BD3A-0DE87A60AE2F}']
    //Conditions
    function Eq(Field: string): IWhereSQL; overload;
    function EqField(FieldLeft, FieldRight: string): IWhereSQL;
    function BeginIF(Condition: Boolean): IWhereSQL;
    function ElseIF(Condition: Boolean = True): IWhereSQL;
    function EndIF: IWhereSQL;
    function IfThen(Condition: Boolean): IWhereSQL;
    function Andd(Condition: string): IWhereSQL;
    function Nott: IWhereSQL;
    function Inn(Field: string; Values: string): IWhereSQL; overload;
    function Inn(Field: string; Values: array of Variant): IWhereSQL; overload;
    function Gt(Field: string): IWhereSQL; overload;
    function Lt(Field: string): IWhereSQL; overload;
    function GtOrEq(Field: string): IWhereSQL; overload;
    function LtOrEq(Field: string): IWhereSQL; overload;
    function Lk(Field: string): IWhereSQL; overload;
    function Eq(Field: string; Value: Variant; ValueEmpty: TValueEmpty = veDefault): IWhereSQL; overload;
    function Gt(Field: string; Value: Variant; ValueEmpty: TValueEmpty = veDefault): IWhereSQL; overload;
    function Lt(Field: string; Value: Variant; ValueEmpty: TValueEmpty = veDefault): IWhereSQL; overload;
    function GtOrEq(Field: string; Value: Variant; ValueEmpty: TValueEmpty = veDefault): IWhereSQL; overload;
    function LtOrEq(Field: string; Value: Variant; ValueEmpty: TValueEmpty = veDefault): IWhereSQL; overload;
    function LtOrEqField(Field: string; FieldValue: string): IWhereSQL; overload;
    function Between(Field: string; MinValue, MaxValue: Variant): IWhereSQL; overload;
    function Between(Value: Variant; MinField, MaxField: String): IWhereSQL; overload;
    function Lk(Field: string; Value: string; ValueEmpty: TValueEmpty = veDefault): IWhereSQL; overload;
    function Group(Fields: string): IGroupSQL;
    function Order(Fields: string): IOrderSQL;
  end;

  IJoinSQL = interface(IBaseSQL)
  ['{8AE812F6-4EC9-4EBC-9AF9-58ACE4E47B9F}']
    function Eq(FieldInner: string; FieldFrom: string): IJoinSQL;
    function EqValue(FieldInner: string; Value: Variant; ValueEmpty: TValueEmpty = veDefault): IJoinSQL;
    function EqSQL(FieldInner: string; SQL: string): IJoinSQL;
    function Onn(SQLJoin: string): IJoinSQL;
    function Inner(Table: string; Alias: string = ''): IJoinSQL;
    function Left(Table: string; Alias: string = ''): IJoinSQL; overload;
    function Left(Condition:Boolean; Table: string; Alias: string = ''): IJoinSQL; overload;
    function Outer(Table: string; Alias: string = ''): IJoinSQL;
    function Right(Table: string; Alias: string = ''): IJoinSQL;
    function Where: IWhereSQL;
    function Group(Fields: string): IGroupSQL;
    function Order(Fields: string): IOrderSQL;
  end;

  IFromSQL = interface(IBaseSQL)
  ['{008603FF-1186-4242-93A9-8CCBEEB132E5}']
    function Inner(Table: string; Alias: string = ''): IJoinSQL;
    function Left(Table: string; Alias: string = ''): IJoinSQL; overload;
    function Left(Condition:Boolean; Table: string; Alias: string = ''): IJoinSQL; overload;
    function Outer(Table: string; Alias: string = ''): IJoinSQL;
    function Right(Table: string; Alias: string = ''): IJoinSQL;
    function Where: IWhereSQL;
    function Group(Fields: string): IGroupSQL;
    function Order(Fields: string): IOrderSQL;
  end;

  ISelectSQL = interface(IBaseSQL)
  ['{F75FD8C0-4CBE-415E-8294-C92D51ABCFB0}']
    function From(Table: string; Alias: string = ''): IFromSQL;
  end;

  IDeleteSQL = interface(IBaseSQL)
  ['{50BDDA33-D228-4D12-B9C1-B8E7928745AB}']
    function Where: IWhereSQL;
  end;

  IUpdateSQL = interface(IBaseSQL)
  ['{AF46177D-2EE0-4AD4-A0C2-72DD0DB1F59A}']
    function Value(Field: string; Value: Variant; ValueEmpty: TValueEmpty = veConsider): IUpdateSQL; overload;
    function Param(Field: string): IUpdateSQL; overload;
    function IfThen(Condition: Boolean): IUpdateSQL; overload;
    function Where: IWhereSQL;
  end;

  IInsertSQL = interface(IBaseSQL)
  ['{E1F5FBCF-FBB8-44EE-9AF0-B3F64ABF103F}']
    function Value(Field: string; Value: Variant; ValueEmpty: TValueEmpty = veConsider): IInsertSQL; overload;
    function Param(Field: string): IInsertSQL; overload;
    function IfThen(Condition: Boolean): IInsertSQL; overload;    
  end;


  IMetaDataSQL = interface
    function Select(Fields: string): ISelectSQL;
    function From(Table: string; Alias: string = ''): IFromSQL;
    function Where: IWhereSQL;
    function Inner(Table: string; Alias: string = ''): IJoinSQL;
    function Left(Table: string; Alias: string = ''): IJoinSQL;
    function Outer(Table: string; Alias: string = ''): IJoinSQL;
  end;

implementation

end.
