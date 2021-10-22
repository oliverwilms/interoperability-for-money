Class Oliver.CSVRecordWizard Extends EnsPortal.CSVRecordWizard
{

/// pCharEncoding = "unicodefeff"  --> "UnicodeBig": $char(254,255)
ClassMethod DetectBOM(pFilename As %String) As %String
{
	Try {
		Set tReadStr = ""
		Set tStatus = $$$OK
		Set tIO = ##class(%IO.FileStream).%New()
		Do tIO.Open(pFilename, "R",,"RAW",.tStatus)
		If $$$ISERR(tStatus) Quit
		For {
			Set tReadStr = tIO.Read(2,,.tStatus)
			If (tReadStr = $CHAR(254,255)) Set tCharEncoding = "unicodefeff"
			If (tReadStr = $CHAR(255,254)) Set tCharEncoding = "@UnicodeLittle"
			Quit
		}
	}
	Catch ex {
		Set tStatus = ex.AsStatus()
	}
	Quit $Get(tCharEncoding)
}

/// Record Terminator - CRLF, CR, LF
ClassMethod DetectRecTerm(pFilename As %String) As %String
{
	Try {
		Set tReadStr = ""
		Set tRecTerm = ""
		Set tStatus = $$$OK
		Set tIO = ##class(%IO.FileStream).%New()
		Do tIO.Open(pFilename, "R",,"RAW",.tStatus)
		If $$$ISERR(tStatus) Quit
		For {
			Set tReadStr = tIO.Read(1,,.tStatus)
			If $$$ISERR(tStatus) Quit
			If ($ASCII(tReadStr) '= 10),($ASCII(tReadStr) '= 13) {
				If (tRecTerm '= "") Quit
				Continue
			}
			Set tRecTerm = tRecTerm _ tReadStr
		}
	}
	Catch ex {
		Set tStatus = ex.AsStatus()
	}
	Quit $Get(tRecTerm)
}

/// Quoted header records did not process before code change on 10/3/2021 - OTW 
ClassMethod ProcessCSVFile(
	pFilename As %String,
	pRecordMapName As %String,
	pSep As %String = ",",
	pQuoteChar As %String = """",
	pHasHeaderRow As %Boolean = 0,
	pRecTerm As %String = "\x0d\x0a",
	pCharEncoding As %String = "UTF-8",
	pKeepSQLCols As %Boolean = 1) As %String [ Internal, ZenMethod ]
{
	New %recTerm,%sep,%quoteChar
	Try {
		Set tStatus = $$$OK
		
		If '($system.Security.Check("%Ens_Code","WRITE") || $system.Security.Check("%Ens_RecordMap","WRITE")) {
			Set tStatus = $$$ERROR($$$InsufficientPrivilegeForOperation)
			Quit
		}
		
		Set tIO = ##class(%IO.FileStream).%New()
		
		// Make sure we check for a BOM
		Set tEncodingTable = tIO.GetCharEncodingTable(pCharEncoding)
		Set tCheckBOM = $case(tEncodingTable, "Unicode": 1, "UnicodeLittle": 1, "UnicodeBig": 1, "UTF8": 1, : 0)
		If tCheckBOM {
			Set tReadBOM = 0
			Do tIO.Open(pFilename, "R",,"RAW",.tStatus)
			If $$$ISERR(tStatus) Quit
			Set tTestBOM = tIO.Read(2,,.tStatus)
			If $$$ISERR(tStatus) Quit
			If tTestBOM = $char(239,187) {
				Set tTestBOM = tTestBOM _ tIO.Read(1,,.tStatus)
				If $$$ISERR(tStatus) Quit
			}
			Set tExpectedBOM = $case(tEncodingTable, "Unicode": $char(255,254), "UnicodeLittle": $char(255,254), "UnicodeBig": $char(254,255), "UTF8": $char(239,187,191), : "")
			If (tTestBOM '= "") && (tTestBOM = tExpectedBOM) {
				Set tReadBOM = 1
			}
			Do tIO.Rewind(.tStatus)
			If $$$ISERR(tStatus) Quit
			
			Set tStatus = tIO.CharEncodingSet(pCharEncoding)
			If $$$ISERR(tStatus) Quit
			If tReadBOM Do tIO.Read(1,,.tStatus)
			If $$$ISERR(tStatus) Quit
		}
		Else {
			Do tIO.Open(pFilename, "R",,pCharEncoding,.tStatus)
			If $$$ISERR(tStatus) Quit
		}
		
		Set tCount = 0
	
		Set tRecTerm = ##class(EnsLib.RecordMap.Generator).getLogicalChars(pRecTerm)
		Set tGetTerm = "Set %recTerm = "_tRecTerm
		Xecute tGetTerm
		Set tRecTerm = %recTerm
	
		If (pQuoteChar '= "") {
			Set tQuoteChar = ##class(EnsLib.RecordMap.Generator).getLogicalChars(pQuoteChar)
			Set tGetQuote = "Set %quoteChar = "_tQuoteChar
			Xecute tGetQuote
		}
		Else { Set %quoteChar = "" }
	
		Set tSep = ##class(EnsLib.RecordMap.Generator).getLogicalChars(pSep)
		Set tGetSep = "Set %sep = "_tSep
		Xecute tGetSep
		
		Set tStatus = ##class(EnsLib.RecordMap.RecordMap).chunkRecord(tIO, .tRecData,,,,.tRecTerm,,, %quoteChar)
		If $$$ISERR(tStatus) Quit
		ZW tRecData
	
		Set tRecordMap = ##class(EnsLib.RecordMap.Model.Record).%New()
		Set tRecordMap.name = $$$NormalizeClassname(pRecordMapName)
		Set tRecordMap.targetClassname = $$$NormalizeClassname(pRecordMapName) _ ".Record"
		Set tRecordMap.charEncoding = pCharEncoding
		If pQuoteChar '= "" {
			Set tRecordMap.escaping = "quote"
			Set tRecordMap.escapeSequence = pQuoteChar
		}
		Set tRecordMap.recordTerminator = pRecTerm
		Set tRecordMap.type = "delimited"
		Do tRecordMap.Separators.Insert(pSep)
		// name and target name
	
		Set tCurrChunk = 1
		Set tCurrPiece = 1
		Set tCurrString = $select($data(tRecData(tCurrChunk,"block")): tRecData(tCurrChunk), 1: $piece(tRecData(tCurrChunk), %sep, tCurrPiece))
		
		While tCurrChunk {
			Set tCount = tCount + 1
		
			Set tField = ##class(EnsLib.RecordMap.Model.Field).%New()
			Set tField.datatype = "%String"
			Set tField.name = $select(pHasHeaderRow: $zstrip(tCurrString, "*WP"), 1: "Property"_tCount)
			If pKeepSQLCols { // Column numbers start at 2
				Set tField.sqlColumn = tCount+1
			}
			Do tRecordMap.Contents.Insert(tField)
			Do ##class(EnsLib.RecordMap.RecordMap).checkMerge(.tCurrChunk, .tRecData, .tCurrString, %sep, .tCurrPiece, "block")
			If tCurrChunk > tRecData Quit
			If (tCurrChunk = tRecData),$Data(tRecData(tCurrChunk,"block")),(tCurrPiece > 1) { Quit }  // OTW -10/3/2021
			Set tCurrString = $select($data(tRecData(tCurrChunk,"block")): tRecData(tCurrChunk), 1: $piece(tRecData(tCurrChunk), %sep, tCurrPiece))
			If (tCurrString = "") && (tCurrChunk = tRecData) && ($length(tRecData(tCurrChunk), %sep) < tCurrPiece) Quit
		}
	
		Set tStatus = tRecordMap.SaveToClass()
		If $$$ISERR(tStatus) Quit
	}
	Catch ex {
		ZWRITE
		Set tStatus = ex.AsStatus()
	}
	If $$$ISERR(tStatus) {
		Quit $System.Status.GetErrorText(tStatus)
	}
	Quit ""
}

/// pHasHeaderRow defaults to 1 - Oliver Wilms
ClassMethod Test(
	pFilename As %String,
	pRecordMapName As %String,
	pSep As %String = ",",
	pQuoteChar As %String = """",
	pHasHeaderRow As %Boolean = 1,
	pRecTerm As %String = "\x0d\x0a",
	pCharEncoding As %String = "UTF-8",
	pKeepSQLCols As %Boolean = 1) As %String
{
	If ($Get(pFilename) = "") Set pFilename = "/opt/irisapp/iris-for-money-25-Sep-2021 22-26.csv"
	If ($Get(pRecordMapName) = "") Set pRecordMapName = "Oliver.Riches"
	Set tCharEncoding = ..DetectBOM(pFilename)
	If (tCharEncoding '= "") Set pCharEncoding = tCharEncoding
	If (tCharEncoding = "") Set pCharEncoding = "@RAW"
	Set tRecTerm = ..DetectRecTerm(pFilename)
	If (tRecTerm = $CHAR(10)) Set pRecTerm = "\x0a"
	If (tRecTerm = $CHAR(13)) Set pRecTerm = "\x0d"
	If (tRecTerm = $CHAR(13,10)) Set pRecTerm = "\x0d\x0a"
	Set tString = ..ProcessCSVFile(pFilename,pRecordMapName,pSep,pQuoteChar,pHasHeaderRow,pRecTerm,pCharEncoding,pKeepSQLCols)
	Write tString,!
	Quit tString
}

}
