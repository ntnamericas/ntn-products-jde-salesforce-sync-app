%dw 2.0
output application/json
---
if (payload.successful == true) {Successful : payload.successful}
else (payload.items map() -> {
	"MessageSender": "Update Products Failed",
	failedId: $.id,
	message: $.message,
	External_ID__c: vars.testVar.Create.External_ID__c,
	payload: vars.testVar.Update
	
})