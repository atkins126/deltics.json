
{$i deltics.json.inc}

  unit Deltics.Json.Collection;


interface

  uses
    Deltics.InterfacedObjects,
    Deltics.Strings,
    Deltics.Json.Interfaces,
    Deltics.Json.Value;


  type
    TJsonCollection = class(TJsonValue, IJsonCollection)
    private
      fItems: TInterfaceList;

    // IJsonCollection
    protected
      function get_IsEmpty: Boolean;
      function get_Count: Integer;

    protected
      property Items: TInterfaceList read fItems;
    public
      constructor Create;
      destructor Destroy; override;
      property IsEmpty: Boolean read get_IsEmpty;
      property Count: Integer read get_Count;
    end;




implementation


{ TJsonCollection }

  constructor TJsonCollection.Create;
  begin
    inherited;

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


  function TJsonCollection.get_Count: Integer;
  begin
    result := fItems.Count;
  end;




end.
