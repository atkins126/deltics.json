
{$i deltics.inc}

unit Test.BuildingJson;

interface

  uses
    Deltics.Smoketest;


  type
    BuildingJson = class(TTest)
      procedure CreateEmptyObject;
      procedure AddStringToObjectAsJsonString;
      procedure AddStringToObjectAsString;
      procedure AddIntegerToObjectAsJsonNumber;
      procedure AccessingMemberThatDoesNotExistYieldsNullValue;
      procedure SettingMemberThatDoesNotExistAddsTheMember;
      procedure SettingMemberWithValueOfDifferentTypeChangesValueType;
    end;

implementation

  uses
    Deltics.Strings,
    Deltics.Json;


{ BuildingJson }

  procedure BuildingJson.AddStringToObjectAsJsonString;
  var
    sut: IJsonObject;
  begin
    sut := JsonObject.Create;
    sut.Add('foo', JsonString.Create('bar'));

    Test('sut.Count').Assert(sut.Count).Equals(1);
    Test('sut[''foo'']').AssertUtf8(sut['foo'].Value).Equals('bar');
  end;


  procedure BuildingJson.AddStringToObjectAsString;
  var
    sut: IJsonObject;
  begin
    sut := JsonObject.Create;
    sut.Add('foo', JsonString.Create('bar'));

    Test('sut.Count').Assert(sut.Count).Equals(1);
    Test('sut[''foo'']').AssertUtf8(sut['foo'].Value).Equals('bar');
  end;


  procedure BuildingJson.AccessingMemberThatDoesNotExistYieldsNullValue;
  var
    sut: IJsonObject;
    v: IJsonValue;
  begin
    sut := JsonObject.Create;

    v := sut['foo'];

    Test('v').Assert(v).IsAssigned;
    Test('v.IsNull').Assert(v.IsNull).IsTrue;
  end;


  procedure BuildingJson.AddIntegerToObjectAsJsonNumber;
  var
    sut: IJsonObject;
  begin
    sut := JsonObject.Create;
    sut.Add('foo', JsonNumber.Create(42));

    Test('Count').Assert(sut.Count).Equals(1);
    Test('foo.AsInteger').Assert(sut['foo'].AsInteger).Equals(42);
    Test('foo.AsDouble').Assert(sut['foo'].AsDouble).Equals(42.0);
    Test('foo.AsString').Assert(sut['foo'].AsString).Equals('42');
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


  procedure BuildingJson.SettingMemberThatDoesNotExistAddsTheMember;
  var
    sut: IJsonObject;
  begin
    sut := JsonObject.Create;

    Test('foo.IsNull').Assert(sut['foo'].IsNull).IsTrue;
    Test('Count').Assert(sut.Count).Equals(0);

    sut['foo'].AsInteger := 42;

    Test('foo.IsNull').Assert(sut['foo'].IsNull).IsFalse;
    Test('foo.AsInteger').Assert(sut['foo'].AsInteger).Equals(42);
    Test('Count').Assert(sut.Count).Equals(1);
  end;


  procedure BuildingJson.SettingMemberWithValueOfDifferentTypeChangesValueType;
  var
    sut: IJsonObject;
  begin
    sut := JsonObject.Create;

    sut['foo'].AsInteger := 42;

    Test('foo.ValueType').Assert(Ord(sut['foo'].ValueType)).Equals(Ord(jsNumber));
    Test('foo.AsInteger').Assert(sut['foo'].AsInteger).Equals(42);
    Test('Count').Assert(sut.Count).Equals(1);

    sut['foo'].AsBoolean := TRUE;

    Test('foo.ValueType').Assert(Ord(sut['foo'].ValueType)).Equals(Ord(jsBoolean));
    Test('foo.AsInteger').Assert(sut['foo'].AsBoolean).IsTrue;
    Test('Count').Assert(sut.Count).Equals(1);
  end;




end.
