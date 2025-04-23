%dw 2.0
output application/json
---
{
    "data":((payload.a - "Part_Number_Type__c") ++{"Part_Number_Type__c": if (payload."External_ID__c" contains "-NBCC") "Industry" else "Base"}
    ++ {"id":vars.SFExtId[0].Id, "External_ID__c": payload.External_ID__c}
),
"operation": "Update"
}