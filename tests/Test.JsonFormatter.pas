
{$i deltics.inc}

unit Test.JsonFormatter;

interface

  uses
    Deltics.Smoketest;


  type
    JsonFormatter = class(TTest)
      procedure FormatsEmptyArray;
      procedure FormatsEmptyObject;
      procedure FormatsBooleanArray;
      procedure FormatsBooleanObjectMembers;
      procedure FormatsBooleanObjectMembersAsConfig;
    end;

implementation

  uses
    Deltics.Strings,
    Deltics.Json;


  procedure JsonFormatter.FormatsEmptyArray;
  var
    value: IJsonArray;
    result: Utf8String;
  begin
    value   := JsonArray.New;
    result  := Json.AsUtf8(value);

    Test('array.IsEmpty').Assert(value.IsEmpty).IsTrue;
    Test('Json.AsUtf8(array)').AssertUtf8(result).Equals('[]');
  end;


  procedure JsonFormatter.FormatsEmptyObject;
  var
    value: IJsonObject;
    result: Utf8String;
  begin
    value   := JsonObject.New;
    result  := Json.AsUtf8(value);

    Test('object.IsEmpty').Assert(value.IsEmpty).IsTrue;
    Test('Json.AsUtf8(object)').AssertUtf8(result).Equals('{}');
  end;


  procedure JsonFormatter.FormatsBooleanArray;
  var
    value: IJsonArray;
    result: Utf8String;
  begin
    value := JsonArray.New;
    value.Add(JsonBoolean(false));
    value.Add(JsonBoolean(true));
    value.Add(JsonNull.New);

    result := Json.AsUtf8(value, jfCompact);

    Test('array.Count').Assert(value.Count).Equals(3);
    Test('Json.AsUtf8(array)').AssertUtf8(result).Equals('[false,true,null]');
  end;


  procedure JsonFormatter.FormatsBooleanObjectMembers;
  var
    value: IJsonObject;
    result: Utf8String;
  begin
    value   := JsonObject.New;
    value.Add('isFalse', JsonBoolean(false));
    value.Add('isTrue', JsonBoolean(true));
    value.Add('isNull', JsonNull.New);

    result  := Json.AsUtf8(value, jfCompact);

    Test('object.Count').Assert(value.Count).Equals(3);
    Test('Json.AsUtf8(object)').AssertUtf8(result).Equals('{"isFalse":false,"isTrue":true,"isNull":null}');
  end;


  procedure JsonFormatter.FormatsBooleanObjectMembersAsConfig;
  var
    value: IJsonObject;
    result: Utf8String;
  begin
    value   := JsonObject.New;
    value.Add('isFalse', JsonBoolean(false));
    value.Add('isTrue', JsonBoolean(true));
    value.Add('isNull', JsonNull.New);

    result  := Json.AsUtf8(value, jfConfig);

    Test('object.Count').Assert(value.Count).Equals(3);
    Test('object[0].Name').Assert(value.Items[0].Name).Equals('isFalse');
    Test('object[1].Name').Assert(value.Items[1].Name).Equals('isTrue');
    Test('object[2].Name').Assert(value.Items[2].Name).Equals('isNull');


    Test('Json.AsUtf8(object)').AssertUtf8(result).Equals(
      '{'#13#10
    + '  isFalse: false,'#13#10
    + '  isTrue: true,'#13#10
    + '  isNull: null'#13#10
    + '}');
  end;



end.
