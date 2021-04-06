
{$i deltics.inc}

  unit Test.JsonArray;


interface

  uses
    Deltics.Smoketest;


  type
    JsonArrays = class(TTest)
      procedure SetupTest;
      procedure TeardownTest;
      procedure EmptyArrayHasCountOfZero;
      procedure NonEmptyArrayFirstYieldsFirstItem;
      procedure NonEmptyArrayLastYieldsLastItem;
    end;


implementation

  uses
    Deltics.Json;



  var
    empty: IJsonArray;
    nonEmpty: IJsonArray;



{ JsonObjects }

  procedure JsonArrays.NonEmptyArrayFirstYieldsFirstItem;
  var
    sut: IJsonValue;
  begin
    sut := nonEmpty.First;

    Test('nonEmpty.First').Assert(sut).IsAssigned;
    Test('nonEmpty.First.AsString').Assert(sut.AsString).Equals('string1');
  end;


  procedure JsonArrays.NonEmptyArrayLastYieldsLastItem;
  var
    sut: IJsonValue;
  begin
    sut := nonEmpty.Last;

    Test('nonEmpty.Last').Assert(sut).IsAssigned;
    Test('nonEmpty.Last.AsString').Assert(sut.AsString).Equals('string3');
  end;


  procedure JsonArrays.SetupTest;
  begin
    empty     := JsonArray.FromString('[]');
    nonEmpty  := JsonArray.FromString('["string1", "string2", "string3"]');
  end;


  procedure JsonArrays.TeardownTest;
  begin
    empty     := NIL;
    nonEmpty  := NIL;
  end;


  procedure JsonArrays.EmptyArrayHasCountOfZero;
  begin
    Test('empty.Count').Assert(empty.Count).Equals(0);
  end;











end.
