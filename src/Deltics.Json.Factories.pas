
{$i deltics.json.inc}

  unit Deltics.Json.Factories;


interface

  uses
    Deltics.Strings,
    Deltics.Json.Types;


  type
    JsonArrayFactory = class
    public
      class function New: IJsonArray;
      class function FromFile(const aFilename: String): IJsonArray;
      class function FromString(const aString: UnicodeString): IJsonArray;
    end;
    JsonArray = class of JsonArrayFactory;


    JsonBooleanFactory = class
    public
      class function New: IJsonMutableValue;
      class function AsBoolean(const aValue: Boolean): IJsonMutableValue;
    end;
    JsonBoolean = class of JsonBooleanFactory;


    JsonNullFactory = class
    public
      class function New: IJsonMutableValue;
    end;
    JsonNull = class of JsonNullFactory;


    JsonNumberFactory = class
    public
      class function New: IJsonMutableValue;
      class function AsCardinal(const aValue: Cardinal): IJsonMutableValue;
      class function AsDouble(const aValue: Double): IJsonMutableValue;
      class function AsExtended(const aValue: Extended): IJsonMutableValue;
      class function AsInt64(const aValue: Int64): IJsonMutableValue;
      class function AsInteger(const aValue: Integer): IJsonMutableValue;
      class function AsSingle(const aValue: Single): IJsonMutableValue;
    end;
    JsonNumber = class of JsonNumberFactory;


    JsonObjectFactory = class
    public
      class function New: IJsonObject; reintroduce;
      class function FromFile(const aFilename: String): IJsonObject;
      class function FromString(const aString: UnicodeString): IJsonObject;
    end;
    JsonObject = class of JsonObjectFactory;


    JsonStringFactory = class
    public
      class function New: IJsonMutableValue;
      class function AsString(const aValue: UnicodeString): IJsonMutableValue;
      class function AsUtf8(const aValue: Utf8String): IJsonMutableValue;
      class function Decode(const aValue: UnicodeString): UnicodeString; overload;
      class function Decode(const aValue: Utf8String): UnicodeString; overload;
      class function Encode(const aValue: UnicodeString; const aQuoted: Boolean = TRUE): UnicodeString;
      class function EncodeUtf8(const aValue: UnicodeString; const aQuoted: Boolean = TRUE): Utf8String;
    end;
    JsonString = class of JsonStringFactory;



implementation

  uses
    Deltics.Json.Array_,
    Deltics.Json.Object_,
    Deltics.Json.Reader,
    Deltics.Json.Utils,
    Deltics.Json.Value;



{ JsonArrayFactory ------------------------------------------------------------------------------- }

  class function JsonArrayFactory.New: IJsonArray;
  begin
    result := TJsonArray.Create;
  end;


  class function JsonArrayFactory.FromFile(const aFilename: String): IJsonArray;
  begin
    result := Json.FromFile(aFilename) as IJsonArray;
  end;


  class function JsonArrayFactory.FromString(const aString: UnicodeString): IJsonArray;
  begin
    result := Json.FromString(aString) as IJsonArray;
  end;






{ JsonBooleanFactory ----------------------------------------------------------------------------- }

  class function JsonBooleanFactory.New: IJsonMutableValue;
  begin
    result := TJsonValue.Create;
    result.AsBoolean := FALSE;
  end;


  class function JsonBooleanFactory.AsBoolean(const aValue: Boolean): IJsonMutableValue;
  begin
    result := TJsonValue.Create;
    result.AsBoolean := aValue;
  end;






{ JsonNullFactory -------------------------------------------------------------------------------- }

  class function JsonNullFactory.New: IJsonMutableValue;
  begin
    result := TJsonValue.Create;
  end;





{ JsonNumberFactory ------------------------------------------------------------------------------ }

  class function JsonNumberFactory.New: IJsonMutableValue;
  begin
    result := TJsonValue.Create;
    result.AsInteger := 0;
  end;


  class function JsonNumberFactory.AsCardinal(const aValue: Cardinal): IJsonMutableValue;
  begin
    result := TJsonValue.Create;
    result.AsCardinal := aValue;
  end;


  class function JsonNumberFactory.AsDouble(const aValue: Double): IJsonMutableValue;
  begin
    result := TJsonValue.Create;
    result.AsDouble := aValue;
  end;


  class function JsonNumberFactory.AsExtended(const aValue: Extended): IJsonMutableValue;
  begin
    result := TJsonValue.Create;
    result.AsExtended := aValue;
  end;


  class function JsonNumberFactory.AsInt64(const aValue: Int64): IJsonMutableValue;
  begin
    result := TJsonValue.Create;
    result.AsInt64 := aValue;
  end;


  class function JsonNumberFactory.AsInteger(const aValue: Integer): IJsonMutableValue;
  begin
    result := TJsonValue.Create;
    result.AsInteger := aValue;
  end;


  class function JsonNumberFactory.AsSingle(const aValue: Single): IJsonMutableValue;
  begin
    result := TJsonValue.Create;
    result.AsSingle := aValue;
  end;





{ JsonObjectFactory ------------------------------------------------------------------------------ }

  class function JsonObjectFactory.New: IJsonObject;
  begin
    result := TJsonObject.Create;
  end;


  class function JsonObjectFactory.FromFile(const aFilename: String): IJsonObject;
  begin
    result := Json.FromFile(aFilename) as IJsonObject;
  end;


  class function JsonObjectFactory.FromString(const aString: UnicodeString): IJsonObject;
  begin
    result := Json.FromString(aString) as IJsonObject;
  end;





{ JsonStringFactory ------------------------------------------------------------------------------ }

  class function JsonStringFactory.New: IJsonMutableValue;
  begin
    result := TJsonValue.Create;
    result.AsString := '';
  end;


  class function JsonStringFactory.AsString(const aValue: UnicodeString): IJsonMutableValue;
  begin
    result := TJsonValue.Create;
    result.AsString := aValue;
  end;


  class function JsonStringFactory.AsUtf8(const aValue: Utf8String): IJsonMutableValue;
  begin
    result := TJsonValue.Create;
    result.AsUtf8 := aValue;
  end;


  class function JsonStringFactory.Decode(const aValue: Utf8String): UnicodeString;
  begin
    result := Json.DecodeString(aValue);
  end;


  class function JsonStringFactory.Decode(const aValue: UnicodeString): UnicodeString;
  begin
    result := Json.DecodeString(aValue);
  end;


  class function JsonStringFactory.Encode(const aValue: UnicodeString;
                                          const aQuoted: Boolean): UnicodeString;
  begin
    if aQuoted then
      result := Json.EncodeString(aValue)
    else
      result := Json.EncodeStringContent(aValue);
  end;


  class function JsonStringFactory.EncodeUtf8(const aValue: UnicodeString;
                                              const aQuoted: Boolean): Utf8String;
  begin
    if aQuoted then
      result := Json.EncodeUtf8Quoted(aValue)
    else
      result := Json.EncodeUtf8(aValue);
  end;










end.
