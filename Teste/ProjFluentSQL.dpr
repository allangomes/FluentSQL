program ProjFluentSQL;

uses
  Forms,
  MainTeste in 'MainTeste.pas' {Form7},
  FluentSQLConventions in '..\src\FluentSQLConventions.pas',
  FluentSQLExceptions in '..\src\FluentSQLExceptions.pas',
  FluentSQLInterfaces in '..\src\FluentSQLInterfaces.pas',
  FluentSQL in '..\src\FluentSQL.pas',
  FluentSQLTypes in '..\src\FluentSQLTypes.pas',
  FluentSQLUtils in '..\src\FluentSQLUtils.pas',
  FluentSQLWhere in '..\src\FluentSQLWhere.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm7, Form7);
  Application.Run;
end.

