
{$i deltics.inc}

unit Test.JsonReader;

interface

  uses
    Deltics.Smoketest;


  type
    JsonReader = class(TTest)
      procedure ReadsEmptyArray;
      procedure ReadsEmptyObject;
      procedure ReadsBooleanArray;
      procedure ReadsBooleanObjectMembers;
      procedure ReadsBooleanObjectMembersAsConfig;
    end;

implementation

  uses
    Deltics.Strings,
    Deltics.Json;


  procedure JsonReader.ReadsEmptyArray;
  var
    sut: IJsonArray;
  begin
    sut := JsonArray.FromString('[]');

    Test('Count').Assert(sut.Count).Equals(0);
    Test('IsEmpty').Assert(sut.IsEmpty).IsTrue;
    Test('IsNull').Assert(sut.IsNull).IsFalse;
  end;


  procedure JsonReader.ReadsEmptyObject;
  var
    sut: IJsonObject;
  begin
    sut := JsonObject.FromString('{}');

    Test('Count').Assert(sut.Count).Equals(0);
    Test('IsEmpty').Assert(sut.IsEmpty).IsTrue;
    Test('IsNull').Assert(sut.IsNull).IsFalse;
  end;


  procedure JsonReader.ReadsBooleanArray;
  var
    sut: IJsonArray;
  begin
    sut := JsonArray.FromString('[false,true,null]');

    Test('sut.Count').Assert(sut.Count).Equals(3);

    Test('sut[0].AsBoolean').Assert(sut[0].AsBoolean).IsFalse;
    Test('sut[1].AsBoolean').Assert(sut[1].AsBoolean).IsTrue;

    Test('sut[0].IsNull').Assert(sut[0].IsNull).IsFalse;
    Test('sut[1].IsNull').Assert(sut[0].IsNull).IsFalse;
    Test('sut[2].IsNull').Assert(sut[2].IsNull).IsTrue;
  end;


  procedure JsonReader.ReadsBooleanObjectMembers;
  var
    sut: IJsonObject;
  begin
    sut := JsonObject.FromString('{"isFalse":false,"isTrue":true,"isNull":null}');

    Test('sut.Count').Assert(sut.Count).Equals(3);

    Test('sut[''isFalse''].AsBoolean').Assert(sut['isFalse'].AsBoolean).IsFalse;
    Test('sut[''isTrue''].AsBoolean').Assert(sut['isTrue'].AsBoolean).IsTrue;

    Test('sut[''isFalse''].IsNull').Assert(sut['isFalse'].IsNull).IsFalse;
    Test('sut[''isTrue''].IsNull').Assert(sut['isTrue'].IsNull).IsFalse;
    Test('sut[''isNull''].IsNull').Assert(sut['isNull'].IsNull).IsTrue;
  end;


  procedure JsonReader.ReadsBooleanObjectMembersAsConfig;
  var
    sut: IJsonObject;
  begin
    sut := JsonObject.FromString('{isFalse:false,isTrue:true,isNull:null}');

    Test('sut.Count').Assert(sut.Count).Equals(3);

    Test('sut[''isFalse''].AsBoolean').Assert(sut['isFalse'].AsBoolean).IsFalse;
    Test('sut[''isTrue''].AsBoolean').Assert(sut['isTrue'].AsBoolean).IsTrue;

    Test('sut[''isFalse''].IsNull').Assert(sut['isFalse'].IsNull).IsFalse;
    Test('sut[''isTrue''].IsNull').Assert(sut['isTrue'].IsNull).IsFalse;
    Test('sut[''isNull''].IsNull').Assert(sut['isNull'].IsNull).IsTrue;
  end;



end.
