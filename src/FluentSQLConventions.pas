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
  DEFALT_FORMAT_DATETIMESQL = 'MM/dd/yyyy hh:mm:ss';
  DEFAULT_PRIMARYKEY_NAME = 'ID';
  DEFAULT_FOREINGKEY_NAME = VAR_TABLE + '_ID';

type
  TSQLConventions = class
  public
    FormatDateTimeSQL: string;
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
  FormatDateTimeSQL := DEFALT_FORMAT_DATETIMESQL;
  PrimaryKeyName := DEFAULT_PRIMARYKEY_NAME;
  ForeingKeyName := DEFAULT_FOREINGKEY_NAME;
end;

initialization
  SQLConventions := TSQLConventions.Create;
  SQLConventions.Default;

finalization
  SQLConventions.Free;

end.
