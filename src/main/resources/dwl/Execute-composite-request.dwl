%dw 2.0
output application/json
---
{
  "compositeRequest": [

      {
        "method": "GET",
        "referenceId": "refPricebook11" as String,
        "url": "/services/data/v57.0/query/?q=SELECT id from Pricebook2 where JDE_Price_Book__c = '11'"
      },
	  {
        "method": "GET",
        "referenceId": "refPricebook3" as String,
        "url": "/services/data/v57.0/query/?q=SELECT id from Pricebook2 where JDE_Price_Book__c = '3'"
      },
	  {
        "method": "GET",
        "referenceId": "refPricebook4" as String,
        "url": "/services/data/v57.0/query/?q=SELECT id from Pricebook2 where JDE_Price_Book__c = '4'"
      }
      //,
	  //{
      //  "method": "GET",
      //  "referenceId": "refPricebook14" as String,
      //  "url": "/services/data/v57.0/query/?q=SELECT id from Pricebook2 where JDE_Price_Book__c = '14'"
      //},
      //{
      //  "method": "GET",
      //  "referenceId": "refPricebook15" as String,
      //  "url": "/services/data/v57.0/query/?q=SELECT id from Pricebook2 where JDE_Price_Book__c = '15'"
      //}
	  ]
	}