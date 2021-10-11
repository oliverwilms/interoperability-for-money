Class Oliver.Production.Config
{

Parameter DataDir = "/irisdev/app/data";

Parameter MoneyProduction = "Oliver.Money.Production";

Parameter RecordMap = "Oliver.Riches";

ClassMethod AddItems() As %Status
{
	Set pIris = "127.0.0.1:52773"
	Set pType = "POST"
	Set tItem = "MoneyService"
	Set tProduction = ..#MoneyProduction
	Set pURL = "/production/items/"_tProduction_"/"_tItem
	Set tSC = ..MakeDataAddService(.pStream)
	Set tSC = ##class(Oliver.Util).CallRESTapi(pIris,pURL,.obj,pType,pStream)
	Set tSC = ..GetItemSettings(tItem)
	Set tSC = ..UpdateItemSettings(tItem)
	Quit tSC
}

ClassMethod CreateMoney() As %Status
{
	Set pIris = "127.0.0.1:52773"
	Set pType = "POST"
	Set tProduction = ..#MoneyProduction
	Set pURL = "/production/productions/"_tProduction
	Set tSC = ..MakeData(.pStream)
	Set tSC = ##class(Oliver.Util).CallRESTapi(pIris,pURL,.obj,pType,pStream)
	Set tSC = ..AddItems()
	Quit tSC
}

ClassMethod Exists() As %Boolean
{
	Set pDEBUG = 1
	Set pIris = "127.0.0.1:52773"
	Set pURL = "/production/productions"
	Set tProduction = ..#MoneyProduction
	Set pURL = "/production/status/"_tProduction
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

ClassMethod GetItemSettings(pItem As %String = "") As %Status
{
	Set pIris = "127.0.0.1:52773"
	Set pType = "GET"
	Set tItem = "MoneyService"
	Set tProduction = ..#MoneyProduction
	Set pURL = "/production/items/"_tProduction_"/"_tItem
	//Set tSC = ..MakeDataAddService(.pStream)
	Set tSC = ##class(Oliver.Util).CallRESTapi(pIris,pURL,.obj,pType,$Get(pStream))
	Quit tSC
}

ClassMethod MakeData(ByRef pData As %Library.GlobalCharacterStream) As %Status
{
	Set comma = ","
	Set tSC = $$$OK
	Set pData = ##class(%Library.GlobalCharacterStream).%New()
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

ClassMethod MakeDataAddService(ByRef pData As %Library.GlobalCharacterStream) As %Status
{
	Set comma = ","
	Set tSC = $$$OK
	Set pData = ##class(%Library.GlobalCharacterStream).%New()
	Set tSC = pData.WriteLine("{")
	Set tSC = pData.WriteLine(..MakeQLineNumber("enabled",1)_comma)
	Set tSC = pData.WriteLine(..MakeQLineNumber("pool_size",1)_comma)
	Set tSC = pData.WriteLine(..MakeQLineText("class_name","EnsLib.RecordMap.Service.FileService"))
	Set tSC = pData.WriteLine("}")
	Quit tSC
}

ClassMethod MakeDataPutService(ByRef pData As %Library.GlobalCharacterStream) As %Status
{
	Set comma = ","
	Set tSC = $$$OK
	Set pData = ##class(%Library.GlobalCharacterStream).%New()
	Set tSC = pData.WriteLine("{")
	Set tSC = pData.WriteLine(..MakeQLineNumber("enabled",1)_comma)
	Set tSC = pData.WriteLine(..MakeQLineNumber("pool_size",1)_comma)
	Set tSC = pData.WriteLine(..MakeQLineText("class_name","EnsLib.RecordMap.Service.FileService"))
	Set tSC = pData.WriteLine("}")

	Set comma = ","
	Set tSC = $$$OK
	Set pData = ##class(%Library.GlobalCharacterStream).%New()
	Set tSC = pData.WriteLine("{")
	Set tSC = pData.WriteLine(..MakeQLineNumber("pool_size",2)_comma)
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
	Set tSC = pData.WriteLine("}]}")
	Quit tSC

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

ClassMethod MakeQLineNumber(pName As %String = "", pValue As %String = "") As %String
{
	Set pReturn = ""
	Set quote = """"
	Set qName = quote _ pName _ quote
	Set sep = ": "
	Set pReturn = qName _ sep _ pValue
	Quit pReturn
}

ClassMethod MakeQLineText(pName As %String = "", pValue As %String = "") As %String
{
	Set pReturn = ""
	Set quote = """"
	Set qName = quote _ pName _ quote
	Set qValue = quote _ pValue _ quote
	Set sep = ": "
	Set pReturn = qName _ sep _ qValue
	Quit pReturn
}

ClassMethod Test() As %Status
{
	Kill ^TESTunit
	Set tSC = $$$OK
	Set pDEBUG = 1
	Set pIris = "127.0.0.1:52773"
	Set pURL = "/production/productions"
	//Set tSC = ..CallRESTapi(pIris,pURL,.obj)
	Set tProduction = ..#MoneyProduction
	Set pURL = "/production/status/"_tProduction
	//Set tSC = ..CallRESTapi(pIris,pURL,.obj)
	//If $$$ISERR(tSC) Do:pDEBUG ..DebugStatus(tSC)
	If $$$ISOK(tSC) {
		Try {
			Set pMessage = obj.message
			Set pName = obj.name
			Set pStatus = obj.status
			Set pType = obj.type
		}
		Catch {
			Set tSC = $$$ERROR($$$GeneralError,"JSON error")
			//Do:pDEBUG ..DebugStatus(tSC)
		}
	}
	Try {
		//Do:pDEBUG ..DebugTEST("pType = "_pType)
		//Do:pDEBUG ..DebugTEST("pMessage = "_pMessage)


	} Catch { }
	If ($Get(pType) = "error"),($Get(pMessage) [ "Production not found") {
		Set pType = "POST"
		Set pURL = "/production/productions/"_tProduction
		Set tSC = ..MakeData(.pStream)
		//Set tSC = ..CallRESTapi(pIris,pURL,.obj,pType,pStream)
	}
	Quit tSC
}

ClassMethod UpdateItemSettings(pItem As %String = "") As %Status
{
	Set pIris = "127.0.0.1:52773"
	Set pType = "PUT"
	Set tItem = "MoneyService"
	Set tProduction = ..#MoneyProduction
	Set pURL = "/production/items/"_tProduction_"/"_tItem
	Set tSC = ..MakeDataPutService(.pStream)
	Set tSC = ##class(Oliver.Util).CallRESTapi(pIris,pURL,.obj,pType,$Get(pStream))
	Quit tSC
}

}
