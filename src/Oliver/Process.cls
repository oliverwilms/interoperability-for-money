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
<sequence xend='200' yend='450' >
<code xpos='200' ypos='250' />
<call name='MoneyOperation' target='MoneyOperation' async='1' xpos='200' ypos='350' >
<request type='Oliver.REST.MoneyRequest' >
<assign property="callrequest.Query" value="request.Memo" action="set" />
</request>
<response type='Ens.Response' />
</call>
</sequence>
</process>
}

}
