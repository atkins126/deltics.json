
{$i deltics.json.inc}

  unit Deltics.Json.Member;


interface

  uses
    Deltics.InterfacedObjects,
    Deltics.Unicode,
    Deltics.Json.Types;


  type
    TJsonMember = class(TComInterfacedObject, IJsonMember)
    // IJsonMember
    protected
      function get_Name: UnicodeString;
      function get_Value: IJsonMutableValue;
      procedure set_Name(const aValue: UnicodeString);
      procedure set_Value(const aValue: IJsonMutableValue);
      function ValueOrDefault(aDefault: IJsonMutableValue): IJsonMutableValue;

    private
      fName: UnicodeString;
      fValue: IJsonMutableValue;
    end;


    JsonMember = class
      class function Create(const aName: UnicodeString; const aValue: IJsonValue): IJsonMember;
    end;


implementation

{ JsonMember }

  class function JsonMember.Create(const aName: UnicodeString;
                                   const aValue: IJsonValue): IJsonMember;
  begin
    result := TJsonMember.Create;
    result.Name   := aName;
    result.Value  := aValue as IJsonMutableValue;
  end;



{ TJsonMember }

  function TJsonMember.get_Name: UnicodeString;
  begin
    result := fName;
  end;


  function TJsonMember.get_Value: IJsonMutableValue;
  begin
    result := fValue;
  end;


  procedure TJsonMember.set_Name(const aValue: UnicodeString);
  begin
    fName := aValue;
  end;


  procedure TJsonMember.set_Value(const aValue: IJsonMutableValue);
  begin
    fValue := aValue;
  end;


  function TJsonMember.ValueOrDefault(aDefault: IJsonMutableValue): IJsonMutableValue;
  begin
    result := fValue;
    if result.IsNull then
      result := aDefault;
  end;





end.

