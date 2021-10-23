Class Oliver.Workflow.Process Extends Ens.BusinessProcessBPL 
{

XData BPL
{
<process request='Oliver.Workflow.Request'
         response='Ens.Response' >
  <context>
    <property name='Resolved' type='%Boolean' initialexpression='0' />
    <property name='DevelopmentAction' type='%String' />
    <property name='TestingAction' type='%String' />
  </context>

  <sequence>
    <while name='while'
           condition='context.Resolved=0' >
      <annotation>
        Work on this problem until it is resolved.
        (Click on the loop icon to see details of this while loop.)
      </annotation>

      <call name='Notify Development'
            target='Demo-Development'
            async='1' >
        <annotation>
          Send the problem report to Development for review.
        </annotation>
        <request type='EnsLib.Workflow.TaskRequest' >
          <assign property='callrequest.%Actions'
                  value='"Corrected,Ignored"'
                  action='set' />
          <assign property='callrequest.%Subject'
                  value='"Problem reported by "_request.ReportedBy'
                  action='set' />
          <assign property='callrequest.%Message'
                  value='request.Problem'
                  action='set' />
          <assign property='callrequest.%FormFields'
                  value='"Comments"'
                  action='set' />
        </request>
        <response type='EnsLib.Workflow.TaskResponse' >
          <assign property='context.DevelopmentAction'
                  value='callresponse.%Action'
                  action='set' />
        </response>
      </call>

      <sync name='WaitForDevelopment' calls='Notify Development' type='all' />

      <if name='Fixed?' condition='context.DevelopmentAction="Corrected"' >
        <annotation>
          If Development fixed the problem, test it.
        </annotation>

        <true>
          <call name='Notify Testing'
                target='Demo-Testing'
                async='1' >
            <annotation>
              Send the problem to Testing for confirmation.
            </annotation>
            <request type='EnsLib.Workflow.TaskRequest' >
              <assign property='callrequest.%Actions'
                      value='"Corrected,Retest"'
                      action='set' />
              <assign property='callrequest.%Subject'
                      value='"Test this problem from "_request.ReportedBy'
                      action='set' />
              <assign property='callrequest.%Message'
                      value='request.Problem'
                      action='set' />
            </request>
            <response type='EnsLib.Workflow.TaskResponse' >
              <assign property='context.TestingAction'
                      value='callresponse.%Action'
                      action='set' />
            </response>
          </call>

          <sync name='WaitForTesting' calls='Notify Testing' type='all' />

          <if name='Corrected?' condition='context.TestingAction="Corrected"' >
            <annotation>Has the problem been corrected?</annotation>
            <true>
              <assign name='Resolved'
                      property='context.Resolved'
                      value='1'
                      action='set' />
            </true>
          </if>
        </true>

        <false>
          <assign name='Not a problem'
                  property='context.Resolved'
                  value='1'
                  action='set' />
        </false>

      </if>
    </while>
  </sequence>
</process>
}
}
