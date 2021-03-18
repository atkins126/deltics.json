
{$i deltics.json.inc}

  unit Deltics.Json.MemberValue;


interface

  uses
    TypInfo,
    Deltics.Datetime,
    Deltics.InterfacedObjects,
    Deltics.Unicode,
    Deltics.Json.Types,
    Deltics.Json.Value;


  type
    TMemberValueFn = function: IJsonMutableValue of object;

    TJsonMemberValue = class(TComInterfacedObject, IJsonMemberValue)
    // IJsonValue
    protected
      function get_AsBoolean: Boolean;
      function get_AsCardinal: Cardinal;
      function get_AsDate: TDate;
      function get_AsTime: TTime;
      function get_AsDateTime: TDateTime;
      function get_AsDouble: Double;
      function get_AsEnum(const aTypeInfo: PTypeInfo): Integer;
      function get_AsExtended: Extended;
      function get_AsGuid: TGuid;
      function get_AsInt64: Int64;
      function get_AsInteger: Integer;
      function get_AsSingle: Single;
      function get_AsString: UnicodeString;
      function get_AsUtf8: UTF8String;
      function get_IsNull: Boolean;
      function get_ValueType: TValueType;
      procedure set_AsBoolean(const aValue: Boolean);
      procedure set_AsCardinal(const aValue: Cardinal);
      procedure set_AsDate(const aValue: TDate);
      procedure set_AsTime(const aValue: TTime);
      procedure set_AsDateTime(const aValue: TDateTime);
      procedure set_AsDouble(const aValue: Double);
      procedure set_AsExtended(const aValue: Extended);
      procedure set_AsGuid(const aValue: TGuid);
      procedure set_AsInt64(const aValue: Int64);
      procedure set_AsInteger(const aValue: Integer);
      procedure set_AsSingle(const aValue: Single);
      procedure set_AsString(const aValue: UnicodeString);
      procedure set_AsUtf8(const aValue: Utf8String);

    // IJsonMemberValue
    protected
      function OrDefault(const aValue: IJsonValue): IJsonValue;

    private
      fObject: IJsonObject;
      fMember: IJsonMember;
      fMemberExists: Boolean;
      fMemberName: UnicodeString;
      fMemberValueFn: TMemberValueFn;
      fValue: IJsonMutableValue;
      property MemberValue: TMemberValueFn read fMemberValueFn;

      function _InitMemberValue: IJsonMutableValue;
      function _YieldMemberValue: IJsonMutableValue;
    public
      constructor Create(const aObject: IJsonObject; const aMemberName: UnicodeString);
      property MemberExists: Boolean read fMemberExists;
    end;




implementation

  uses
    Deltics.Json,
    Deltics.Json.Object_;


{ TJsonMemberValue }

  constructor TJsonMemberValue.Create(const aObject: IJsonObject;
                                      const aMemberName: UnicodeString);
  begin
    inherited Create;

    fObject       := aObject;
    fMemberName   := aMemberName;
    fMemberExists := aObject.Contains(aMemberName, fMember);

    if MemberExists then
    begin
      fMemberValueFn  := _YieldMemberValue;
      fValue          := fMember.Value;
    end
    else
    begin
      fMemberValueFn  := _InitMemberValue;
      fValue          := TJsonValue.Create;
    end;
  end;


  function TJsonMemberValue.get_AsBoolean: Boolean;
  begin
    result := fValue.AsBoolean;
  end;


  function TJsonMemberValue.get_AsCardinal: Cardinal;
  begin
    result := fValue.AsCardinal;
  end;


  function TJsonMemberValue.get_AsDate: TDate;
  begin
    result := fValue.AsDate;
  end;


  function TJsonMemberValue.get_AsDateTime: TDateTime;
  begin
    result := fValue.AsDateTime;
  end;


  function TJsonMemberValue.get_AsDouble: Double;
  begin
    result := fValue.AsDouble;
  end;


  function TJsonMemberValue.get_AsEnum(const aTypeInfo: PTypeInfo): Integer;
  begin
    result := fValue.AsEnum[aTypeInfo];
  end;


  function TJsonMemberValue.get_AsExtended: Extended;
  begin
    result := fValue.AsExtended;
  end;


  function TJsonMemberValue.get_AsGuid: TGuid;
  begin
    result := fValue.AsGuid;
  end;


  function TJsonMemberValue.get_AsInt64: Int64;
  begin
    result := fValue.AsInt64;
  end;


  function TJsonMemberValue.get_AsInteger: Integer;
  begin
    result := fValue.AsInteger;
  end;


  function TJsonMemberValue.get_AsSingle: Single;
  begin
    result := fValue.AsSingle;
  end;


  function TJsonMemberValue.get_AsString: UnicodeString;
  begin
    result := fValue.AsString;
  end;


  function TJsonMemberValue.get_AsTime: TTime;
  begin
    result := fValue.AsTime;
  end;


  function TJsonMemberValue.get_AsUtf8: Utf8String;
  begin
    result := fValue.AsUtf8;
  end;


  function TJsonMemberValue.get_IsNull: Boolean;
  begin
    result := fValue.IsNull;
  end;


  function TJsonMemberValue.get_ValueType: TValueType;
  begin
    result := fValue.ValueType;
  end;


  function TJsonMemberValue.OrDefault(const aValue: IJsonValue): IJsonValue;
  begin
    if MemberExists then
      result := fValue
    else
      result := aValue;
  end;


  function TJsonMemberValue._InitMemberValue: IJsonMutableValue;
  begin
    TJsonObject((fObject as IInterfacedObject).AsObject).Add(fMemberName, fValue);

    fMemberExists   := TRUE;
    fMemberValueFn  := _YieldMemberValue;
    result          := fValue;
  end;


  function TJsonMemberValue._YieldMemberValue: IJsonMutableValue;
  begin
    result := fValue;
  end;


  procedure TJsonMemberValue.set_AsBoolean(const aValue: Boolean);
  begin
    MemberValue.AsBoolean := aValue;
  end;


  procedure TJsonMemberValue.set_AsCardinal(const aValue: Cardinal);
  begin
    MemberValue.AsCardinal := aValue;
  end;


  procedure TJsonMemberValue.set_AsDate(const aValue: TDate);
  begin
    MemberValue.AsDate := aValue;
  end;


  procedure TJsonMemberValue.set_AsDateTime(const aValue: TDateTime);
  begin
    MemberValue.AsDateTime := aValue;
  end;


  procedure TJsonMemberValue.set_AsDouble(const aValue: Double);
  begin
    MemberValue.AsDouble := aValue;
  end;


  procedure TJsonMemberValue.set_AsExtended(const aValue: Extended);
  begin
    MemberValue.AsExtended := aValue;
  end;


  procedure TJsonMemberValue.set_AsGuid(const aValue: TGuid);
  begin
    MemberValue.AsGuid := aValue;
  end;


  procedure TJsonMemberValue.set_AsInt64(const aValue: Int64);
  begin
    MemberValue.AsInt64 := aValue;
  end;


  procedure TJsonMemberValue.set_AsInteger(const aValue: Integer);
  begin
    MemberValue.AsInteger := aValue;
  end;


  procedure TJsonMemberValue.set_AsSingle(const aValue: Single);
  begin
    MemberValue.AsSingle := aValue;
  end;


  procedure TJsonMemberValue.set_AsString(const aValue: UnicodeString);
  begin
    MemberValue.AsString := aValue;
  end;


  procedure TJsonMemberValue.set_AsTime(const aValue: TTime);
  begin
    MemberValue.AsTime := aValue;
  end;


  procedure TJsonMemberValue.set_AsUtf8(const aValue: Utf8String);
  begin
    MemberValue.AsUtf8 := aValue;
  end;







end.
