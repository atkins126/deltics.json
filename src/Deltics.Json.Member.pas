
{$i deltics.json.inc}

  unit Deltics.Json.Member;


interface

  uses
    Deltics.InterfacedObjects,
    Deltics.Strings,
    Deltics.Json.Interfaces;


  type
    TJsonMember = class(TComInterfacedObject, IJsonMember)
    // IJsonMember
    protected
      function get_Name: UnicodeString;
      function get_Value: IJsonValue;
      procedure set_Name(const aValue: UnicodeString);
      procedure set_Value(const aValue: IJsonValue);
      function ValueOrDefault(aDefault: IJsonValue): IJsonValue;

    private
      fName: UnicodeString;
      fValue: IJsonValue;
    end;


    JsonMember = class
      class function Create(const aName: UnicodeString; const aValue: IJsonValue): IJsonMember;
    end;


implementation

{ JsonMember }

  class function JsonMember.Create(const aName: UnicodeString; const aValue: IJsonValue): IJsonMember;
  begin
    result := TJsonMember.Create;
    result.Name   := aName;
    result.Value  := aValue;
  end;



{ TJsonMember }

  function TJsonMember.get_Name: UnicodeString;
  begin
    result := fName;
  end;


  function TJsonMember.get_Value: IJsonValue;
  begin
    result := fValue;
  end;


  procedure TJsonMember.set_Name(const aValue: UnicodeString);
  begin
    fName := aValue;
  end;


  procedure TJsonMember.set_Value(const aValue: IJsonValue);
  begin
    fValue := aValue;
  end;


  function TJsonMember.ValueOrDefault(aDefault: IJsonValue): IJsonValue;
  begin
    result := fValue;
    if result.IsNull then
      result := aDefault;
  end;





end.

