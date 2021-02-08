
{$define CONSOLE}

program Test;

{$i deltics.inc}

uses
  FastMM4,
  Deltics.Smoketest,
  Deltics.Json in '..\src\Deltics.Json.pas',
  Deltics.Json.Array_ in '..\src\Deltics.Json.Array_.pas',
  Deltics.Json.Collection in '..\src\Deltics.Json.Collection.pas',
  Deltics.Json.Exceptions in '..\src\Deltics.Json.Exceptions.pas',
  Deltics.Json.Factories in '..\src\Deltics.Json.Factories.pas',
  Deltics.Json.Formatter in '..\src\Deltics.Json.Formatter.pas',
  Deltics.Json.Interfaces in '..\src\Deltics.Json.Interfaces.pas',
  Deltics.Json.Member in '..\src\Deltics.Json.Member.pas',
  Deltics.Json.MemberValue in '..\src\Deltics.Json.MemberValue.pas',
  Deltics.Json.Object_ in '..\src\Deltics.Json.Object_.pas',
  Deltics.Json.Reader in '..\src\Deltics.Json.Reader.pas',
  Deltics.Json.Value in '..\src\Deltics.Json.Value.pas',
  Deltics.Json.Utils in '..\src\Deltics.Json.Utils.pas',
  Test.BuildingJson in 'Test.BuildingJson.pas',
  Test.NumberConversions in 'Test.NumberConversions.pas',
  Test.JsonReader in 'Test.JsonReader.pas';

begin
  TestRun.Test(BuildingJson);
  TestRun.Test(NumberConversions);
  TestRun.Test(JsonReader);
end.

