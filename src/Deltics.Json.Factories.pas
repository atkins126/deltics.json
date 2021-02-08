
{$i deltics.json.inc}

  unit Deltics.Json.Factories;


interface

  uses
    Deltics.Strings,
    Deltics.Json.Interfaces;


  type
    JsonArrayFactory = class
    public
      class function New: IJsonArray;
      class function FromString(const aString: UnicodeString): IJsonArray;
    end;
    JsonArray = class of JsonArrayFactory;


    JsonBooleanFactory = class
    public
      class function New: IJsonValue;
      class function AsBoolean(const aValue: Boolean): IJsonValue;
    end;
    JsonBoolean = class of JsonBooleanFactory;


    JsonNullFactory = class
    public
      class function New: IJsonValue;
    end;
    JsonNull = class of JsonNullFactory;


    JsonNumberFactory = class
    public
      class function New: IJsonValue;
      class function AsCardinal(const aValue: Cardinal): IJsonValue;
      class function AsDouble(const aValue: Double): IJsonValue;
      class function AsExtended(const aValue: Extended): IJsonValue;
      class function AsInt64(const aValue: Int64): IJsonValue;
      class function AsInteger(const aValue: Integer): IJsonValue;
      class function AsSingle(const aValue: Single): IJsonValue;
    end;
    JsonNumber = class of JsonNumberFactory;


    JsonObjectFactory = class
    public
      class function New: IJsonObject; reintroduce;
      class function FromString(const aString: UnicodeString): IJsonObject;
    end;
    JsonObject = class of JsonObjectFactory;


    JsonStringFactory = class
    public
      class function New: IJsonValue;
      class function AsString(const aValue: UnicodeString): IJsonValue;
      class function AsUtf8(const aValue: Utf8String): IJsonValue;
      class function Decode(const aValue: Utf8String): UnicodeString;
      class function Encode(const aValue: UnicodeString): Utf8String;
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


  class function JsonArrayFactory.FromString(const aString: UnicodeString): IJsonArray;
  begin
    result := Json.FromString(aString) as IJsonArray;
  end;






{ JsonBooleanFactory ----------------------------------------------------------------------------- }

  class function JsonBooleanFactory.New: IJsonValue;
  begin
    result := TJsonValue.Create;
    result.AsBoolean := FALSE;
  end;


  class function JsonBooleanFactory.AsBoolean(const aValue: Boolean): IJsonValue;
  begin
    result := TJsonValue.Create;
    result.AsBoolean := aValue;
  end;






{ JsonNullFactory -------------------------------------------------------------------------------- }

  class function JsonNullFactory.New: IJsonValue;
  begin
    result := TJsonValue.Create;
  end;





{ JsonNumberFactory ------------------------------------------------------------------------------ }

  class function JsonNumberFactory.New: IJsonValue;
  begin
    result := TJsonValue.Create;
    result.AsInteger := 0;
  end;


  class function JsonNumberFactory.AsCardinal(const aValue: Cardinal): IJsonValue;
  begin
    result := TJsonValue.Create;
    result.AsCardinal := aValue;
  end;


  class function JsonNumberFactory.AsDouble(const aValue: Double): IJsonValue;
  begin
    result := TJsonValue.Create;
    result.AsDouble := aValue;
  end;


  class function JsonNumberFactory.AsExtended(const aValue: Extended): IJsonValue;
  begin
    result := TJsonValue.Create;
    result.AsExtended := aValue;
  end;


  class function JsonNumberFactory.AsInt64(const aValue: Int64): IJsonValue;
  begin
    result := TJsonValue.Create;
    result.AsInt64 := aValue;
  end;


  class function JsonNumberFactory.AsInteger(const aValue: Integer): IJsonValue;
  begin
    result := TJsonValue.Create;
    result.AsInteger := aValue;
  end;


  class function JsonNumberFactory.AsSingle(const aValue: Single): IJsonValue;
  begin
    result := TJsonValue.Create;
    result.AsSingle := aValue;
  end;





{ JsonObjectFactory ------------------------------------------------------------------------------ }

  class function JsonObjectFactory.New: IJsonObject;
  begin
    result := TJsonObject.Create;
  end;


  class function JsonObjectFactory.FromString(const aString: UnicodeString): IJsonObject;
  begin
    result := Json.FromString(aString) as IJsonObject;
  end;





{ JsonStringFactory ------------------------------------------------------------------------------ }

  class function JsonStringFactory.New: IJsonValue;
  begin
    result := TJsonValue.Create;
    result.AsString := '';
  end;


  class function JsonStringFactory.AsString(const aValue: UnicodeString): IJsonValue;
  begin
    result := TJsonValue.Create;
    result.AsString := aValue;
  end;


  class function JsonStringFactory.AsUtf8(const aValue: Utf8String): IJsonValue;
  begin
    result := TJsonValue.Create;
    result.AsUtf8 := aValue;
  end;


  class function JsonStringFactory.Decode(const aValue: Utf8String): UnicodeString;
  begin
    result := Json.DecodeString(aValue);
  end;


  class function JsonStringFactory.Encode(const aValue: UnicodeString): Utf8String;
  begin
    result := Json.EncodeString(aValue);
  end;









end.
