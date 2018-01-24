
-- Nitro functions and setup
-- This file should be placed in /stdplugs/stdscripts to be made available to other macroscripts
-- JVla

--Get all objects	
	function GetNodeMaterials nodes:$objects=
		(
			for obj in nodes where (obj.material != undefined ) collect obj.material				
		)			
		
--Get all materials
		function RefreshMapDisplay mats=
		(
			for mat in mats where mat.showInViewport == true do
			(
				mat.showinviewport=mapDisplay=false
				mat.showinviewport=mapDisplay=true
			)
		)

-- set small Nitro bitmap size
function NitroSmall =(
	NitrousGraphicsManager.SetTextureSizeLimit 256 true
freeSceneBitmaps() 
RefreshMapDisplay (GetNodeMaterials())
	)		

-- set large Nitro bitmap size
	function NitroLarge =(
	NitrousGraphicsManager.SetTextureSizeLimit 2048 true
freeSceneBitmaps() 
RefreshMapDisplay (GetNodeMaterials())
	)		

--	NitroSmall() --set texture size to 256
--	NitroLarge() --set texture size to 2048




	
	
