macroScript JV_RenderUI_v04
	category:"Vla"
	buttonText:"JV_RenderCaller"
	icon:#("jvRenderUI", 1)
	toolTip:"JV_RenderUI_v04.1"

(
		-- separated in 2 scripts:
		  --JV_Render_Caller.mcr just a micorscript wrapper 
			--JV_Render_Caller.ms calls the UI 
			--JV_Render_Universal.ms is the body and can be used for ui-less batch rendering with ShowUI = false in ini file

		-- Added 320x480 render mode
		-- Added 320x240 render mode
		-- added multiple render options
		-- Updated quality settinngs
		-- help on naming: dir_sign03_0203 (mark the camers that hide this object)
		-- renamed output to conform to XXXxXXX


	fileIn "JV_Render_Caller.ms"

)