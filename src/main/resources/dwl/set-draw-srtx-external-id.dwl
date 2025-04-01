%dw 2.0
output application/json
---
if(vars.exId == "drawExternalIDLanded")
    {"a":payload - "srtxExternalIDLanded" - "drawExternalIDLanded",
    	"External_ID__c": payload."drawExternalIDLanded"
    }
 else
    {"a":payload - "srtxExternalIDLanded" - "drawExternalIDLanded",
    	"External_ID__c":payload."srtxExternalIDLanded"
    }