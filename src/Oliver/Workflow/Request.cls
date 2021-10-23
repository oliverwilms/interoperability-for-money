Class Oliver.Workflow.Request Extends (%Persistent, Ens.Util.MessageBodyMethods)
{

/// Name of customer reporting the problem.
Property Account As %String(MAXLEN = 60);

/// Description of the problem.
Property Status As %String(MAXLEN = 200);

Storage Default
{
<Data name="RequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Account</Value>
</Value>
<Value name="3">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^Oliver.Workflow.RequestD</DataLocation>
<DefaultData>RequestDefaultData</DefaultData>
<IdLocation>^Oliver.Workflow.RequestD</IdLocation>
<IndexLocation>^Oliver.Workflow.RequestI</IndexLocation>
<StreamLocation>^Oliver.Workflow.RequestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
