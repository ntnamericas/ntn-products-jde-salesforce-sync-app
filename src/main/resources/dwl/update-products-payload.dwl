%dw 2.0
output application/json
---
{
    "data": (payload ++ {"id":vars.SFExtId[0].Id}
    	//((payload - "Part_Number_Type__c") ++{"Part_Number_Type__c": if (payload."External_ID__c" contains "-NBCC") "Industry" else "Base"}
    
),
"operation": "Update"
}