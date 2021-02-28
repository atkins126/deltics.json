
{$i deltics.json.inc}

  unit Deltics.Json.Array_;


interface

  uses
    Deltics.InterfacedObjects,
    Deltics.Strings,
    Deltics.Json.Interfaces,
    Deltics.Json.Collection;


  type
    TJsonArray = class(TJsonCollection, IJsonArray)
    // IJsonArray
    protected
      function get_AsStringArray: TUnicodeStringArray;
      function get_First: IJsonMutableValue;
      function get_Item(const aIndex: Integer): IJsonMutableValue;
      function get_Last: IJsonMutableValue;
    public
      function Add(const aValue: IJsonValue): Integer;
      procedure Delete(const aIndex: Integer);
      procedure Remove(const aValue: IJsonValue);
      property Items[const aIndex: Integer]: IJsonMutableValue read get_Item;
    end;




implementation

  uses
    Deltics.Json.Exceptions,
    Deltics.Json.Member,
    Deltics.Json.MemberValue,
    Deltics.Json.Value;





{ TJsonArray }

  function TJsonArray.Add(const aValue: IJsonValue): Integer;
  begin
    result := inherited Items.Add(aValue);
  end;


  procedure TJsonArray.Delete(const aIndex: Integer);
  begin
    inherited Items.Delete(aIndex);
  end;


  procedure TJsonArray.Remove(const aValue: IJsonValue);
  var
    i: Integer;
    item: IUnknown;
  begin
    for i := 0 to Pred(Count) do
      if item = (Items[i] as IUnknown) then
      begin
        Delete(i);
        EXIT;
      end;
  end;


  function TJsonArray.get_AsStringArray: TUnicodeStringArray;
  var
    i: Integer;
  begin
    SetLength(result, Count);
    for i := 0 to Pred(Count) do
      result[i] := Items[i].AsString;
  end;


  function TJsonArray.get_First: IJsonMutableValue;
  begin
    result := Items[0] as IJsonMutableValue;
  end;


  function TJsonArray.get_Item(const aIndex: Integer): IJsonMutableValue;
  begin
    result := inherited Items[aIndex] as IJsonMutableValue;
  end;


  function TJsonArray.get_Last: IJsonMutableValue;
  begin
    result := Items[Count - 1] as IJsonMutableValue;
  end;






end.
