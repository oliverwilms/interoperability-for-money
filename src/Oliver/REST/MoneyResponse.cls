Class Oliver.REST.MoneyResponse Extends (%Persistent, Ens.Util.MessageBodyMethods)
{

Property Temperature As %String;

Property MinTemp As %String;

Property MaxTemp As %String;

Property Pressure As %String;

Property Humidity As %String;

Property WindSpeed As %String;

Property WindDirection As %String;

Property Sunrise As %String;

Property Sunset As %String;

Storage Default
{
<Data name="MoneyResponseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Temperature</Value>
</Value>
<Value name="3">
<Value>MinTemp</Value>
</Value>
<Value name="4">
<Value>MaxTemp</Value>
</Value>
<Value name="5">
<Value>Pressure</Value>
</Value>
<Value name="6">
<Value>Humidity</Value>
</Value>
<Value name="7">
<Value>WindSpeed</Value>
</Value>
<Value name="8">
<Value>WindDirection</Value>
</Value>
<Value name="9">
<Value>Sunrise</Value>
</Value>
<Value name="10">
<Value>Sunset</Value>
</Value>
</Data>
<DataLocation>^Oliver.REST.MoneyResponseD</DataLocation>
<DefaultData>MoneyResponseDefaultData</DefaultData>
<IdLocation>^Oliver.REST.MoneyResponseD</IdLocation>
<IndexLocation>^Oliver.REST.MoneyResponseI</IndexLocation>
<StreamLocation>^Oliver.REST.MoneyResponseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
