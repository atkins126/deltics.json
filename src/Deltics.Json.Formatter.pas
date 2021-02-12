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

  unit Deltics.Json.Formatter;


interface

  uses
  { deltics: }
    Deltics.Datetime,
    Deltics.io.Text,
    Deltics.Strings,
    Deltics.Json.Exceptions,
    Deltics.Json.Factories,
    Deltics.Json.Interfaces,
    Deltics.Json.Utils;


  type
    TJsonFormat = (jfStandard, jfCompact, jfConfig);


    JsonFormatter = class
      class function Format(const aValue: IJsonValue; const aFormat: TJsonFormat): Utf8String;
    end;





implementation

{ JsonFormatter }

  class function JsonFormatter.Format(const aValue: IJsonValue;
                                      const aFormat: TJsonFormat): Utf8String;

    function ObjectToString(const aObject: IJsonObject;
                            const aIndent: Integer): Utf8String; forward;

    function ArrayToString(const aArray: IJsonArray;
                           const aIndent: Integer): Utf8String;
    var
      i: Integer;
      item: IJsonValue;
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
            result := result + Utf8.StringOf(' ', aIndent);

          if NOT item.IsNull then
            case item.ValueType of
              jsString  : result := result + JsonString.EncodeUtf8(item.AsString);

              jsArray   : begin
                            if aFormat in [jfStandard, jfConfig] then
                              result := result + '  ';
                            result := result + ArrayToString(item as IJsonArray, aIndent + 2);
                          end;

              jsObject  : begin
                            if aFormat in [jfStandard, jfConfig] then
                              result := result + '  ';
                            result := result + ObjectToString(item as IJsonObject, aIndent + 2);
                          end;
            else
              result := result + item.AsUtf8;
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
        result := result + #13#10 + Utf8.FromString(StringOfChar(' ', aIndent - 2));

      result := result + ']';
    end;

    function ObjectToString(const aObject: IJsonObject;
                            const aIndent: Integer): Utf8String;
    var
      i: Integer;
      member: IJsonMember;
      value: IJsonValue;
    begin
      if (aObject.Count = 0) then
      begin
        result := '{}';
        EXIT;
      end;

      result := '{';
      if aFormat in [jfStandard, jfConfig] then
        result := result + #13#10;

      if aObject.Count > 0 then
      begin
        for i := 0 to Pred(aObject.Count) do
        begin
          member := aObject.Items[i];

          if aFormat in [jfStandard, jfConfig] then
            result := result + Utf8.FromString(StringOfChar(' ', aIndent + 2));

          if (aFormat = jfConfig) then
            result := result + Utf8.FromString(member.Name)
          else
            result := result + JsonString.EncodeUtf8(member.Name);

          result := result + ':';
          if (aFormat = jfConfig) then
            result := result + ' ';

          if value.IsNull then
            result := result + 'null'
          else
            case value.ValueType of
              jsString  : result := result + JsonString.EncodeUtf8(value.AsString);
              jsArray   : result := result + ArrayToString(value as IJsonArray, aIndent + 4);
              jsObject  : result := result + ObjectToString(value as IJsonObject, aIndent + 4);
            else
              result := result + value.AsUtf8;
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
        result := result + #13#10 + Utf8.FromString(StringOfChar(' ', aIndent));

      result := result + '}';
    end;

  begin
    case aValue.ValueType of
      jsArray   : result := ArrayToString(aValue as IJsonArray, 0);
      jsObject  : result := ObjectToString(aValue as IJsonObject, 0);
      jsString  : result := JsonString.EncodeUtf8(aValue.AsString);
    else
      result := aValue.AsUtf8;
    end;
  end;



end.