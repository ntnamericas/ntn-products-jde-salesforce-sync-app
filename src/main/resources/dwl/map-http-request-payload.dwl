%dw 2.0
output application/json
---
vars.createData map (item, index) -> (
{
  	IsActive: item.IsActive,
  	//ProductCode : item.ProductCode,
  	CurrencyIsoCode : item.CurrencyIsoCode,
  	//Name : item.Name,
  	Product2Id : vars.product2id.Product2Id[index],
  	PriceBookId: payload,
  	UnitPrice : 0 
})