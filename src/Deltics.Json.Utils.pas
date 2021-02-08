
{$i deltics.json.inc}

  unit Deltics.Json.Utils;


interface

  uses
    Classes,
    SysUtils,
    Deltics.Datetime,
    Deltics.Strings,
    Deltics.Json.Interfaces;

  type
    TJsonDateTimeParts = (dpYear, dpMonth, dpDay, dpTime, dpOffset);
    TJsonDatePart = dpYear..dpDay;


    Json = class
      class function DecodeDate(const aString: UnicodeString): TDateTime;
      class function DecodeString(const aValue: Utf8String): UnicodeString;
      class function EncodeDate(const aDate: TDate; const aAccuracy: TJsonDatePart = dpDay): UnicodeString; overload;
      class function EncodeDate(const aYear: Word): UnicodeString; overload;
      class function EncodeDate(const aYear, aMonth: Word): UnicodeString; overload;
      class function EncodeDate(const aYear, aMonth, aDay: Word): UnicodeString; overload;
      class function EncodeDateTime(const aDateTime: TDateTime): UnicodeString; overload;
      class function EncodeDateTime(const aDateTime: TDateTime; const aDateAccuracy: TJsonDatePart): UnicodeString; overload;
      class function EncodeDateTime(const aDateTime: TDateTime; const aOffset: SmallInt): UnicodeString; overload;
      class function EncodeDateTime(const aDateTime: TDateTime; const aDateAccuracy: TJsonDatePart; const aOffset: SmallInt): UnicodeString; overload;
      class function EncodeString(const aString: UnicodeString): Utf8String;

      class function FromFile(const aFilename: String): IJsonValue;
      class function FromStream(aStream: TStream): IJsonValue; overload;
      class function FromString(const aString: String): IJsonValue; overload;

    end;


implementation

  uses
    Deltics.io.Text,
    Deltics.Pointers,
    Deltics.Json.Exceptions,
    Deltics.Json.Reader;


  class function Json.DecodeDate(const aString: UnicodeString): TDateTime;

    function Pop(var S: String;
                 const aLen: Integer;
                 const aValidNextChars: TAnsiCharSet;
                 var   aNextChar: Char): Word;
    var
      ok: Boolean;
      nextChar: AnsiChar;
    begin
      ok        := TRUE;
      nextChar  := AnsiChar(#0);

      // Determine the AnsiChar that follows immediately after the value of the
      //  specified length that we are about to extract from the string.
      //
      // If the string is exactly the length of the value we are about to extract
      //  then the next char is #0 (NULL).  i.e. the end of the string.
      //
      // If the string is longer than the value we are about to extract then the
      //  next char is simply the char occuring immediately following the extracted
      //  value.
      //
      // If the string is shorter than the required value or if the determined
      //  next character is not one of the expected, valid next characters then
      //  the string is not a valid Json encoded date.

      if (Length(S) > aLen) then
        nextChar := AnsiChar(S[aLen + 1])
      else if (Length(S) < aLen) then
        ok := FALSE;

      ok := ok and (nextChar in aValidNextChars);

      if NOT ok then
        raise EJsonConvertError.CreateFmt('''%s'' is not a valid Json date/time', [aString]);

      result := StrToInt(Copy(S, 1, aLen));
      Delete(S, 1, aLen);

      if Length(S) > 0 then
      begin
        aNextChar := S[1];
        Delete(S, 1, 1);
      end
      else
        aNextChar := #0;
    end;

  var
    c: Char;
    s: String;
    year, month, day: Word;
    hour, min, sec, msec, zh, zm: Word;
    z: Integer;
  begin
    s := aString;

    // Year is required to be present so either we have a valid value and
    //  year will be set or the value is invalid and there will be an exception.
    //  Either way, we do not need to initialise year here.
    //
    // All other values are initialised with the required defaults should they
    //  not be present.

    month := 1;
    day   := 1;
    hour  := 0;
    min   := 0;
    sec   := 0;
    msec  := 0;
    z     := 0;
    zh    := 0;
    zm    := 0;

    year := Pop(s, 4, [#0, '-', 'T'], c);

    if c = '-' then
      month := Pop(s, 2, [#0, '-', 'T'], c);

    if c = '-' then
      day := Pop(s, 2, [#0, '-', 'T'], c);

    if c = 'T' then
    begin
      hour  := Pop(s, 2, [':'], c);
      min   := Pop(s, 2, [':'], c);
      sec   := Pop(s, 2, ['.'], c);
      msec  := Pop(s, 3, [#0, '+', '-', 'Z'], c);

      case c of
        '+' : z := 1;
        '-' : z := -1;
      end;

      if z <> 0 then
      begin
        zh := z * Pop(s, 2, [':'], c);
        zm := z * Pop(s, 2, [#0], c);
      end;
    end;

    result := SysUtils.EncodeDate(year, month, day);
    result := result + EncodeTime(hour - zh, min - zm, sec, msec);
  end;


  class function Json.EncodeDate(const aDate: TDate;
                                 const aAccuracy: TJsonDatePart): UnicodeString;
  begin
    case aAccuracy of
      dpYear  : result := FormatDateTime('yyyy', aDate);
      dpMonth : result := FormatDateTime('yyyy-mm', aDate);
      dpDay   : result := FormatDateTime('yyyy-mm-dd', aDate);
    end;
  end;


  class function Json.EncodeDate(const aYear: Word): UnicodeString;
  begin
    result := WIDE.PadLeft(aYear, 4, '0');
  end;


  class function Json.EncodeDate(const aYear, aMonth: Word): UnicodeString;
  begin
    result := self.EncodeDate(aYear) + '-' + WIDE.PadLeft(aMonth, 2, '0');
  end;


  class function Json.EncodeDate(const aYear, aMonth, aDay: Word): UnicodeString;
  begin
    result := self.EncodeDate(aYear, aMonth) + '-' + WIDE.PadLeft(aDay, 2, '0');
  end;


  class function Json.EncodeDateTime(const aDateTime: TDateTime): UnicodeString;
  begin
    result := EncodeDateTime(aDateTime, dpDay);
  end;


  class function Json.EncodeDateTime(const aDateTime: TDateTime;
                                     const aDateAccuracy: TJsonDatePart): UnicodeString;
  begin
    result := EncodeDate(aDateTime, aDateAccuracy) + 'T' + FormatDateTime('HH:nn:ss.zzz', aDateTime);
  end;


  class function Json.EncodeDateTime(const aDateTime: TDateTime;
                                     const aOffset: SmallInt): UnicodeString;
  begin
    result := EncodeDateTime(aDateTime, dpDay, aOffset);
  end;


  class function Json.EncodeDateTime(const aDateTime: TDateTime;
                                     const aDateAccuracy: TJsonDatePart;
                                     const aOffset: SmallInt): UnicodeString;
  const
    SIGN: array[FALSE..TRUE] of String = ('-', '+');
  var
    isPos: Boolean;
    zh, zm: SmallInt;
  begin
    if aOffset <> 0 then
    begin
      isPos := aOffset >= 0;
      zh    := Abs(aOffset) div 60;
      zm    := Abs(aOffset) mod 60;

      result := EncodeDateTime(aDateTime, aDateAccuracy) + SIGN[isPos] + WIDE.PadLeft(zh, 2, '0')
                                                                 + ':' + WIDE.PadLeft(zm, 2, '0');
    end
    else
      result := EncodeDate(aDateTime, aDateAccuracy) + 'Z';
  end;




  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  class function Json.DecodeString(const aValue: Utf8String): UnicodeString;

    function UnescapeUnicode(var aI: Integer): WideChar;
    var
      buf: array[0..3] of Utf8Char;
    begin
      buf[2] := Utf8Char(aValue[aI + 1]);
      buf[3] := Utf8Char(aValue[aI + 2]);
      buf[0] := Utf8Char(aValue[aI + 3]);
      buf[1] := Utf8Char(aValue[aI + 4]);

      HexToBin(PANSIChar(@buf), result, 4);

      Inc(aI, 4);
    end;

  var
    c: Utf8Char;
    wc: WideChar;
    quoted: Boolean;
    i, ri: Integer;
    len: Integer;
  begin
    wc := #0;

    result := '';
    if aValue = '' then
      EXIT;

    i   := 1;
    len := Length(aValue);

    quoted := (aValue[1] = '"');
    if quoted then
    begin
      if (len < 2) or (aValue[len] <> '"') then
        raise EJsonFormatError.Create('Quoted string not terminated');

      Inc(i);
      Dec(len);
    end;

    ri := 1;
    SetLength(result, len);
    try
      while (i <= len) do
      begin
        c := aValue[i];

        if (c = '\') then
        begin
          if (i = len) then
            raise EJsonFormatError.Create('Incomplete escape sequence');

          Inc(i);
          c := aValue[i];

          case c of
            '"', '\', '/' : wc := WideChar(c);
            'b' : wc := WideChar(#8);
            't' : wc := WideChar(#9);
            'n' : wc := WideChar(#10);
            'f' : wc := WideChar(#12);
            'r' : wc := WideChar(#13);
            'u' : if (i + 4) <= len then
                    wc := UnescapeUnicode(i)
                  else
                    raise EJsonFormatError.Create('Incomplete Unicode escape sequence');
          else
            raise EJsonFormatError.Create('Invalid escape sequence');
          end;
        end;

        result[ri] := wc;
        Inc(ri);
        Inc(i);
      end;

    finally
      SetLength(result, ri - 1);
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  class function Json.EncodeString(const aString: UnicodeString): Utf8String;

  // TODO: I don't think this handles surrogate pairs properly

    procedure EscapeUnicode(const aChar: WideChar);
    var
      i: Integer;
      buf: array[0..3] of Char;
    begin
//      Classes.BinToHex(@aChar, PWideChar(@buf), 2);

      i := Length(result);
      SetLength(result, i + 6);

      result[i + 1] := '\';
      result[i + 2] := 'u';
      result[i + 3] := Utf8Char(buf[2]);
      result[i + 4] := Utf8Char(buf[3]);
      result[i + 5] := Utf8Char(buf[0]);
      result[i + 6] := Utf8Char(buf[1]);
    end;

  var
    i: Integer;
    c: WideChar;
  begin
    result := '"';

    for i := 1 to Length(aString) do
    begin
      c := aString[i];

      case c of
        '"', '/', '\' : result := Utf8.Append(Utf8.Append(result, '\'), Utf8Char(c));
        ANSIChar(#8)  : result := result + '\b';
        ANSIChar(#9)  : result := result + '\t';
        ANSIChar(#10) : result := result + '\n';
        ANSIChar(#12) : result := result + '\f';
        ANSIChar(#13) : result := result + '\r';
      else
        if (Word(c) > $7f) then
          EscapeUnicode(c)
        else
          result := Utf8.Append(result, Utf8Char(c));
      end;
    end;

    result := result + '"';
  end;


  class function Json.FromFile(const aFilename: String): IJsonValue;
  var
    src: TFileStream;
  begin
    src := TFileStream.Create(aFilename, fmOpenRead or fmShareDenyWrite);
    try
      result := FromStream(src);
    finally
      src.Free;
    end;
  end;



  class function Json.FromStream(aStream: TStream): IJsonValue;
  var
    source: IUnicodeReader;
    reader: IJsonReader;
  begin
    source := TUnicodeReader.Create(aStream, TEncoding.Utf8);
    reader := TJsonReader.Create(source);

    result := reader.ReadValue;
  end;



  class function Json.FromString(const aString: String): IJsonValue;
  var
    source: IUnicodeReader;
    reader: IJsonReader;
  begin
    source := TUnicodeReader.Create(aString);
    reader := TJsonReader.Create(source);

    result := reader.ReadValue;
  end;







end.
