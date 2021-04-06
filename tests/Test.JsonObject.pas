
{$i deltics.inc}

  unit Test.JsonObject;


interface

  uses
    Deltics.Smoketest;


  type
    JsonObjects = class(TTest)
      procedure SetupTest;
      procedure TeardownTest;
      procedure ContainsYieldsJsonValueThatExists;
      procedure ContainsYieldsArrayThatExists;
      procedure ContainsYieldsBooleanThatExists;
      procedure ContainsYieldsDoubleThatExists;
      procedure ContainsYieldsIntegerThatExists;
      procedure ContainsYieldsObjectThatExists;
      procedure ContainsYieldsUnicodeStringThatExists;
      procedure ContainsYieldsUnicodeStringArrayThatExists;
    end;


implementation

  uses
    Deltics.Json,
    Deltics.Unicode;



  var
    o: IJsonObject;



{ JsonObjects }

  procedure JsonObjects.SetupTest;
  begin
    o := JsonObject.FromString('{'
                              + 'aString: "string value",'
                              + 'anInteger: 42,'
                              + 'aBoolean: true,'
                              + 'aFloat: 4.2,'
                              + 'aNull: null,'
                              + 'anEmptyObject: {},'
                              + 'anObjectWithFoo: {foo: "bar"},'
                              + 'anEmptyArray: [],'
                              + 'aStringArray: ["string1", "string2"]'
                              + '}');
  end;


  procedure JsonObjects.TeardownTest;
  begin
    o := NIL;
  end;


  procedure JsonObjects.ContainsYieldsArrayThatExists;
  var
    sut: IJsonArray;
  begin
    Test('Contains[''anEmptyArray'']').Assert(o.Contains('anEmptyArray', sut)).IsTrue;
    Test('sut').Assert(sut).IsAssigned;
    Test('sut').Assert(sut).Supports(IJsonArray);
  end;


  procedure JsonObjects.ContainsYieldsBooleanThatExists;
  var
    sut: Boolean;
  begin
    Test('Contains[''aBoolean'']').Assert(o.Contains('aBoolean', sut)).IsTrue;
    Test('sut').Assert(sut).IsTrue;
  end;


  procedure JsonObjects.ContainsYieldsDoubleThatExists;
  var
    sut: Double;
  begin
    Test('Contains[''aFloat'']').Assert(o.Contains('aFloat', sut)).IsTrue;
    Test('sut').AssertDouble(sut).Equals(4.2);
  end;


  procedure JsonObjects.ContainsYieldsIntegerThatExists;
  var
    sut: Integer;
  begin
    Test('Contains[''anInteger'']').Assert(o.Contains('anInteger', sut)).IsTrue;
    Test('sut').Assert(sut).Equals(42);
  end;


  procedure JsonObjects.ContainsYieldsJsonValueThatExists;
  var
    sut: IJsonValue;
  begin
    Test('Contains[''aString'']').Assert(o.Contains('aString', sut)).IsTrue;
    Test('sut').Assert(sut).IsAssigned;
  end;


  procedure JsonObjects.ContainsYieldsObjectThatExists;
  var
    sut: IJsonObject;
  begin
    Test('Contains[''anEmptyObject'']').Assert(o.Contains('anEmptyObject', sut)).IsTrue;
    Test('sut').Assert(sut).IsAssigned;
    Test('sut').Assert(sut).Supports(IJsonObject);
  end;


  procedure JsonObjects.ContainsYieldsUnicodeStringArrayThatExists;
  var
    sut: UnicodeStringArray;
  begin
    Test('Contains[''aStringArray'']').Assert(o.Contains('aStringArray', sut)).IsTrue;
    Test('sut').Assert(Length(sut)).Equals(2);
    Test('sut[0]').Assert(sut[0]).Equals('string1');
    Test('sut[1]').Assert(sut[1]).Equals('string2');
  end;


  procedure JsonObjects.ContainsYieldsUnicodeStringThatExists;
  var
    sut: UnicodeString;
  begin
    Test('Contains[''aString'']').Assert(o.Contains('aString', sut)).IsTrue;
    Test('sut').Assert(sut).Equals('string value');
  end;










end.
