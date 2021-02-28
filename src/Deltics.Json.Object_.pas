
{$i deltics.json.inc}

  unit Deltics.Json.Object_;


interface

  uses
    Deltics.InterfacedObjects,
    Deltics.Strings,
    Deltics.Json.Interfaces,
    Deltics.Json.Collection;


  type
    TJsonObject = class(TJsonCollection, IJsonObject)
    // IJsonObject
    protected
      function get_Item(const aIndex: Integer): IJsonMember;
      function get_Value(const aName: UnicodeString): IJsonMemberValue; overload;
    public
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
//      property Value[const aName: UnicodeString]: IJsonValue read get_Value; default;
//      property Items[const aIndex: Integer]: IJsonMember read get_Item;

    protected
      function InternalAdd(const aName: UnicodeString; const aValue: IJsonValue): IJsonMember;
    end;




implementation

  uses
    Deltics.Json.Exceptions,
    Deltics.Json.Member,
    Deltics.Json.MemberValue,
    Deltics.Json.Value;





{ TJsonObject }

  function TJsonObject.Add(const aName: UnicodeString;
                           const aValue: IJsonValue): IJsonMember;
  begin
    result := InternalAdd(aName, aValue);
  end;


  function TJsonObject.Contains(const aName: UnicodeString): Boolean;
  var
    notUsed: IJsonValue;
  begin
    result := Contains(aName, notUsed);
  end;


  function TJsonObject.Contains(const aName: UnicodeString;
                                var   aMember: IJsonMember): Boolean;
  var
    i: Integer;
  begin
    result := TRUE;

    for i := 0 to Pred(Count) do
    begin
      aMember := Items[i] as IJsonMember;
      if (aMember.Name = aName) then
        EXIT;
    end;

    aMember := NIL;
    result  := FALSE;
  end;


  function TJsonObject.Contains(const aName: UnicodeString;
                                var   aValue: IJsonValue): Boolean;
  var
    member: IJsonMember;
  begin
    aValue  := NIL;
    result  := Contains(aName, member);

    if result then
      aValue := member.Value;
  end;


  function TJsonObject.get_Value(const aName: UnicodeString): IJsonMemberValue;
  begin
    result := TJsonMemberValue.Create(self as IJsonObject, aName)
  end;


  function TJsonObject.InternalAdd(const aName: UnicodeString;
                                   const aValue: IJsonValue): IJsonMember;
  begin
    if Contains(aName, result) then
    begin
      result.Value := aValue as IJsonMutableValue;
      EXIT;
    end;

    result := JsonMember.Create(aName, aValue);

    inherited Items.Add(result);
  end;


  function TJsonObject.get_Item(const aIndex: Integer): IJsonMember;
  begin
    result := inherited Items[aIndex] as IJsonMember;
  end;


  function TJsonObject.Contains(const aName: UnicodeString; var aValue: AnsiString): Boolean;
  var
    v: IJsonValue;
  begin
    result := Contains(aName, v);
    if result then
      aValue := Ansi.FromWide(v.AsString);
  end;


  function TJsonObject.Contains(const aName: UnicodeString; var aValue: UnicodeString): Boolean;
  var
    v: IJsonValue;
  begin
    result := Contains(aName, v);
    if result then
      aValue := v.AsString;
  end;


  function TJsonObject.Contains(const aName: UnicodeString; var aValue: Utf8String): Boolean;
  var
    v: IJsonValue;
  begin
    result := Contains(aName, v);
    if result then
      aValue := v.AsUtf8;
  end;


  function TJsonObject.Contains(const aName: UnicodeString; var aValue: WideString): Boolean;
  var
    v: IJsonValue;
  begin
    result := Contains(aName, v);
    if result then
      aValue := v.AsString;
  end;


  function TJsonObject.Contains(const aName: UnicodeString; var aValue: Boolean): Boolean;
  var
    v: IJsonValue;
  begin
    result := Contains(aName, v);
    if result then
      aValue := v.AsBoolean;
  end;


  function TJsonObject.Contains(const aName: UnicodeString; var aValue: IJsonObject): Boolean;
  var
    v: IJsonValue;
  begin
    result := Contains(aName, v);
    if result then
      aValue := v as IJsonObject;
  end;


  function TJsonObject.Contains(const aName: UnicodeString; var aValue: IJsonArray): Boolean;
  var
    v: IJsonValue;
  begin
    result := Contains(aName, v);
    if result then
      aValue := v as IJsonArray;
  end;


  function TJsonObject.Contains(const aName: UnicodeString; var aValue: TUnicodeStringArray): Boolean;
  var
    a: IJsonArray;
  begin
    result := Contains(aName, a);
    if result then
      aValue := a.AsStringArray;
  end;


  function TJsonObject.Contains(const aName: UnicodeString; var aValue: Double): Boolean;
  var
    v: IJsonValue;
  begin
    result := Contains(aName, v);
    if result then
      aValue := v.AsDouble;
  end;


  function TJsonObject.Contains(const aName: UnicodeString; var aValue: Integer): Boolean;
  var
    v: IJsonValue;
  begin
    result := Contains(aName, v);
    if result then
      aValue := v.AsInteger;
  end;






end.
