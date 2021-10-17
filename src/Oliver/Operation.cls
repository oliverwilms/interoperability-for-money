/// https://docs.intersystems.com/healthconnectlatest/csp/docbook/DocBook.UI.Page.cls?KEY=EREST_operation
Class Oliver.Operation Extends EnsLib.REST.Operation
{

Parameter INVOCATION = "Queue";

Parameter DEBUG = 1;

/// Insert into Riches.Transact (Account,TranDate,Merchant,Category,AmountDebit,AmountCredit) values ...
Method postQuery(
	pRequest As Oliver.REST.MoneyRequest,
	Output pResponse As Oliver.REST.MoneyResponse) As %Status
{
	If ..#DEBUG Do ##class(Oliver.Util).DebugTEST("Oliver.Operation - postQuery")
    // Instantiate the response object
    Set pResponse = ##class(Oliver.REST.MoneyResponse).%New()
	Try {
      // Prepare and log the call
      // Append the query to the URL configured for adapter
      Set tQuery = pRequest.Query
      Set tURL = ..Adapter.URL_tQuery
      If ..#DEBUG Do ##class(Oliver.Util).DebugTEST("tURL = "_tURL)
      Set tURL = ##class(%CSP.Page).EscapeURL(tURL)
      If ..#DEBUG Do ##class(Oliver.Util).DebugTEST("tURL = "_tURL)

      // Execute the call
      #Dim tHttpResponse As %Net.HttpResponse
      Set tSC = ..Adapter.PostURL(tURL,.tHttpResponse)
      Set pResponse.PostStatus = tSC
      If ..#DEBUG {
	      Do ##class(Oliver.Util).DebugStatus(tSC)
	      If $IsObject(tHttpResponse) Do ##class(Oliver.Util).DebugTEST("tHttpResponse = "_tHttpResponse.StatusCode)
      }
      // Return the response
      If $$$ISERR(tSC)&&$IsObject(tHttpResponse)&&$IsObject(tHttpResponse.Data)&&tHttpResponse.Data.Size {
         Set tSC=$$$ERROR($$$EnsErrGeneral,$$$StatusDisplayString(tSC)_":"_tHttpResponse.Data.Read())
      If ..#DEBUG Do ##class(Oliver.Util).DebugTEST($$$StatusDisplayString(tSC)_":"_tHttpResponse.Data.Read())
      }
      Quit:$$$ISERR(tSC)
      If $IsObject(tHttpResponse) {
         Set pResponse.ResponseStatusCode = tHttpResponse.StatusCode
         Set pResponse.ReasonPhrase = tHttpResponse.ReasonPhrase
         /*
         // Convert JSON into a Proxy Object
         set tSC = ..JSONStreamToObject(tHttpResponse.Data, .tProxy)
         if (tSC){                                 
            // Set response properties from the Proxy Object
            set pResponse.Temperature = tProxy.main.temp_"F"
            set pResponse.Humidity = tProxy.main.humidity_"%"
            set pResponse.MaxTemp = tProxy.main."temp_max"_"F"
            set pResponse.MinTemp = tProxy.main."temp_min"_"F"
            set pResponse.Pressure = tProxy.main.pressure_" mbar"
            set pResponse.WindSpeed = tProxy.wind.speed_" MPH"
            set pResponse.WindDirection = tProxy.wind.deg_" degrees"
            // Convert from POSIX time
            set pResponse.Sunrise = $ZT($PIECE($ZDTH(tProxy.sys.sunrise, -2),",",2),3)
            set pResponse.Sunset = $ZT($PIECE($ZDTH(tProxy.sys.sunset, -2),",",2),3)
          }
          */
       }
   } Catch {
       Set tSC = $$$SystemError
   }
   Quit tSC
}

XData MessageMap
{
<MapItems>
  <MapItem MessageType="Oliver.REST.MoneyRequest">
    <Method>postQuery</Method>
  </MapItem>
</MapItems>
}

}
