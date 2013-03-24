{*******************************************************}
{                                                       }
{       FluentSQL                                       }
{                                                       }
{       Copyright (C) 2013 Allan Gomes                  }
{                                                       }
{*******************************************************}

unit FluentSQLTypes;

interface

type
  TConditionOperator = (Equal, GranThan, LessThan, Like, GranThanOrEqual, LessThanOrEqual);
  TValueEmpty = (DidEmpty, IgnoreEmpty, ExceptEmpty, SetNull);
  TExecSqlOptions = (CreateTransaction, UseTransaction, ExecuteDirect);
  TTypeJoin = (Inner, Left, Outher);
  TSQLOperation = (soSelect, soInsert, soUpdate, soDelete);

implementation

end.
