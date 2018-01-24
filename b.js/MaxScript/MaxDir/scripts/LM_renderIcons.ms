-- render 3 icon sizes using Template_Icon max file
--sizePx = 80 --render width
namePref = maxFilePath  + "_" --+ "icon_"

sizePx = 32
sizePxStr = sizePx as string
render camera:$Camera_Icon outputFile:(namePref + sizePxStr + "x" + sizePxStr + ".png") outputwidth:sizePx outputheight:sizePx pixelaspect:1 progressbar:true vfb:on
sizePx = 64
sizePxStr = sizePx as string
render camera:$Camera_Icon outputFile:(namePref + sizePxStr + "x" + sizePxStr + ".png") outputwidth:sizePx outputheight:sizePx pixelaspect:1 progressbar:true vfb:on
sizePx = 80
sizePxStr = sizePx as string
render camera:$Camera_Icon outputFile:(namePref + sizePxStr + "x" + sizePxStr + ".png") outputwidth:sizePx outputheight:sizePx pixelaspect:1 progressbar:true vfb:on

