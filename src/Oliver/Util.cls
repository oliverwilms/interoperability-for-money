Class Oliver.Util
{

ClassMethod DebugMerge(
	strMessage As %String = "",
	ByRef pArray) As %Status
{
	Merge ^TESTunit($I(^TESTunit)) = pArray
	Set tValue = ""
	If $Get(pArray) '= "" Set tValue = " = "_pArray
	Set ^TESTunit(^TESTunit) = $ZDateTime($NOW(),8,1,3)_" : "_$JOB_" : "_strMessage_tValue
	Quit $$$OK
}

ClassMethod DebugTEST(strMessage As %String = "") As %Status
{
	Set ^TESTunit($I(^TESTunit)) = $ZDateTime($NOW(),8,1,3)_" : "_$JOB_" : "_strMessage
	Quit $$$OK
}

ClassMethod StatusToText(pStatus As %Status) As %String
{
	Set tReturn = $System.Status.GetOneErrorText(pStatus)
	Quit tReturn
}

ClassMethod DebugStatus(pStatus As %Status) As %Status
{
	Set tStatus = ..StatusToText(pStatus)
	Quit ..DebugTEST(tStatus)
}

ClassMethod CallRESTapi(
	pIris As %String,
	pUrl As %String,
	ByRef pResponseData As %DynamicObject,
	pType As %String = "GET",
	pStream As %Library.GlobalCharacterStream) As %Status
{
	#define maxRESTapiErr 3
	#define maxRetries 2
	#define timeout 3
	Do ..DebugTEST("Oliver.Util - CallRESTapi")
	Do ..DebugTEST("pIris = "_$Get(pIris))
	Do ..DebugTEST("pUrl = "_$Get(pUrl))
	Do ..DebugTEST("pType = "_$Get(pType))
	Set tErrorCount = 0
	Set tParamIRIS = pIris
	If (pIris = 0) Set pIris = "127.0.0.1:52773"
	Set tServer = $Piece(pIris,":",1)
	Set tPort = $Piece(pIris,":",2)
	Do {
		Set tRetryFlag = 0
		Set pResponse = $$$NULLOREF
		Set tRequest = ##class(%Net.HttpRequest).%New()

		// InitiateAuthentication does not exist in HealthShare versions
		Try {
			//Supported schemes are Negotiate, NTLM and Basic.
			Set tRequest.InitiateAuthentication = "Basic"
			Set tRequest.Username = "_SYSTEM"
			Set tRequest.Password = ..GetPass(pIris)
		} Catch {
		}
		
		// Request body 
		Try {
			Set tSC = tRequest.EntityBody.CopyFrom(pStream)
			If $$$ISERR(tSC) Do ##class(Feeder.Util).DebugStatus(tSC)
		} Catch {
		}

		//Set tRequest.Server = ""  // This defaults to 'localhost', i.e. your current machine if not specified.
		Set tRequest.Port = tPort
		If (tServer '= "") Set tRequest.Server = tServer
		Set tRequest.Timeout = $$$timeout
		If ($Get(pType) = "") Set pType = "GET"
		Set location = $Get(pUrl)
		Set location = ##class(%CSP.Page).EscapeURL(location)
		Set test = 0
		Set reset = 1
		Set tSC = tRequest.Send(pType,location,test,reset)
		If $$$ISERR(tSC) Do ..DebugStatus(tSC)
		Set pResponse = tRequest.HttpResponse
		If $IsObject(pResponse) {
			If (pResponse.StatusCode '= 200) {
				Do ..DebugTEST("StatusCode = "_pResponse.StatusCode)
				Do ..DebugTEST("ReasonPhrase = "_pResponse.ReasonPhrase)
			}
			If (pResponse.StatusCode = 500) {  // Internal Server Error
				If $Increment(tErrorCount) <= $$$maxRetries Set tRetryFlag = 1
			}
		} Else {
			Do ..DebugTEST("HttpResponse = "_pResponse)
		}
	} While tRetryFlag

	If $IsObject(pResponse) {
		#dim tDataStream As %Stream.GlobalBinary
		Set tDataStream = pResponse.Data
		Set tDataString = tDataStream.Read(.len,.sc)
		If $$$ISOK(sc) {
			Do ..DebugTEST("tDataString = "_tDataString)
		} Else {
			Do ..DebugTEST("Data = "_pResponse.Data)
			Do ..DebugTEST("len = "_$Get(len))
			Do ..DebugStatus(sc)
		}
		Try {
			Set pResponseData = ##class(%DynamicObject).%FromJSON(tDataString)
		}
		Catch {
			Set tSC = $$$ERROR($$$GeneralError,"JSON error")
			If (pResponse.StatusCode '= 200) {
				Set tSC = $$$ERROR($$$GeneralError,"Response was "_pResponse.StatusCode_" / "_pResponse.ReasonPhrase)
			}
			Do ..DebugStatus(tSC)
		}
	}
	If $$$ISOK(tSC) {
		Quit tSC
	}
	Set pIris = $Get(tParamIRIS,pIris)
	Quit tSC
}

ClassMethod CallRESTapi2(
	pIris As %String,
	pUrl As %String,
	ByRef pResponseData As %DynamicObject,
	pType As %String = "GET") As %Status
{
	Set tSC = ..CallRESTapi(pIris,pUrl,.pResponseData,pType)
	If $$$ISOK(tSC) {
		Quit tSC
	}
	If $$$ISERR(tSC) {
		Set tError = ..StatusToText(tSC)
		If (tError [ "ERROR #6059: Unable to open TCP/IP socket to server ") {
			Set tPort = $Piece(pIris,":",2)
			If (tPort = 52773) {
				Set tPort = 443
				Set $Piece(pIris,":",2) = tPort
				Set tSC = ..CallRESTapi(pIris,pUrl,.pResponseData,pType)
				Quit tSC
			}
		}
	}
	Quit tSC
	#define maxRESTapiErr 3
	#define maxRetries 2
	#define timeout 3
	Do ..DebugTEST("Oliver.Util - CallRESTapi")
	Do ..DebugTEST("pIris = "_$Get(pIris))
	Do ..DebugTEST("pUrl = "_$Get(pUrl))
	Set myUnitTest = $Get(^myUnitTests)
}

ClassMethod ExecuteQueryOneValue(
	pQuery As %String,
	ByRef pResult As %String,
	pDEBUG As %Integer = 0) As %Status
{
	Do:pDEBUG ..DebugTEST("Oliver.Util - ExecuteQueryOneValue")
	Do:pDEBUG ..DebugTEST("pQuery = "_pQuery)
	Set pResult = ""
	Set rs = ##class(%ResultSet).%New()
	Set tSC = rs.Prepare(pQuery)
	Do:pDEBUG ..DebugStatus(tSC)
	If $$$ISOK(tSC) {
		Set tSC = rs.Execute()
		Do:pDEBUG ..DebugStatus(tSC)
		If $$$ISOK(tSC), rs.Next() Set pResult = rs.GetData(1)
	}
	Do rs.Close()
	Set rs = ""
	Do:pDEBUG ..DebugTEST("pResult = "_pResult)
	Quit tSC
}

/// Get a list of files in the directory configured by FilePath.
/// The filenames are returned in a %ListOfDataTypes object. Each entry in the list is
/// a semicolon-separated string containing: Filename;Type;Size;DateCreated;DateModified;FullPathName
ClassMethod FileSet(
	Output pFileList As %ListOfDataTypes,
	pFilePath As %String = "",
	pWildcards As %String = "*",
	pIncludeDirs As %Boolean = 0) As %Status
{
	#; ={$Select($$$isVMS:"*.*",1:"*")}
	Set $ZT="Trap",tSC=$$$OK
	do {
		Kill pFileList Set pFileList=##class(%ListOfDataTypes).%New()
		//$$$catTRACE("file","Getting list of filenames for "_..fixPath(..FilePath))
		Set tResultSet=##class(%ResultSet).%New("%File:FileSet")
		Set tSC=tResultSet.Execute(pFilePath,pWildcards,"Type",pIncludeDirs)  Quit:$$$ISERR(tSC)
		While 0'=tResultSet.Next() {
			#; PathName;Type;Size;DateCreated;DateModified;Name
			Set tSC = pFileList.Insert(tResultSet.GetData(6)_";="_tResultSet.GetData(2)_";"_tResultSet.GetData(3)_";created="_tResultSet.GetData(4)_";modified="_tResultSet.GetData(5)_";"_tResultSet.GetData(1))  Quit:$$$ISERR(tSC)
		}
	} while (0)
	//If $$$ISERR(tSC) $$$LOGSTATUS(tSC)
Exit
	Quit tSC
Trap
	//Set $ZT="",tSC=$$$SystemError
	Set $ZT="",tSC=$$$ERROR($$$GeneralError,"FileSet Error")
	Goto Exit
}

ClassMethod GetPass(pIris As %String) As %String
{
	Set tPass = "SYS"
	Quit tPass
}

ClassMethod MakeCredential() As %Status
{
	Set c = ##class(Ens.Config.Credentials).%New()
	Set c.Password = "abc123"
	Set c.SystemName = "restapi"
	Set c.Username = "_SYSTEM"
	Set tSC = c.%Save()
	Quit tSC
}

ClassMethod MakeRecordMap(pGenerate As %Boolean = 1) As %Status
{
	Set pDEBUG = 1
	Do:pDEBUG ..DebugTEST("Oliver.Util - MakeRecordMap")
	Set tDataDir = ##class(Oliver.Production.Config).#DataDir
	Do:pDEBUG ..DebugTEST("tDataDir = "_tDataDir)
	Set tFilename = "export.CSV"
	Do:pDEBUG ..DebugTEST("tFilename = "_tFilename)
	Set x = "/"
	Set tDataFile = tDataDir _ x _ tFilename
	Do:pDEBUG ..DebugTEST("tDataFile = "_tDataFile)
	Set tRecordMap = ##class(Oliver.Production.Config).#RecordMap
	Set tReturn = ##class(Oliver.CSVRecordWizard).Test(tDataFile,tRecordMap)
	Do:pDEBUG ..DebugTEST("tReturn = "_tReturn)
	If pGenerate {
		Set tSC = ##class(EnsLib.RecordMap.Generator).GenerateObject(tRecordMap)
	}
	Quit $Get(tSC,$$$OK)
}

ClassMethod Test() As %Status
{
	Set pDEBUG = 1
	Do:pDEBUG ##class(Oliver.Util).DebugTEST("Oliver.Util - Test")
	Kill ^TESTunit
	Set tSC = ..MakeCredential()
	Set tSC = ..MakeRecordMap()
	Set tExists = ##class(Oliver.Production.Config).Exists()
	//If tExists Quit $$$OK
	Set tSC = ##class(Oliver.Production.Config).CreateMoney()
	Quit tSC
}

}
