
{$i deltics.json.inc}

  unit Deltics.Json.Reader;


interface

  uses
    Deltics.InterfacedObjects,
    Deltics.IO.Text,
    Deltics.Strings,
    Deltics.Json.Array_,
    Deltics.Json.Object_,
    Deltics.Json.Types,
    Deltics.Json.Value;


  type
    TJsonReader = class(TComInterfacedObject, IJsonReader)
    private
      fSource: IUnicodeReader;
      function EOF: Boolean;
      function PeekChar: WideChar;
      function PeekRealChar: WideChar;
      function ReadChar: WideChar;
      function ReadRealChar: WideChar; overload;
      function ReadName: UnicodeString;
      function ReadString(const aQuoted: Boolean = TRUE): UnicodeString;
    public
      constructor Create(const aSource: IUnicodeReader);
      function ReadArray: IJsonArray;
      function ReadObject: IJsonObject;
      function ReadValue: IJsonMutableValue;
    end;


implementation

  uses
    SysUtils,
    Deltics.Hex2Bin,
    Deltics.StringParsers,
    Deltics.Json.Exceptions,
    Deltics.Json.Factories;



{ TJsonReader ------------------------------------------------------------------------------ }

  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  constructor TJsonReader.Create(const aSource: IUnicodeReader);
  begin
    inherited Create;

    fSource := aSource;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonReader.EOF: Boolean;
  begin
    result := fSource.EOF;
  end;


  function TJsonReader.PeekChar: WideChar;
  begin
    result := fSource.PeekChar;
   end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonReader.PeekRealChar: WideChar;
  begin
    result := fSource.PeekCharSkippingWhitespace;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonReader.ReadChar: WideChar;
  begin
    result := fSource.NextChar;
  end;



  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonReader.ReadRealChar: WideChar;
  begin
    result := fSource.NextCharSkippingWhitespace;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonReader.ReadArray: IJsonArray;
  var
    value: IJsonValue;
  begin
    if ReadRealChar <> '[' then
      raise EJsonStreamError.Create('Expected ''[''');

    result := TJsonArray.Create;

    if (PeekRealChar = ']') then
    begin
      // It's an array alright, but it's empty so just return
      //  the new, empty array, reading past the  ']' that closes the array
      ReadRealChar;
      EXIT;
    end;

    // Read values to be added to the array until we reach either the
    //  end of the array or run out of data

    while NOT EOF do
    begin
      value := ReadValue;
      result.Add(value);

      case PeekRealChar of
        ']' : begin
                ReadRealChar;
                EXIT;
              end;

        ',' : ReadRealChar;
      else
        raise EJsonStreamError.Create('Unexpected character ''' + PeekRealChar + ''' in array');
      end;
    end;

    raise EJsonStreamError.Create('Array not closed');
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonReader.ReadObject: IJsonObject;
  var
    c: WideChar;
    name: UnicodeString;
    value: IJsonMutableValue;
  begin
    if ReadRealChar <> '{' then
      raise EJsonStreamError.Create('Expected ''{''');

    result := TJsonObject.Create;

    if (PeekRealChar = '}') then
    begin
      ReadRealChar; // Skip the '}'
      EXIT;
    end;

    while NOT EOF do
    begin
      if PeekRealChar = '"' then
        name := ReadString
      else
        name := ReadName;

      c := ReadRealChar;
      if (c <> ':') then
        raise EJsonStreamError.Create('Expected '':'', read ''' + c + ''' instead');

      value := ReadValue;

      if NOT Assigned(value) then
        raise EJsonStreamError.Create('Expected value');

      result.Add(name, value);

      // Test the next char for , (another name/value pair to follow) or } (end of object)

      case PeekRealChar of

        '}' : begin
                ReadRealChar;
                EXIT;
              end;

        ',' : ReadRealChar;

      else
        raise EJsonStreamError.Create('Unexpected character ''' + PeekRealChar + ''' in object');
      end;
    end;

    raise EJsonStreamError.Create('Object not terminated');
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonReader.ReadName: UnicodeString;
  {
    NOTE: This supports a relaxed Json reader that allows for unquoted object
           value names instead of requiring quoted string values.  The lack
           of quotes means that allowed names are much simplified: only alpha
           characters are permitted.  Whitespace, most symbols and escaped
           characters are not supported or allowed.
  }
  var
    c: WideChar;
  begin
    result := '';
    while TRUE do
    begin
      c := ReadChar;

      case c of
        'a'..'z',
        'A'..'Z'  : result := result + c;
        '.', '-'  : if result = '' then
                      raise EJsonStreamError.Create('Invalid name')
                    else
                      result := result + c;
      else
        raise EJsonStreamError.Create('Invalid name');
      end;

      if EOF then
        raise EJsonStreamError.Create('UnicodeString not terminated');

      c := PeekRealChar;

      if (Ord(c) < 128) and (AnsiChar(c) = ':') then
      begin
        c := result[Length(result)];
        if (c = '.') or (c = '-') then
          raise EJsonStreamError.Create('Invalid name')
        else
          EXIT;
      end;
    end;

  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonReader.ReadString(const aQuoted: Boolean): UnicodeString;
  {
    NOTE: This effectively duplicates the functionality of TJsonString.Decode
           but it is far more efficient to decode inline than it would be to
           parse the reading of the entire string before decoding it.
  }

    function UnescapeUnicode: WideChar;
    const
      BYTEINDEX: array[1..4] of Integer = (3, 4, 1, 2);
    var
      i: Integer;
      c: WideChar;
      buf: UnicodeString;
    begin
      SetLength(buf, 4);

      for i := 1 to 4 do
      begin
        c := PeekChar;

        if (Ord(c) < 128) and (AnsiChar(c) in ['0'..'9', 'a'..'f', 'A'..'F']) then
        begin
          buf[i] := c;
          ReadChar;
        end
        else
          raise EJsonStreamError.CreateFmt('Invalid character ''%s'' in escaped Unicode', [c]);
      end;

      Hex2Bin.ToBin(buf, @result);
    end;

  var
    c: WideChar;
  begin
    if aQuoted then
    begin
      if (ReadRealChar <> '"') then
        raise EJsonStreamError.Create('Expected ''"''');
    end;

    if EOF then
      raise EJsonStreamError.Create('UnicodeString not terminated');

    result := '';
    while TRUE do
    begin
      c := ReadChar;

      if (c = '\') then
      begin
        c := ReadChar;

        case c of
          '"', '\', '/' : {NO-OP - read these chars just as they are};
          'b' : c := WideChar(#8);
          't' : c := WideChar(#9);
          'n' : c := WideChar(#10);
          'f' : c := WideChar(#12);
          'r' : c := WideChar(#13);
          'u' : c := UnescapeUnicode;
        else
          raise EJsonStreamError.Create('Invalid escape character sequence');
        end;
      end
      else if aQuoted and (c = '"') then
        EXIT;

      result := result + c;

      if EOF then
        raise EJsonStreamError.Create('UnicodeString not terminated');

      c := PeekChar;

      if NOT aQuoted and (Ord(c) < 128) and (AnsiChar(c) in [#13, #10, #9, ' ', ',', '}', ']']) then
        EXIT;
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonReader.ReadValue: IJsonMutableValue;
  var
    c: WideChar;
    s: UnicodeString;
    int64Value: Int64;
    extendedValue: Extended;
  begin
    result := NIL;
    try
      c := PeekRealChar;

      case c of
        #0  : { NO-OP };
        '[' : result := ReadArray;
        '{' : result := ReadObject;

        '"'       : begin
                      s := ReadString;
                      result := JsonString.AsString(s);
                    end;

        '-'       : begin
                      ReadRealChar;

                      c := PeekChar;
                      case c of
                        '1'..'9'  : begin
                                      s := ReadString(FALSE);

                                      if Parse(s).IsInt64(int64Value) then
                                        result := JsonNumber.AsInt64(-1 * int64Value)
                                      else if Parse(s).IsExtended(extendedValue) then
                                        result := JsonNumber.AsExtended(-1 * extendedValue)
                                      else
                                        raise EJsonStreamError.CreateFmt('''%s'' is not a valid number', [s]);
                                    end;
                      else
                        raise EJsonStreamError.CreateFmt('Expected 1..9, found ''%s''', [c]);
                      end;
                    end;

        '0'..'9'  : begin
                      s := ReadString(FALSE);

                      if Parse(s).IsInt64(int64Value) then
                        result := JsonNumber.AsInt64(int64Value)
                      else if Parse(s).IsExtended(extendedValue) then
                        result := JsonNumber.AsExtended(extendedValue)
                      else
                        raise EJsonStreamError.CreateFmt('''%s'' is not a valid number', [s]);
                    end;

        'n', 'N'  : begin
                      s := ReadString(FALSE);
                      if SameText(s, 'null') then
                        result := JsonNull.New
                      else
                        raise EJsonStreamError.CreateFmt('Expected ''null'', found ''%s''', [s]);
                    end;

        'f', 'F',
        't', 'T'  : begin
                      s := ReadString(FALSE);
                      if SameText(s, 'true') or SameText(s, 'false') then
                        result := JsonBoolean.AsBoolean(s = 'true')
                      else
                        raise EJsonStreamError.CreateFmt('Expected ''true'' or ''false'', found ''%s''', [s]);
                    end;
      else
        raise EJsonStreamError.CreateFmt('Unexpected char (%s) in stream', [c]);
      end;

    except
      raise EJsonStreamError.CreateFmt('Error at position %d, line %d', [fSource.Location.Character, fSource.Location.Line]);
    end;
  end;





end.
