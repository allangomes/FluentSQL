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
  TConditionOperator = (Equal, GranThan, LessThan, Like, GranThanOrEqual, LessThanOrEqual, Iss);
  TValueEmpty = (veConsider, veIgnore, veExcept, veSetNull, veDefault);
  TExecSqlOptions = (CreateTransaction, UseTransaction, ExecuteDirect);
  TTypeJoin = (tjInner=1, tjLeft=2, tjOuter=3, tjRight=4);
  TSQLOperation = (soSelect, soInsert, soUpdate, soDelete);

implementation

end.
