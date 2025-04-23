%dw 2.0
output application/csv header=true
---
(payload map (item, index) -> {
    Block_Code_Description: item.a.Block_Code_Description__c,
    Brand: item.a.Brand__c,
    Detailed_Product_Type: item.a.Detailed_Product_Type__c,
    Detail_Product_Code: item.a.Detail_Product_Code__c,
    General_Product_Code: item.a.General_Product_Code__c,
    General_Product_Description: item.a.General_Product_Description__c,
    Industry_P_N: item.a.Industry_P_N__c,
    Part_Number_Type: item.a.Part_Number_Type__c,
    Source: item.a.Source__c,
    Stocking_Type_Code: item.a.Stocking_Type_Code__c,
    NTN_Company_Number: item.a.NTN_Company_Number__c,
    IsActive: item.a.IsActive,
    CurrencyIsoCode: item.a.CurrencyIsoCode,
    CPA_Detail_Classification: item.a.CPA_Detail_Classification__c,
    CPA_MCA_Detail_Type_Code: item.a.CPA_MCA_Detail_Type_Code__c,
    CPA_MCA_Detail_Type_Desc: item.a.CPA_MCA_Detail_Type_Desc__c,
    External_ID__c: payload.External_ID__c[index]
})