%dw 2.0
output application/json
---
(vars.productMaster map (item, index) -> (
{
        drawExternalIDLanded:
        if (
            item.IMDRAW != null and trim(item.IMDRAW) != "" and
            item.IBPRP1 != null and trim(item.IBPRP1) != "" and
            item.IBSRP4 != null and trim(item.IBSRP4) != ""
        )
        (
            trim(item.IMDRAW) ++ "-" ++ trim(item.IBPRP1) ++ "-" ++ trim(item.IBSRP4)
        )
        else "" ,
 
 
    srtxExternalIDLanded:
        if (item.IMSRTX != null and trim(item.IMSRTX) != "")
            (
                if (["1801", "1802"] contains trim(item.IBMCU))
                    trim(item.IMSRTX) ++ "-NTN-NBCC"
                else
                    trim(item.IMSRTX) ++ "-NTN-NTN"
            )
        else "",

    Block_Code__c : trim(item.IBPRP4),
    Block_Code_Description__c : trim(item.DRDL01_IBPRP4),
    Brand__c : trim(item.IBSRP4),
    Detailed_Product_Type__c : trim(item.DRKY_SRP2) ++ "-" ++ trim(item.DRDL01_SRP2),
    Detail_Product_Code__c : trim(item.IBSRP2),
    Detail_Product_Description__c : trim(item.DRKY_SRP2) ++ "-" ++ trim(item.DRDL01_SRP2),
    General_Product_Code__c : trim(item.DRKY_SRP1) ++ "-" ++ trim(item.DRDL01_SRP1),
    General_Product_Description__c : trim(item.DRDL01_SRP1),
    Family : if(trim(item.DRKY_SRP5) != "")((vars.excelData.Sheet1 filter ((sheetItem) -> sheetItem.SRP5 == trim(item.DRKY_SRP5)))[0].Product_Family__c)else "",
    Industry_P_N__c :  trim(item.IMSRTX),
    Japan_Plant_Block_Code__c:
    if (item.IBPRP7 != null and trim(item.IBPRP7) != "" and item.DRDL01_PRP8 != null and trim(item.DRDL01_PRP8) != "")
        trim(item.IBPRP7) ++ "-" ++ trim(item.DRDL01_PRP8)
    else "",
    Origin__c : trim(item.IBPRP1),
    Part_Number__c : trim(item.IMDRAW_IBLTLV),
    Part_Number_Type__c : if(trim(item.IMSRTX_IBLTLV) == trim(item.IMDRAW_IBLTLV)) "Industry" else "Base",
    Source__c : if (trim(item.IBMCU) == '1801' or trim(item.IBMCU) =='1802') "NBCC" else "NBCA",    
    Stocking_Type_Code__c : if(item.IBSTKT contains('O')) 'OBSOLETE'
        else if( (item.IBSTKT contains('P')) or (item.IBSTKT contains('M')) or
            (item.IBSTKT contains('D')) or (item.IBSTKT contains('Z'))
        ) 'ACTIVE' else '',
    //Update_Date__c : (now() >> "EST") as Date {format: "MM/dd/YYYY"},
    NTN_Company_Number__c : if (trim(item.IBMCU) == "1801" or trim(item.IBMCU) == "1802") "00010" else "00001",
    IsActive: if (["P", "M", "D", "Z", "U"] contains trim(item.IBSTKT)) true else false,
    ProductCode : if(trim(item.IMSRTX_IBLTLV) == trim(item.IMDRAW_IBLTLV)) trim(item.IMSRTX_IBLTLV) else trim(item.IMDRAW_IBLTLV),
    CurrencyIsoCode : if(["1801","1802"] contains (trim(item.IBMCU))) "CAD" else "USD",
    Name : if(trim(item.IMSRTX_IBLTLV) == trim(item.IMDRAW_IBLTLV)) trim(item.IMSRTX_IBLTLV) else trim(item.IMDRAW_IBLTLV),
    CPA_Detail_Classification__c:
    if (item.DRKY_SRP5 != null and trim(item.DRKY_SRP5) != "" and item.DRDL01_SRP5 != null and trim(item.DRDL01_SRP5) != "")
        (if (sizeOf(trim(item.DRKY_SRP5)) >= 2) trim(item.DRKY_SRP5)[1 to 2] else "") ++ "-" ++ trim(item.DRDL01_SRP5)
    else "",
    CPA_General_Classification__c :if(trim(item.DRKY_SRP5) != "")((vars.excelData.Sheet1 filter ((sheetItem) -> sheetItem.SRP5 == trim(item.DRKY_SRP5)))[0].CPA_General_Classification__c)else "" ,
    CPA_MCA_Detail_Type_Code__c : trim(item.DRKY_SRP5),
    CPA_MCA_Detail_Type_Desc__c : trim(item.DRKY_SRP5) ++ "-" ++ trim(item.DRDL01_SRP5),
    //CreatedDate : (now() >> "EST") as String { format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
}))  distinctBy $
 