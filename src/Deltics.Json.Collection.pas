
{$i deltics.json.inc}

  unit Deltics.Json.Collection;


interface

  uses
    Classes,
    Deltics.InterfacedObjects,
    Deltics.Strings,
    Deltics.Json.Types,
    Deltics.Json.Value;


  type
    TJsonCollection = class(TJsonValue, IJsonCollection)
    private
      fItems: TInterfaceList;

    // IJsonCollection
    protected
      function get_IsEmpty: Boolean;
      function get_Count: Integer;
    public
      procedure Clear;
      procedure SaveAs(const aFilename: String; const aFormat: TJsonFormat = jfStandard);
      procedure WriteTo(const aStream: TStream; const aFormat: TJsonFormat = jfStandard);

    protected
      property Items: TInterfaceList read fItems;
    public
      constructor Create;
      destructor Destroy; override;
      property IsEmpty: Boolean read get_IsEmpty;
      property Count: Integer read get_Count;
    end;




implementation

  uses
    Deltics.Exceptions,
    Deltics.Json.Array_,
    Deltics.Json.Object_,
    Deltics.Json.Utils;



{ TJsonCollection }

  constructor TJsonCollection.Create;
  begin
    if self is TJsonObject then
      inherited CreateObject
    else if self is TJsonArray then
      inherited CreateArray
    else
      raise ENotImplemented.Create(ClassName + ' is not a supported Json collection type');

    fItems := TInterfaceList.Create;
  end;


  destructor TJsonCollection.Destroy;
  begin
    fItems.Free;

    inherited;
  end;


  function TJsonCollection.get_IsEmpty: Boolean;
  begin
    result := fItems.Count = 0;
  end;


  procedure TJsonCollection.SaveAs(const aFilename: String; const aFormat: TJsonFormat);
  begin
    Json.SaveToFile(self as IJsonCollection, aFilename, aFormat);
  end;


  procedure TJsonCollection.WriteTo(const aStream: TStream; const aFormat: TJsonFormat);
  begin
    Json.SaveToStream(self as IJsonCollection, aStream, aFormat);
  end;


  function TJsonCollection.get_Count: Integer;
  begin
    result := fItems.Count;
  end;


  procedure TJsonCollection.Clear;
  begin
    fItems.Clear;
  end;



end.
