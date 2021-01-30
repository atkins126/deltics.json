
{$i deltics.inc}

unit Test.BuildingJson;

interface

  uses
    Deltics.Smoketest;


  type
    BuildingJson = class(TTest)
      procedure CreateEmptyObject;
      procedure AddNamedStringToObject;
    end;

implementation

  uses
    Deltics.Json;


{ BuildingJson }

  procedure BuildingJson.AddNamedStringToObject;
  var
    sut: IJsonObject;
  begin
    sut := JsonObject.Create;
    sut.Add('foo', JsonString.Create('bar'));

    Test('sut.Count').Assert(sut.Count).Equals(1);
    Test('sut[''foo'']').Assert(sut['foo']).Supports(IJsonString);
    Test('sut[''foo'']').Assert((sut['foo'] as IJsonString).Value).Equals('bar');
  end;


  procedure BuildingJson.CreateEmptyObject;
  var
    sut: IJsonObject;
  begin
    sut := JsonObject.Create;

    Test('sut').Assert(sut).IsNotNIL;
    Test('sut.ValueType').Assert(Ord(sut.ValueType)).Equals(Ord(jsObject));
    Test('sut.IsEmpty').Assert(sut.IsEmpty).IsTrue;
  end;




end.
