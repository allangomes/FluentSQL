{*******************************************************}
{                                                       }
{       FluentSQL                                       }
{                                                       }
{       Copyright (C) 2013 Allan Gomes                  }
{                                                       }
{*******************************************************}

unit FluentSQLConventions;

interface

const
  VAR_TABLE = '$(TABLE)';
  DEFALT_FORMAT_DATESQL = 'MM/dd/yyyy';
  DEFAULT_PRIMARYKEY_NAME = 'ID';
  DEFAULT_FOREINGKEY_NAME = VAR_TABLE + '_ID';

type
  TSQLConventions = class
  public
    FormatDateSQL: string;
    PrimaryKeyName: string;
    ForeingKeyName: string;
    procedure Default;
  end;

var
  SQLConventions: TSQLConventions;

implementation

{ TSQLConventions }

procedure TSQLConventions.Default;
begin
  FormatDateSQL := DEFALT_FORMAT_DATESQL;
  PrimaryKeyName := DEFAULT_PRIMARYKEY_NAME;
  ForeingKeyName := DEFAULT_FOREINGKEY_NAME;
end;

initialization
  SQLConventions := TSQLConventions.Create;
  SQLConventions.Default;

finalization
  SQLConventions.Free;

end.
