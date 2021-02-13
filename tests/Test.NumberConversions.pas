unit Test.NumberConversions;

interface

  uses
    Deltics.Smoketest;


  type
    NumberConversions = class(TTest)
      procedure GetAsDoubleRaisesConvertErrorWhenDoubleRangeExceeded;
      procedure GetAsIntegerRaisesConvertErrorWhenFloatIsNotAnInteger;
      procedure SetAsDoubleRaisesConvertErrorWhenDoubleRangeExceeded;
      procedure SetFloatAsIntegerPreserves64BitsOfIntegerPrecision;
      procedure SetIntegerAsDoubleRaisesConvertErrorWhenInt64RangeExceeded;
      procedure SetIntegerAsDoubleSucceedsWhenInInt64Range;
      procedure SetIntegerAsExtendedRaisesConvertErrorWhenInt64RangeExceeded;
      procedure SetIntegerAsExtendedSucceedsWhenInInt64Range;
    end;



implementation

  uses
    Deltics.Json;



  var
    sut: IJsonMutableValue;


{ NumberConversions }

  procedure NumberConversions.GetAsDoubleRaisesConvertErrorWhenDoubleRangeExceeded;
  begin
    Test.Raises(EJsonConvertError);

    sut := JsonNumber(1.8e+308);

    sut.AsDouble;
  end;


  procedure NumberConversions.GetAsIntegerRaisesConvertErrorWhenFloatIsNotAnInteger;
  begin
    Test.Raises(EJsonConvertError);

    sut := JsonNumber(1.42);

    sut.AsInteger;
  end;


  procedure NumberConversions.SetAsDoubleRaisesConvertErrorWhenDoubleRangeExceeded;
  const
    INFINITE: Double = 1.0 / 0.0;
  begin
    Test.Raises(EJsonConvertError);

    sut := JsonNumber.AsDouble(1.8e+308);

    Test('sut.AsDouble').AssertDouble(sut.AsDouble).Equals(INFINITE);
  end;


  procedure NumberConversions.SetFloatAsIntegerPreserves64BitsOfIntegerPrecision;
  begin
    sut := JsonNumber.AsInteger(High(Integer));

    Test('sut.AsInteger').Assert(sut.AsInteger).Equals(High(Integer));

    sut.AsInt64 := Int64(High(Integer)) + 1;

    Test('sut.AsInt64').Assert(sut.AsInt64).Equals(Int64(High(Integer)) + 1);

    sut.AsInt64 := (Int64(1) shl 53) + 1;

    Test('sut.AsInt64 (above integer range of Double)').Assert(sut.AsInt64).Equals((Int64(1) shl 53) + 1);

    sut.AsInt64 := High(Int64);

    Test('sut.AsInt64 (max Int64)').Assert(sut.AsInt64).Equals(High(Int64));
  end;


  procedure NumberConversions.SetIntegerAsDoubleRaisesConvertErrorWhenInt64RangeExceeded;
  begin
    sut := JsonNumber.New;

    sut.AsDouble := 1.0 * ((Int64(1) shl 63) + 1);
  end;


  procedure NumberConversions.SetIntegerAsDoubleSucceedsWhenInInt64Range;
  begin
    sut := JsonNumber.New;

    sut.AsDouble := 1.0 * ((Int64(1) shl 63));
  end;


  procedure NumberConversions.SetIntegerAsExtendedRaisesConvertErrorWhenInt64RangeExceeded;
  begin
    sut := JsonNumber.New;

    sut.AsExtended := 1.0 * ((Int64(1) shl 63) + 1);
  end;


  procedure NumberConversions.SetIntegerAsExtendedSucceedsWhenInInt64Range;
  begin

  end;




end.
