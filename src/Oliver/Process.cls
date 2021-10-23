/// 
Class Oliver.Process Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Oliver.Riches.Record' response='Ens.Response' height='2000' width='2000' >
<sequence xend='200' yend='700' >
<switch name='Status' xpos='200' ypos='250' xend='200' yend='500' >
<case condition='request.Status="Investigate"' name='Investigate' >
<call name='Workflow' target='Workflow' async='1' xpos='335' ypos='400' >
<request type='Oliver.Workflow.Request' >
<assign property="callrequest.Account" value="request.Account" action="set" />
<assign property="callrequest.Status" value="request.Status" action="set" />
</request>
<response type='Ens.Response' />
</call>
</case>
<case condition='request.Status="Cleared"' name='Cleared' >
<call name='Workflow' target='Workflow' async='1' xpos='605' ypos='400' >
<request type='Oliver.Workflow.Request' >
<assign property="callrequest.Account" value="request.Account" action="set" />
<assign property="callrequest.Status" value="request.Status" action="set" />
</request>
<response type='Ens.Response' />
</call>
</case>
<default name='default' />
</switch>
<call name='MoneyOperation' target='MoneyOperation' async='1' xpos='200' ypos='600' >
<request type='Oliver.REST.MoneyRequest' >
<assign property="callrequest.Query" value="##class(Oliver.REST.Util).RecordToQuery(request)" action="set" />
</request>
<response type='Ens.Response' />
</call>
</sequence>
</process>
}

}
