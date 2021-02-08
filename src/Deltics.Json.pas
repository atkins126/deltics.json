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
  { deltics: }
    Deltics.Json.Exceptions,
    Deltics.Json.Factories,
    Deltics.Json.Formatter,
    Deltics.Json.Interfaces,
    Deltics.Json.Utils;


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
    TJsonDateTimeParts = Deltics.Json.Utils.TJsonDateTimeParts;
    TJsonDatePart      = Deltics.Json.Utils.TJsonDatePart;
  const
    dpYear    = Deltics.Json.Utils.dpYear;
    dpMonth   = Deltics.Json.Utils.dpMonth;
    dpDay     = Deltics.Json.Utils.dpDay;
    dpTime    = Deltics.Json.Utils.dpTime;
    dpOffset  = Deltics.Json.Utils.dpOffset;


  type
    TJsonFormat = Deltics.Json.Formatter.TJsonFormat;
  const
    jfStandard  = Deltics.Json.Formatter.jfStandard;
    jfCompact   = Deltics.Json.Formatter.jfCompact;
    jfConfig    = Deltics.Json.Formatter.jfConfig;


  type
    EJsonConvertError = Deltics.Json.Exceptions.EJsonConvertError;


  type
    IJsonArray  = Deltics.Json.Interfaces.IJsonArray;
    IJsonObject = Deltics.Json.Interfaces.IJsonObject;
    IJsonValue  = Deltics.Json.Interfaces.IJsonValue;

    JsonArray   = Deltics.Json.Factories.JsonArray;
    JsonBoolean = Deltics.Json.Factories.JsonBoolean;
    JsonObject  = Deltics.Json.Factories.JsonObject;
    JsonString  = Deltics.Json.Factories.JsonString;
    JsonNull    = Deltics.Json.Factories.JsonNull;
    JsonNumber  = Deltics.Json.Factories.JsonNumber;

    Json        = Deltics.Json.Utils.Json;



implementation






end.
