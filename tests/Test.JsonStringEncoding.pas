unit Test.JsonStringEncoding;

interface

  uses
    Deltics.Smoketest;


  type
    JsonStringEncoding = class(TTest)
      procedure AsciiCharacterStringsEncodeWithoutEscaping;
      procedure DoubleQuoteEncodesWithEscaping;
      procedure ReverseSolidusEncodesWithEscaping;
      procedure SolidusEncodesWithEscaping;
      procedure BackspaceEncodesWithEscaping;
      procedure FormFeedEncodesWithEscaping;
      procedure LineFeedEncodesWithEscaping;
      procedure CarriageReturnEncodesWithEscaping;
      procedure TabEncodesWithEscaping;
      procedure OtherControlCharactersEncodeWithEscapedUnicode;
      procedure NonAsciiCharactersEncodeWithEscapedUnicode;
      procedure SupplementaryCharacterStringsEncodeWithEscapedUnicode;
    end;



implementation

  uses
    Deltics.Strings,
    Deltics.Json;



{ JsonStringEncoding }

  procedure JsonStringEncoding.AsciiCharacterStringsEncodeWithoutEscaping;
  var
    s: UnicodeString;
  begin
    s := Json.EncodeString('abc def');

    Test('s').Assert(s).Equals('"abc def"');
  end;


  procedure JsonStringEncoding.SolidusEncodesWithEscaping;
  var
    s: UnicodeString;
  begin
    s := Json.EncodeString('/');

    Test('s').Assert(s).Equals('"\/"');
  end;


  procedure JsonStringEncoding.BackspaceEncodesWithEscaping;
  var
    s: UnicodeString;
  begin
    s := Json.EncodeString(#8);

    Test('s').Assert(s).Equals('"\b"');
  end;


  procedure JsonStringEncoding.CarriageReturnEncodesWithEscaping;
  var
    s: UnicodeString;
  begin
    s := Json.EncodeString(#13);

    Test('s').Assert(s).Equals('"\r"');
  end;


  procedure JsonStringEncoding.DoubleQuoteEncodesWithEscaping;
  var
    s: UnicodeString;
  begin
    s := Json.EncodeString('"');

    Test('s').Assert(s).Equals('"\""');
  end;


  procedure JsonStringEncoding.FormFeedEncodesWithEscaping;
  var
    s: UnicodeString;
  begin
    s := Json.EncodeString(#12);

    Test('s').Assert(s).Equals('"\f"');
  end;


  procedure JsonStringEncoding.LineFeedEncodesWithEscaping;
  var
    s: UnicodeString;
  begin
    s := Json.EncodeString(#10);

    Test('s').Assert(s).Equals('"\n"');
  end;


  procedure JsonStringEncoding.NonAsciiCharactersEncodeWithEscapedUnicode;
  var
    s: UnicodeString;
  begin
    s := Json.EncodeString('©');

    Test('s').Assert(s).Equals('"\u00a9"');
  end;


  procedure JsonStringEncoding.OtherControlCharactersEncodeWithEscapedUnicode;
  var
    s: UnicodeString;
  begin
    s := Json.EncodeString(#11);

    Test('s').Assert(s).Equals('"\u000b"');
  end;


  procedure JsonStringEncoding.ReverseSolidusEncodesWithEscaping;
  var
    s: UnicodeString;
  begin
    s := Json.EncodeString('\');

    Test('s').Assert(s).Equals('"\\"');
  end;


  procedure JsonStringEncoding.SupplementaryCharacterStringsEncodeWithEscapedUnicode;
  {
    For this test we use Unicode codepoint Ux1d11e - the treble clef

      UTF-8 Encoding  :	0xF0 0x9D 0x84 0x9E
      UTF-16 Encoding :	0xD834 0xDD1E
  }
  var
    src: UnicodeString;
    s: UnicodeString;
  begin
    src  := '??';
    src[1] := WideChar($d834);
    src[2] := WideChar($dd1e);

    s := Json.EncodeString(src);

    Test('s').Assert(s).Equals('"\ud834\udd1e"');
  end;


  procedure JsonStringEncoding.TabEncodesWithEscaping;
  var
    s: UnicodeString;
  begin
    s := Json.EncodeString(#9);

    Test('s').Assert(s).Equals('"\t"');
  end;



end.
