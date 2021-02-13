
{$i deltics.inc}

  unit Test.DefaultValues;


interface

  uses
    Deltics.Smoketest;


  type
    DefaultValues = class(TTest)
      procedure OrDefaultDoesNotSubstituteValueWhenMemberValueExists;
      procedure OrDefaultDoesNotSubstituteValueWhenMemberValueExistsAndIsNull;
      procedure OrDefaultSubstitutesValueWhenMemberValueDoesNotExist;
    end;


implementation

  uses
    Deltics.Strings,
    Deltics.Json;






{ DefaultValues }

  procedure DefaultValues.OrDefaultDoesNotSubstituteValueWhenMemberValueExists;
  var
    obj: IJsonObject;
    sut: IJsonValue;
  begin
    obj := JsonObject.New;
    obj['foo'].AsString := 'exists';

    sut := obj['foo'].OrDefault(JsonString('default'));

    Test('obj.Count').Assert(obj.Count).Equals(1);
    Test('sut.AsString').Assert(sut.AsString).Equals('exists');
  end;


  procedure DefaultValues.OrDefaultDoesNotSubstituteValueWhenMemberValueExistsAndIsNull;
  var
    obj: IJsonObject;
    sut: IJsonValue;
  begin
    obj := JsonObject.New;
    obj.Add('foo', JsonNull.New);

    sut := obj['foo'].OrDefault(JsonString('default'));

    Test('obj.Count').Assert(obj.Count).Equals(1);
    Test('sut.IsNull').Assert(sut.IsNull).IsTrue;
  end;


  procedure DefaultValues.OrDefaultSubstitutesValueWhenMemberValueDoesNotExist;
  var
    obj: IJsonObject;
    sut: IJsonValue;
  begin
    obj := JsonObject.New;

    sut := obj['foo'].OrDefault(JsonString('default'));

    Test('obj.Count').Assert(obj.Count).Equals(0);
    Test('sut.AsString').Assert(sut.AsString).Equals('default');
  end;





end.
