
{$i deltics.json.inc}

  unit Deltics.Json.Value;


interface

  uses
    Deltics.InterfacedObjects,
    Deltics.Json.Interfaces;


  type
    TJsonValue = class(TComInterfacedObject, IJsonValue)
    // IJsonValue
    protected
      function get_AsString: UnicodeString; virtual; abstract;
      function get_ValueType: TValueType;
      procedure set_AsString(const aValue: UnicodeString); virtual; abstract;
    public
      property AsString: UnicodeString read get_AsString write set_AsString;
      property ValueType: TValueType read get_ValueType;
    end;


implementation

  uses
    Deltics.Json.Object_;


{ TJsonValue }

  function TJsonValue.get_ValueType: TValueType;
  begin
    result := jsNull;

    if self.ClassType = TJsonObject then
      result := jsObject;
  end;



end.
