/// https://docs.intersystems.com/healthconnectlatest/csp/docbook/DocBook.UI.Page.cls?KEY=EREST_operation
Class Oliver.Operation Extends EnsLib.REST.Operation
{

Parameter INVOCATION = "Queue";

Method postQuery(pRequest As Oliver.REST.MoneyRequest, Output pResponse As Oliver.REST.MoneyResponse) As %Status
{
   
   try {
      // Prepare and log the call
      // Append the city to the URL configured for adapter
      Set tURL=..Adapter.URL_"?q="_pRequest.City_"&units=imperial"
      
      // Execute the call
      Set tSC=..Adapter.PostURL(tURL,.tHttpResponse)
      
      // Return the response
      If $$$ISERR(tSC)&&$IsObject(tHttpResponse)&&$IsObject(tHttpResponse.Data)&&tHttpResponse.Data.Size {
         Set tSC=$$$ERROR($$$EnsErrGeneral,$$$StatusDisplayString(tSC)_":"_tHttpResponse.Data.Read())
      }
      Quit:$$$ISERR(tSC)
      If $IsObject(tHttpResponse) {
         // Instantiate the response object
         set pResponse = ##class(Oliver.REST.MoneyResponse).%New()
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
       }
   }catch{
       Set tSC=$$$SystemError
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
