
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
      function Contains(const aName: UnicodeString; var aMember: IJsonMember): Boolean; overload;
      function Contains(const aName: UnicodeString; var aValue: IJsonValue): Boolean; overload;
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




end.
