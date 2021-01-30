{
  * X11 (MIT) LICENSE *

  Copyright © 2011 Jolyon Smith

  Permission is hereby granted, free of charge, to any person obtaining a copy of
   this software and associated documentation files (the "Software"), to deal in
   the Software without restriction, including without limitation the rights to
   use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
   of the Software, and to permit persons to whom the Software is furnished to do
   so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
   copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
   SOFTWARE.


  * GPL and Other Licenses *

  The FSF deem this license to be compatible with version 3 of the GPL.
   Compatability with other licenses should be verified by reference to those
   other license terms.


  * Contact Details *

  Original author : Jolyon Smith
  skype           : deltics
  e-mail          : <EXTLINK mailto: jsmith@deltics.co.nz>jsmith@deltics.co.nz</EXTLINK>
  website         : <EXTLINK http://www.deltics.co.nz>www.deltics.co.nz</EXTLINK>
}

{$i deltics.json.inc}

  unit Deltics.Json;


interface

  uses
  { vcl: }
    Classes,
    Contnrs,
    SysUtils,
    TypInfo,
  { deltics: }
    Deltics.Datetime,
    Deltics.IO.Text,
    Deltics.Strings,
    Deltics.Json.Interfaces,
    Deltics.Json.Object_,
    Deltics.Json.String_;


  type
    TJsonValueType = Deltics.Json.Interfaces.TValueType;
  const
    jsObject    = Deltics.Json.Interfaces.jsObject;
    jsArray     = Deltics.Json.Interfaces.jsArray;
    jsString    = Deltics.Json.Interfaces.jsString;
    jsNumber    = Deltics.Json.Interfaces.jsNumber;
    jsBoolean   = Deltics.Json.Interfaces.jsBoolean;
    jsNull      = Deltics.Json.Interfaces.jsNull;


  type
    IJsonObject = Deltics.Json.Interfaces.IJsonObject;
    JsonObject  = Deltics.Json.Object_.JsonObject;

    IJsonString = Deltics.Json.Interfaces.IJsonString;
    JsonString  = Deltics.Json.String_.JsonString;

    Json = class;

    TJsonDateTimeParts = (dpYear, dpMonth, dpDay, dpTime, dpOffset);
    TJsonDatePart = dpYear..dpDay;

    TJsonValue = class;
      TJsonBoolean = class;
      TJsonNull = class;
      TJsonNumber = class;
      TJsonInteger = class;
      TJsonString = class;
      TJsonStructure = class;
        TJsonArray  = class;
        TJsonObject  = class;

    TJsonFormat = (jfStandard, jfCompact, jfConfig);
//      TJsonComment = class;


    TJsonValueClass = class of TJsonValue;


    EJsonError = class(Exception);
    EJsonStreamError = class(EJsonError);

    TJsonObjectComparer = function(const A, B: TJsonObject): Integer;

//    TJsonValueType = (jsString, jsNumber, jsBoolean, jsArray, jsObject, jsNull);


    Json = class
      class function DecodeDate(const aString: UnicodeString): TDateTime;
      class function EncodeDate(const aDate: TDate; const aAccuracy: TJsonDatePart = dpDay): UnicodeString; overload;
      class function EncodeDate(const aYear: Word): UnicodeString; overload;
      class function EncodeDate(const aYear, aMonth: Word): UnicodeString; overload;
      class function EncodeDate(const aYear, aMonth, aDay: Word): UnicodeString; overload;
      class function EncodeDateTime(const aDateTime: TDateTime): UnicodeString; overload;
      class function EncodeDateTime(const aDateTime: TDateTime; const aDateAccuracy: TJsonDatePart): UnicodeString; overload;
      class function EncodeDateTime(const aDateTime: TDateTime; const aOffset: SmallInt): UnicodeString; overload;
      class function EncodeDateTime(const aDateTime: TDateTime; const aDateAccuracy: TJsonDatePart; const aOffset: SmallInt): UnicodeString; overload;
      class function EncodeString(const aString: String): String;

      class function ReadFromFile(const aFilename: String): TJsonValue;
      class function ReadValue(aStream: TStream): TJsonValue; overload;
      class function ReadValue(const aString: String): TJsonValue; overload;
    end;


    TJsonValue = class
    private
      fIsNull: Boolean;
      fName: UnicodeString;
      fValueType: TJsonValueType;
      function get_AsArray: TJsonArray;
      function get_AsBoolean: Boolean;
      function get_AsDateTime: TDateTime;
      function get_AsDouble: Double;
      function get_AsEnum(const aTypeInfo: PTypeInfo): Integer;
      function get_AsGUID: TGUID;
      function get_AsInt64: Int64;
      function get_AsInteger: Integer;
      function get_AsObject: TJsonObject;
      function get_AsString: UnicodeString;
      procedure set_AsBoolean(const aValue: Boolean);
      procedure set_AsDateTime(const aValue: TDateTime);
      procedure set_AsDouble(const aValue: Double);
      procedure set_AsGUID(const aValue: TGUID);
      procedure set_AsInt64(const aValue: Int64);
      procedure set_AsInteger(const aValue: Integer);
      procedure set_AsString(const aValue: UnicodeString);
      function get_IsNull: Boolean; virtual;
      procedure set_IsNull(const aValue: Boolean); virtual;
      function DoGetAsString: UnicodeString; virtual; abstract;
      procedure DoSetAsString(const aValue: UnicodeString); virtual;
      procedure Wipe; virtual;
    protected
      function get_AsJson: UnicodeString; virtual;
    public
      constructor Create; virtual;
      procedure Clear; virtual;
      function Clone: TJsonValue; virtual;
      procedure CopyFrom(const aSource: TJsonValue); virtual;
      function IsEqual(const aOther: TJsonValue): Boolean;
      property AsArray: TJsonArray read get_AsArray;
      property AsBoolean: Boolean read get_AsBoolean write set_AsBoolean;
      property AsDateTime: TDateTime read get_AsDateTime write set_AsDateTime;
      property AsDouble: Double read get_AsDouble write set_AsDouble;
      property AsEnum[const aTypeInfo: PTypeInfo]: Integer read get_AsEnum;
      property AsGUID: TGUID read get_AsGUID write set_AsGUID;
      property AsInt64: Int64 read get_AsInt64 write set_AsInt64;
      property AsInteger: Integer read get_AsInteger write set_AsInteger;
      property AsJson: UnicodeString read get_AsJson;
      property AsObject: TJsonObject read get_AsObject;
      property AsString: UnicodeString read get_AsString write set_AsString;
      property IsNull: Boolean read get_IsNull write set_IsNull;
      property Name: UnicodeString read fName write fName;
      property ValueType: TJsonValueType read fValueType;

    {$ifdef DELPHI2009__}
    private
      function get_AsDate: TDate;
      function get_AsTime: TTime;
      procedure set_AsDate(const aValue: TDate);
      procedure set_AsTime(const aValue: TTime);
    public
      property AsDate: TDate read get_AsDate write set_AsDate;
      property AsTime: TTime read get_AsTime write set_AsTime;
    {$endif}
    end;


      TJsonBoolean = class(TJsonValue)
      private
        fValue: Boolean;
        procedure set_Value(const aValue: Boolean);
      protected
        function DoGetAsString: UnicodeString; override;
        procedure DoSetAsString(const aValue: UnicodeString); override;
      public
        procedure CopyFrom(const aSource: TJsonValue); override;
        property Value: Boolean read fValue write set_Value;
      end;

      TJsonNull = class(TJsonValue)
      protected
        function get_IsNull: Boolean; override;
        function DoGetAsString: UnicodeString; override;
      end;

      TJsonNumber = class(TJsonValue);

        TJsonDouble = class(TJsonNumber)
        private
          fValue: Double;
          procedure set_Value(const aValue: Double);
        protected
          function DoGetAsString: UnicodeString; override;
          procedure DoSetAsString(const aValue: UnicodeString); override;
        public
          procedure CopyFrom(const aSource: TJsonValue); override;
          property Value: Double read fValue write set_Value;
        end;

        TJsonInteger = class(TJsonNumber)
        private
          fValue: Int64;
          procedure set_Value(const aValue: Int64);
        protected
          function DoGetAsString: UnicodeString; override;
          procedure DoSetAsString(const aValue: UnicodeString); override;
        public
          procedure CopyFrom(const aSource: TJsonValue); override;
          property Value: Int64 read fValue write set_Value;
        end;


      TJsonString = class(TJsonValue)
      private
        fValue: UnicodeString;
        procedure set_Value(const aValue: UnicodeString);
      protected
        function get_AsJson: UnicodeString; override;
        function DoGetAsString: UnicodeString; override;
        procedure DoSetAsString(const aValue: UnicodeString); override;
      public
        class function Decode(const aValue: UnicodeString): UnicodeString;
        class function Encode(const aValue: UnicodeString): UnicodeString;
        procedure CopyFrom(const aSource: TJsonValue); override;
        property Value: UnicodeString read fValue write set_Value;
      end;


      TJsonStructure = class(TJsonValue)
      private
        function get_AsDisplayText: UnicodeString;
      protected
        function get_IsEmpty: Boolean; virtual; abstract;
        function get_IsNull: Boolean; override;
        procedure Add(const aValue: TJsonValue); overload; virtual; abstract;
      public
        class function CreateFromFile(const aFilename: UnicodeString): TJsonStructure;
        class function CreateFromStream(const aStream: TStream): TJsonStructure; overload;
        class function CreateFromStream(const aStream: TStream; const aDefaultEncoding: TEncoding): TJsonStructure; overload;
        class function CreateFromANSI(const aString: ANSIString): TJsonStructure;
        class function CreateFromUTF8(const aString: UTF8String): TJsonStructure;
        class function CreateFromWIDE(const aString: UnicodeString): TJsonStructure;
        class function CreateFromString(const aString: String): TJsonStructure;
        function Add(const aName: UnicodeString; const aValue: TJsonStructure): TJsonStructure; overload;
        function Add(const aName: UnicodeString; const aValue: Boolean): TJsonBoolean; overload;
        function Add(const aName: UnicodeString; const aValue: Integer): TJsonInteger; overload;
        function Add(const aName: UnicodeString; const aValue: Int64): TJsonNumber; overload;
        function Add(const aName: UnicodeString; const aValue: UnicodeString): TJsonString; overload;
        function Add(const aName: UnicodeString; const aValue: TGUID): TJsonString; overload;
        function Add(const aName: UnicodeString; const aValue: Double): TJsonNumber; overload;
        function Add(const aName: UnicodeString; const aValue: Integer; const aTypeInfo: PTypeInfo): TJsonString; overload;
      {$ifdef DELPHI2009__}
        function Add(const aName: UnicodeString; const aValue: TDateTime): TJsonString; overload;
        function Add(const aName: UnicodeString; const aValue: TDate): TJsonString; overload;
        function Add(const aName: UnicodeString; const aValue: TTime): TJsonString; overload;
      {$endif}
        function AddArray(const aName: UnicodeString = ''): TJsonArray;
        function AddDate(const aName: UnicodeString; const aValue: TDate): TJsonString;
        function AddTime(const aName: UnicodeString; const aValue: TTime): TJsonString;
        function AddDateTime(const aName: UnicodeString; const aValue: TDateTime): TJsonString;
        function AddDouble(const aName: UnicodeString; const aValue: Double): TJsonNumber;
        procedure AddNull(const aName: UnicodeString);
        function AddObject(const aName: UnicodeString = ''): TJsonObject;
        procedure Load(const aSource: IUnicodeReader);
        procedure LoadFromFile(const aFileName: UnicodeString; const aEncoding: TEncoding = NIL);
        procedure LoadFromStream(const aStream: TStream; const aEncoding: TEncoding = NIL);
        procedure SaveToFile(const aFileName: UnicodeString; const aFormat: TJsonFormat = jfStandard);
        procedure SaveToStream(const aStream: TStream; const aFormat: TJsonFormat = jfStandard);
        procedure Wipe; override; abstract;
        property AsDisplayText: UnicodeString read get_AsDisplayText;
        property IsEmpty: Boolean read get_IsEmpty;
      end;


        TJsonArray = class(TJsonStructure)
        private
          fItems: TObjectList;
          function get_Item(const aIndex: Integer): TJsonValue;
          function get_Count: Integer;
        protected
          function get_IsEmpty: Boolean; override;
          function DoGetAsString: UnicodeString; override;
          procedure DoSetAsString(const aValue: UnicodeString); override;
        public
          constructor Create; overload; override;
          destructor Destroy; override;
          function Add(const aValue: Boolean): TJsonBoolean; reintroduce; overload;
          function Add(const aValue: Integer): TJsonInteger; reintroduce; overload;
          function Add(const aValue: UnicodeString): TJsonString; reintroduce; overload;
          function Add(const aValue: TDateTime): TJsonString; reintroduce; overload;
          function Add(const aValue: TGUID): TJsonString; reintroduce; overload;
          function Add(const aValue: TJsonStructure): TJsonStructure; reintroduce; overload;
          function Add(const aValue: Integer; const aTypeInfo: PTypeInfo): TJsonString; reintroduce; overload;
          procedure Add(const aValues: IStringList); reintroduce; overload;
          procedure Add(const aValue: TJsonValue); override;
          function AddArray: TJsonArray; reintroduce;
          procedure AddNull; reintroduce;
          function AddObject(const aTemplate: TJsonObject = NIL): TJsonObject; reintroduce;
          function AsStringArray: TStringArray;
          procedure Clear; override;
          function Clone: TJsonArray; reintroduce;
          procedure Combine(const aSource: TJsonArray);
          procedure CopyFrom(const aSource: TJsonValue); override;
          procedure Delete(const aIndex: Integer); overload;
          procedure Delete(const aValue: TJsonValue); overload;
          function FindObject(const aValueName: UnicodeString; const aValue: TGUID; var aObject: TJsonObject): Boolean;
          procedure GetStrings(const aList: TStringList);
          procedure Sort(const aComparer: TJsonObjectComparer);
          procedure Wipe; override;
          property Count: Integer read get_Count;
          property Items[const aIndex: Integer]: TJsonValue read get_Item; default;
        end;


        TJsonObject = class(TJsonStructure)
        private
          fValues: TObjectList;
          function get_Value(const aName: UnicodeString): TJsonValue;
          function get_ValueCount: Integer;
          function get_ValueByIndex(const aIndex: Integer): TJsonValue;
        protected
          function get_IsEmpty: Boolean; override;
          procedure Add(const aValue: TJsonValue); override;
          function DoGetAsString: UnicodeString; override;
          procedure DoSetAsString(const aValue: UnicodeString); override;
        public
          class function TryCreate(const aString: UnicodeString): TJsonObject;
          constructor Create; overload; override;
          constructor Create(const aString: UnicodeString); reintroduce; overload;
          constructor CreateFromFile(const aFilename: UnicodeString; const aEncoding: TEncoding);
          destructor Destroy; override;
          function AddAfter(const aPredecessor: UnicodeString; const aName: UnicodeString; const aValue: UnicodeString): TJsonString; overload;
          procedure Clear; override;
          function Clone: TJsonObject; reintroduce;
          procedure Combine(const aObject: TJsonObject);
          function Contains(const aValueName: UnicodeString): Boolean; overload;
          function Contains(const aValueName: UnicodeString; var aValue: UnicodeString): Boolean; overload;
          function Contains(const aValueName: UnicodeString; var aValue: TJsonArray): Boolean; overload;
          function Contains(const aValueName: UnicodeString; var aValue: TWIDEStringArray): Boolean; overload;
          procedure Delete(const aValueName: UnicodeString); overload;
          function FindValue(const aName: UnicodeString): TJsonValue;
          procedure CopyFrom(const aSource: TJsonValue); override;
          procedure LoadFromStream(const aStream: TStream; const aEncoding: TEncoding = NIL);
          function OptBoolean(const aName: UnicodeString; const aDefault: Boolean = FALSE): Boolean;
          function OptDateTime(const aName: UnicodeString; const aDefault: TDateTime = 0): TDateTime;
          function OptEnum(const aName: UnicodeString; const aTypeInfo: PTypeInfo; const aDefault: Integer = 0): Integer;
          function OptInteger(const aName: UnicodeString; const aDefault: Integer = 0): Integer;
          function OptString(const aName: UnicodeString; const aDefault: UnicodeString = ''): UnicodeString;
          procedure Wipe; override;
        {$ifdef DELPHI2009__}
          function OptDate(const aName: UnicodeString; const aDefault: TDate = 0): TDate;
          function OptTime(const aName: UnicodeString; const aDefault: TTime = 0): TTime;
        {$endif}
          property ValueCount: Integer read get_ValueCount;
          property Values[const aName: UnicodeString]: TJsonValue read get_Value; default;
          property ValueByIndex[const aIndex: Integer]: TJsonValue read get_ValueByIndex;
        end;


    TJsonReader = class
    private
      fSource: IUnicodeReader;
      function EOF: Boolean;
      function NextChar: WideChar;
      function NextRealChar: WideChar;
      function ReadChar: WideChar;
      function ReadRealChar: WideChar; overload;
      function ReadName: UnicodeString;
      function ReadString(const aQuoted: Boolean = TRUE): UnicodeString;
    public
      constructor Create(const aSource: IUnicodeReader);
      function ReadArray: TJsonArray;
      function ReadObject: TJsonObject;
      function ReadValue: TJsonValue;
    end;


    JsonFormatter = class
      class function Format(const aJson: TJsonStructure; const aFormat: TJsonFormat): String;
    end;


implementation

  uses
    Types,
    Windows,
  { deltics: }
    Deltics.IO.Streams;


  const
    NULLDATE  : TDateTime = 0;
    NULLGUID  : TGUID = '{00000000-0000-0000-0000-000000000000}';



  function SameGUID(const GUIDA, GUIDB: TGUID): Boolean;
  begin
    result := CompareMem(@GUIDA, @GUIDB, sizeof(TGUID));
  end;



  class function Json.DecodeDate(const aString: UnicodeString): TDateTime;

    function Pop(var S: String;
                 const aLen: Integer;
                 const aValidNextChars: TANSICharSet;
                 var   aNextChar: Char): Word;
    var
      ok: Boolean;
      nextChar: ANSIChar;
    begin
      ok        := TRUE;
      nextChar  := ANSIChar(#0);

      // Determine the ANSIChar that follows immediately after the value of the
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
        nextChar := ANSIChar(S[aLen + 1])
      else if (Length(S) < aLen) then
        ok := FALSE;

      ok := ok and (nextChar in aValidNextChars);

      if NOT ok then
        raise EJsonError.Create('''' + aString + ''' is not a valid Json date/time');

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



  class function Json.EncodeString(const aString: String): String;
  begin
    result := TJsonString.Encode(aString);
  end;


  class function Json.ReadFromFile(const aFilename: String): TJsonValue;
  var
    src: TFileStream;
  begin
    result := NIL;

    src := TFileStream.Create(aFilename, fmOpenRead or fmShareDenyWrite);
    try
      try
        result := ReadValue(src);

      except
        raise;
//        raise Exception.CreateFmt(' Json in file ''%s''', [aFilename]);
      end;

    finally
      src.Free;
    end;
  end;



  class function Json.ReadValue(aStream: TStream): TJsonValue;
  var
    unicode: IUnicodeReader;
  begin
    unicode := TUnicodeReader.Create(aStream, TEncoding.Utf8);

    with TJsonReader.Create(unicode) do
    try
      result := ReadValue;
      try
        if NOT EOF and (NextRealChar <> #0) then
          raise EJsonStreamError.Create('Unexpected data');

      except
        result.Free;
        raise;
      end;

    finally
      Free;
    end;
  end;



  class function Json.ReadValue(const aString: String): TJsonValue;
  var
    unicode: IUnicodeReader;
  begin
    unicode := TUnicodeReader.Create(aString);

    with TJsonReader.Create(unicode) do
    try
      result := ReadValue;
      try
        if NOT EOF and (NextRealChar <> #0) then
          raise EJsonStreamError.Create('Unexpected data');

      except
        result.Free;
        raise;
      end;

    finally
      Free;
    end;
  end;









{ TJsonValue ------------------------------------------------------------------------------------- }

  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  constructor TJsonValue.Create;
  begin
    inherited Create;

    if      (self is TJsonArray)   then  fValueType := jsArray
    else if (self is TJsonString)  then  fValueType := jsString
    else if (self is TJsonBoolean) then  fValueType := jsBoolean
    else if (self is TJsonNull)    then  fValueType := jsNull
    else if (self is TJsonNumber)  then  fValueType := jsNumber
    else if (self is TJsonObject)  then  fValueType := jsObject
    else
      raise EJsonError.Create('Unknown Json value class');
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonValue.DoSetAsString(const aValue: UnicodeString);
  begin
    fIsNull := FALSE;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonValue.Clear;
  begin
    fIsNull  := TRUE;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonValue.Clone: TJsonValue;
  begin
    result := TJsonValueClass(ClassType).Create;
    result.CopyFrom(self);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonValue.CopyFrom(const aSource: TJsonValue);
  begin
    fIsNull  := aSource.fIsNull;
    fName    := aSource.fName;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonValue.Wipe;
  begin
    Clear;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonValue.get_AsArray: TJsonArray;
  begin
    result := self as TJsonArray;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonValue.get_AsBoolean: Boolean;
  begin
    if Assigned(self) and NOT IsNull then
    begin
      if NOT (self is TJsonBoolean) then
      begin
        ASSERT(ValueType = jsString);
        result := SameText(AsString, 'true');
      end
      else
        result := TJsonBoolean(self).Value;
    end
    else
      result := FALSE;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonValue.get_AsDateTime: TDateTime;
  begin
    if NOT IsNull then
    begin
      ASSERT(ValueType = jsString);
      result := Json.DecodeDate(AsString)
    end
    else
      result := NULLDATE;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonValue.get_AsDouble: Double;
  begin
    if NOT IsNull then
    begin
      ASSERT(ValueType in [jsNumber, jsString]);
      result := StrToFloat(AsString);
    end
    else
      result := 0.0;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonValue.get_AsEnum(const aTypeInfo: PTypeInfo): Integer;
  begin
    if NOT IsNull then
    begin
      ASSERT(ValueType = jsString);
      result := GetEnumValue(aTypeInfo, AsString)
    end
    else
      result := 0;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonValue.get_AsGUID: TGUID;
  begin
    if NOT IsNull then
    begin
      ASSERT(ValueType = jsString);
      result := StringToGUID(AsString)
    end
    else
      result := NULLGUID;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonValue.get_AsInt64: Int64;
  begin
    if IsNull then
      raise EJsonError.CreateFmt('Cannot convert null value ''%s'' to integer', [Name]);

    case ValueType of
      jsBoolean : result := Ord(AsBoolean);
      jsNumber,
      jsString  : result := StrToInt64(DoGetAsString);
    else
      raise EJsonError.CreateFmt('Cannot convert value ''%s'' to integer', [Name]);
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonValue.get_AsInteger: Integer;
  begin
    if IsNull then
      raise EJsonError.CreateFmt('Cannot convert null value ''%s'' to integer', [Name]);

    case ValueType of
      jsBoolean : result := Ord(AsBoolean);
      jsNumber,
      jsString  : result := StrToInt(DoGetAsString);
    else
      raise EJsonError.CreateFmt('Cannot convert value ''%s'' to integer', [Name]);
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonValue.get_AsJson: UnicodeString;
  begin
    result := DoGetAsString;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonValue.get_AsObject: TJsonObject;
  begin
    result := self as TJsonObject;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonValue.get_AsString: UnicodeString;
  begin
    if IsNull then
      raise EJsonError.CreateFmt('Cannot convert null value ''%s'' to UnicodeString', [Name])
    else
      result := DoGetAsString;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonValue.get_IsNull: Boolean;
  begin
    result := fIsNull;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonValue.IsEqual(const aOther: TJsonValue): Boolean;
  begin
    result := (ValueType = aOther.ValueType)
              and (Name = aOther.Name)
              and (AsString = aOther.AsString);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonValue.set_AsBoolean(const aValue: Boolean);
  begin
    case aValue of
      TRUE  : AsString := 'true';
      FALSE : AsString := 'false';
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonValue.set_AsDateTime(const aValue: TDateTime);
  begin
    AsString := DateTimeToISO8601(aValue);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonValue.set_AsDouble(const aValue: Double);
  begin
    AsString := FloatToStr(aValue);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonValue.set_AsGUID(const aValue: TGUID);
  begin
    ASSERT(ValueType = jsString);

    AsString := GUIDToString(aValue);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonValue.set_AsInt64(const aValue: Int64);
  begin
    DoSetAsString(IntToStr(aValue));
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonValue.set_AsInteger(const aValue: Integer);
  begin
    DoSetAsString(IntToStr(aValue));
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonValue.set_AsString(const aValue: UnicodeString);
  begin
    DoSetAsString(aValue);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonValue.set_IsNull(const aValue: Boolean);
  begin
    fIsNull := aValue;
  end;



{$ifdef DELPHI2009__}
  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonValue.get_AsDate: TDate;
  begin
    if NOT IsNull then
    begin
      ASSERT(ValueType = jsString);
      result := DateTimeFromISO8601(AsString, [dtDate])
    end
    else
      result := NULLDATE;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonValue.get_AsTime: TTime;
  begin
    if NOT IsNull then
    begin
      ASSERT(ValueType = jsString);
      result := DateTimeFromISO8601(AsString, [dtTime])
    end
    else
      result := NULLDATE;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonValue.set_AsDate(const aValue: TDate);
  begin
    AsString := DateTimeToISO8601(aValue, [dtDate]);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonValue.set_AsTime(const aValue: TTime);
  begin
    AsString := DateTimeToISO8601(aValue, [dtTime]);
  end;
{$endif}











{ TJsonText -------------------------------------------------------------------------------------- }

  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  class function TJsonStructure.CreateFromFile(const aFilename: UnicodeString): TJsonStructure;
  var
    fileStream: TFileStream;
    stream: IStreamReader;
  begin
    fileStream  := TFileStream.Create(aFilename, fmOpenRead or fmShareDenyWrite);
    stream      := BufferedStream.CreateReader(fileStream);
    try
      result := CreateFromStream(stream.Stream);

    finally
      fileStream.Free;
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  class function TJsonStructure.CreateFromStream(const aStream: TStream): TJsonStructure;
  var
    source: IUnicodeReader;
    reader: TJsonReader;
  begin
    source := TUnicodeReader.Create(aStream, TEncoding.Utf8);
    reader := TJsonReader.Create(source);
    try
      result := reader.ReadValue as TJsonStructure;

    finally
      reader.Free;
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  class function TJsonStructure.CreateFromStream(const aStream: TStream;
                                                 const aDefaultEncoding: TEncoding): TJsonStructure;
  var
    source: IUnicodeReader;
    reader: TJsonReader;
  begin
    source := TUnicodeReader.Create(aStream, aDefaultEncoding);
    reader := TJsonReader.Create(source);
    try
      result := reader.ReadValue as TJsonStructure;

    finally
      reader.Free;
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  class function TJsonStructure.CreateFromANSI(const aString: ANSIString): TJsonStructure;
  var
    source: IUnicodeReader;
    reader: TJsonReader;
  begin
    source := TUnicodeReader.Create(aString);

    reader := TJsonReader.Create(source);
    try
      result := reader.ReadValue as TJsonStructure;

    finally
      reader.Free;
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  class function TJsonStructure.CreateFromUTF8(const aString: UTF8String): TJsonStructure;
  var
    source: IUnicodeReader;
    reader: TJsonReader;
  begin
    source := TUnicodeReader.Create(aString);

    reader := TJsonReader.Create(source);
    try
      result := reader.ReadValue as TJsonStructure;

    finally
      reader.Free;
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  class function TJsonStructure.CreateFromWIDE(const aString: UnicodeString): TJsonStructure;
  var
    source: IUnicodeReader;
    reader: TJsonReader;
  begin
    source := TUnicodeReader.Create(aString);

    reader := TJsonReader.Create(source);
    try
      result := reader.ReadValue as TJsonStructure;

    finally
      reader.Free;
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  class function TJsonStructure.CreateFromString(const aString: String): TJsonStructure;
  begin
  {$ifdef UNICODE}
    result := CreateFromWIDE(aString);
  {$else}
    result := CreateFromANSI(aString);
  {$endif}
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonStructure.get_AsDisplayText: UnicodeString;

    function ObjectToString(const aObject: TJsonObject;
                            const aIndent: Integer): UnicodeString; forward;

    function ArrayToString(const aArray: TJsonArray;
                           const aIndent: Integer): UnicodeString;
    var
      i: Integer;
      item: TJsonValue;
    begin
      if (aArray.Count = 0) then
      begin
        result := '[]';
        EXIT;
      end;

      result := '['#13#10;

      if aArray.Count > 0 then
      begin
        for i := 0 to Pred(aArray.Count) do
        begin
          item := aArray.Items[i];

          result := result + StringOfChar(' ', aIndent);

          if NOT item.IsNull then
            case item.ValueType of
              jsString  : result := result + TJsonString.Encode(item.AsString);
              jsArray   : result := result + '  ' + ArrayToString(item as TJsonArray, aIndent + 2);
              jsObject  : result := result + '  ' + ObjectToString(item as TJsonObject, aIndent + 2);
            else
              result := result + item.AsString;
            end
          else
            result := result + '  null';

          result := result + ','#13#10;
        end;

        SetLength(result, Length(result) - 3);
      end;

      result := result + #13#10 + StringOfChar(' ', aIndent) + ']';
    end;

    function ObjectToString(const aObject: TJsonObject;
                            const aIndent: Integer): UnicodeString;
    var
      i: Integer;
      value: TJsonValue;
    begin
      if (aObject.ValueCount = 0) then
      begin
        result := '{}';
        EXIT;
      end;

      result := '{'#13#10;

      if aObject.ValueCount > 0 then
      begin
        for i := 0 to Pred(aObject.ValueCount) do
        begin
          value := aObject.ValueByIndex[i];

          result := result + StringOfChar(' ', aIndent + 2) + TJsonString.Encode(value.Name) + ':';

          if value.IsNull then
            result := result + 'null'
          else
            case value.ValueType of
              jsString  : result := result + TJsonString.Encode(value.AsString);
              jsArray   : result := result + ArrayToString(value as TJsonArray, aIndent + Length(value.Name) + 5);
              jsObject  : result := result + ObjectToString(value as TJsonObject, aIndent + Length(value.Name) + 5);
            else
              result := result + value.AsString;
            end;

          result := result + ','#13#10;
        end;

        SetLength(result, Length(result) - 3);
      end;

      result := result + #13#10 + StringOfChar(' ', aIndent) + '}';
    end;

  begin
    case ValueType of
      jsArray   : result := ArrayToString(TJsonArray(self), 0);
      jsObject  : result := ObjectToString(TJsonObject(self), 0);
    else
      result := 'Not a Json text Value';
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonStructure.get_IsNull: Boolean;
  begin
    result := FALSE;  // Arrays and objects are never NULL (not even when empty)
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonStructure.Add(const aName: UnicodeString; const aValue: Boolean): TJsonBoolean;
  begin
    result := TJsonBoolean.Create;
    result.Name   := aName;
    result.Value  := aValue;

    Add(result);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonStructure.Add(const aName: UnicodeString; const aValue: Integer): TJsonInteger;
  begin
    result := TJsonInteger.Create;
    result.Name  := aName;
    result.Value := aValue;

    Add(result);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonStructure.Add(const aName, aValue: UnicodeString): TJsonString;
  begin
    result := TJsonString.Create;
    result.Name  := aName;
    result.Value := aValue;

    Add(result);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonStructure.AddDate(const aName: UnicodeString;
                             const aValue: TDate): TJsonString;
  {
    Cannot simply overload Double/TDateTime if we wish to support earlier Delphi
     compilers as there is a bug in the compiler that considers Double/TDateTime
     ambiguous despite being declared as distinct types.

    Instead we have to provide this protected method specifically for adding
     TDateTime values - the Add(name, TDateTime) method calls this protected
     method as does the override in TJsonArray.
  }
  begin
    result := TJsonString.Create;
    result.Name := aName;

    if (aValue <> NULLDATE) then
      result.Value := DateTimeToISO8601(aValue, [dtDate])
    else
      result.IsNull := TRUE;

    Add(result);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonStructure.AddTime(const aName: UnicodeString;
                             const aValue: TTime): TJsonString;
  {
    Cannot simply overload Double/TDateTime if we wish to support earlier Delphi
     compilers as there is a bug in the compiler that considers Double/TDateTime
     ambiguous despite being declared as distinct types.

    Instead we have to provide this protected method specifically for adding
     TDateTime values - the Add(name, TDateTime) method calls this protected
     method as does the override in TJsonArray.
  }
  begin
    result := TJsonString.Create;
    result.Name := aName;

    if (aValue <> NULLDATE) then
      result.Value := DateTimeToISO8601(aValue, [dtTime])
    else
      result.IsNull := TRUE;

    Add(result);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonStructure.AddDateTime(const aName: UnicodeString;
                                      const aValue: TDateTime): TJsonString;
  {
    Cannot simply overload Double/TDateTime if we wish to support earlier Delphi
     compilers as there is a bug in the compiler that considers Double/TDateTime
     ambiguous despite being declared as distinct types.

    Instead we have to provide this protected method specifically for adding
     TDateTime values - the Add(name, TDateTime) method calls this protected
     method as does the override in TJsonArray.
  }
  begin
    result := TJsonString.Create;
    result.Name := aName;

    if (aValue <> NULLDATE) then
      result.Value := DateTimeToISO8601(aValue)
    else
      result.IsNull := TRUE;

    Add(result);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonStructure.AddDouble(const aName: UnicodeString;
                                    const aValue: Double): TJsonNumber;
  {
    Cannot simply overload Double/TDateTime if we wish to support earlier Delphi
     compilers as there is a bug in the compiler that considers Double/TDateTime
     ambiguous despite being declared as distinct types.

    Instead we have to provide this protected method specifically for adding
     TDateTime values - the Add(name, TDateTime) method calls this protected
     method as does the override in TJsonArray.
  }
  begin
    result := TJsonDouble.Create;
    result.Name := aName;

    TJsonDouble(result).Value  := aValue;

    Add(result);
  end;


{$ifdef DELPHI2009__}
  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonStructure.Add(const aName: UnicodeString;
                         const aValue: TDate): TJsonString;
  begin
    result := TJsonString.Create;
    result.Name := aName;

    if (aValue <> NULLDATE) then
      result.Value := DateTimeToISO8601(aValue, [dtDate])
    else
      result.IsNull := TRUE;

    Add(result);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonStructure.Add(const aName: UnicodeString;
                              const aValue: TTime): TJsonString;
  begin
    result := TJsonString.Create;
    result.Name := aName;

    if (aValue <> NULLDATE) then
      result.Value := DateTimeToISO8601(aValue, [dtTime])
    else
      result.IsNull := TRUE;

    Add(result);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonStructure.Add(const aName: UnicodeString;
                              const aValue: TDateTime): TJsonString;
  begin
    result := AddDateTime(aName, aValue);
  end;
{$endif}


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonStructure.Add(const aName: UnicodeString;
                              const aValue: TGUID): TJsonString;
  begin
    result := TJsonString.Create;
    result.Name  := aName;

    if NOT SameGUID(aValue, NULLGUID) then
      result.Value := GUIDToString(aValue)
    else
      result.IsNull := TRUE;

    Add(result);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonStructure.Add(const aName: UnicodeString;
                         const aValue: Integer;
                         const aTypeInfo: PTypeInfo): TJsonString;
  begin
    result := Add(aName, GetEnumName(aTypeInfo, aValue));
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonStructure.Add(const aName: UnicodeString;
                              const aValue: Int64): TJsonNumber;
  begin
    result := TJsonInteger.Create;
    result.Name := aName;

    TJsonInteger(result).Value := aValue;

    Add(result);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonStructure.Add(const aName: UnicodeString;
                              const aValue: Double): TJsonNumber;
  begin
    result := TJsonDouble.Create;
    result.Name := aName;

    TJsonDouble(result).Value  := aValue;

    Add(result);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonStructure.AddArray(const aName: UnicodeString): TJsonArray;
  begin
    result := TJsonArray.Create;
    result.Name := aName;
    Add(result);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonStructure.AddNull(const aName: UnicodeString);
  var
    null: TJsonValue;
  begin
    null := TJsonNull.Create;
    null.Name   := aName;
    Add(null);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonStructure.AddObject(const aName: UnicodeString): TJsonObject;
  begin
    result := TJsonObject.Create;
    result.Name := aName;
    Add(result);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonStructure.Add(const aName: UnicodeString;
                         const aValue: TJsonStructure): TJsonStructure;
  begin
    result := TJsonStructure(aValue.Clone);
    result.Name := aName;
    Add(result);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonStructure.Load(const aSource: IUnicodeReader);
  var
    reader: TJsonReader;
    loaded: TJsonValue;
  begin
    reader := NIL;
    loaded := NIL;
    try
      Clear;

      if NOT aSource.EOF then
      begin
        reader := TJsonReader.Create(aSource);
        loaded := reader.ReadValue;

        if Assigned(loaded) then
          CopyFrom(loaded);
      end;

    finally
      loaded.Free;
      reader.Free;
    end;
  end;


  procedure TJsonStructure.LoadFromFile(const aFileName: UnicodeString;
                                        const aEncoding: TEncoding);
  var
    stream: TFileStream;
    reader: IUnicodeReader;
  begin
    stream := TFileStream.Create(aFileName, fmOpenRead or fmShareDenyWrite);
    reader := TUnicodeReader.Create(stream, aEncoding);

    Load(reader);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonStructure.LoadFromStream(const aStream: TStream;
                                          const aEncoding: TEncoding);
  var
    reader: IUnicodeReader;
  begin
    reader := TUnicodeReader.Create(aStream, aEncoding);
    Load(reader);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonStructure.SaveToFile(const aFileName: UnicodeString;
                                      const aFormat: TJsonFormat);
  var
    stream: TMemoryStream;
  begin
    stream := TMemoryStream.Create;
    try
      SaveToStream(stream, aFormat);
      stream.Position := 0;
      stream.SaveToFile(aFileName);

    finally
      stream.Free;
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonStructure.SaveToStream(const aStream: TStream;
                                        const aFormat: TJsonFormat);
  var
    s: UTF8String;
  begin
    s := UTF8.FromWIDE(JsonFormatter.Format(self, aFormat));

    aStream.Write(s[1], Length(s));
  end;









{ TJsonArray ------------------------------------------------------------------------------------- }

  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  constructor TJsonArray.Create;
  begin
    inherited Create;

    fItems := TObjectList.Create(TRUE);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  destructor TJsonArray.Destroy;
  begin
    FreeAndNIL(fItems);

    inherited;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonArray.Add(const aValue: UnicodeString): TJsonString;
  begin
    result := inherited Add('', aValue);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonArray.Add(const aValue: Integer): TJsonInteger;
  begin
    result := inherited Add('', aValue);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonArray.Add(const aValue: Boolean): TJsonBoolean;
  begin
    result := inherited Add('', aValue);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonArray.Add(const aValue: Integer; const aTypeInfo: PTypeInfo): TJsonString;
  begin
    result := inherited Add('', aValue, aTypeInfo);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonArray.Add(const aValue: TJsonStructure): TJsonStructure;
  begin
    result := inherited Add('', aValue);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonArray.Add(const aValue: TGUID): TJsonString;
  begin
    result := inherited Add('', aValue);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonArray.Add(const aValue: TDateTime): TJsonString;
  begin
    result := inherited AddDateTime('', aValue);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonArray.Add(const aValue: TJsonValue);
  begin
    fIsNull := FALSE;
    fItems.Add(aValue);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonArray.Add(const aValues: IStringList);
  var
    i: Integer;
  begin
    for i := 0 to Pred(aValues.Count) do
      Add(aValues[i]);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonArray.AddArray: TJsonArray;
  begin
    result := inherited AddArray('');
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonArray.AddNull;
  begin
    inherited AddNull('');
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonArray.AddObject(const aTemplate: TJsonObject): TJsonObject;
  begin
    if Assigned(aTemplate) then
      result := aTemplate.Clone
    else
      result := TJsonObject.Create;

    Add(TJsonValue(result));
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonArray.AsStringArray: TStringArray;
  var
    i: Integer;
  begin
    SetLength(result, Count);

    for i := 0 to Pred(Count) do
      result[i] := Items[i].AsString;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonArray.Clear;
  begin
    fItems.Clear;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonArray.Clone: TJsonArray;
  begin
    ASSERT(self is TJsonArray);
    result := TJsonArray(inherited Clone);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonArray.Combine(const aSource: TJsonArray);
  var
    i: Integer;
  begin
    for i := 0 to Pred(aSource.Count) do
      fItems.Add(aSource[i].Clone);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonArray.CopyFrom(const aSource: TJsonValue);
  var
    i: Integer;
    source: TJsonArray absolute aSource;
  begin
    inherited CopyFrom(aSource);

    Clear;

    for i := 0 to Pred(source.Count) do
      fItems.Add(source.Items[i].Clone);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonArray.Delete(const aIndex: Integer);
  begin
    fItems.Delete(aIndex);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonArray.Delete(const aValue: TJsonValue);
  begin
    Delete(fItems.IndexOf(aValue));
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonArray.DoGetAsString: UnicodeString;
  var
    i: Integer;
    item: TJsonValue;
  begin
    result := '';

    if Count > 0 then
    begin
      for i := 0 to Pred(Count) do
      begin
        Item := Items[i];

        case item.ValueType of
          jsNull    : result := result + 'null';
          jsString  : result := result + TJsonString.Encode(item.AsString);
        else
          result := result + item.AsString;
        end;

        result := result + ',';
      end;

      SetLength(result, Length(result) - 1);
    end;

    result := '[' + result + ']';
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonArray.DoSetAsString(const aValue: UnicodeString);
  var
    source: IUnicodeReader;
  begin
    source := TUnicodeReader.Create(aValue);
    Load(source);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonArray.get_Count: Integer;
  begin
    result := fItems.Count;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonArray.get_IsEmpty: Boolean;
  begin
    result := (fItems.Count = 0);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonArray.get_Item(const aIndex: Integer): TJsonValue;
  begin
    result := TJsonValue(fItems[aIndex])
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonArray.Sort(const aComparer: TJsonObjectComparer);
  begin
    fItems.Sort(TListSortCompare(aComparer));
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonArray.Wipe;
  var
    i: Integer;
  begin
    for i := 0 to Pred(Count) do
      Items[i].Wipe;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonArray.FindObject(const aValueName: UnicodeString;
                                 const aValue: TGUID;
                                 var aObject: TJsonObject): Boolean;
  var
    i: Integer;
  begin
    result := FALSE;

    try
      for i := 0 to Pred(Count) do
      begin
        if Items[i].ValueType <> jsObject then
          CONTINUE;

        aObject := TJsonObject(Items[i]);
        if aObject.Contains(aValueName)
         and SameGUID(aObject[aValueName].AsGUID, aValue) then
          EXIT;
      end;

      aObject := NIL;

    finally
      result := Assigned(aObject);
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonArray.GetStrings(const aList: TStringList);
  var
    i: Integer;
  begin
    for i := 0 to Pred(Count) do
      aList.Add(Items[i].AsString);
  end;




{ TJsonNull -------------------------------------------------------------------------------------- }

  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonNull.DoGetAsString: UnicodeString;
  begin
    result := 'null';
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonNull.get_IsNull: Boolean;
  begin
    result := TRUE;
  end;







{ TJsonBoolean ----------------------------------------------------------------------------------- }

  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonBoolean.set_Value(const aValue: Boolean);
  begin
    IsNull := FALSE;
    fValue := aValue;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonBoolean.CopyFrom(const aSource: TJsonValue);
  begin
    inherited CopyFrom(aSource);

    fValue := TJsonBoolean(aSource).fValue;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonBoolean.DoGetAsString: UnicodeString;
  begin
    case fValue of
      TRUE  : result := 'true';
      FALSE : result := 'false';
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonBoolean.DoSetAsString(const aValue: UnicodeString);
  begin
    inherited;

    if SameText(aValue, 'true') then
      Value := TRUE
    else if SameText(aValue, 'false') then
      Value := FALSE
    else
      raise EJsonError.CreateFmt('"%s" is not a valid value for a boolean', [aValue]);
  end;








{ TJsonDouble ------------------------------------------------------------------------------------ }

  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonDouble.CopyFrom(const aSource: TJsonValue);
  begin
    inherited CopyFrom(aSource);

    fValue := TJsonDouble(aSource).fValue;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonDouble.DoGetAsString: UnicodeString;
  begin
    result := FloatToStr(fValue);

    if Trunc(fValue) = fValue then
      result := result + '.0';
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonDouble.DoSetAsString(const aValue: UnicodeString);
  begin
    inherited;

    Value := StrToFloat(aValue);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonDouble.set_Value(const aValue: Double);
  begin
    IsNull := FALSE;
    fValue := aValue;
  end;







{ TJsonInteger ----------------------------------------------------------------------------------- }

  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonInteger.CopyFrom(const aSource: TJsonValue);
  begin
    inherited CopyFrom(aSource);

    fValue := TJsonInteger(aSource).fValue;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonInteger.DoGetAsString: UnicodeString;
  begin
    result := IntToStr(fValue);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonInteger.DoSetAsString(const aValue: UnicodeString);
  begin
    inherited;

    Value := StrToInt64(aValue);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonInteger.set_Value(const aValue: Int64);
  begin
    IsNull := FALSE;
    fValue := aValue;
  end;







{ TJsonString ------------------------------------------------------------------------------------ }

  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  class function TJsonString.Decode(const aValue: UnicodeString): UnicodeString;

    function UnescapeUnicode(var aI: Integer): WideChar;
    var
      buf: array[0..3] of ANSIChar;
    begin
      buf[2] := ANSIChar(aValue[aI + 1]);
      buf[3] := ANSIChar(aValue[aI + 2]);
      buf[0] := ANSIChar(aValue[aI + 3]);
      buf[1] := ANSIChar(aValue[aI + 4]);

      HexToBin(PANSIChar(@buf), @result, 2);

      Inc(aI, 4);
    end;

  var
    c: WideChar;
    quoted: Boolean;
    i, ri: Integer;
    len: Integer;
  begin
    result := '';
    if aValue = '' then
      EXIT;

    i   := 1;
    len := Length(aValue);

    quoted := (aValue[1] = '"');
    if quoted then
    begin
      if (len < 2) or (aValue[len] <> '"') then
        raise EJsonError.Create('Quoted string not terminated');

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
            raise EJsonError.Create('Incomplete escape sequence');

          Inc(i);
          c := aValue[i];

          case c of
            '"', '\', '/' : {NO-OP - read these chars just as they are};
            'b' : c := WideChar(#8);
            't' : c := WideChar(#9);
            'n' : c := WideChar(#10);
            'f' : c := WideChar(#12);
            'r' : c := WideChar(#13);
            'u' : if (i + 4) <= len then
                    c := UnescapeUnicode(i)
                  else
                    raise EJsonError.Create('Incomplete Unicode escape sequence');
          else
            raise EJsonError.Create('Invalid escape sequence');
          end;
        end;

        result[ri] := c;
        Inc(ri);
        Inc(i);
      end;

    finally
      SetLength(result, ri - 1);
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  class function TJsonString.Encode(const aValue: UnicodeString): UnicodeString;

    procedure EscapeUnicode(const aChar: WideChar);
    var
      i: Integer;
      buf: array[0..3] of Char;
    begin
    {$ifdef UNICODE}
      BinToHex(@aChar, PWideChar(@buf), 2);
    {$else}
      BinToHex(PANSIChar(@aChar), @buf, 2);
    {$endif}

      i := Length(result);
      SetLength(result, i + 6);

      result[i + 1] := '\';
      result[i + 2] := 'u';
      result[i + 3] := WideChar(buf[2]);
      result[i + 4] := WideChar(buf[3]);
      result[i + 5] := WideChar(buf[0]);
      result[i + 6] := WideChar(buf[1]);
    end;

  var
    i: Integer;
    c: WideChar;
  begin
    result := '"';

    for i := 1 to Length(aValue) do
    begin
      c := aValue[i];

      case c of
        '"', '/', '\' : result := result + '\' + c;
        ANSIChar(#8)  : result := result + '\b';
        ANSIChar(#9)  : result := result + '\t';
        ANSIChar(#10) : result := result + '\n';
        ANSIChar(#12) : result := result + '\f';
        ANSIChar(#13) : result := result + '\r';
      else
        if (Word(c) > $7f) then
          EscapeUnicode(c)
        else
          result := result + c;
      end;
    end;

    result := result + '"';
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonString.get_AsJson: UnicodeString;
  begin
    result := TJsonString.Encode(fValue);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonString.set_Value(const aValue: UnicodeString);
  begin
    IsNull := FALSE;
    fValue := aValue;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonString.CopyFrom(const aSource: TJsonValue);
  begin
    inherited CopyFrom(aSource);

    fValue := TJsonString(aSource).fValue;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonString.DoGetAsString: UnicodeString;
  begin
    result := fValue;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonString.DoSetAsString(const aValue: UnicodeString);
  begin
    inherited;

    Value := aValue;
  end;







{ TJsonObject ------------------------------------------------------------------------------------ }

  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  class function TJsonObject.TryCreate(const aString: UnicodeString): TJsonObject;
  begin
    result := TJsonObject.Create;
    try
      result.AsString := aString;

    except
      result.Free;
      result := NIL;
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  constructor TJsonObject.Create;
  begin
    inherited Create;

    fValues := TObjectList.Create(TRUE);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  constructor TJsonObject.Create(const aString: UnicodeString);
  begin
    Create;
    AsString := aString;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  constructor TJsonObject.CreateFromFile(const aFilename: UnicodeString;
                                         const aEncoding: TEncoding);
  begin
    Create;

    LoadFromFile(aFilename, aEncoding);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonObject.Delete(const aValueName: UnicodeString);
  var
    val: TJsonValue;
  begin
    if NOT Contains(aValueName) then
      EXIT;

    val := Values[aValueName];
    fValues.Remove(val);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  destructor TJsonObject.Destroy;
  begin
    FreeAndNIL(fValues);
    inherited;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonObject.get_IsEmpty: Boolean;
  begin
    result := (fValues.Count = 0);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonObject.get_Value(const aName: UnicodeString): TJsonValue;
  begin
    result := FindValue(aName);

    if NOT Assigned(result) then
      raise EJsonError.CreateFmt('No such value (%s) in object', [aName]);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonObject.get_ValueByIndex(const aIndex: Integer): TJsonValue;
  begin
    result := TJsonValue(fValues[aIndex]);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonObject.get_ValueCount: Integer;
  begin
    result := fValues.Count;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonObject.Add(const aValue: TJsonValue);
  begin
    fValues.Add(aValue);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonObject.AddAfter(const aPredecessor: UnicodeString;
                                const aName: UnicodeString;
                                const aValue: UnicodeString): TJsonString;
  var
    i: Integer;
  begin
    if NOT Contains(aPredecessor) then
      raise EJsonError.CreateFmt('No such predecessor ''%s''', [aPredecessor]);

    result := TJsonString.Create;
    result.Name  := aName;
    result.Value := aValue;

    for i := 0 to Pred(fValues.Count) do
      if STR.SameText(aPredecessor, TJsonValue(fValues[i]).Name) then
        if i < Pred(fValues.Count) then
        begin
          fValues.Insert(i + 1, result);
          BREAK;
        end
        else
          fValues.Add(result);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonObject.Clear;
  begin
    fValues.Clear;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonObject.Clone: TJsonObject;
  begin
    result := TJsonObject(inherited Clone);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonObject.Combine(const aObject: TJsonObject);
  var
    i: Integer;
  begin
    for i := 0 to Pred(aObject.ValueCount) do
      Add(aObject.ValueByIndex[i].Clone);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonObject.Contains(const aValueName: UnicodeString): Boolean;
  begin
    result := Assigned(FindValue(aValueName));
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonObject.Contains(const aValueName: UnicodeString;
                                var   aValue: UnicodeString): Boolean;
  begin
    result := Assigned(FindValue(aValueName));
    if result then
      aValue := self[aValueName].AsString;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonObject.Contains(const aValueName: UnicodeString;
                                var   aValue: TJsonArray): Boolean;
  begin
    result := Contains(aValueName) and (Values[aValueName].ValueType = jsArray);

    if result then
      aValue := self[aValueName].AsArray;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonObject.Contains(const aValueName: UnicodeString;
                                var   aValue: TWIDEStringArray): Boolean;
  var
    i: Integer;
    values: TJsonArray;
  begin
    result := Contains(aValueName, values);

    if result then
    begin
      SetLength(aValue, values.Count);
      for i := 0 to Pred(values.Count) do
        aValue[i] := values[i].AsString;
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonObject.CopyFrom(const aSource: TJsonValue);
  var
    i: Integer;
    source: TJsonObject absolute aSource;
  begin
    Clear;

    inherited CopyFrom(aSource);

    for i := 0 to Pred(source.ValueCount) do
      Add(source.ValueByIndex[i].Clone);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonObject.DoGetAsString: UnicodeString;
  var
    i: Integer;
    value: TJsonValue;
  begin
    result := '';

    if IsNull then
      result := 'null'
    else if ValueCount > 0 then
    begin
      for i := 0 to Pred(ValueCount) do
      begin
        value := ValueByIndex[i];

        result := result + TJsonString.Encode(value.Name) + ':';

        if value.IsNull then
          result := result + 'null'
        else if (value.ValueType = jsString) then
          result := result + TJsonString.Encode(value.AsString)
        else
          result := result + value.AsString;

        result := result + ',';
      end;

      SetLength(result, Length(result) - 1);
    end;

    result := '{' + result + '}';
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonObject.DoSetAsString(const aValue: UnicodeString);
  var
    source: IUnicodeReader;
  begin
    inherited;

    source:= TUnicodeReader.Create(aValue);
    Load(source);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonObject.Wipe;
  var
    i: Integer;
  begin
    for i := 0 to Pred(ValueCount) do
      ValueByIndex[i].Wipe;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonObject.FindValue(const aName: UnicodeString): TJsonValue;
  var
    i: Integer;
  begin
    for i := 0 to Pred(ValueCount) do
    begin
      result := ValueByIndex[i];
      if SameText(result.Name, aName) then
        EXIT;
    end;

    result := NIL;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TJsonObject.LoadFromStream(const aStream: TStream;
                                       const aEncoding: TEncoding);
  var
    source: IUnicodeReader;
    reader: TJsonReader;
    loaded: TJsonValue;
  begin
    source := TUnicodeReader.Create(aStream, aEncoding);

    loaded := NIL;
    reader := TJsonReader.Create(source);
    try
      loaded := reader.ReadValue;

      if NOT (loaded is TJsonObject) then
        raise EJsonError.Create('Stream does not contain a Json object');

      Clear;
      CopyFrom(loaded);

    finally
      loaded.Free;
      reader.Free;
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonObject.OptBoolean(const aName: UnicodeString;
                                  const aDefault: Boolean): Boolean;
  begin
    if Contains(aName) and NOT Values[aName].IsNull then
      result := Values[aName].AsBoolean
    else
      result := aDefault;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonObject.OptDateTime(const aName: UnicodeString;
                                   const aDefault: TDateTime): TDateTime;
  begin
    if Contains(aName) and NOT Values[aName].IsNull then
      result := Values[aName].AsDateTime
    else
      result := aDefault;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonObject.OptEnum(const aName: UnicodeString;
                               const aTypeInfo: PTypeInfo;
                               const aDefault: Integer): Integer;
  begin
    if Contains(aName) and NOT Values[aName].IsNull then
      result := GetEnumValue(aTypeInfo, Values[aName].AsString)
    else
      result := aDefault;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonObject.OptInteger(const aName: UnicodeString;
                                  const aDefault: Integer): Integer;
  begin
    if Contains(aName) and NOT Values[aName].IsNull then
      result := Values[aName].AsInteger
    else
      result := aDefault;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonObject.OptString(const aName: UnicodeString;
                                 const aDefault: UnicodeString): UnicodeString;
  begin
    if Contains(aName) and NOT Values[aName].IsNull then
      result := Values[aName].AsString
    else
      result := aDefault;
  end;


{$ifdef DELPHI2009__}
  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonObject.OptDate(const aName: UnicodeString; const aDefault: TDate): TDate;
  begin
    if Contains(aName) and NOT Values[aName].IsNull then
      result := Values[aName].AsDate
    else
      result := aDefault;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonObject.OptTime(const aName: UnicodeString;
                               const aDefault: TTime): TTime;
  begin
    if Contains(aName) and NOT Values[aName].IsNull then
      result := Values[aName].AsTime
    else
      result := aDefault;
  end;
{$endif}







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


  function TJsonReader.NextChar: WideChar;
  begin
    result := fSource.PeekChar;
   end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonReader.NextRealChar: WideChar;
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
  function TJsonReader.ReadArray: TJsonArray;
  var
    value: TJsonValue;
  begin
    if ReadRealChar <> '[' then
      raise EJsonStreamError.Create('Expected ''[''');

    result := TJsonArray.Create;
    try
      if (NextRealChar = ']') then
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

        case NextRealChar of
          ']' : begin
                  ReadRealChar;
                  EXIT;
                end;

          ',' : ReadRealChar;
        else
          raise EJsonStreamError.Create('Unexpected character ''' + NextRealChar + ''' in array');
        end;
      end;

      raise EJsonStreamError.Create('Array not closed');

    except
      result.Free;
      raise;
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonReader.ReadObject: TJsonObject;
  var
    c: WideChar;
    name: UnicodeString;
    value: TJsonValue;
  begin
    if ReadRealChar <> '{' then
      raise EJsonStreamError.Create('Expected ''{''');

    result := TJsonObject.Create;
    try
      if (NextRealChar = '}') then
      begin
        ReadRealChar; // Skip the '}'
        EXIT;
      end;

      while NOT EOF do
      begin
        if NextRealChar = '"' then
          name := ReadString
        else
          name := ReadName;

        c := ReadRealChar;
        if (c <> ':') then
          raise EJsonStreamError.Create('Expected '':'', read ''' + c + ''' instead');

        value := ReadValue;

        if NOT Assigned(value) then
          raise EJsonStreamError.Create('Expected value');

        value.Name := name;

        result.Add(value);

        // Test the next char for , (another name/value pair to follow) or } (end of object)

        case NextRealChar of

          '}' : begin
                  ReadRealChar;
                  EXIT;
                end;

          ',' : ReadRealChar;

        else
          raise EJsonStreamError.Create('Unexpected character ''' + NextRealChar + ''' in object');
        end;
      end;

      raise EJsonStreamError.Create('Object not terminated');

    except
      result.Free;
      raise;
    end;
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
        raise EJsonError.Create('UnicodeString not terminated');

      c := NextRealChar;

      if ANSIChar(c) = ':' then
      begin
        if WIDE.EndsWith(result, '.') or WIDE.EndsWith(result, '-') then
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
      BYTEINDEX: array[1..4] of Integer = (2, 3, 0, 1);
    var
      i: Integer;
      c: ANSIChar;
      buf: array[0..3] of ANSIChar;
    begin
      for i := 1 to 4 do
      begin
        c := ANSIChar(NextChar);

        if c in ['0'..'9', 'a'..'f', 'A'..'F'] then
          buf[BYTEINDEX[i]] := c
        else
          raise EJsonStreamError.CreateFmt('Invalid character ''%s'' in escaped Unicode', [c]);

        ReadChar;
      end;

      HexToBin(PANSIChar(@buf), @result, 2);
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
      raise EJsonError.Create('UnicodeString not terminated');

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
        raise EJsonError.Create('UnicodeString not terminated');

      c := NextChar;

      if NOT aQuoted and (ANSIChar(c) in [#13, #10, #9, ' ', ',', '}', ']']) then
        EXIT;
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TJsonReader.ReadValue: TJsonValue;
  var
    c: WideChar;
    s: UnicodeString;
  begin
    result := NIL;
    try
      c := NextRealChar;

      case c of
        #0  : { NO-OP };
        '[' : result := ReadArray;
        '{' : result := ReadObject;

        '"'       : begin
                      s := ReadString;
                      result := TJsonString.Create;
                      result.AsString := s;
                    end;

        '-'       : begin
                      ReadRealChar;

                      c := NextChar;
                      case c of
                        '1'..'9'  : begin
                                      s := ReadString(FALSE);

                                      if Length(s) > 1 then
                                      begin
                                        if STR.IsInteger(s) then
                                          result := TJsonInteger.Create
                                        else if STR.IsNumeric(s) then
                                          result := TJsonDouble.Create
                                        else
                                          raise EJsonStreamError.CreateFmt('''%s'' is not a valid number', [s]);
                                      end
                                      else
                                        result := TJsonInteger.Create;

                                      result.AsString := '-' + s;
                                    end;
                      else
                        raise EJsonStreamError.CreateFmt('Expected 1..9, found ''%s''', [c]);
                      end;
                    end;

        '0'..'9'  : begin
                      s := ReadString(FALSE);

                      if Length(s) > 1 then
                      begin
                        if STR.IsInteger(s) then
                          result := TJsonInteger.Create
                        else if STR.IsNumeric(s) then
                          result := TJsonDouble.Create
                        else
                          raise EJsonStreamError.CreateFmt('''%s'' is not a valid number', [s]);
                      end
                      else
                        result := TJsonInteger.Create;

                      result.AsString := s;
                    end;

        'n', 'N'  : begin
                      s := ReadString(FALSE);
                      if SameText(s, 'null') then
                        result := TJsonNull.Create
                      else
                        raise EJsonStreamError.CreateFmt('Expected ''null'', found ''%s''', [s]);
                    end;

        'f', 'F',
        't', 'T'  : begin
                      s := ReadString(FALSE);
                      if SameText(s, 'true') or SameText(s, 'false') then
                      begin
                        result := TJsonBoolean.Create;
                        result.AsString := s;
                      end
                      else
                        raise EJsonStreamError.CreateFmt('Expected ''true'' or ''false'', found ''%s''', [s]);
                    end;
      else
        raise EJsonStreamError.CreateFmt('Unexpected char (%s) in stream', [c]);
      end;

    except
      result.Free;
      raise EJsonStreamError.CreateFmt('Error at position %d, line %d', [fSource.Location.Character, fSource.Location.Line]);
    end;
  end;












{ JsonFormatter }

  class function JsonFormatter.Format(const aJson: TJsonStructure; const aFormat: TJsonFormat): String;

    function ObjectToString(const aObject: TJsonObject;
                            const aIndent: Integer): UnicodeString; forward;

    function ArrayToString(const aArray: TJsonArray;
                           const aIndent: Integer): UnicodeString;
    var
      i: Integer;
      item: TJsonValue;
    begin
      if (aArray.Count = 0) then
      begin
        result := '[]';
        EXIT;
      end;

      result := '[';
      if aFormat in [jfStandard, jfConfig] then
        result := result + #13#10;

      if aArray.Count > 0 then
      begin
        for i := 0 to Pred(aArray.Count) do
        begin
          item := aArray.Items[i];

          if aFormat in [jfStandard, jfConfig] then
            result := result + StringOfChar(' ', aIndent);

          if NOT item.IsNull then
            case item.ValueType of
              jsString  : result := result + TJsonString.Encode(item.AsString);

              jsArray   : begin
                            if aFormat in [jfStandard, jfConfig] then
                              result := result + '  ';
                            result := result + ArrayToString(item as TJsonArray, aIndent + 2);
                          end;

              jsObject  : begin
                            if aFormat in [jfStandard, jfConfig] then
                              result := result + '  ';
                            result := result + ObjectToString(item as TJsonObject, aIndent + 2);
                          end;
            else
              result := result + item.AsString;
            end
          else
          begin
            if aFormat in [jfStandard, jfConfig] then
              result := result + '  ';
            result := result + 'null';
          end;

          result := result + ',';

          if aFormat in [jfStandard, jfConfig] then
            result := result + #13#10;
        end;

        if aFormat in [jfStandard, jfConfig] then
          SetLength(result, Length(result) - 3)
        else
          SetLength(result, Length(result) - 1)
      end;

      if aFormat in [jfStandard, jfConfig] then
        result := result + #13#10 + StringOfChar(' ', aIndent - 2);

      result := result + ']';
    end;

    function ObjectToString(const aObject: TJsonObject;
                            const aIndent: Integer): UnicodeString;
    var
      i: Integer;
      value: TJsonValue;
    begin
      if (aObject.ValueCount = 0) then
      begin
        result := '{}';
        EXIT;
      end;

      result := '{';
      if aFormat in [jfStandard, jfConfig] then
        result := result + #13#10;

      if aObject.ValueCount > 0 then
      begin
        for i := 0 to Pred(aObject.ValueCount) do
        begin
          value := aObject.ValueByIndex[i];

          if aFormat in [jfStandard, jfConfig] then
            result := result + StringOfChar(' ', aIndent + 2);

          if (aFormat = jfConfig) then
            result := result + value.Name
          else
            result := result + TJsonString.Encode(value.Name);

          result := result + ':';
          if (aFormat = jfConfig) then
            result := result + ' ';

          if value.IsNull then
            result := result + 'null'
          else
            case value.ValueType of
              jsString  : result := result + TJsonString.Encode(value.AsString);
              jsArray   : result := result + ArrayToString(value as TJsonArray, aIndent + 4);
              jsObject  : result := result + ObjectToString(value as TJsonObject, aIndent + 4);
            else
              result := result + value.AsString;
            end;

          result := result + ',';
          if aFormat in [jfStandard, jfConfig] then
            result := result + #13#10;
        end;

        if aFormat in [jfStandard, jfConfig] then
          SetLength(result, Length(result) - 3)
        else
          SetLength(result, Length(result) - 1);
      end;

      if aFormat in [jfStandard, jfConfig] then
        result := result + #13#10 + StringOfChar(' ', aIndent);

      result := result + '}';
    end;

  begin
    case aJson.ValueType of
      jsArray   : result := ArrayToString(TJsonArray(aJson), 0);
      jsObject  : result := ObjectToString(TJsonObject(aJson), 0);
    else
      result := 'Not a Json array or object';
    end;
  end;



end.
