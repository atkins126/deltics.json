
{$i deltics.json.inc}

  unit Deltics.Json.Factories;


interface

  uses
    Deltics.Strings,
    Deltics.Json.Interfaces;


  type
    JsonBoolean = class
    public
      class function Create(const aValue: Boolean): IJsonValue; {$ifdef InlineMethods} inline; {$endif}
    end;


    JsonNull = class
    public
      class function Create: IJsonValue; {$ifdef InlineMethods} inline; {$endif}
    end;


    JsonNumber = class
    public
      class function Create(const aValue: Double): IJsonValue; overload; {$ifdef InlineMethods} inline; {$endif}
      class function Create(const aValue: Extended): IJsonValue; overload; {$ifdef InlineMethods} inline; {$endif}
      class function Create(const aValue: Cardinal): IJsonValue; overload; {$ifdef InlineMethods} inline; {$endif}
      class function Create(const aValue: Integer): IJsonValue; overload; {$ifdef InlineMethods} inline; {$endif}
      class function Create(const aValue: Int64): IJsonValue; overload; {$ifdef InlineMethods} inline; {$endif}
    end;


    JsonArray = class
    public
      class function Create: IJsonArray; reintroduce;
      class function FromString(const aString: UnicodeString): IJsonArray;
    end;


    JsonObject = class
    public
      class function Create: IJsonObject; reintroduce;
      class function FromString(const aString: UnicodeString): IJsonObject;
    end;


    JsonString = class
    public
      class function Create(const aValue: AnsiString): IJsonValue; overload; {$ifdef InlineMethods} inline; {$endif}
      class function Create(const aValue: UnicodeString): IJsonValue; overload; {$ifdef InlineMethods} inline; {$endif}
    {$ifdef UNICODE}
      class function Create(const aValue: Utf8String): IJsonValue; overload; {$ifdef InlineMethods} inline; {$endif}
    {$endif}
      class function Decode(const aValue: Utf8String): UnicodeString; {$ifdef InlineMethods} inline; {$endif}
      class function Encode(const aValue: UnicodeString): Utf8String; {$ifdef InlineMethods} inline; {$endif}
    end;



implementation

  uses
    Deltics.Json.Array_,
    Deltics.Json.Object_,
    Deltics.Json.Reader,
    Deltics.Json.Utils,
    Deltics.Json.Value;



  class function JsonArray.Create: IJsonArray;
  begin
    result := TJsonArray.Create;
  end;


  class function JsonArray.FromString(const aString: UnicodeString): IJsonArray;
  begin
    result := Json.FromString(aString) as IJsonArray;
  end;




  class function JsonBoolean.Create(const aValue: Boolean): IJsonValue;
  begin
    result := TJsonValue.Create;
    result.AsBoolean := aValue;
  end;





  class function JsonNull.Create: IJsonValue;
  begin
    result := TJsonValue.Create;
  end;




  class function JsonNumber.Create(const aValue: Cardinal): IJsonValue;
  begin
    result := TJsonValue.Create;
    result.AsCardinal := aValue;
  end;


  class function JsonNumber.Create(const aValue: Double): IJsonValue;
  begin
    result := TJsonValue.Create;
    result.AsDouble := aValue;
  end;


  class function JsonNumber.Create(const aValue: Extended): IJsonValue;
  begin
    result := TJsonValue.Create;
    result.AsExtended := aValue;
  end;


  class function JsonNumber.Create(const aValue: Integer): IJsonValue;
  begin
    result := TJsonValue.Create;
    result.AsInteger := aValue;
  end;


  class function JsonNumber.Create(const aValue: Int64): IJsonValue;
  begin
    result := TJsonValue.Create;
    result.AsInt64 := aValue;
  end;




{ JsonObject }

  class function JsonObject.Create: IJsonObject;
  begin
    result := TJsonObject.Create;
  end;


  class function JsonObject.FromString(const aString: UnicodeString): IJsonObject;
  begin
    result := Json.FromString(aString) as IJsonObject;
  end;






  class function JsonString.Create(const aValue: AnsiString): IJsonValue;
  begin
    result := TJsonValue.Create;
    result.AsString := Wide.FromAnsi(aValue);
  end;


  class function JsonString.Create(const aValue: UnicodeString): IJsonValue;
  begin
    result := TJsonValue.Create;
    result.AsString := aValue;
  end;


{$ifdef UNICODE}
  class function JsonString.Create(const aValue: Utf8String): IJsonValue;
  begin
    result := TJsonValue.Create;
    result.Value := aValue;
  end;
{$endif}


  class function JsonString.Decode(const aValue: Utf8String): UnicodeString;
  begin
    result := Json.DecodeString(aValue);
  end;


  class function JsonString.Encode(const aValue: UnicodeString): Utf8String;
  begin
    result := Json.EncodeString(aValue);
  end;








end.
