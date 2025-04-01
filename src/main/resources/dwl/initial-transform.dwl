%dw 2.0
import * from dw::core::Strings 
output application/json

// Function to convert Julian date to standard date format
fun julianToStandard(julianDate : Number) = do {
    var myDate = if (sizeOf(julianDate splitBy '') > 5) {
        date : leftPad(julianDate, 6, 0),
        day : leftPad(julianDate, 6, 0)[3 to -1],
        year : 1900 + leftPad(julianDate, 6, 0)[0 to 2]
    }
    else if (!isEmpty(julianDate) and !(julianDate ~= 0) and sizeOf(julianDate splitBy '') > 4) {
        date : julianDate,
        day : julianDate[2 to -1],
        year : 1900 + julianDate[0 to 1]
    }
    else if (!isEmpty(julianDate) and !(julianDate ~= 0) and sizeOf(julianDate splitBy '') > 3) {
        date : julianDate,
        day : julianDate[1 to -1],
        year : 1900 + (julianDate[0] default 0)
    }
    else if (!isEmpty(julianDate) and !(julianDate ~= 0) and sizeOf(julianDate splitBy '') >= 1) {
        date : julianDate,
        day : julianDate[0 to -1],
        year : 1900
    }
    else 0
  ---
  if (myDate ~= 0)
    0
  else
    ((("0101" ++ myDate.year) as Date {format: "ddMMyyyy"}) + ("P$(myDate.day - 1)D" as Period)) as Date {format: "yyyy-MM-dd"}
}

fun concatKeyValue(DRKY, DRDL01, pvalue) =
  (if (!isEmpty(DRKY))
  [trim(DRKY),trim(DRDL01)] filter (!isEmpty($)) joinBy  "-"
  else
    pvalue)
---
payload map (item, index) -> (do {
    var recordType = if (trim(item.ABSIC) ~= "NBCC" and trim(item.ABAT1) ~= "C")
      {
        "RecordTypeId": "012f4000000MFV5AAO",
        "Is_Account_Activated__c": true,
        "Status__c": 'Active',
        "Type": 'Customer',
        "Address_Type__c": 'C-Customer',
        "Integration_Complete__c": true
      }
    else if (trim(item.ABSIC) ~= "NBCC" and trim(item.ABAT1) ~= "CX")
      {
        "RecordTypeId": "012f4000000MFV5AAO",
        "Is_Account_Activated__c": false,
        "Status__c": 'Inactive',
        "Type": 'Customer',
        "Address_Type__c": 'CX-Inactive Customer',
        "Integration_Complete__c": true
      }
    else if (trim(item.ABSIC) ~= "NBCC" and trim(item.ABAT1) ~= "EU")
      {
        "RecordTypeId": "012f4000000d9wxAAA",
        "Is_Account_Activated__c": true,
        "Status__c": 'Active',
        "Type": 'End User',
        "Address_Type__c": 'EU-End User',
        "Integration_Complete__c": true
      }
    else if (trim(item.ABSIC) ~= "NBCC" and trim(item.ABAT1) ~= "EUX")
      {
        "RecordTypeId": "012f4000000d9wxAAA",
        "Is_Account_Activated__c": false,
        "Status__c": 'Inactive',
        "Type": 'End User',
        "Address_Type__c": 'EUX-Inactive End User',
        "Integration_Complete__c": true      }
    else
      null
    ---
    {
      "X1st_Address_Number__c": item.ABAN81,
      "X2nd_Address_Number__c": item.ABAN82,
      "X3rd_Party_Billing__c": item.ABAN83,
      "Name": trim(item.ABALPH),
      "AccountNumber": item.ABAN8,
      "RecordType": recordType,
      "Address_Type__c": concatKeyValue(item.BILLINGADDRESSTYPEDRKY, item.BILLINGADDRESSTYPEDRDL01, trim(item.ABAT1)),
      "Alpha_Name__c": trim(item.ABALPH),
      "Bill_To_Number__c": item.ABAN81,
 "Customer_Service_Coordinator_Code__c": concatKeyValue(item.COORDINATORCODEDRKY, item.COORDINATORCODEDRDL01, trim(item.ABAC05)),
    "DunsNumber": trim(item.ABDUNS),
    "Effective_Date__c": julianToStandard(item.ABEFTB) default "",
      "NumberOfEmployees": item.ABNOE,
      "Growth_Rate__c": item.ABGROWTHR,
      "JDE_AddressNumber__c": ((item.ABAN8 as Number) + 90000000),
      "Long_Address_Number__c": trim(item.ABALKY),
      "NBCA_Market__c": concatKeyValue(item.NBCAMARKETDRKY, item.NBCAMARKETDRDL01, trim(item.ABAC08)),
      "NBCA_MKT_DES__c": concatKeyValue(item.NBCAMKTDESDRKY, item.NBCAMKTDESDRDL01, trim(item.ABAC08)),
      "NTN_ADV_PRC_GRP__c": if (!isEmpty(item.NTNADVPRCGRPDRDL01) and !isEmpty(item.NTNADVPRCGRPDRKY))
          trim(item.NTNADVPRCGRPDRKY) default "" ++ "-" ++ trim(item.NTNADVPRCGRPDRDL01) default ""
        else
          "",
       "NTN_Company_Name__c": trim(item.ABSIC),
      "NTN_Cust_Type__c": concatKeyValue(item.NTNCUSTTYPEDRKY, item.NTNCUSTTYPEDRDL01, trim(item.ABAC08)),
      "NTN_Customer_Group__c": concatKeyValue(item.NTNCUSTOMERGROUPDRKY, item.NTNCUSTOMERGROUPDRDL01, trim(item.ABAC10)),
      "NTN_Global_Market__c": concatKeyValue(item.NTNGLOBALMARKETDRKY, item.NTNGLOBALMARKETDRDL01, trim(item.ABAC12)),
      "NTN_Market_Code__c": concatKeyValue(item.NBCAMKTDESDRKY, item.NBCAMKTDESDRDL01, trim(item.ABAC08)),
      "Region__c": concatKeyValue(item.REGIONDRKY, item.REGIONDRDL01, trim(item.ABAC02)),
      "Rep_Code__c": concatKeyValue(item.REPCODEDRKY, item.REPCODEDRDL01, trim(item.ABAC04)),
      "Sic": trim(item.ABSIC),
      "SicDesc": trim(item.SicDesc),
      "YearStarted": trim(item.ABYEARSTAR),
      "Mailing_Name__c": trim(item.MAILINGNAME),
      "Bill_To_Fax__c": if(!isEmpty(item.BILLFAXWPAR1) and !isEmpty(item.BILLFAXWPPH1))["(", trim(item.BILLFAXWPAR1), ")", " ", trim(item.BILLFAXWPPH1)] joinBy "" else "",
      "Bill_To_Phone__c":if(!isEmpty(item.BILLPHONEWPAR1) and !isEmpty(item.BILLPHONEWPPH1))["(", trim(item.BILLPHONEWPAR1), ")", " ", trim(item.BILLPHONEWPPH1)] joinBy "" else "",

      "Fax": if(!isEmpty(item.BILLFAXABAN8WPAR1) and !isEmpty(item.BILLFAXABAN8WPPH1)) ["(", trim(item.BILLFAXABAN8WPAR1), ")", " ", trim(item.BILLFAXABAN8WPPH1)] joinBy "" else "",
      "Phone": if(!isEmpty(item.PHONEWPAR1) and !isEmpty(item.PHONEWPPH1)) ["(", trim(item.PHONEWPAR1), ")", " ", trim(item.PHONEWPPH1)] joinBy "" else "",
      "Website": trim(item.WEBSITEEAEMAL),
      "BillingAddress": {
        "BillingStreet": trim([
          trim(item.BILLINGADDRESSALADD1) ++ " \n " default "",
          trim(item.BILLINGADDRESSALADD2) ++ " \n " default "",
          trim(item.BILLINGADDRESSALADD3) ++ " \n " default "",
          trim(item.BILLINGADDRESSALADD4)
        ] filter (!isEmpty($)) joinBy ""),
        "BillingCity": trim(item.BILLINGADDRESSALCTY1),
        "BillingStateCode": trim(item.BILLINGADDRESSALADDS),
        "BillingPostalCode": trim(item.BILLINGADDRESSALADDZ),
        "BillingCountryCode":  trim(item.BILLINGCOUNTRYCODEVALUE),
      },
      "ShippingAddress": {
        "ShippingStreet": trim([
          trim(item.SHIPPINGADDRESSALADD1)  ++ " \n " default "",
          trim(item.SHIPPINGADDRESSALADD2) ++ " \n " default "",
          trim(item.SHIPPINGADDRESSALADD3) ++ " \n " default "",
          trim(item.SHIPPINGADDRESSALADD4)
        ] filter (!isEmpty($)) joinBy ""),
        "ShippingCity": trim(item.SHIPPINGADDRESSALCTY1),
        "ShippingStateCode": trim(item.SHIPPINGADDRESSALADDS),
        "ShippingPostalCode": trim(item.SHIPPINGADDRESSALADDZ),
        "ShippingCountryCode": trim(item.SHIPPINGCOUNTRYCODEVALUE),
      },
      ("Parent": trim(item.PARENTAXDC)) if (!isEmpty(item.PARENTAXDC)),
      "Parent_Number__c": trim(item.ABAN86),
      "CurrencyIsoCode": item.CURRENCYISOCODEAICRCD,
      "Billing_Address_Type__c": 
        if (!isEmpty(item.BILLINGADDRESSTYPEDRDL01) and !isEmpty(item.BILLINGADDRESSTYPEDRKY))
          trim(item.BILLINGADDRESSTYPEDRKY) default "" ++ "-" ++ trim(item.BILLINGADDRESSTYPEDRDL01) default ""
        else
          "",
      "Credit_Limit__c": 
        if (!isEmpty(item.F03012TABLEAIACL))
          trim(item.F03012TABLEAIACL)
        else
          "",
      "Credit_Manager__c": concatKeyValue(item.CREDITMANAGERDRKY, item.CREDITMANAGERDRDL01, trim(item.F03012TABLEAICMGR)),
      "Customer_Price_Group_40PC__c": concatKeyValue(item.CUSTOMERPRICEGROUPDRKY, item.CUSTOMERPRICEGROUPDRDL01, trim(item.F03012TABLEAICPGP)),
      "Date_Account_Opened__c":  // Convert date to julian format,
        if (!isEmpty(item.F03012TABLEAIDAOJ))
          julianToStandard(trim(item.F03012TABLEAIDAOJ))
        else
          "",
      "Date_Of_Last_Credit_Review__c":  // Convert date to julian format,
        if (!isEmpty(item.F03012TABLEAIDLC))
          julianToStandard(trim(item.F03012TABLEAIDLC))
        else
          "",
      "Dun_Bradstreet_Rating__c": concatKeyValue(item.DUNBRADSTREETDRKY, item.DUNBRADSTREETDRDL01, trim(item.F03012TABLEAIDB)),
      "Factor_Special_Payee__c": 
        if (!isEmpty(item.F03012TABLEAIARPY))
          trim(item.F03012TABLEAIARPY)
        else
          "",
      "Hold_Orders_Code__c":  concatKeyValue(item.HOLDORDERSDRKY, item.HOLDORDERSDRDL01, trim(item.F03012TABLEAIHOLD)),
    
      "Payment_Terms_A_R__c": concatKeyValue(item.PAYMENTPNPTC, item.PAYMENTPNPTD, trim(item.F03012TABLEAITRAR)),
      "Print_Message__c": concatKeyValue(item.PRINTMESSAGEDRKY, item.PRINTMESSAGEDRDL01, trim(item.F03012TABLEAIINMG)),
      "Temporary_Credit_Message__c": concatKeyValue(item.TEMPORARYCREDITMESSAGEDRKY, item.TEMPORARYCREDITMESSAGEDRDL01, trim(item.F03012TABLEAITSTA)),
      "Branch_Code__c": trim(item.BRANCHCODEAXEXRA),
      "Owner": trim(item.OWNERCUALPH3),
      "Account_Coordinator__c": trim(item.ACCOUNTCOORDINATORCUALPH3),
      "Engineer__c": concatKeyValue(item.ENGINEERDRKY, item.ENGINEERDRDL01, trim(item.F03012TABLEAIAC06)),
      ("Bill_To_Account__c": trim(item.BILLACCOUNT)) if (!isEmpty(trim(item.BILLACCOUNT))),
      "Account_Engineer__c": trim(item.accountEngineer),
      "Account_Marketing_Rep__c": trim(item.ACCOUNTMARKETINGREP),
      "MKT_REP__c": concatKeyValue(item.MKTREPDRKY, item.MKTREPDRDL01, trim(item.F03012TABLEAIAC05)),
      "NTN_Company_Number__c": 
        if (trim(item.ABSIC) ~= "NBCC")
          "00010"
        else
          "00001"
    }
  })