Class Oliver.REST.MoneyRequest Extends (%Persistent, Ens.Util.MessageBodyMethods)
{

Property Query As %String(MAXLEN = 32765);

Storage Default
{
<Data name="MoneyRequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Query</Value>
</Value>
</Data>
<DataLocation>^Oliver.REST.MoneyRequestD</DataLocation>
<DefaultData>MoneyRequestDefaultData</DefaultData>
<IdLocation>^Oliver.REST.MoneyRequestD</IdLocation>
<IndexLocation>^Oliver.REST.MoneyRequestI</IndexLocation>
<StreamLocation>^Oliver.REST.MoneyRequestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
