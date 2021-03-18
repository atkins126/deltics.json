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
    Deltics.Json.Types,
    Deltics.Json.Utils;


  type
    JsonFormatter = class
      class function Format(const aValue: IJsonValue; const aFormat: TJsonFormat): Utf8String;
    end;





implementation

  uses
    Deltics.StringBuilders;



{ JsonFormatter }

  class function JsonFormatter.Format(const aValue: IJsonValue;
                                      const aFormat: TJsonFormat): Utf8String;
  var
    builder: IUtf8StringBuilder;

    function ObjectToString(const aObject: IJsonObject;
                            const aIndent: Integer): Utf8String; forward;

    function ArrayToString(const aArray: IJsonArray;
                           const aIndent: Integer): Utf8String;
    var
      i: Integer;
      item: IJsonMutableValue;
    begin
      if (aArray.Count = 0) then
      begin
        builder.Add('[]');
        EXIT;
      end;

      builder.Add('[');

      if aFormat in [jfStandard, jfConfig] then
        builder.Add(#13#10);

      if aArray.Count > 0 then
      begin
        for i := 0 to Pred(aArray.Count) do
        begin
          item := aArray.Items[i];

          if aFormat in [jfStandard, jfConfig] then
            builder.Add(' ', aIndent);

          if NOT item.IsNull then
            case item.ValueType of
              jsString  : builder.Add(JsonString.EncodeUtf8(item.AsString));

              jsArray   : begin
                            if aFormat in [jfStandard, jfConfig] then
                              builder.Add('  ');

                            ArrayToString(item as IJsonArray, aIndent + 2);
                          end;

              jsObject  : begin
                            if aFormat in [jfStandard, jfConfig] then
                              builder.Add('  ');

                            ObjectToString(item as IJsonObject, aIndent + 2);
                          end;
            else
              builder.Add(item.AsUtf8);
            end
          else
          begin
            if aFormat in [jfStandard, jfConfig] then
              builder.Add('  ');

            builder.Add('null');
          end;

          builder.Add(',');

          if aFormat in [jfStandard, jfConfig] then
            builder.Add(#13#10);
        end;

        // At this point we have at least an excess ',' and if we are formatting
        //  in standard (pretty) or config mode, then we also have an excess
        //  CRLF, all of which need to be removed.

        if aFormat in [jfStandard, jfConfig] then
          builder.Remove(3)
        else
          builder.Remove(1);
      end;

      if aFormat in [jfStandard, jfConfig] then
      begin
        builder.Add(#13#10);
        builder.Add(' ', aIndent - 2);
      end;

      builder.Add(']');
    end;

    function ObjectToString(const aObject: IJsonObject;
                            const aIndent: Integer): Utf8String;
    var
      i: Integer;
      member: IJsonMember;
      value: IJsonMutableValue;
    begin
      if (aObject.Count = 0) then
      begin
        builder.Add('{}');
        EXIT;
      end;

      builder.Add('{');

      if aFormat in [jfStandard, jfConfig] then
        builder.Add(#13#10);

      if aObject.Count > 0 then
      begin
        for i := 0 to Pred(aObject.Count) do
        begin
          member  := aObject.Items[i];
          value   := member.Value;

          if aFormat in [jfStandard, jfConfig] then
            builder.Add(' ', aIndent + 2);

          builder.Add(JsonString.EncodeUtf8(member.Name, aFormat <> jfConfig));

          builder.Add(':');
          if (aFormat = jfConfig) then
            builder.Add(' ');

          if value.IsNull then
            builder.Add('null')
          else
            case value.ValueType of
              jsString  : builder.Add(JsonString.EncodeUtf8(value.AsString, TRUE));
              jsArray   : ArrayToString(value as IJsonArray, aIndent + 4);
              jsObject  : ObjectToString(value as IJsonObject, aIndent + 4);
            else
              builder.Add(value.AsUtf8);
            end;

          builder.Add(',');
          if aFormat in [jfStandard, jfConfig] then
            builder.Add(#13#10);
        end;

        // At this point we have at least an excess ',' and if we are formatting
        //  in standard (pretty) or config mode, then we also have an excess
        //  CRLF, all of which need to be removed.

        if aFormat in [jfStandard, jfConfig] then
          builder.Remove(3)
        else
          builder.Remove(1);
      end;

      if aFormat in [jfStandard, jfConfig] then
      begin
        builder.Add(#13#10);
        builder.Add(' ', aIndent);
      end;

      builder.Add('}');
    end;

  begin
    builder := TUtf8StringBuilder.Create;

    case aValue.ValueType of
      jsArray   : ArrayToString(aValue as IJsonArray, 0);
      jsObject  : ObjectToString(aValue as IJsonObject, 0);
      jsString  : builder.Add(JsonString.EncodeUtf8(aValue.AsString, TRUE));
    else
      builder.Add(aValue.AsUtf8);
    end;

    result := builder.AsString;
  end;



end.