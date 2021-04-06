
{$i deltics.json.inc}

  unit Deltics.Json.Object_;


interface

  uses
    Deltics.InterfacedObjects,
    Deltics.StringTypes,
    Deltics.Json.Collection,
    Deltics.Json.Types;


  type
    TJsonObject = class(TJsonCollection, IJsonObject)
    // IJsonObject
    protected
      function get_Item(const aIndex: Integer): IJsonMember;
      function get_Value(const aName: UnicodeString): IJsonMemberValue; overload;
    public
      function Add(const aName: UnicodeString; const aValue: IJsonArray): IJsonArray; overload;
      function Add(const aName: UnicodeString; const aValue: IJsonObject): IJsonObject; overload;
      function Add(const aName: UnicodeString; const aValue: IJsonValue): IJsonMember; overload;
      function AddAfter(const aPredecessor: UnicodeString; const aName: UnicodeString; const aValue: IJsonArray): IJsonArray; overload;
      function AddAfter(const aPredecessor: UnicodeString; const aName: UnicodeString; const aValue: IJsonObject): IJsonObject; overload;
      function AddAfter(const aPredecessor: UnicodeString; const aName: UnicodeString; const aValue: IJsonValue): IJsonMember; overload;
      function Contains(const aName: UnicodeString): Boolean; overload;
      function Contains(const aName: UnicodeString; var aValue: IJsonArray): Boolean; overload;
      function Contains(const aName: UnicodeString; var aMember: IJsonMember): Boolean; overload;
      function Contains(const aName: UnicodeString; var aValue: IJsonObject): Boolean; overload;
      function Contains(const aName: UnicodeString; var aValue: IJsonValue): Boolean; overload;
      function Contains(const aName: UnicodeString; var aValue: Boolean): Boolean; overload;
      function Contains(const aName: UnicodeString; var aValue: Integer): Boolean; overload;
      function Contains(const aName: UnicodeString; var aValue: Double): Boolean; overload;
      function Contains(const aName: UnicodeString; var aValue: UnicodeStringArray): Boolean; overload;
      function Contains(const aName: UnicodeString; var aValue: UnicodeString): Boolean; overload;
//      function Contains(const aName: UnicodeString; var aValue: UnicodeStringArray): Boolean; overload;
//      property Value[const aName: UnicodeString]: IJsonValue read get_Value; default;
//      property Items[const aIndex: Integer]: IJsonMember read get_Item;

    protected
      function InternalAdd(const aName: UnicodeString; const aValue: IJsonValue): IJsonMember;
      function InternalAddAfter(const aPredecessor: UnicodeString; const aName: UnicodeString; const aValue: IJsonValue): IJsonMember;
    end;




implementation

  uses
    Deltics.Json.Exceptions,
    Deltics.Json.Member,
    Deltics.Json.MemberValue,
    Deltics.Json.Value;





{ TJsonObject }

  function TJsonObject.Add(const aName: UnicodeString;
                           const aValue: IJsonArray): IJsonArray;
  begin
    result := aValue;
    InternalAdd(aName, result);
  end;


  function TJsonObject.Add(const aName: UnicodeString;
                           const aValue: IJsonObject): IJsonObject;
  begin
    result := aValue;
    InternalAdd(aName, result);
  end;


  function TJsonObject.Add(const aName: UnicodeString;
                           const aValue: IJsonValue): IJsonMember;
  begin
    result := InternalAdd(aName, aValue);
  end;


  function TJsonObject.AddAfter(const aPredecessor, aName: UnicodeString;
                                const aValue: IJsonArray): IJsonArray;
  begin

  end;

  function TJsonObject.AddAfter(const aPredecessor, aName: UnicodeString;
                                const aValue: IJsonObject): IJsonObject;
  begin

  end;

  function TJsonObject.AddAfter(const aPredecessor, aName: UnicodeString;
                                const aValue: IJsonValue): IJsonMember;
  begin

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


  function TJsonObject.InternalAddAfter(const aPredecessor, aName: UnicodeString;
                                        const aValue: IJsonValue): IJsonMember;
  var
    predMember: IJsonMember;
    insertIndex: Integer;
  begin
    if NOT Contains(aPredecessor, predMember) then
    begin
      InternalAdd(aName, aValue);
      EXIT;
    end;

    if Contains(aName, result) then
    begin
      result.Value := aValue as IJsonMutableValue;
      EXIT;
    end;

    result := JsonMember.Create(aName, aValue);

    insertIndex := inherited Items.IndexOf(predMember) + 1;
    if (insertIndex >= inherited Items.Count) then
      inherited Items.Add(result)
    else
      inherited Items.Insert(insertIndex, result);
  end;


  function TJsonObject.get_Item(const aIndex: Integer): IJsonMember;
  begin
    result := inherited Items[aIndex] as IJsonMember;
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
    result := Contains(aName, v) and (v.ValueType = jsArray);
    if result then
      aValue := v as IJsonArray;
  end;


  function TJsonObject.Contains(const aName: UnicodeString; var aValue: UnicodeStringArray): Boolean;
  var
    a: IJsonArray;
  begin
    result := Contains(aName, a);
    if result then
      aValue := a.AsStringArray;
  end;


  function TJsonObject.Contains(const aName: UnicodeString; var aValue: UnicodeString): Boolean;
  var
    v: IJsonValue;
  begin
    result := Contains(aName, v);
    if result then
      aValue := v.AsString;
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
