%dw 2.0
output application/json
---
payload map {
    drawExternalID: if ((trim($.IMDRAW_COLITM) != "") and (trim($.IMDRAW_COLITM) != null) 
    	and trim($.IBPRP1_COLITM != "") and trim($.IBPRP1_COLITM != null) and trim($.IBSRP4_COLITM != "")
    	and trim($.IBSRP4_COLITM != null)) 
    	( trim($.IMDRAW_COLITM) ++ "-" ++ trim($.IBPRP1_COLITM) ++ "-" ++ trim($.IBSRP4_COLITM)) else "",
    srtxExternalID:if ((trim($.IMSRTX_COLITM) != null) and (trim($.IMSRTX_COLITM) != "")) 
    	(trim($.IMSRTX_COLITM) ++ "-NTN-NBCC") else ""
} distinctBy $
