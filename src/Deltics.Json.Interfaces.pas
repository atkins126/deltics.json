
{$i deltics.json.inc}

  unit Deltics.Json.Interfaces;


interface


  type
    TValueType = (jsObject, jsArray, jsString, jsNumber, jsBoolean, jsNull);



    IJsonValue = interface;
    IJsonMember = interface;
    IJsonObject = interface;



    IJsonValue = interface
    ['{836B3B1C-9590-4568-B65A-92ED284F1116}']
      function get_AsString: UnicodeString;
      function get_ValueType: TValueType;
      procedure set_AsString(const aValue: UnicodeString);

      property AsString: UnicodeString read get_AsString write set_AsString;
      property ValueType: TValueType read get_ValueType;
    end;

    IJsonString = interface(IJsonValue)
    ['{7A4790EF-B430-467B-86EA-9B85A7A5557D}']
      function get_Value: Utf8String;
      procedure set_Value(const aValue: Utf8String);

      property Value: Utf8String read get_Value write set_Value;
    end;


    IJsonCollection = interface(IJsonValue)
    ['{5F178757-189B-4930-972B-2DB76A34BC3B}']
      function get_Count: Integer;
      function get_IsEmpty: Boolean;

      property Count: Integer read get_Count;
      property IsEmpty: Boolean read get_IsEmpty;
    end;


    IJsonObject = interface(IJsonCollection)
    ['{736DF530-F017-4727-91DF-E62137B0B107}']
      function get_Item(const aIndex: Integer): IJsonMember;
      function get_Value(const aName: UnicodeString): IJsonValue;

      procedure Add(const aName: UnicodeString; const aValue: IJsonValue);

      property Items[const aIndex: Integer]: IJsonMember read get_Item;
      property Value[const aName: UnicodeString]: IJsonValue read get_Value; default;

(*
      function DoGetAsString: UnicodeString; override;
      procedure DoSetAsString(const aValue: UnicodeString); override;
    public
      class function TryCreate(const aString: UnicodeString): TJsonObject;
      constructor Create; overload; override;
      constructor Create(const aString: UnicodeString); reintroduce; overload;
      constructor CreateFromFile(const aFilename: UnicodeString; const aEncoding: TEncoding);
      destructor Destroy; override;
      function AddAfter(const aPredecessor: UnicodeString; const aName: UnicodeString; const aValue: UnicodeString): TJsonString; overload;
      procedure Clear; override;
      function Clone: TJsonObject; reintroduce;
      procedure Combine(const aObject: TJsonObject);
      function Contains(const aValueName: UnicodeString): Boolean; overload;
      function Contains(const aValueName: UnicodeString; var aValue: UnicodeString): Boolean; overload;
      function Contains(const aValueName: UnicodeString; var aValue: TJsonArray): Boolean; overload;
      function Contains(const aValueName: UnicodeString; var aValue: TWIDEStringArray): Boolean; overload;
      procedure Delete(const aValueName: UnicodeString); overload;
      function FindValue(const aName: UnicodeString): TJsonValue;
      procedure CopyFrom(const aSource: TJsonValue); override;
      procedure LoadFromStream(const aStream: TStream; const aEncoding: TEncoding = NIL);
      function OptBoolean(const aName: UnicodeString; const aDefault: Boolean = FALSE): Boolean;
      function OptDateTime(const aName: UnicodeString; const aDefault: TDateTime = 0): TDateTime;
      function OptEnum(const aName: UnicodeString; const aTypeInfo: PTypeInfo; const aDefault: Integer = 0): Integer;
      function OptInteger(const aName: UnicodeString; const aDefault: Integer = 0): Integer;
      function OptString(const aName: UnicodeString; const aDefault: UnicodeString = ''): UnicodeString;
      procedure Wipe; override;
    {$ifdef DELPHI2009__}
      function OptDate(const aName: UnicodeString; const aDefault: TDate = 0): TDate;
      function OptTime(const aName: UnicodeString; const aDefault: TTime = 0): TTime;
    {$endif}
*)
    end;


    IJsonMember = interface
    ['{61F3F493-B3CB-4A60-A7D2-4E76EA197FAD}']
      function get_Name: Utf8String;
      function get_Value: IJsonValue;
      procedure set_Name(const aValue: Utf8String);
      procedure set_Value(const aValue: IJsonValue);

      property Name: Utf8String read get_Name write set_Name;
      property Value: IJsonValue read geT_Value write set_Value;
    end;



implementation

end.
