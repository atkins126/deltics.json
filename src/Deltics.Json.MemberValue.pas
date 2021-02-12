
{$i deltics.json.inc}

  unit Deltics.Json.MemberValue;


interface

  uses
    TypInfo,
    Deltics.Datetime,
    Deltics.InterfacedObjects,
    Deltics.Strings,
    Deltics.Json.Interfaces,
    Deltics.Json.Value;


  type
    TMemberValueFn = function: IJsonValue of object;

    TJsonMemberValue = class(TComInterfacedObject, IJsonValue)
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

    private
      fObject: IJsonObject;
      fMember: IJsonMember;
      fMemberName: UnicodeString;
      fMemberValueFn: TMemberValueFn;
      fValue: IJsonValue;
      property MemberValue: TMemberValueFn read fMemberValueFn;

      function InitMemberValue: IJsonValue;
      function YieldMemberValue: IJsonValue;
    public
      constructor Create(const aObject: IJsonObject; const aMemberName: UnicodeString);
    end;




implementation

  uses
    Deltics.Json.Object_;


{ TJsonMemberValue }

  constructor TJsonMemberValue.Create(const aObject: IJsonObject;
                                      const aMemberName: UnicodeString);
  begin
    inherited Create;

    fObject     := aObject;
    fMemberName := aMemberName;

    if aObject.Contains(aMemberName, fMember) then
    begin
      fMemberValueFn  := YieldMemberValue;
      fValue          := fMember.Value;
    end
    else
    begin
      fMemberValueFn  := InitMemberValue;
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


  function TJsonMemberValue.InitMemberValue: IJsonValue;
  begin
    TJsonObject((fObject as IInterfacedObject).AsObject).Add(fMemberName, fValue);

    fMemberValueFn  := YieldMemberValue;
    result          := fValue;
  end;


  function TJsonMemberValue.YieldMemberValue: IJsonValue;
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
