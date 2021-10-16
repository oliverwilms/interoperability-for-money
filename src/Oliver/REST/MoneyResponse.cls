Class Oliver.REST.MoneyResponse Extends (%Persistent, Ens.Util.MessageBodyMethods)
{

/// The HTTP status code. This is useful to determine if the request was
/// successful. Look in the rfc for HTTP to see which codes are supported
/// and what they mean. A human readable form of this code is stored as
/// the <PROPERTY>ReasonPhrase</PROPERTY>
Property ResponseStatusCode As %Integer;

/// This is the human readable reason that goes with the <PROPERTY>ResponseStatusCode</PROPERTY>.
Property ReasonPhrase As %String;

Property PostStatus As %Status;

Storage Default
{
<Data name="MoneyResponseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ResponseStatusCode</Value>
</Value>
<Value name="3">
<Value>ReasonPhrase</Value>
</Value>
<Value name="4">
<Value>PostStatus</Value>
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
