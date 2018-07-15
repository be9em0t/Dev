macroScript JV_FileExport --ver. 1.3
category:"Vla"
	toolTip:"Export as 3D files"
	buttonText:"Exp"
	Icon:#("jvMaxTame",7)
(
	colorman.reInitIcons()
	function ChangeStatistic =
	(
		dialogMonitorOPS.UnRegisterNotification id:#miauuChangeStatisticsSettingsID
		dialogMonitorOps.enabled = true
		function miauuChangeStatisticsSettings = 
		(
			local type = 3
			local BM_SETCHECK = 241	
			local BN_CLICKED = 0
			local WM_COMMAND = 273
			local TCM_SETCURFOCUS = 0x1330
			--local statisticsTabIndex = if curMaxVersion < 15 then 5 else 6
			local statisticsTabIndex = 6
			local hwnd = DialogMonitorOPS.GetWindowHandle()
			local hwnd_title = UIAccessor.GetWindowText hwnd
			if (hwnd_title == "Viewport Configuration") then
			( 
				for kidHWND in (UIAccessor.GetChildWindows hWND) where ((UIAccessor.GetWindowClassName kidHWND) == "SysTabControl32") do
				(
					UIAccessor.SendMessage kidHWND TCM_SETCURFOCUS statisticsTabIndex 0
				)
				controls = windows.getChildrenHWND hwnd
				show = undefined
-- 					for child in controls do
-- 					(
-- 						if (child[5] == type) do show = child
-- 						if (child[5] == "Total") do (UIAccessor.SendMessage child[1] BM_SETCHECK 0 0)
-- 						if (child[5] == "Selection") do (UIAccessor.SendMessage child[1] BM_SETCHECK 0 0)
-- 						if (child[5] == "Total + Selection") do (UIAccessor.SendMessage child[1] BM_SETCHECK 0 0)
-- 						if (child[5] == "Polygon Count") do (UIAccessor.SendMessage child[1] BM_SETCHECK (if chkbtn_polygon.checked then 1 else 0) 0)
-- 						if (child[5] == "Triangle Count") do (UIAccessor.SendMessage child[1] BM_SETCHECK (if chkbtn_triangle.checked then 1 else 0)  0)
-- 						if (child[5] == "Edge Count") do (UIAccessor.SendMessage child[1] BM_SETCHECK (if chkbtn_edge.checked then 1 else 0)  0)
-- 						if (child[5] == "Vertex Count") do (UIAccessor.SendMessage child[1] BM_SETCHECK (if chkbtn_vertex.checked then 1 else 0)  0)
-- 						if (child[5] == "Frames Per Second") do (UIAccessor.SendMessage child[1] BM_SETCHECK (if chkbox_fps.checked then 1 else 0)  0)
-- 					)
				for child in controls do
				(
					if (child[5] == type) do show = child
					if (child[5] == "Total") do (UIAccessor.SendMessage child[1] BM_SETCHECK 0 0)
					if (child[5] == "Selection") do (UIAccessor.SendMessage child[1] BM_SETCHECK 0 0)
					if (child[5] == "Total + Selection") do (UIAccessor.SendMessage child[1] BM_SETCHECK 1 0)
					if (child[5] == "Polygon Count") do (UIAccessor.SendMessage child[1] BM_SETCHECK 0 0)
					if (child[5] == "Triangle Count") do (UIAccessor.SendMessage child[1] BM_SETCHECK 1  0)
					if (child[5] == "Edge Count") do (UIAccessor.SendMessage child[1] BM_SETCHECK 0  0)
					if (child[5] == "Vertex Count") do (UIAccessor.SendMessage child[1] BM_SETCHECK 0  0)
					if (child[5] == "Frames Per Second") do (UIAccessor.SendMessage child[1] BM_SETCHECK 0  0)
				)					
-- 					UIAccessor.SendMessage child[1] BM_SETCHECK 0 0
-- 					UIAccessor.SendMessage child[1] BM_SETCHECK 1  0
				--
				if show != undefined do
				(
					UIAccessor.SendMessage show[1] BM_SETCHECK 1 0
					windows.sendMessage (UIAccessor.getParentWindow show[1]) WM_COMMAND ((bit.shift BN_CLICKED 16) + (UIAccessor.getWindowResourceID hwnd)) show[1] 
					uiAccessor.sendMessageID hwnd #IDOK
				)
				UIAccessor.PressButtonByName hwnd "OK"
			) 
			true
		)
		dialogMonitorOPS.RegisterNotification miauuChangeStatisticsSettings id:#miauuChangeStatisticsSettingsID
		max vptconfig
		dialogMonitorOPS.UnRegisterNotification id:#miauuChangeStatisticsSettingsID
		dialogMonitorOps.enabled = false
		
		max show statistics toggle
		)
	


	JV_ini = getFilenamePath (getThisScriptFilename()) + "JV_settings.ini"
	if (getfiles JV_ini).count == 0 then (
		setINISetting JV_ini "UI" "UIwidth" "200" 	
		setINISetting JV_ini "FileOps" "ExportDir" "c:\ "
		setINISetting JV_ini "FileOps" "ExportSame" "0"
		setINISetting JV_ini "FileOps" "ExportOBJ" "1"
		setINISetting JV_ini "FileOps" "ExportVRL" "1"
		setINISetting JV_ini "FileOps" "ExportAllLODs" "1"
		setINISetting JV_ini "ResetPos" "ResetPos" "1"
		setINISetting JV_ini "ResetRot" "ResetRot" "0"
		setINISetting JV_ini "ResetScale" "ResetScale" "0"
		)

		
	UIwidthStr = getINISetting JV_ini "UI" "UIwidth" 	--read a setting
	UIwidth = UIwidthStr as integer
		
	expDir = getINISetting JV_ini "FileOps" "ExportDir" 	--read a setting
	expSame = getINISetting JV_ini "FileOps" "ExportSame"
	expOBJ = getINISetting JV_ini "FileOps" "ExportOBJ"
	expVRL = getINISetting JV_ini "FileOps" "ExportVRL"
	expAll = getINISetting JV_ini "FileOps" "ExportAllLODs"
	resPos = getINISetting JV_ini "Reset" "ResetPos"
	resRot = getINISetting JV_ini "Reset" "ResetRot"
	resScl = getINISetting JV_ini "Reset" "ResetScale"	
	
-- 	if expDir == "maxfile" then (
-- 		expDir = maxFilePath + "\\"
-- 		tiptext1 = "Will save to " + expDir)  --"Will save to max file's folder"
-- 		else tiptext1 = "Will save to " + expDir
		
	if expSame == "1" then expSamestate = true else expSamestate = false
	if expOBJ == "1" then expOBJstate = true else expOBJstate = false
	if expVRL == "1" then expVRLstate = true else expVRLstate = false
	if expAll == "1" then expAllstate = true else expAllstate = false

	if resPos == "1" then resPosState = true else resPosState = false
	if resRot == "1" then resRotState = true else resRotState = false
	if resScl == "1" then resSclState = true else resSclState = false
	
		--UI
				rollout JV_MaxTame "JV Max Tamer" width:200 --height:402
	(

groupBox group1 "Export LODs" pos:[5,5] width:190 height:155
groupBox group2 "Reset Transforms" pos:[5,170] width:190 height:115
		
		edittext eExportDir "Export to folder:" text:expDir labelOnTop:true pos:[10,25] width:180 --height:28
			on eExportDir entered txt do (setINISetting JV_ini "FileOps" "ExportDir" txt
				expDir = txt)  --write a setting
		checkbox exportSame "Export to same folder" pos:[15,65] width:150 height:21 checked:expSamestate
			on exportSame changed state do (
				if state == false then (
					setINISetting JV_ini "FileOps" "ExportSame" "0" 
					expSame = "0") 
				else (
					setINISetting JV_ini "FileOps" "ExportSame" "1"
					expSame = "1")
					)  --write a setting
		checkbox exportOBJ "Export to OBJ" pos:[15,85] width:150 height:21 checked:expOBJstate
			on exportOBJ changed state do (
				if state == false then setINISetting JV_ini "FileOps" "ExportOBJ" "0" else setINISetting JV_ini "FileOps" "ExportOBJ" "1")  --write a setting
		checkbox exportVRL "Export to WRL" pos:[15,105] width:150 height:21 checked:expVRLstate
			on exportVRL changed state do (
				if state == false then setINISetting JV_ini "FileOps" "ExportVRL" "0" else setINISetting JV_ini "FileOps" "ExportVRL" "1")
/*		checkbox exportAll "Export All LODs" pos:[10,100] width:(UIwidth-10) height:21 checked:expAllstate
			on exportAll changed state do (
				if state == false then setINISetting JV_ini "FileOps" "ExportAllLODs" "0" else setINISetting JV_ini "FileOps" "ExportAllLODs" "1")
*/		 
		checkbox chPos "Zero Position" pos:[15,190] width:150 height:21 checked:resPosState
			on chPos changed state do (
				if state == false then setINISetting JV_ini "Reset" "ResetPos" "0" else setINISetting JV_ini "Reset" "ResetPos" "1")  --write a setting
		checkbox chRot "Zero Rotation" pos:[15,210] width:150 height:21 checked:resRotState
			on chRot changed state do (
				if state == false then setINISetting JV_ini "Reset" "ResetRot" "0" else setINISetting JV_ini "Reset" "ResetRot" "1")  --write a setting
		checkbox chScl "Zero Scale" pos:[15,230] width:150 height:21 checked:resSclState
			on chScl changed state do (
				if state == false then setINISetting JV_ini "Reset" "ResetScale" "0" else setINISetting JV_ini "Reset" "ResetScale" "1")  --write a setting


		button btn1_Export "Start Export" pos:[15,130]  align:#center width:170 --height:33 toolTip:tiptext1 
				on btn1_Export pressed do (
					if expSame == "1" then expPath = maxFilePath
					else expPath = expDir
					for a in selection do (
					hide objects
					unhide a			
					if a.name == "lod3" then (if exportVRL.checked == true do exportFile (expPath + a.name + ".wrl") using:VRBL_Export)
						else (
					if exportOBJ.checked == true do exportFile (expPath + a.name + ".obj") using:ObjExp
					if exportVRL.checked == true do exportFile (expPath + a.name + ".wrl") using:VRBL_Export
								)
							)
						)				

		button btn2_ZeroOut "Zero Out LODs" pos:[15,255] width:170 --height:33
			on btn2_ZeroOut pressed do (
				objArray = objects as array
				if objArray.count != 3 then (
						--MessageBox("Wrong number of LODs: " + (objArray.count as string))
						q_answer = queryBox ("Wrong number of LODs: " + (objArray.count as string) + "\n\nContinue?")
						if q_answer then
							clearUndoBuffer()  
							undo on(
							(						
							for s in objArray do(
							print s as string
							if chPos.checked == true do s.pos = [0,0,0]
							if chRot.checked == true do (
								s.rotation.x_rotation = 0
								s.rotation.y_rotation = 0
								s.rotation.z_rotation = 0
																	)
							if chScl.checked == true do s.scale = [1,1,1]
													)
							)))
					else (
						clearUndoBuffer()  
						undo on(
						for s in objArray do(
							print s as string
							if chPos.checked == true do s.pos = [0,0,0]
							if chRot.checked == true do (
								s.rotation.x_rotation = 0
								s.rotation.y_rotation = 0
								s.rotation.z_rotation = 0
																	)
							if chScl.checked == true do s.scale = [1,1,1]
							)))
				--for OBJ in Geometry do(
-- 					OBJ.pos = [0,0,0]
-- 					OBJ.rotation.x_rotation = 0
-- 					OBJ.rotation.y_rotation = 0
-- 					OBJ.rotation.z_rotation = 0
-- 					--OBJ.
-- 					)
		
					
-- 					for s in selection do (
-- 					unhide objects
-- 					if s.name == "lod3" then (print "If - do")
-- 						else (print "else do")
-- 				)
							)

			button btn3_SetRenderer "Set Scanline Render" pos:[15,290] width:170 --height:33
			on btn3_SetRenderer pressed do (
				renderers.current = Default_Scanline_Renderer ()
				)
			button btn4_TriToggle "Toggle Triangle Statistics" pos:[15,320] width:170 --height:33
			on btn4_TriToggle pressed do (
				ChangeStatistic()
				)
				)
			
		createdialog JV_MaxTame 

)		
		
	----- Snippets ------
		--MessageBox("Settings file created"
	-- theClasses =exporterPlugin.classes    -- get the availble exporters
	-- fn existFile fname = (getfiles fname).count != 0
	-- checkButton ckb1_ExpAll "Export All LODs" pos:[9,100] height:18 -- width:170

		
		

