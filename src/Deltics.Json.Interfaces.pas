
{$i deltics.json.inc}

  unit Deltics.Json.Interfaces;


interface

  uses
    TypInfo,
    Deltics.Datetime,
    Deltics.Strings;


  type
    TNumberType = (ntDouble, ntInteger);
    TValueType = (jsObject, jsArray, jsString, jsNumber, jsBoolean, jsNull);



    IJsonArray = interface;
    IJsonMember = interface;
    IJsonMemberValue = interface;
    IJsonObject = interface;
    IJsonMutableValue = interface;



    IJsonValue = interface
    ['{4ABEBCB3-1D62-481A-83C8-E0C4B1DA25C7}']
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
      function get_AsUtf8: Utf8String;
      function get_IsNull: Boolean;
      function get_ValueType: TValueType;

      property AsBoolean: Boolean read get_AsBoolean;
      property AsCardinal: Cardinal read get_AsCardinal;
      property AsDate: TDate read get_AsDate;
      property AsTime: TTime read get_AsTime;
      property AsDateTime: TDateTime read get_AsDateTime;
      property AsDouble: Double read get_AsDouble;
      property AsEnum[const aTypeInfo: PTypeInfo]: Integer read get_AsEnum;
      property AsExtended: Extended read get_AsExtended;
      property AsGuid: TGuid read get_AsGuid;
      property AsInt64: Int64 read get_AsInt64;
      property AsInteger: Integer read get_AsInteger;
      property AsSingle: Single read get_AsSingle;
      property AsString: UnicodeString read get_AsString;
      property AsUtf8: Utf8String read get_AsUtf8;
      property IsNull: Boolean read get_IsNull;
      property ValueType: TValueType read get_ValueType;
    end;


    IJsonMutableValue = interface(IJsonValue)
    ['{836B3B1C-9590-4568-B65A-92ED284F1116}']
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

      property AsBoolean: Boolean read get_AsBoolean write set_AsBoolean;
      property AsCardinal: Cardinal read get_AsCardinal write set_AsCardinal;
      property AsDate: TDate read get_AsDate write set_AsDate;
      property AsTime: TTime read get_AsTime write set_AsTime;
      property AsDateTime: TDateTime read get_AsDateTime write set_AsDateTime;
      property AsDouble: Double read get_AsDouble write set_AsDouble;
      property AsEnum[const aTypeInfo: PTypeInfo]: Integer read get_AsEnum;
      property AsExtended: Extended read get_AsExtended write set_AsExtended;
      property AsGuid: TGuid read get_AsGuid write set_AsGuid;
      property AsInt64: Int64 read get_AsInt64 write set_AsInt64;
      property AsInteger: Integer read get_AsInteger write set_AsInteger;
      property AsSingle: Single read get_AsSingle write set_AsSingle;
      property AsString: UnicodeString read get_AsString write set_AsString;
      property AsUtf8: Utf8String read get_AsUtf8 write set_AsUtf8;
      property IsNull: Boolean read get_IsNull;
      property ValueType: TValueType read get_ValueType;
    end;


    IJsonCollection = interface(IJsonMutableValue)
    ['{5F178757-189B-4930-972B-2DB76A34BC3B}']
      function get_Count: Integer;
      function get_IsEmpty: Boolean;

      procedure Clear;

      property Count: Integer read get_Count;
      property IsEmpty: Boolean read get_IsEmpty;
    end;


    IJsonObject = interface(IJsonCollection)
    ['{736DF530-F017-4727-91DF-E62137B0B107}']
      function get_Item(const aIndex: Integer): IJsonMember;
      function get_Value(const aName: UnicodeString): IJsonMemberValue;

      function Add(const aName: UnicodeString; const aValue: IJsonValue): IJsonMember;
      function Contains(const aName: UnicodeString): Boolean; overload;
      function Contains(const aName: UnicodeString; var aValue: IJsonArray): Boolean; overload;
      function Contains(const aName: UnicodeString; var aMember: IJsonMember): Boolean; overload;
      function Contains(const aName: UnicodeString; var aValue: IJsonObject): Boolean; overload;
      function Contains(const aName: UnicodeString; var aValue: IJsonValue): Boolean; overload;
      function Contains(const aName: UnicodeString; var aValue: Boolean): Boolean; overload;
      function Contains(const aName: UnicodeString; var aValue: Integer): Boolean; overload;
      function Contains(const aName: UnicodeString; var aValue: Double): Boolean; overload;
      function Contains(const aName: UnicodeString; var aValue: AnsiString): Boolean; overload;
      function Contains(const aName: UnicodeString; var aValue: UnicodeString): Boolean; overload;
      function Contains(const aName: UnicodeString; var aValue: Utf8String): Boolean; overload;
      function Contains(const aName: UnicodeString; var aValue: WideString): Boolean; overload;
      function Contains(const aName: UnicodeString; var aValue: TUnicodeStringArray): Boolean; overload;

      property Items[const aIndex: Integer]: IJsonMember read get_Item;
      property Value[const aName: UnicodeString]: IJsonMemberValue read get_Value; default;
    end;


    IJsonMemberValue = interface(IJsonMutableValue)
    ['{2D952767-5D95-46D7-AA2A-CBDC7C76944B}']
      function OrDefault(const aValue: IJsonValue): IJsonValue;
    end;


    IJsonMember = interface
    ['{61F3F493-B3CB-4A60-A7D2-4E76EA197FAD}']
      function get_Name: UnicodeString;
      function get_Value: IJsonMutableValue;
      procedure set_Name(const aValue: UnicodeString);
      procedure set_Value(const aValue: IJsonMutableValue);

      property Name: UnicodeString read get_Name write set_Name;
      property Value: IJsonMutableValue read geT_Value write set_Value;
    end;


    IJsonArray = interface(IJsonCollection)
    ['{9F5563F5-D0BB-4DDA-9300-FFC7FC941C3B}']
      function get_AsStringArray: TUnicodeStringArray;
      function get_First: IJsonMutableValue;
      function get_Item(const aIndex: Integer): IJsonMutableValue;
      function get_Last: IJsonMutableValue;

      function Add(const aValue: IJsonValue): Integer;
      procedure Delete(const aIndex: Integer);
      procedure Remove(const aValue: IJsonValue);

      property AsStringArray: TUnicodeStringArray read get_AsStringArray;
      property First: IJsonMutableValue read get_First;
      property Items[const aIndex: Integer]: IJsonMutableValue read get_Item; default;
      property Last: IJsonMutableValue read get_Last;
    end;



    IJsonReader = interface
    ['{92F4B915-D0AE-436D-B6FA-952ABABD4B46}']
      function ReadArray: IJsonArray;
      function ReadObject: IJsonObject;
      function ReadValue: IJsonMutableValue;
    end;



implementation

end.
