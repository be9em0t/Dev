macroScript JV_RenderUI_v04
	category:"Vla"
	buttonText:"JV_RenderUI_v04"
	icon:#("jvRenderUI", 1)
	toolTip:"JV_RenderUI_v04.1"

(
		-- separated in 2 scripts:
			--JV_Render_Caller.mcr calls the UI 
			--JV_Render_Universal.ms is the body and can be used for ui-less batch rendering with ShowUI = false in ini file

		-- Added 320x480 render mode
		-- Added 320x240 render mode
		-- added multiple render options
		-- Updated quality settinngs
		-- help on naming: dir_sign03_0203 (mark the camers that hide this object)
		-- renamed output to conform to XXXxXXX


		-- read ini settings		
		JV_ini = getFilenamePath(getThisScriptFilename()) + "JVRenderUniversal_settings.ini"

if (getfiles JV_ini).count == 0 then(
	fileIn "JV_Render_Universal.ms"
	)
else (
	 strShowUI = getINISetting JV_ini "Render" "showUI"--read a setting
	 global bShowUI = strShowUI as booleanClass

	if bShowUI == false then(
		setINISetting JV_ini "Render" "ShowUI" "true"
		fileIn "JV_Render_Universal.ms"
		)
	else (
		fileIn "JV_Render_Universal.ms"
		)
)

)