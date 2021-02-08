
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
      function get_Value(const aName: UnicodeString): IJsonValue;
      function get_Item(const aIndex: Integer): IJsonMember;
    public
      function Add(const aName: UnicodeString; const aValue: IJsonValue): IJsonMember;
      function Contains(const aName: UnicodeString): Boolean; overload;
      function Contains(const aName: UnicodeString; var aMember: IJsonMember): Boolean; overload;
      property Value[const aName: UnicodeString]: IJsonValue read get_Value; default;
      property Items[const aIndex: Integer]: IJsonMember read get_Item;

    protected
      function DoGetAsString: UnicodeString; override;
      procedure DoSetAsString(const aValue: UnicodeString); override;
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
    notUsed: IJsonMember;
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
      aMember := Items[i];
      if aMember.Name = aName then
        EXIT;
    end;

    aMember := NIL;
    result  := FALSE;
  end;


  function TJsonObject.get_Value(const aName: UnicodeString): IJsonValue;
  begin
    result := TJsonMemberValue.Create(self as IJsonObject, aName)
  end;


  function TJsonObject.DoGetAsString: UnicodeString;
  begin
    // TODO
  end;


  procedure TJsonObject.DoSetAsString(const aValue: UnicodeString);
  begin
    inherited;

    // TODO
  end;


  function TJsonObject.InternalAdd(const aName: UnicodeString;
                                   const aValue: IJsonValue): IJsonMember;
  begin
    if Contains(aName, result) then
    begin
      result.Value := aValue;
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
