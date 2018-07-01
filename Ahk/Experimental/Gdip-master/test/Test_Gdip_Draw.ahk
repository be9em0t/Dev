#SingleInstance, Force
#NoEnv
SetBatchLines, -1

#Include, d:\Work\OneDrive\Dev\Ahk\Experimental\Gdip-master\test\Gdip_All.ahk
#Include, d:\Work\OneDrive\Dev\Ahk\Experimental\Gdip-master\test\GDIpHelper.ahk

SetUpGDIP()

StartDrawGDIP()
ClearDrawGDIP()

Gdip_SetSmoothingMode(G,4)
imageFile := "d:\Work\OneDrive\Dev\Ahk\Experimental\Gdip-master\test\alpha.png"

pBrush := Gdip_BrushCreateSolid(0xffff0000)
Gdip_FillEllipse(G, pBrush, 205, 5, 200, 100)
Gdip_DeleteBrush(pBrush)

pBitmap := Gdip_CreateBitmapFromFile(imageFile)                 
W:= Gdip_GetImageWidth( pBitmap ), H:= Gdip_GetImageHeight( pBitmap )   
Gdip_DrawImage(G, pBitmap, 5, 5, W, H)
Gdip_DisposeImage( pBitmap )


EndDrawGDIP()
return

^q::ExitApp