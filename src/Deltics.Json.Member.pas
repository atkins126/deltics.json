
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
      function get_Name: Utf8String;
      function get_Value: IJsonValue;
      procedure set_Name(const aValue: Utf8String);
      procedure set_Value(const aValue: IJsonValue);

    private
      fName: Utf8String;
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
    result.Name   := Utf8.FromWIDE(aName);
    result.Value  := aValue;
  end;



{ TJsonMember }

  function TJsonMember.get_Name: Utf8String;
  begin
    result := fName;
  end;


  function TJsonMember.get_Value: IJsonValue;
  begin
    result := fValue;
  end;


  procedure TJsonMember.set_Name(const aValue: Utf8String);
  begin
    fName := aValue;
  end;


  procedure TJsonMember.set_Value(const aValue: IJsonValue);
  begin
    fValue := aValue;
  end;




end.

