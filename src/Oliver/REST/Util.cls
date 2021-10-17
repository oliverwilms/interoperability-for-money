Class Oliver.REST.Util
{

Parameter DEBUG = 1;

/*

Property Date As %String [ SqlColumnNumber = 2 ];

Property Check As %String [ SqlColumnNumber = 3 ];

Property Merchant As %String [ SqlColumnNumber = 4 ];

Property Category As %String [ SqlColumnNumber = 5 ];

Property SubCategory As %String [ SqlColumnNumber = 6 ];

Property Memo As %String [ SqlColumnNumber = 7 ];

Property Credit As %String [ SqlColumnNumber = 8 ];

Property Debit As %String [ SqlColumnNumber = 9 ];

Property BillPay As %String [ SqlColumnNumber = 10 ];

Property DebitCard As %String [ SqlColumnNumber = 11 ];

Property Account As %String [ SqlColumnNumber = 12 ];

Property Balance As %String [ SqlColumnNumber = 13 ];

Property Status As %String [ SqlColumnNumber = 14 ];
*/
ClassMethod QuotedValue(
	pValue As %String = "",
	pQuote As %String = "'") As %String
{
	Quit pQuote_pValue_pQuote
}

/// Insert into Riches.Transact (Account,TranDate,Merchant,Category,AmountDebit,AmountCredit)
/// values ('Chase Better Banking Checking','1-3-2021','Aldi','Groceries','51.41','')
ClassMethod RecordToQuery(pRecord As EnsLib.RecordMap.Base) As %String
{
	Set tAccount = ""
	Set tAmountCredit = ""
	Set tAmountDebit = ""
	Set tCategory = ""
	Set tMerchant = ""
	Set tTranDate = ""
	Try { Set tAccount = pRecord.Account } Catch { }
	Try { Set tAmountCredit = pRecord.Credit } Catch { }
	Try { Set tAmountDebit = pRecord.Debit } Catch { }
	Try { Set tCategory = pRecord.Category } Catch { }
	Try { Set tMerchant = pRecord.Merchant } Catch { }
	Try { Set tTranDate = pRecord.Date } Catch { }
	Set comma = ","
	Set tQuery = "Insert into Riches.Transact "
	Set tQuery = tQuery_"(Account,TranDate,Merchant,Category,AmountDebit,AmountCredit) "
	Set tQuery = tQuery_"values ("
	Set tQuery = tQuery_..QuotedValue(tAccount)_comma
	Set tQuery = tQuery_..QuotedValue(tTranDate)_comma
	Set tQuery = tQuery_..QuotedValue(tMerchant)_comma
	Set tQuery = tQuery_..QuotedValue(tCategory)_comma
	Set tQuery = tQuery_..QuotedValue(tAmountDebit)_comma
	Set tQuery = tQuery_..QuotedValue(tAmountCredit)
	Set tQuery = tQuery_")"
	Set tQuery = $Translate(tQuery,"/","-")  // Slashes in date caused 404 Not Found
	Quit tQuery
}

}
