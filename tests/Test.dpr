
{$define CONSOLE}

program Test;

{$i deltics.inc}

uses
  FastMM4,
  Deltics.Smoketest,
  Deltics.Json in '..\src\Deltics.Json.pas',
  Test.BuildingJson in 'Test.BuildingJson.pas',
  Deltics.Json.Interfaces in '..\src\Deltics.Json.Interfaces.pas',
  Deltics.Json.Object_ in '..\src\Deltics.Json.Object_.pas',
  Deltics.Json.Value in '..\src\Deltics.Json.Value.pas',
  Deltics.Json.Member in '..\src\Deltics.Json.Member.pas',
  Deltics.Json.String_ in '..\src\Deltics.Json.String_.pas',
  Deltics.Json.Collection in '..\src\Deltics.Json.Collection.pas';

begin
  TestRun.Test(BuildingJson);
end.

