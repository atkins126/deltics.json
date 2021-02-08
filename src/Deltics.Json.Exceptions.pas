
{$i deltics.json.inc}

  unit Deltics.Json.Exceptions;


interface

  uses
    Deltics.Exceptions;


  type
    EJson = class(Exception);
    EJsonClass = class of EJson;

    EJsonConvertError       = class(EJson);
    EJsonFormatError        = class(EJson);
    EJsonMemberDoesNotExist = class(EJson);
    EJsonNullValue          = class(EJson);
    EJsonStreamError        = class(EJson);



implementation

end.
