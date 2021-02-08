
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
      function get_Item(const aIndex: Integer): IJsonValue;
    public
      function Add(const aValue: IJsonValue): Integer;
      procedure Delete(const aIndex: Integer); overload;
      procedure Delete(const aValue: IJsonValue); overload;
      property Items[const aIndex: Integer]: IJsonValue read get_Item; default;
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


  procedure TJsonArray.Delete(const aValue: IJsonValue);
  begin
    // TODO
  end;


  function TJsonArray.get_Item(const aIndex: Integer): IJsonValue;
  begin
    result := inherited Items[aIndex] as IJsonValue;
  end;




end.
