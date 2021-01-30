
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
    // IJsonValue
    protected
      function get_AsString: UnicodeString; override;
      procedure set_AsString(const aValue: UnicodeString); override;

    // IJsonObject
    protected
      function get_Value(const aName: UnicodeString): IJsonValue;
      function get_Item(const aIndex: Integer): IJsonMember;
    public
      procedure Add(const aName: UnicodeString; const aValue: IJsonValue);
      property Value[const aName: UnicodeString]: IJsonValue read get_Value; default;
      property Items[const aIndex: Integer]: IJsonMember read get_Item;
    end;


    JsonObject = class
    public
      class function Create: IJsonObject; reintroduce;
    end;


implementation

  uses
    Deltics.Json.Member;





{ JsonObject }

  class function JsonObject.Create: IJsonObject;
  begin
    result := TJsonObject.Create;
  end;



{ TJsonObject }

  procedure TJsonObject.Add(const aName: UnicodeString;
                            const aValue: IJsonValue);
  begin
    inherited Items.Add(JsonMember.Create(aName, aValue));
  end;


  function TJsonObject.get_AsString: UnicodeString;
  begin

  end;


  function TJsonObject.get_Value(const aName: UnicodeString): IJsonValue;
  var
    i: Integer;
    name: Utf8String;
    item: IJsonMember;
  begin
    name := Utf8.FromWide(aName);

    for i := 0 to Pred(Count) do
    begin
      item := Items[i];
      if item.Name = name then
      begin
        result := item.Value;
        EXIT;
      end;
    end;

    result := NIL;
  end;


  function TJsonObject.get_Item(const aIndex: Integer): IJsonMember;
  begin
    result := inherited Items[aIndex] as IJsonMember;
  end;


  procedure TJsonObject.set_AsString(const aValue: UnicodeString);
  begin
    inherited;

  end;




end.
