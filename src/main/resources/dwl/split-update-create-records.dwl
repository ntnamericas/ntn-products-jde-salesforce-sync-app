%dw 2.0
output application/json  skipNullOn="everywhere"
---
{"Update" : payload.operation map ((item, index) -> if(item == "Update")
payload.data[index]
else null),
"Create" : payload.operation map ((item, index) -> if(item == "Create")
payload.data[index]
else null),
"noOperation": payload.External_ID__c map((item, index) -> if(isEmpty(item))
payload.a[index]
else null)
}
 