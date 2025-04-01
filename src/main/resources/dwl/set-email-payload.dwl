%dw 2.0
output application/csv header=true
---

if(payload.Status != null and payload.Status != [])(
  if (payload.Status[0]."Status Code" == "REQUIRED_FIELD_MISSING") [] else
(flatten(
    payload.Status map ((statusItem) -> 
    statusItem.payload map ((item) -> item ) 
)))) else [] 