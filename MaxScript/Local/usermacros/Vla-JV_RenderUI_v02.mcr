macroScript JV_RenderUI_v02
category:"Vla"
	toolTip:"JV_RenderUI_v02.05"
	buttonText:"JV_RenderUI_v02"
	icon:#("jvRenderUI", 1)


( --macroscript bracket
	-- Added 320x480 render mode
	-- Updated quality settinngs
	-- help on naming: dir_sign03_0203 (mark the camers that hide this object)
	
	
	-- JV_RenderUI_v02
		-- INITIAL SETTINGS
			ShadowQ = 12 --skylight shadow quality
			ShortName = trimright maxFileName ".max" --filename without extension
			sceneName = maxFilePath + ShortName + "_LQ";  --filename prefix	
			linear_exposure = Linear_Exposure_Control();
			if lights.count > 1 then (messagebox  "ERROR: Too many lights, expected only 1 light.") --number of lights check 
			if IsValidNode $Sky01 == false  then (messageBox "ERROR: Light is not called Sky01") --light's name check
			camArray = #()
			camArraySel = #()
			camArraySelRender = #()
			camArrayAngles  = #()
			dirSignParseArray = #()
			dirSignArrayRaw = #()
			dirSignArray = #()
			rendArrowsOnly = false
			try(destroyDialog JV_renderDialog)catch()
			global FnBye
			global FnRenderSelection
			global FnRender
			global Fn_CameraAngles
			global Fn_CameraAngleCalc
			global Fn_HideDirSigns
			global Dialog_JV_camAnglesPos
			global Fn_hideDirSign
			global thisSign
			rollout JV_camAngles "JV_camAngles" ( )
			rollout JV_renderDialog "JV_renderDialog" ( )
			
				
select cameras; explodeGroup selection; --free cameras from their groups 
select cameras; deselect $*Target; 			
			camArrayRaw = getCurrentSelection()
			camcount = camArrayRaw.count 
			lbx1_height = (
				if camcount<22 then camcount+2 else 24
			)

function Fn_HideDirSigns =(
		select $dir_sign*
	dirSignArrayRaw = getCurrentSelection()

			for i=1 to dirSignArrayRaw.count do ( --loop 
				append dirSignArray (dirSignArrayRaw[i].name as string)
					--print (dirSignArrayRaw[i].name as string)
					)
				--dirSignArray = #{1..dirSignArray.count}
					
for thisSign in dirSignArray do (
	print thisSign 
	dirSignParseArray = #()
--start hide
		numbersOnly = substring thisSign 12 (thisSign.count-1)
	j = (numbersOnly.count)/2
	
    for i=1 to ((numbersOnly.count)/2) do (
		offCam = substring numbersOnly (i*2-1) 2
		--messagebox (offCam as string) beep:false
		append dirSignParseArray (offCam as string)
		--messagebox (dirSignParseArray[i] as string) beep:false
)

dirSignParseArray.count
dirSignParseArray[2]
camNumber as string
exist = findItem dirSignParseArray (camNumber as string)

If exist != 0 do (
	select (execute ("$" + thisSign)) 
	hide $
	)
--end hide	
)
)
			
function Fn_CameraAngles =(
	Fn_CameraAngleCalc()
	
	rollout JV_camAngles "JV_camAngles" width:189 --height:390
(
	button btn1_Refresh "Refresh" pos:[9,10] width:170 height:30
	ListBox lbx2_camAngles "Camera Angles:" pos:[9,50] width:170 height:lbx1_height items:camArrayAngles  
	on btn1_Refresh pressed do (Dialog_JV_camAnglesPos = GetDialogPos JV_camAngles; DestroyDialog JV_camAngles; Fn_CameraAngles()) -- call Camera Angles routine
	)
createdialog JV_camAngles pos:Dialog_JV_camAnglesPos
	)

function Fn_CameraAngleCalc = (
			camArrayAngles = #()
			for i=1 to camArray.count do ( --loop cameras
				delta = (execute ("$" + camArray[i] + ".pos")) - (execute ("$" + camArray[i] + ".Target.pos"))
				theAngleVert = acos(dot (normalize delta) (normalize z_axis))
				append camArrayAngles (camArray[i] + "   " + theAngleVert as string)								
					)
			)

function Fn_LQ_setup =(
			ShadowQ = 5 --skylight shadow quality
			ShortName = trimright maxFileName ".max" --filename without extension
			sceneName = maxFilePath + ShortName + "_LQ";  --filename prefix	
)

function Fn_HQ_setup =(
			ShadowQ = 12 --skylight shadow quality
			ShortName = trimright maxFileName ".max" --filename without extension
			sceneName = maxFilePath + ShortName + "_HQ";  --filename prefix	
)

function FnCameraList = (
			for i=1 to camArrayRaw.count do ( --loop cameras
				append camArray (camArrayRaw[i].name as string) 
					)
				sort camArray
				camArraySel = #{1..camArray.count}
			)

	
function FnRenderSelection = ( --- this will be an universal render routine
	camArraySelRender = #()
    for i in camArraySel do (
		append camArraySelRender (camArray[i] as string)
		)
		 FnRender()
	)		
	
function FnRender = (
	for i in camArraySelRender do ( -- repeat for every camera
		-- get the camera number (last two charcter in name)
			camNumber = substring i (i.count-1) -1
		-- hide non-render objects + elevated --
			unhide objects
			if IsValidNode $elevated == true  then 	(select $elevated; hide $) --hide Elevated if exist
			select $arrows_camera*; hide $ -- hide all arrows_camera

select $dir_sign*
	dirSignArrayRaw = getCurrentSelection()

			for i=1 to dirSignArrayRaw.count do ( --loop 
				append dirSignArray (dirSignArrayRaw[i].name as string)
					--print (dirSignArrayRaw[i].name as string)
					)
				--dirSignArray = #{1..dirSignArray.count}
					
for thisSign in dirSignArray do (
	print thisSign 
	dirSignParseArray = #()
--start hide
		numbersOnly = substring thisSign 12 (thisSign.count-1)
	j = (numbersOnly.count)/2
	
    for i=1 to ((numbersOnly.count)/2) do (
		offCam = substring numbersOnly (i*2-1) 2
		--messagebox (offCam as string) beep:false
		append dirSignParseArray (offCam as string)
		--messagebox (dirSignParseArray[i] as string) beep:false
)

dirSignParseArray.count
dirSignParseArray[2]
camNumber as string
exist = findItem dirSignParseArray (camNumber as string)

If exist != 0 do (
	select (execute ("$" + thisSign)) 
	hide $
	)
--end hide	
)

		-- render camera ------------------------
			if rendArrowsOnly == false then ( -- render only arrows if checkbutton pressed
			SceneExposureControl.exposureControl = linear_exposure
			linear_exposure.active = true
			backgroundColor = color 55 66 77
			ambientColor = color 0 0 0
			useEnvironmentMap = off				
			$Sky01.on = true; $Sky01.multiplier = 1; $Sky01.baseObject.castShadows = on; $Sky01.rays_per_sample = ShadowQ -- Light settings for scene render
			--render camera:(execute ("$" + i)) outputFile:(sceneName + "_200cam" + camNumber + ".png") outputwidth:200 outputheight:216 pixelaspect:1 progressbar:true vfb:on 	--render current scene setup
			--render camera:(execute ("$" + i)) outputFile:(sceneName + "_320cam" + camNumber + ".png") outputwidth:320 outputheight:480 pixelaspect:1 progressbar:true vfb:on 	--render current scene setup
			)
		-- render arrow-------------------------
			SceneExposureControl.exposureControl = linear_exposure
			linear_exposure.active = false
			hide objects
			select (execute ("$" + "arrows_" + i)) 
			unhide $
			$Sky01.on = true; $Sky01.multiplier = 1; $Sky01.baseObject.castShadows = off; $Sky01.rays_per_sample = ShadowQ  -- Light settings for arrow render
			render camera:(execute ("$" + i)) outputFile:(sceneName + "_200dir" + camNumber + ".png") outputwidth:200 outputheight:216 pixelaspect:1 progressbar:true vfb:on --render current arrow
			render camera:(execute ("$" + i)) outputFile:(sceneName + "_320dir" + camNumber + ".png") outputwidth:320 outputheight:480 pixelaspect:1 progressbar:true vfb:on 	--render current scene setup
		-- render elevated-------------------------	
			if rendArrowsOnly == false then ( -- render only arrows if checkbutton pressed
			if IsValidNode $elevated == true  then 	(
				hide objects
				select $elevated
				unhide $
			SceneExposureControl.exposureControl = linear_exposure
			linear_exposure.active = true
			backgroundColor = color 55 66 77
			ambientColor = color 0 0 0
			useEnvironmentMap = off				
			$Sky01.on = true; $Sky01.multiplier = 1; $Sky01.baseObject.castShadows = on; $Sky01.rays_per_sample = ShadowQ -- Light settings for scene render
			render camera:(execute ("$" + i)) outputFile:(sceneName + "_200el" + camNumber + ".png") outputwidth:200 outputheight:216 pixelaspect:1 progressbar:true vfb:on 	--render current scene setup
			render camera:(execute ("$" + i)) outputFile:(sceneName + "_320el" + camNumber + ".png") outputwidth:320 outputheight:480 pixelaspect:1 progressbar:true vfb:on 	--render current scene setup
					)
				) --end of render Elevated if exist
			
		-- reset after render -------------------------						
			unhide objects --unhide all to finish cycle
			SceneExposureControl.exposureControl = linear_exposure
			linear_exposure.active = true
			backgroundColor = color 55 66 77
			ambientColor = color 0 0 0
			useEnvironmentMap = off				
			$Sky01.on = true; $Sky01.multiplier = 1; $Sky01.baseObject.castShadows = on; $Sky01.rays_per_sample = ShadowQ -- Light settings for scene render
			) --end of cycle for every selected camera
		) -- end of FnRender
	
rollout JV_renderDialog "JV_renderDialog" width:189 --height:390
(
	checkbox chk_elev "Has elevated elements" pos:[13,10] width:166 height:15 checked:false
	checkbox chk_320 "Render 320x480 version" pos:[13,30] width:166 height:15 checked:true
	checkbutton cbt_arrowsOnly "Arrows Only" pos:[9,(chk_320.pos.y+25)] width:100 height:30  checked:rendArrowsOnly
	button btn4_CamAngles "Angles" pos:[119,(chk_320.pos.y+25)] width:59 height:30
	MultiListBox lbx1_cams "Camera List:" pos:[9,(cbt_arrowsOnly.pos.y+38)] width:170 height:lbx1_height items:camArray selection:camArraySel
	button btn1_RenderLQ "Quick Render" pos:[9,(lbx1_cams.pos.y+lbx1_cams.height+10)] width:170 height:30
	button btn2_RenderHQ "HQ Render" pos:[9,(btn1_RenderLQ.pos.y+40)] width:170 height:30
	button btn3_Cancel "Close" pos:[9,(btn2_RenderHQ.pos.y+40)] width:170 height:30

		on JV_renderDialog open do (			-- initial open setings	
			If IsValidNode $elevated == true  then (chk_elev.checked = true)
			FnCameraList(); lbx1_cams.items = camArray  -- evaluate camera list
			lbx1_cams.selection = camArraySel  -- evaluate and mark camera selection
			) -- end of on JV_renderDialog open 
		
		on chk_elev changed theState do (  -- checkbox elevated on click
			If IsValidNode $elevated == true  then (chk_elev.checked = true; messagebox  "Object 'elevated' present in scene" beep:false)
			else (chk_elev.checked = false; messagebox  "Object 'elevated' not present in scene" beep:false)
			)
		
		on cbt_arrowsOnly changed state do (  -- checkbutton arrows Only render on click
			if state == on then (rendArrowsOnly=true)
			else (rendArrowsOnly=false)
			)
    
		
		on lbx1_cams selectionEnd do (camArraySel = lbx1_cams.selection) --select camers to render
		
		on btn4_CamAngles pressed do (Dialog_JV_camAnglesPos = GetDialogPos JV_renderDialog; Fn_CameraAngles()) -- call Camera Angles routine

		on btn1_RenderLQ pressed do (Fn_LQ_setup(); FnRenderSelection()) -- call main render routine
						
		on btn2_RenderHQ pressed do (Fn_HQ_setup(); FnRenderSelection()) -- call main render routine

		on btn3_Cancel pressed do FnBye() -- close dialog
	)			
			

createdialog JV_renderDialog 
	
function FnBye = (try
 	DestroyDialog JV_renderDialog
		catch
		(
		messageBox "Close the dialog manually" beep:false
		results = undefined
		)
	)

)--macroscript bracket