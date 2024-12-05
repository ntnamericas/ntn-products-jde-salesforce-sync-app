%dw 2.0
output application/json
---
payload map {
    drawExternalID: if ((trim($.IMDRAW_IBLTV) != "") and (trim($.IMDRAW_IBLTV) != null) 
    	and (trim($.IBPRP1_IBLTV) != "") and (trim($.IBPRP1_IBLTV) != null) 
    	and (trim($.IBSRP4_IBLTV) != "") and (trim($.IBSRP4_IBLTV) != null)) 
    	( trim($.IMDRAW_IBLTV) ++ "-" ++ trim($.IBPRP1_IBLTV) ++ "-" ++ 
    		trim($.IBSRP4_IBLTV)
    	) else "",
    srtxExternalID:if (( trim($.IMSRTX_IBLTV) != "") and ( trim($.IMSRTX_IBLTV) != null))
         (trim($.IMSRTX_IBLTV) ++ "-NTN-NTN") else ""
} distinctBy $