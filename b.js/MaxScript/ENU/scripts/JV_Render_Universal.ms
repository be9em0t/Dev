		-- Added 320x480 render mode
		-- Added 320x240 render mode
		-- added multiple render options
		-- Updated quality settinngs
		-- help on naming: dir_sign03_0203 (mark the camers that hide this object)
		--renamed output to conform to XXXxXXX
		
		-- set correct options in INI file, and then render using this
		
		-- JV_RenderUI_v03
			-- INITIAL SETTINGS
				ShadowQ = 10 --skylight shadow quality
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
				global Fn_LQ_setup
				global Fn_HQ_setup
				global Fn_200x216_setup
				global Fn_320x480_setup
				global Fn_320x240_setup
				global FnCameraList
				global FnBye
				global Fn_HideDirSigns

				global Dialog_JV_camAnglesPos
				global Fn_hideDirSign
				global thisSign
				global render200x216
				global render320x480
				global render320x240
				rollout JV_camAngles "JV_camAngles" ( )
				rollout JV_renderDialog "JV_renderDialog" ( )

		-- read ini settings		
		JV_ini = getFilenamePath(getThisScriptFilename()) + "JVRenderUniversal_settings.ini"
	 if (getfiles JV_ini).count == 0 then(
		setINISetting JV_ini "Render"	"showUI" "true"
	 	setINISetting JV_ini "Render"	"elevated" "false"
	 	setINISetting JV_ini "Render" "200x216" "true"
	 	setINISetting JV_ini "Render" "320x480" "true"
	 	setINISetting JV_ini "Render" "320x240" "true"
	 	setINISetting JV_ini "View" "SetView" "1"
		setINISetting JV_ini "View" "viewportGrid" "true"
	 )

	 strShowUI = getINISetting JV_ini "Render" "showUI"--read a setting
	 global bShowUI = strShowUI as booleanClass
	 strElevated = getINISetting JV_ini "Render" "elevated"
	 global bElevated = strElevated as booleanClass
	 str200x216 = getINISetting JV_ini "Render" "200x216"
	 global b200x216 = str200x216 as booleanClass
	 str320x480 = getINISetting JV_ini "Render" "320x480"
	 global b320x480 = str320x480 as booleanClass
	 str320x240 = getINISetting JV_ini "Render" "320x240"
	 global b320x240 = str320x240 as booleanClass
	 strView = getINISetting JV_ini "View" "SetView"
	 global intView = strView as integer
	 strGrid = getINISetting JV_ini "View" "viewportGrid"
	 global intViewportGrid = strGrid as integer
	 strGrid = getINISetting JV_ini "View" "viewportGrid"
	 global bGrid = strGrid as booleanClass


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

	 function Fn_200x216_setup = (
	 	renderWidth              = 200 
		renderHeight              = 216
	 )

	 function Fn_320x480_setup = (
	 	renderWidth              = 320 
		renderHeight              = 480
	 )

	 function Fn_320x240_setup = 
	 (
	 	renderWidth = 320 
		renderHeight = 240
	 ) 

	 -- controlling the viewport (safe frame, grid, stats)
	 fn ConfigureCallbackFalse = 
 	(
 		hWND = DialogMonitorOPS.GetWindowHandle()
 		
 		if (UIAccessor.GetWindowText hWND) != "Viewport Configuration"  do return true
 		
 		TCM_SETCURFOCUS = 0x1330	
 		
 		BM_SETCHECKED = 0x00F1
 		BM_UNCHECKED = 0x0000
 		BM_CHECKED = 0x0001
 
 		-- Switch to the 'Safe Frames' Panel  (it's number 2)
 		for kidHWND in (UIAccessor.GetChildWindows hWND) where ((UIAccessor.GetWindowClassName kidHWND) == "SysTabControl32") do
 		(
 			UIAccessor.SendMessage kidHWND TCM_SETCURFOCUS 3 0 
 		)
 		for kidHWND in (UIAccessor.GetChildWindows hWND) where (UIAccessor.GetWindowText kidHWND) == "Live Area" do
 		(
 			UIAccessor.SendMessage kidHWND BM_SETCHECKED BM_CHECKED 0
 		)
 		for kidHWND in (UIAccessor.GetChildWindows hWND) where (UIAccessor.GetWindowText kidHWND) == "Region (when Region Rendering)" do
 		(
 			UIAccessor.SendMessage kidHWND BM_SETCHECKED BM_CHECKED 0
 		)
 		for kidHWND in (UIAccessor.GetChildWindows hWND) where (UIAccessor.GetWindowText kidHWND) == "Action Safe" do
 		(
 			UIAccessor.SendMessage kidHWND BM_SETCHECKED BM_CHECKED 0
 		)
 		for kidHWND in (UIAccessor.GetChildWindows hWND) where (UIAccessor.GetWindowText kidHWND) == "Title Safe" do
 		(
 			UIAccessor.SendMessage kidHWND BM_SETCHECKED BM_CHECKED 0
 		)
 		for kidHWND in (UIAccessor.GetChildWindows hWND) where (UIAccessor.GetWindowText kidHWND) == "User Safe" do
 		(
 			UIAccessor.SendMessage kidHWND BM_SETCHECKED BM_UNCHECKED 0
 		)
 		for kidHWND in (UIAccessor.GetChildWindows hWND) where (UIAccessor.GetWindowText kidHWND) == "12-Field Grid" do
 		(
 			UIAccessor.SendMessage kidHWND BM_SETCHECKED BM_CHECKED 0
 		)
		
		/*
		-- statistics
 		for kidHWND in (UIAccessor.GetChildWindows hWND) where ((UIAccessor.GetWindowClassName kidHWND) == "SysTabControl32") do
 		(
 			UIAccessor.SendMessage kidHWND TCM_SETCURFOCUS 6 0 
 		)		
 		for kidHWND in (UIAccessor.GetChildWindows hWND) where (UIAccessor.GetWindowText kidHWND) == "Show Statistics in Active View" do
 		(
 			UIAccessor.SendMessage kidHWND BM_SETCHECKED BM_CHECKED 0
 		)
		
		-- visual style & appearance
 		for kidHWND in (UIAccessor.GetChildWindows hWND) where ((UIAccessor.GetWindowClassName kidHWND) == "SysTabControl32") do
 		(
 			UIAccessor.SendMessage kidHWND TCM_SETCURFOCUS 0 0 
 		)
 		for kidHWND in (UIAccessor.GetChildWindows hWND) where (UIAccessor.GetWindowText kidHWND) == "Viewport Clipping" do
 		(
 			UIAccessor.SendMessage kidHWND BM_SETCHECKED BM_UNCHECKED 0
 		)
 		*/
		
 		UIAccessor.SendMessageID  hWND #IDOK
 
 		true
 	)

 	fn cfgViewport =
 	(
 		DialogMonitorOPS.RegisterNotification ConfigureCallbackFalse id:#PokeViewportConfigure
 		DialogMonitorOPS.Enabled = true		
 		max vptconfig
 		DialogMonitorOPS.unRegisterNotification id:#PokeViewportConfigure
 		DialogMonitorOPS.Enabled = false
 		ok
 	)
 

	function FnCameraList = (
				for i=1 to camArrayRaw.count do ( --loop cameras
					append camArray (camArrayRaw[i].name as string) 
						)
					sort camArray
					camArraySel = #{1..camArray.count}
				)

	-- select cameras to render
	function FnRenderSelection = (			
		if bShowUI == false then(
			camArraySelRender = #()	
	    for i=1 to camArray.count do (
				append camArraySelRender (camArray[i] as string)
				)
			)
		else(
			camArraySelRender = #()
	    for i in camArraySel do (
				append camArraySelRender (camArray[i] as string)
				)
			)	
		FnRender()
		)		

	function FnRenderSelection_OLD = ( 
		camArraySelRender = #()
	    for i in camArraySel do (
			append camArraySelRender (camArray[i] as string)
			)
		print  camArraySelRender()
		print  camArraySel()

			 FnRender()
		)		

	--- this will be an universal render routine		
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
	
	print "=========="
	print b200x216
	print b320x480
	print b320x240
	print "=========="
	
				if rendArrowsOnly == false then ( -- render only arrows if checkbutton pressed
				SceneExposureControl.exposureControl = linear_exposure
				linear_exposure.active = true
				backgroundColor = color 55 66 77
				ambientColor = color 0 0 0
				useEnvironmentMap = off				
				$Sky01.on = true; $Sky01.multiplier = 1; $Sky01.baseObject.castShadows = on; $Sky01.rays_per_sample = ShadowQ -- Light settings for scene render

				if b200x216 == true then (
				prefix = "_200x216cam"
					w = 200
					h = 216
					render camera:(execute ("$" + i)) outputFile:(sceneName + prefix + camNumber + ".png") outputwidth:w outputheight:h pixelaspect:1 progressbar:true vfb:on
				)
				if b320x480 == true then (
					prefix = "_320x480cam"
					w = 320
					h = 480
					render camera:(execute ("$" + i)) outputFile:(sceneName + prefix + camNumber + ".png") outputwidth:w outputheight:h pixelaspect:1 progressbar:true vfb:on
				)
				if b320x240 == true then (
					prefix = "_320x240cam"
					w = 320
					h = 240
					render camera:(execute ("$" + i)) outputFile:(sceneName + prefix + camNumber + ".png") outputwidth:w outputheight:h pixelaspect:1 progressbar:true vfb:on
				)
			)
			-- render arrow-------------------------
				SceneExposureControl.exposureControl = linear_exposure
				linear_exposure.active = false
				hide objects
				select (execute ("$" + "arrows_" + i)) 
				unhide $
				$Sky01.on = true; $Sky01.multiplier = 1; $Sky01.baseObject.castShadows = off; $Sky01.rays_per_sample = ShadowQ  -- Light settings for arrow render
				if b200x216 == true then (
					prefix = "_200x216dir"
					w = 200
					h = 216
					render camera:(execute ("$" + i)) outputFile:(sceneName + prefix + camNumber + ".png") outputwidth:w outputheight:h pixelaspect:1 progressbar:true vfb:on
				)
				if b320x480 == true then (
					prefix = "_320x480dir"
					w = 320
					h = 480
					render camera:(execute ("$" + i)) outputFile:(sceneName + prefix + camNumber + ".png") outputwidth:w outputheight:h pixelaspect:1 progressbar:true vfb:on
				)
				if b320x240 == true then (
					prefix = "_320x240dir"
					w = 320
					h = 240
					render camera:(execute ("$" + i)) outputFile:(sceneName + prefix + camNumber + ".png") outputwidth:w outputheight:h pixelaspect:1 progressbar:true vfb:on
				)
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
				messagebox ("Elevated rendering obsolete" as string) beep:true
				--render camera:(execute ("$" + i)) outputFile:(sceneName + "_200el" + camNumber + ".png") outputwidth:200 outputheight:216 pixelaspect:1 progressbar:true vfb:on 	--render current scene setup
				--render camera:(execute ("$" + i)) outputFile:(sceneName + "_320el" + camNumber + ".png") outputwidth:320 outputheight:480 pixelaspect:1 progressbar:true vfb:on 	--render current scene setup
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
			) 
		
  -- UI CODE ------
	rollout JV_renderDialog "JV_renderDialog" width:189 
	(
		checkbox chk_elev "Has elevated elements" pos:[13,10] width:166 height:15 checked:bElevated
		 on chk_elev changed state do(
	 		if state == false then(
	 			setINISetting JV_ini "Render" "elevated" "false"
	 		)
	 		else(
	 			setINISetting JV_ini "Render" "elevated" "true"
	 		)
	 		If IsValidNode $elevated == true then (
				 chk_elev.checked = true; messagebox "Object 'elevated' present in scene" beep: false
				 )
	 		else(
				 chk_elev.checked = false; messagebox "Object 'elevated' not present in scene" beep: false
				 )
	 	)

	 	checkbox chk_200x216 "Render 200x216 version" pos: [13, 30] width: 166 height: 15 checked:b200x216 
		 on chk_200x216 changed state do(
	 		if state == false then(
	 			setINISetting JV_ini "Render" "200x216" "false"
				 b200x216 = false
				 displaySafeFrames = false
	 		)
	 		else(
	 			setINISetting JV_ini "Render" "200x216" "true"
				 b200x216 = true
				if bGrid then(
				cfgViewport()
				displaySafeFrames = true
		 		)
				else displaySafeFrames = false
	 		)
	 		Fn_200x216_setup()
	 	)
	 	checkbox chk_320x480 "Render 320x480 version" pos: [13, 50] width: 166 height: 15 checked: b320x480 
		 on chk_320x480 changed state do(
	 		if state == false then(
	 			setINISetting JV_ini "Render" "320x480" "false"
				 b320x480 = false
				 displaySafeFrames = false
	 		)
	 		else(
	 			setINISetting JV_ini "Render" "320x480" "true"
				 b320x480 = true
				if bGrid then(
				cfgViewport()
				displaySafeFrames = true
		 		)
				else displaySafeFrames = false
	 		)
	 		Fn_320x480_setup()
	 	)
	 	checkbox chk_320x240 "Render 320x240 version" pos: [13, 70] width: 166 height: 15 checked: b320x240 
		 on chk_320x240 changed state do(
	 		if state == false then(
	 			setINISetting JV_ini "Render" "320x240" "false"
				 b320x240=false
				 displaySafeFrames = false
	 		)
	 		else(
	 			setINISetting JV_ini "Render" "320x240" "true"
				 b320x240=true
				if bGrid then(
				cfgViewport()
				displaySafeFrames = true
		 		)
				else displaySafeFrames = false
	 		)
	 		Fn_320x240_setup()
	 	)
	 	checkbutton cbt_arrowsOnly "Arrows Only" pos: [9, (chk_320x240.pos.y + 25)] width: 100 height: 30 checked: rendArrowsOnly 
		 on cbt_arrowsOnly changed state do(--checkbutton arrows Only render on click
	 		if state == on then(rendArrowsOnly = true)
	 		else(rendArrowsOnly = false)
	 	)
	 	button btn4_CamAngles "Angles" pos: [119, (chk_320x240.pos.y + 25)] width: 59 height: 30 
		 on btn4_CamAngles pressed do(Dialog_JV_camAnglesPos = GetDialogPos JV_renderDialog; Fn_CameraAngles()) --call Camera Angles routine
	 	MultiListBox lbx1_cams "Camera List:" pos: [9, (cbt_arrowsOnly.pos.y + 38)] width: 170 height: lbx1_height items: camArray selection: camArraySel 
		 on lbx1_cams selectionEnd do(camArraySel = lbx1_cams.selection) --select camers to render
	 	button btn1_RenderLQ "Quick Render"	pos: [9, (lbx1_cams.pos.y + lbx1_cams.height + 10)] width: 170 height: 30 
		 on btn1_RenderLQ pressed do(Fn_LQ_setup(); FnRenderSelection()) --call main render routine
	 	button btn2_RenderHQ "HQ Render" pos: [9, (btn1_RenderLQ.pos.y + 40)] width: 170 height: 30 
		 on btn2_RenderHQ pressed do(Fn_HQ_setup(); FnRenderSelection()) --call main render routine
	 	button btn3_Cancel "Close" pos: [9, (btn2_RenderHQ.pos.y + 40)] width: 170 height: 30 
		 on btn3_Cancel pressed do FnBye() --close dialog

		checkbox chk_useUI "Show UI next time" pos:[13,(btn3_Cancel.pos.y + 40)] width:166 height:15 checked:bShowUI
		 on chk_useUI changed state do(
	 		if state == false then(
				 bShowUI = false
				 setINISetting JV_ini "Render" "ShowUI" "false"
	 		)
	 		else(
				 bShowUI = true
				 setINISetting JV_ini "Render" "ShowUI" "true"
	 				)	
	 		)
			 
		checkbox chk_viewGrid "Show SafeFrame and 12-grid" pos:[13,(chk_useUI.pos.y + 25)] width:166 height:15 checked:bGrid
		 on chk_viewGrid changed state do(
	 		if state == false then(
				 bGrid = false
				 setINISetting JV_ini "View" "viewportGrid" "false"
				displaySafeFrames = false
	 		)
	 		else(
				 bGrid = true
				 setINISetting JV_ini "View" "viewportGrid" "true"
				cfgViewport()
				displaySafeFrames = true
	 				)	
	 		)

	 	button btn4_200x216 "200x216"	pos: [9, (chk_viewGrid.pos.y + 25)] width: 56 height: 30 
		 on btn4_200x216 pressed do (
			Fn_200x216_setup()
			if bGrid then(
				cfgViewport()
				displaySafeFrames = true
		 		)
			else displaySafeFrames = false
		 )
	 	button btn5_320x480 "320x480"	pos: [65, (chk_viewGrid.pos.y + 25)] width: 57 height: 30 
		 on btn5_320x480 pressed do (
			Fn_320x480_setup()
			if bGrid then(
				cfgViewport()
				displaySafeFrames = true
		 		)
			else displaySafeFrames = false
		 )		 
	 	button btn6_320x240 "320x240"	pos: [122, (chk_viewGrid.pos.y + 25)] width: 57 height: 30 
		 on btn6_320x240 pressed do (
			Fn_320x240_setup()
			if bGrid then(
				cfgViewport()
				displaySafeFrames = true
		 		)
			else displaySafeFrames = false
		 )

			on JV_renderDialog open do (			-- initial open setings	
				If IsValidNode $elevated == true  then (chk_elev.checked = true)
				FnCameraList(); lbx1_cams.items = camArray  -- evaluate camera list
				lbx1_cams.selection = camArraySel  -- evaluate and mark camera selection
				) 
	)

function main = (	
	if bShowUI == false then(
		Fn_HQ_setup()
		FnCameraList(); 
		--lbx1_cams.items = camArray  -- evaluate camera list
		--lbx1_cams.selection = camArraySel  -- evaluate and mark camera selection
		FnRenderSelection()
		)
	else(
		createdialog JV_renderDialog 	
		)	
	)
	
	main()
		
	function FnBye = (try
	 	DestroyDialog JV_renderDialog
			catch
			(
			messageBox "Close the dialog manually" beep:false
			results = undefined
			)
		)
