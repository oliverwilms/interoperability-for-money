Class Oliver.Production.Config
{

Parameter DataDir = "/irisdev/app/data";

Parameter DEBUG = 1;

Parameter AnalyticsCredential = "restapi";

Parameter AnalyticsHTTPPort = 52773;

Parameter AnalyticsHTTPServer = "172.16.238.30";

Parameter AnalyticsHTTPUrl = "/restapi/sql/";

Parameter MoneyOperation = "MoneyOperation";

Parameter MoneyProcess = "MoneyProcess";

Parameter MoneyProduction = "Oliver.Money.Production";

Parameter MoneyService = "MoneyService";

Parameter ProductionManager = "/prodmgr";

Parameter RecordMap = "Oliver.Riches";

Parameter Workflow = 1;

Parameter WorkflowRole = "Development";

ClassMethod AddOperation() As %Status
{
	Do:..#DEBUG ##class(Oliver.Util).DebugTEST("Oliver.Production.Config - AddOperation")
	Set pIris = "127.0.0.1:52773"
	Set pType = "POST"
	Set tItem = ..#MoneyOperation
	Set tProduction = ..#MoneyProduction
	Set pURL = ..#ProductionManager_"/items/"_tProduction_"/"_tItem
	Set tSC = ..MakeDataAddOperation(.pStream)
	Set tSC = ##class(Oliver.Util).CallRESTapi(pIris,pURL,.obj,pType,pStream)
	Set tSC = ..GetItemSettings(tItem)
	Set tSC = ..MakeDataPutOperation(.pStream)
	Set tSC = ..PutItemSettings(tItem,.pStream)
	Quit tSC
}

ClassMethod AddProcess() As %Status
{
	Do:..#DEBUG ##class(Oliver.Util).DebugTEST("Oliver.Production.Config - AddProcess")
	Set pIris = "127.0.0.1:52773"
	Set pType = "POST"
	Set tItem = ..#MoneyProcess
	Set tProduction = ..#MoneyProduction
	Set pURL = ..#ProductionManager_"/items/"_tProduction_"/"_tItem
	Set tSC = ..MakeDataAddProcess(.pStream)
	Set tSC = ##class(Oliver.Util).CallRESTapi(pIris,pURL,.obj,pType,pStream)
	Set tSC = ..GetItemSettings(tItem)
	Quit tSC
}

ClassMethod AddService() As %Status
{
	Do:..#DEBUG ##class(Oliver.Util).DebugTEST("Oliver.Production.Config - AddService")
	Set pIris = "127.0.0.1:52773"
	Set pType = "POST"
	Set tItem = ..#MoneyService
	Set tProduction = ..#MoneyProduction
	Set pURL = ..#ProductionManager_"/items/"_tProduction_"/"_tItem
	Set tSC = ..MakeDataAddService(.pStream)
	Set tSC = ##class(Oliver.Util).CallRESTapi(pIris,pURL,.obj,pType,pStream)
	Set tSC = ..GetItemSettings(tItem)
	Set tSC = ..MakeDataPutService(.pStream)
	Set tSC = ..PutItemSettings(tItem,.pStream)
	Quit tSC
}

ClassMethod AddWorkflow() As %Status
{
	Do:..#DEBUG ##class(Oliver.Util).DebugTEST("Oliver.Production.Config - AddWorkflow")
	Set tSC = ..AddWorkflowProcess()
	Set tSC = ..AddWorkflowOperation()
	Quit tSC
}

ClassMethod AddWorkflowOperation() As %Status
{
	Do:..#DEBUG ##class(Oliver.Util).DebugTEST("Oliver.Production.Config - AddWorkflowOperation")
	Set pIris = "127.0.0.1:52773"
	Set pType = "POST"
	Set tItem = ..#WorkflowRole
	Set tProduction = ..#MoneyProduction
	Set pURL = ..#ProductionManager_"/items/"_tProduction_"/"_tItem
	Set tClassName = "EnsLib.Workflow.Operation"
	Set tSC = ..MakeDataAddItem(.pStream,tClassName)
	Set tSC = ##class(Oliver.Util).CallRESTapi(pIris,pURL,.obj,pType,pStream)
	Set tSC = ..GetItemSettings(tItem)
	Set tSC = ..MakeDataPutWorkflowOperation(.pStream)
	Set tSC = ..PutItemSettings(tItem,.pStream)
	Quit tSC
}

ClassMethod AddWorkflowProcess() As %Status
{
	Do:..#DEBUG ##class(Oliver.Util).DebugTEST("Oliver.Production.Config - AddWorkflowProcess")
	Set pIris = "127.0.0.1:52773"
	Set pType = "POST"
	Set tItem = "Workflow"
	Set tProduction = ..#MoneyProduction
	Set pURL = ..#ProductionManager_"/items/"_tProduction_"/"_tItem
	Set tClassName = "Oliver.Workflow.Process"
	Set tSC = ..MakeDataAddItem(.pStream,tClassName)
	Set tSC = ##class(Oliver.Util).CallRESTapi(pIris,pURL,.obj,pType,pStream)
	Set tSC = ..GetItemSettings(tItem)
	Quit tSC
}

ClassMethod CreateMoney() As %Status
{
	Do:..#DEBUG ##class(Oliver.Util).DebugTEST("Oliver.Production.Config - CreateMoney")
	Set pIris = "127.0.0.1:52773"
	Set pType = "POST"
	Set tProduction = ..#MoneyProduction
	Set pURL = ..#ProductionManager_"/productions/"_tProduction
	Set tSC = ..MakeData(.pStream)
	Set tSC = ##class(Oliver.Util).CallRESTapi(pIris,pURL,.obj,pType,pStream)
	Set tItem = ..#MoneyService
	Set tExists = ..ExistsItem(tItem)
	If (tExists = 0) {
		Set tSC = ..AddService()
	}
	Set tItem = ..#MoneyProcess
	Set tExists = ..ExistsItem(tItem)
	If (tExists = 0) {
		Set tSC = ..AddProcess()
	}
	Set tItem = ..#MoneyOperation
	Set tExists = ..ExistsItem(tItem)
	If (tExists = 0) {
		Set tSC = ..AddOperation()
	}
	If ..#Workflow {
		Set tSC = ..AddWorkflow()
	}
	Quit tSC
}

ClassMethod Exists() As %Boolean
{
	Do:..#DEBUG ##class(Oliver.Util).DebugTEST("Oliver.Production.Config - Exists")
	Set pDEBUG = 1
	Set pIris = "127.0.0.1:52773"
	Set pURL = ..#ProductionManager_"/productions"
	Set tProduction = ..#MoneyProduction
	Set pURL = ..#ProductionManager_"/status/"_tProduction
	Set tSC = ##class(Oliver.Util).CallRESTapi(pIris,pURL,.obj)
	If $$$ISERR(tSC) Do:pDEBUG ##class(Oliver.Util).DebugStatus(tSC)
	If $$$ISOK(tSC) {
		Try {
			Set pMessage = obj.message
			Set pName = obj.name
			Set pStatus = obj.status
			Set pType = obj.type
		}
		Catch {
			Set tSC = $$$ERROR($$$GeneralError,"JSON error")
			Do:pDEBUG ##class(Oliver.Util).DebugStatus(tSC)
		}
	}
	Try {
		Do:pDEBUG ##class(Oliver.Util).DebugTEST("pMessage = "_pMessage)
		Do:pDEBUG ##class(Oliver.Util).DebugTEST("pName = "_pName)
		Do:pDEBUG ##class(Oliver.Util).DebugTEST("pStatus = "_pStatus)
		Do:pDEBUG ##class(Oliver.Util).DebugTEST("pType = "_pType)
	} Catch { }
	If ($Get(pType) = "error"),($Get(pMessage) [ "Production not found") {
		Quit 0
	}
	Quit 1
}

ClassMethod ExistsItem(pItem As %String = "") As %Boolean
{
	Do:..#DEBUG ##class(Oliver.Util).DebugTEST("Oliver.Production.Config - ExistsItem")
	Set tExists = 0
	Set tSC = ..GetItemSettings(pItem,.obj)
	If $$$ISERR(tSC) Do:..#DEBUG ##class(Oliver.Util).DebugStatus(tSC)
	If $$$ISOK(tSC) {
		Try {
			Set pName = obj.name
		}
		Catch {
			Set tSC = $$$ERROR($$$GeneralError,"JSON error")
			Do:..#DEBUG ##class(Oliver.Util).DebugStatus(tSC)
		}
	}
	Try {
		If (pName = pItem) { Set tExists = 1 }
	} Catch { }
	Quit tExists
}

ClassMethod GetItemSettings(
	pItem As %String = "",
	ByRef pResponseData As %DynamicObject) As %Status
{
	Do:..#DEBUG ##class(Oliver.Util).DebugTEST("Oliver.Production.Config - GetItemSettings")
	Set pIris = "127.0.0.1:52773"
	Set pType = "GET"
	Set tProduction = ..#MoneyProduction
	Set pURL = ..#ProductionManager_"/items/"_tProduction_"/"_pItem
	Set tSC = ##class(Oliver.Util).CallRESTapi(pIris,pURL,.pResponseData,pType,$Get(pStream))
	Quit tSC
}

ClassMethod MakeData(ByRef pData As %Stream.FileCharacter) As %Status
{
	Do:..#DEBUG ##class(Oliver.Util).DebugTEST("Oliver.Production.Config - MakeData")
	Set comma = ","
	Set tSC = $$$OK
	Set pData = ##class(%Stream.FileCharacter).%New()
	Set tSC = pData.WriteLine("{")
	Set tSC = pData.WriteLine(..MakeQLineText("description","new demo production")_comma)
	Set tSC = pData.WriteLine(..MakeQLineNumber("actor_pool_size",2)_comma)
	Set tSC = pData.WriteLine(..MakeQLineNumber("log_general_trace_events",1)_comma)
	Set tSC = pData.WriteLine(..MakeQLineNumber("testing_enabled",1)_comma)
	Set tSC = pData.WriteLine(..MakeQArrayOpen("settings"))
	Set tSC = pData.WriteLine("{")
	Set tSC = pData.WriteLine(..MakeQLineText("name","ShutdownTimeout")_comma)
	Set tSC = pData.WriteLine(..MakeQLineText("target","Adapter")_comma)
	Set tSC = pData.WriteLine(..MakeQLineText("value","180"))
	Set tSC = pData.WriteLine("}]}")
	Quit tSC
}

ClassMethod MakeDataAddItem(
	ByRef pData As %Stream.FileCharacter,
	pItemClass As %String) As %Status
{
	Do:..#DEBUG ##class(Oliver.Util).DebugTEST("Oliver.Production.Config - MakeDataAddItem")
	Do:..#DEBUG ##class(Oliver.Util).DebugTEST("pItemClass = "_pItemClass)
	Set comma = ","
	Set tSC = $$$OK
	Set pData = ##class(%Stream.FileCharacter).%New()
	Set tSC = pData.WriteLine("{")
	Set tSC = pData.WriteLine(..MakeQLineNumber("enabled",1)_comma)
	Set tSC = pData.WriteLine(..MakeQLineNumber("pool_size",1)_comma)
	Set tSC = pData.WriteLine(..MakeQLineText("class_name",pItemClass))
	Set tSC = pData.WriteLine("}")
	Quit tSC
}

ClassMethod MakeDataAddOperation(ByRef pData As %Stream.FileCharacter) As %Status
{
	Do:..#DEBUG ##class(Oliver.Util).DebugTEST("Oliver.Production.Config - MakeDataAddOperation")
	Set tClassName = "Oliver.Operation"
	Set tSC = ..MakeDataAddItem(.pData,tClassName)
	Quit tSC
}

ClassMethod MakeDataAddProcess(ByRef pData As %Stream.FileCharacter) As %Status
{
	Do:..#DEBUG ##class(Oliver.Util).DebugTEST("Oliver.Production.Config - MakeDataAddProcess")
	Set tClassName = "Oliver.Process"
	Set tSC = ..MakeDataAddItem(.pData,tClassName)
	Quit tSC
}

ClassMethod MakeDataAddService(ByRef pData As %Stream.FileCharacter) As %Status
{
	Do:..#DEBUG ##class(Oliver.Util).DebugTEST("Oliver.Production.Config - MakeDataAddService")
	Set tClassName = "EnsLib.RecordMap.Service.FileService"
	Set tSC = ..MakeDataAddItem(.pData,tClassName)
	Quit tSC
}

ClassMethod MakeDataPutOperation(ByRef pData As %Stream.FileCharacter) As %Status
{
	Do:..#DEBUG ##class(Oliver.Util).DebugTEST("Oliver.Production.Config - MakeDataPutOperation")

	Set comma = ","
	Set tSC = $$$OK
	Set pData = ##class(%Stream.FileCharacter).%New()
	Set tSC = pData.WriteLine("{")
	Set tSC = pData.WriteLine(..MakeQLineNumber("pool_size",1)_comma)
	Set tSC = pData.WriteLine(..MakeQLineNumber("log_trace_events",1)_comma)
	Set tSC = pData.WriteLine(..MakeQArrayOpen("settings"))
	Set tSC = pData.WriteLine("{")
	Set tSC = pData.WriteLine(..MakeQLineText("name","HTTPServer")_comma)
	Set tSC = pData.WriteLine(..MakeQLineText("target","Adapter")_comma)
	Set tSC = pData.WriteLine(..MakeQLineText("value",..#AnalyticsHTTPServer))
	Set tSC = pData.WriteLine("}"_comma)
	Set tSC = pData.WriteLine("{")
	Set tSC = pData.WriteLine(..MakeQLineText("name","HTTPPort")_comma)
	Set tSC = pData.WriteLine(..MakeQLineText("target","Adapter")_comma)
	Set tSC = pData.WriteLine(..MakeQLineText("value",..#AnalyticsHTTPPort))
	Set tSC = pData.WriteLine("}"_comma)
	Set tSC = pData.WriteLine("{")
	Set tSC = pData.WriteLine(..MakeQLineText("name","URL")_comma)
	Set tSC = pData.WriteLine(..MakeQLineText("target","Adapter")_comma)
	Set tSC = pData.WriteLine(..MakeQLineText("value",..#AnalyticsHTTPUrl))
	Set tSC = pData.WriteLine("}"_comma)
	Set tSC = pData.WriteLine("{")
	Set tSC = pData.WriteLine(..MakeQLineText("name","Credentials")_comma)
	Set tSC = pData.WriteLine(..MakeQLineText("target","Adapter")_comma)
	Set tSC = pData.WriteLine(..MakeQLineText("value",..#AnalyticsCredential))
	Set tSC = pData.WriteLine("}]}")
	Quit tSC
}

ClassMethod MakeDataPutService(ByRef pData As %Stream.FileCharacter) As %Status
{
	Do:..#DEBUG ##class(Oliver.Util).DebugTEST("Oliver.Production.Config - MakeDataPutService")

	Set comma = ","
	Set tSC = $$$OK
	Set pData = ##class(%Stream.FileCharacter).%New()
	Set tSC = pData.WriteLine("{")
	Set tSC = pData.WriteLine(..MakeQLineNumber("pool_size",1)_comma)
	Set tSC = pData.WriteLine(..MakeQLineNumber("log_trace_events",1)_comma)
	Set tSC = pData.WriteLine(..MakeQArrayOpen("settings"))
	Set tSC = pData.WriteLine("{")
	Set tSC = pData.WriteLine(..MakeQLineText("name","FilePath")_comma)
	Set tSC = pData.WriteLine(..MakeQLineText("target","Adapter")_comma)
	Set tSC = pData.WriteLine(..MakeQLineText("value",..#DataDir))
	Set tSC = pData.WriteLine("}"_comma)
	Set tSC = pData.WriteLine("{")
	Set tSC = pData.WriteLine(..MakeQLineText("name","RecordMap")_comma)
	Set tSC = pData.WriteLine(..MakeQLineText("target","Host")_comma)
	Set tSC = pData.WriteLine(..MakeQLineText("value",..#RecordMap))
	Set tSC = pData.WriteLine("}"_comma)
	Set tSC = pData.WriteLine("{")
	Set tSC = pData.WriteLine(..MakeQLineText("name","TargetConfigNames")_comma)
	Set tSC = pData.WriteLine(..MakeQLineText("target","Host")_comma)
	Set tSC = pData.WriteLine(..MakeQLineText("value",..#MoneyProcess))
	Set tSC = pData.WriteLine("}]}")
	Quit tSC
}

ClassMethod MakeDataPutWorkflowOperation(ByRef pData As %Stream.FileCharacter) As %Status
{
	Do:..#DEBUG ##class(Oliver.Util).DebugTEST("Oliver.Production.Config - MakeDataPutWorkflowOperation")

	Set comma = ","
	Set tSC = $$$OK
	Set pData = ##class(%Stream.FileCharacter).%New()
	Set tSC = pData.WriteLine("{")
	Set tSC = pData.WriteLine(..MakeQLineNumber("pool_size",1)_comma)
	Set tSC = pData.WriteLine(..MakeQLineNumber("log_trace_events",1)_comma)
	Set tSC = pData.WriteLine(..MakeQArrayOpen("settings"))
	Set tSC = pData.WriteLine("{")
	Set tSC = pData.WriteLine(..MakeQLineText("name","AutoCreateRole")_comma)
	Set tSC = pData.WriteLine(..MakeQLineText("target","Host")_comma)
	Set tSC = pData.WriteLine(..MakeQLineText("value",1))
	Set tSC = pData.WriteLine("}]}")
	Quit tSC
}

ClassMethod MakeQArrayOpen(pName As %String = "") As %String
{
	Set pReturn = ""
	Set quote = """"
	Set qName = quote _ pName _ quote
	Set sep = ": "
	Set pReturn = qName _ sep _ "["
	Quit pReturn
}

ClassMethod MakeQLineNumber(
	pName As %String = "",
	pValue As %String = "") As %String
{
	Set pReturn = ""
	Set quote = """"
	Set qName = quote _ pName _ quote
	Set sep = ": "
	Set pReturn = qName _ sep _ pValue
	Quit pReturn
}

ClassMethod MakeQLineText(
	pName As %String = "",
	pValue As %String = "") As %String
{
	Set pReturn = ""
	Set quote = """"
	Set qName = quote _ pName _ quote
	Set qValue = quote _ pValue _ quote
	Set sep = ": "
	Set pReturn = qName _ sep _ qValue
	Quit pReturn
}

ClassMethod PutItemSettings(
	pItem As %String = "",
	ByRef pStream) As %Status
{
	Do:..#DEBUG ##class(Oliver.Util).DebugTEST("Oliver.Production.Config - PutItemSettings")
	Set pIris = "127.0.0.1:52773"
	Set pType = "PUT"
	Set tProduction = ..#MoneyProduction
	Set pURL = ..#ProductionManager_"/items/"_tProduction_"/"_pItem
	Set tSC = ##class(Oliver.Util).CallRESTapi(pIris,pURL,.obj,pType,$Get(pStream))
	Quit tSC
}

}
