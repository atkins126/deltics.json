
{$i deltics.json.inc}

  unit Deltics.Json.String_;


interface

  uses
    Deltics.InterfacedObjects,
    Deltics.Strings,
    Deltics.Json.Interfaces,
    Deltics.Json.Value;


  type
    TJsonString = class(TJsonValue, IJsonString)
    // IJsonString
    protected
      function get_AsString: UnicodeString; override;
      function get_Value: Utf8String;
      procedure set_AsString(const aValue: UnicodeString); override;
      procedure set_Value(const aValue: Utf8String);

    private
      fValue: Utf8String;
    public
      property Value: Utf8String read fValue write fValue;
    end;


    JsonString = class
    public
      class function Create(const aValue: UnicodeString): IJsonString;
    end;




implementation

  uses
    Deltics.Json.Object_;



  class function JsonString.Create(const aValue: UnicodeString): IJsonString;
  begin
    result := TJsonString.Create;
    result.AsString := aValue;
  end;



{ TJsonValue }

  function TJsonString.get_AsString: UnicodeString;
  begin
    result := Wide.FromUtf8(fValue);
  end;


  function TJsonString.get_Value: Utf8String;
  begin
    result := fValue;
  end;


  procedure TJsonString.set_AsString(const aValue: UnicodeString);
  begin
    fValue := Utf8.FromWIDE(aValue);
  end;


  procedure TJsonString.set_Value(const aValue: Utf8String);
  begin
    fValue := aValue;
  end;




end.
