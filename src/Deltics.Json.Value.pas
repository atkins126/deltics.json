
{$i deltics.json.inc}

  unit Deltics.Json.Value;


interface

  uses
    TypInfo,
    Deltics.InterfacedObjects,
    Deltics.Strings,
    Deltics.Json.Exceptions,
    Deltics.Json.Interfaces;


  type
    TJsonValue = class(TComInterfacedObject, IJsonValue)
    // IJsonValue
    protected
      function get_AsBoolean: Boolean;
      function get_AsCardinal: Cardinal; virtual;
      function get_AsDate: TDate;
      function get_AsTime: TTime;
      function get_AsDateTime: TDateTime;
      function get_AsDouble: Double; virtual;
      function get_AsEnum(const aTypeInfo: PTypeInfo): Integer;
      function get_AsExtended: Extended; virtual;
      function get_AsGuid: TGuid;
      function get_AsInt64: Int64; virtual;
      function get_AsInteger: Integer; virtual;
      function get_AsString: UnicodeString;
      function get_IsNull: Boolean;
      function get_Value: Utf8String;
      function get_ValueType: TValueType;
      procedure set_AsBoolean(const aValue: Boolean);
      procedure set_AsCardinal(const aValue: Cardinal); virtual;
      procedure set_AsDate(const aValue: TDate);
      procedure set_AsTime(const aValue: TTime);
      procedure set_AsDateTime(const aValue: TDateTime);
      procedure set_AsDouble(const aValue: Double); virtual;
      procedure set_AsExtended(const aValue: Extended); virtual;
      procedure set_AsGuid(const aValue: TGuid);
      procedure set_AsInt64(const aValue: Int64); virtual;
      procedure set_AsInteger(const aValue: Integer); virtual;
      procedure set_AsString(const aValue: UnicodeString);
      procedure set_Value(const aValue: Utf8String);

    private
      fAsString: UnicodeString;
      fIsNull: Boolean;
      fValue: Utf8String;
      fValueType: TValueType;
    protected
      constructor CreateArray;
      constructor CreateObject;
      procedure ErrorIfNull(ExceptionClass: EJsonClass = NIL);
      function DoGetAsString: UnicodeString; virtual;
      procedure DoSetAsString(const aValue: UnicodeString); virtual;
      procedure SetNull;
      procedure SetValue(const aValueType: TValueType; const aValueAsString: UnicodeString);
    public
      constructor Create;
      property AsBoolean: Boolean read get_AsBoolean write set_AsBoolean;
      property AsCardinal: Cardinal read get_AsCardinal write set_AsCardinal;
      property AsDateTime: TDateTime read get_AsDateTime write set_AsDateTime;
      property AsDouble: Double read get_AsDouble write set_AsDouble;
      property AsEnum[const aTypeInfo: PTypeInfo]: Integer read get_AsEnum;
      property AsExtended: Extended read get_AsExtended write set_AsExtended;
      property AsGuid: TGuid read get_AsGuid write set_AsGuid;
      property AsInt64: Int64 read get_AsInt64 write set_AsInt64;
      property AsInteger: Integer read get_AsInteger write set_AsInteger;
      property AsString: UnicodeString read fAsString write set_AsString;
      property IsNull: Boolean read get_IsNull;
      property Value: Utf8String read fValue write set_Value;
      property ValueType: TValueType read get_ValueType;
    end;



implementation

  uses
    SysUtils,
    Deltics.DateTime,
    Deltics.Guids,
    Deltics.Json.Utils;


  const
    VALUETYPENAME : array[jsObject..jsNull] of String = ('Object', 'Array', 'String', 'Number', 'Boolean', 'Null');


{ TJsonValue }

  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  constructor TJsonValue.Create;
  begin
    inherited;

    fIsNull     := TRUE;
    fValueType  := jsNull;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  constructor TJsonValue.CreateArray;
  begin
    inherited Create;

    fValueType := jsArray;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  constructor TJsonValue.CreateObject;
  begin
    inherited Create;

    fValueType := jsObject;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonValue.DoGetAsString: UnicodeString;
  begin
    if IsNull then
      result := 'null'
    else
      result := Wide.FromUtf8(fValue);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonValue.DoSetAsString(const aValue: UnicodeString);
  begin
    if (aValue = 'null') then
      SetNull
    else
      Value := Utf8.FromString(aValue);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonValue.ErrorIfNull(ExceptionClass: EJsonClass);
  begin
    if IsNull then
    begin
      if ExceptionClass = NIL then
        ExceptionClass := EJsonConvertError;

      raise ExceptionClass.Create('Value is null');
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonValue.get_AsBoolean: Boolean;
  var
    s: UnicodeString;
  begin
    ErrorIfNull;

    case ValueType of
      jsBoolean : result := (Value = 'true');
      jsString  : begin
                    s := Str.Lowercase(AsString);
                    if (s = 'true') then        result := TRUE
                     else if (s = 'false') then result := FALSE
                    else
                      raise EJsonConvertError.CreateFmt('''%s'' is not a valid Boolean value', [AsString]);
                  end;

    else
      raise EJsonConvertError.Create('Value is not a Boolean or String');
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonValue.get_AsCardinal: Cardinal;
  var
    i: Int64;
  begin
    ErrorIfNull;

    case ValueType of
      jsNumber,
      jsString  : begin
                    i := Cardinal(AsInt64);
                    if (i < Low(Integer)) or (i > High(Integer)) then
                      raise EJsonConvertError.CreateFmt('''%s'' cannot be expressed as a Cardinal', [AsString]);

                    result := Integer(i);
                  end;
    else
      raise EJsonConvertError.CreateFmt('''%s'' cannot be expressed as a Cardinal', [AsString]);
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonValue.get_AsDate: TDate;
  begin
    ErrorIfNull;

    case ValueType of
      jsString  : result := DateTimeFromISO8601(AsString, [dtDate]);
    else
      raise EJsonConvertError.CreateFmt('''%s'' cannot be expressed as a Date', [AsString]);
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonValue.get_AsTime: TTime;
  begin
    ErrorIfNull;

    case ValueType of
      jsString  : result := DateTimeFromISO8601(AsString, [dtTime]);
    else
      raise EJsonConvertError.CreateFmt('''%s'' cannot be expressed as a Time', [AsString]);
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonValue.get_AsDateTime: TDateTime;
  begin
    ErrorIfNull;

    case ValueType of
      jsString  : result := DateTimeFromISO8601(AsString, [dtDate, dtTime]);
    else
      raise EJsonConvertError.CreateFmt('''%s'' cannot be expressed as a Date/Time', [AsString]);
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonValue.get_AsDouble: Double;
  const
    MaxDouble: Double =  1.7976931348623157E+308;
    MinDouble: Double = -1.7976931348623157E+308;
  var
    e: Extended;
  begin
    ErrorIfNull;

    case ValueType of
      jsNumber,
      jsString  : begin
                    e := AsExtended;
                    if (e > MaxDouble) or (e < MinDouble) then
                      raise EJsonConvertError.CreateFmt('''%s'' cannot be expressed as Double', [AsString]);

                    result := e;
                  end;
    else
      raise EJsonConvertError.CreateFmt('''%s'' cannot be expressed as Double', [AsString]);
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonValue.get_AsEnum(const aTypeInfo: PTypeInfo): Integer;
  begin
    if IsNull then
      raise EJsonConvertError.Create('Null cannot be converted to Enum');

    case ValueType of
//      jsBoolean : if TJsonBoolean(self).Value then result := 1 else result := 0;
      jsNumber  : result := AsInteger;
      jsString  : result := GetEnumValue(aTypeInfo, AsString);
    else
      raise EJsonConvertError.Create('Cannot convert to Enum');
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonValue.get_AsExtended: Extended;
  begin
    ErrorIfNull;

    case ValueType of
      jsNumber,
      jsString  : try
                    // TODO: Thread safe implementation using TFormatSettings
                    result := StrToFloat(AsString);
                  except
                    raise EJsonConvertError.CreateFmt('''%s'' cannot be expressed as Extended', [AsString]);
                  end;
    else
      raise EJsonConvertError.CreateFmt('''%s'' cannot be expressed as Extended', [AsString]);
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonValue.get_AsGuid: TGuid;
  begin
    if IsNull then
      raise EJsonConvertError.Create('Null cannot be converted to Guid');

    case ValueType of
      jsBoolean : raise EJsonConvertError.Create('Boolean cannot be converted to Guid');
      jsNumber  : raise EJsonConvertError.Create('Number cannot be converted to Guid');
      jsString  : if NOT Guid.FromString(AsString, result) then
                    EJsonConvertError.CreateFmt('''%s'' is not a valid Guid', [AsString]);
    else
      raise EJsonConvertError.Create('Cannot convert to Guid');
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonValue.get_AsInt64: Int64;
  var
    e: Extended;
  begin
    ErrorIfNull;

    case ValueType of
      jsNumber,
      jsString  : begin
                    e       := AsExtended;
                    result  := Trunc(e);
                    if (e - result <> 0) then
                      raise EJsonConvertError.CreateFmt('''%s'' cannot be expressed as Int64', [AsString]);
                  end;

    else
      raise EJsonConvertError.CreateFmt('''%s'' cannot be expressed as Int64', [AsString]);
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonValue.get_AsInteger: Integer;
  var
    i: Int64;
  begin
    ErrorIfNull;

    case ValueType of
      jsNumber,
      jsString  : begin
                    i := AsInt64;
                    if (i > High(Integer)) or (i < Low(integer)) then
                      raise EJsonConvertError.CreateFmt('''%s'' cannot be expressed as an Integer', [AsString]);

                    result := Integer(i);
                  end;
    else
      raise EJsonConvertError.CreateFmt('''%s'' cannot be expressed as an Integer', [AsString]);
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonValue.get_AsString: UnicodeString;
  begin
    if IsNull then
      raise EJsonConvertError.Create('Cannot convert null to UnicodeString');

    result := DoGetAsString;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonValue.get_IsNull: Boolean;
  begin
    result := fIsNull;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonValue.get_Value: Utf8String;
  begin
    result := fValue;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonValue.get_ValueType: TValueType;
  begin
    result := fValueType;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonValue.SetNull;
  begin
    fAsString   := '';
    fIsNull     := TRUE;
    fValue      := '';
    fValueType  := jsNull;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonValue.SetValue(const aValueType: TValueType;
                                const aValueAsString: UnicodeString);
  begin
    fAsString   := aValueAsString;
    fValueType  := aValueType;
    fValue      := Utf8.FromString(aValueAsString);
    fIsNull     := FALSE;
  end;




//  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
//  function TJsonValue.IsEqual(const aOther: TJsonValue): Boolean;
//  begin
//    result := (ValueType = aOther.ValueType)
//              and (Name = aOther.Name)
//              and (AsString = aOther.AsString);
//  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonValue.set_AsBoolean(const aValue: Boolean);
  begin
    case aValue of
      TRUE  : SetValue(jsBoolean, 'true');
      FALSE : SetValue(jsBoolean, 'false');
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonValue.set_AsCardinal(const aValue: Cardinal);
  begin

  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonValue.set_AsDateTime(const aValue: TDateTime);
  begin
    SetValue(jsString, DateTimeToISO8601(aValue));
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonValue.set_AsDouble(const aValue: Double);
  begin
    SetValue(jsNumber, FloatToStr(aValue));
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonValue.set_AsExtended(const aValue: Extended);
  begin
    SetValue(jsNumber, FloatToStr(aValue));
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonValue.set_AsGUID(const aValue: TGUID);
  begin
    SetValue(jsString, GUIDToString(aValue));
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonValue.set_AsInt64(const aValue: Int64);
  begin
    SetValue(jsNumber, IntToStr(aValue));
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonValue.set_AsInteger(const aValue: Integer);
  begin
    SetValue(jsNumber, IntToStr(aValue));
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonValue.set_AsString(const aValue: UnicodeString);
  begin
    SetValue(jsString, aValue);
  end;




  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonValue.set_AsDate(const aValue: TDate);
  begin
    AsString := DateTimeToISO8601(aValue, [dtDate]);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonValue.set_AsTime(const aValue: TTime);
  begin
    AsString := DateTimeToISO8601(aValue, [dtTime]);
  end;






procedure TJsonValue.set_Value(const aValue: Utf8String);
begin

end;

end.
