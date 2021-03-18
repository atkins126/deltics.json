unit Test.JsonStringDecoding;

interface

  uses
    Deltics.Smoketest;


  type
    JsonStringDecoding = class(TTest)
      procedure RemovesDoubleQuotes;
      procedure AsciiCharacterStringsDecodeWithoutEscaping;
      procedure DoubleQuoteDecodesWithEscaping;
      procedure ReverseSolidusDecodesWithEscaping;
      procedure SolidusDecodesWithEscaping;
      procedure BackspaceDecodesWithEscaping;
      procedure FormFeedDecodesWithEscaping;
      procedure LineFeedDecodesWithEscaping;
      procedure CarriageReturnDecodesWithEscaping;
      procedure TabDecodesWithEscaping;
      procedure OtherControlCharactersDecodeWithEscapedUnicode;
      procedure NonAsciiCharactersDecodeWithEscapedUnicode;
      procedure SupplementaryCharacterStringsDecodeWithEscapedUnicode;
    end;



implementation

  uses
    Deltics.Strings,
    Deltics.Json;



{ JsonStringDecoding }

  procedure JsonStringDecoding.AsciiCharacterStringsDecodeWithoutEscaping;
  var
    s: UnicodeString;
  begin
    s := Json.DecodeString('abc def');

    Test('s').Assert(s).Equals('abc def');
  end;


  procedure JsonStringDecoding.SolidusDecodesWithEscaping;
  var
    s: UnicodeString;
  begin
    s := Json.DecodeString('\/');

    Test('s').Assert(s).Equals('/');
  end;


  procedure JsonStringDecoding.BackspaceDecodesWithEscaping;
  var
    s: UnicodeString;
  begin
    s := Json.DecodeString('\b');

    Test('s').Assert(s).Equals(#8);
  end;


  procedure JsonStringDecoding.CarriageReturnDecodesWithEscaping;
  var
    s: UnicodeString;
  begin
    s := Json.DecodeString('\r');

    Test('s').Assert(s).Equals(#13);
  end;


  procedure JsonStringDecoding.DoubleQuoteDecodesWithEscaping;
  var
    s: UnicodeString;
  begin
    s := Json.DecodeString('\"');

    Test('s').Assert(s).Equals('"');
  end;


  procedure JsonStringDecoding.FormFeedDecodesWithEscaping;
  var
    s: UnicodeString;
  begin
    s := Json.DecodeString('\f');

    Test('s').Assert(s).Equals(#12);
  end;


  procedure JsonStringDecoding.LineFeedDecodesWithEscaping;
  var
    s: UnicodeString;
  begin
    s := Json.DecodeString('\n');

    Test('s').Assert(s).Equals(#10);
  end;


  procedure JsonStringDecoding.NonAsciiCharactersDecodeWithEscapedUnicode;
  var
    s: UnicodeString;
  begin
    s := Json.DecodeString('\u00A9');

    Test('s').Assert(s).Equals('©');
  end;


  procedure JsonStringDecoding.OtherControlCharactersDecodeWithEscapedUnicode;
  const
    EXPECTED: UnicodeString = #$000B;
  var
    s: UnicodeString;
  begin
    s := Json.DecodeString('\u000B');

    Test('DecodeString(\u000B)').Assert(s).Equals(EXPECTED);
  end;


  procedure JsonStringDecoding.RemovesDoubleQuotes;
  var
    s: UnicodeString;
  begin
    s := Json.DecodeString('"abc def"');

    Test('s').Assert(s).Equals('abc def');
  end;


  procedure JsonStringDecoding.ReverseSolidusDecodesWithEscaping;
  var
    s: UnicodeString;
  begin
    s := Json.DecodeString('\\');

    Test('s').Assert(s).Equals('\');
  end;


  procedure JsonStringDecoding.SupplementaryCharacterStringsDecodeWithEscapedUnicode;
  {
    For this test we use Unicode codepoint Ux1d11e - the treble clef

      UTF-8 Decoding  :	0xF0 0x9D 0x84 0x9E
      UTF-16 Decoding :	0xD834 0xDD1E
  }
  var
    src: UnicodeString;
    s: UnicodeString;
  begin
    src  := '??';
    src[1] := WideChar($d834);
    src[2] := WideChar($dd1e);

    s := Json.DecodeString('\uD834\uDD1E');

    Test('s[1]').Assert(Word(s[1])).Equals($d834);
    Test('s[2]').Assert(Word(s[2])).Equals($dd1e);
  end;


  procedure JsonStringDecoding.TabDecodesWithEscaping;
  var
    s: UnicodeString;
  begin
    s := Json.DecodeString('\t');

    Test('s').Assert(s).Equals(#9);
  end;



end.
