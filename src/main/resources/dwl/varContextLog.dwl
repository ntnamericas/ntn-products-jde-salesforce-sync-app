%dw 2.0
output application/json
---
vars.metadata map ((item, index) -> 
{   
    ContextLogger: "This is the first logger after data is fetched from Products DB",
    IMDRAW : item.IMDRAW  default  null,
    IMSRTX: item.IMSRTX default  null,
    IMLITM: item.IMLITM default  null,
    IBLITM: item.IBLITM default  null,
    drawExternalIDLanded : item.drawExternalIDLanded default  null,
    srtxExternalIDLanded : item.srtxExternalIDLanded default  null
} )