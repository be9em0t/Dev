macroScript JV_Setup
	category:"Vla"
	toolTip:"JV_Setup - Light & Render"
	buttonText:"JV Set/Reset Scene"
	icon:#("jvSetup", 1)

(
	
		/*RESET SETTINGS*/
			linear_exposure = Linear_Exposure_Control();
			if lights.count > 1 do yesNoCancelBox  "Too many lights" --lights check
			

						SceneExposureControl.exposureControl = linear_exposure
						linear_exposure.active = true
						backgroundColor = color 55 66 77
						ambientColor = color 0 0 0
						useEnvironmentMap = off
						
						unhide objects

						select lights
						for i in selection do 
													(
													i.name = "Sky01"
													i.pos = [0,0,0]
													i.on = true
													i.multiplier = 1
													i.baseObject.castShadows = on
													i.rays_per_sample = 20
													)
							
						/* render current scene setup */ /* render c outputFile:(c.name + ".bmp") vfb:off */
						/* sceneName = maxFilePath + maxFileName;  render camera:$Camera01 outputFile:(sceneName + "_camera01" + ".png") outputwidth:200 outputheight:216 pixelaspect:1 progressbar:true vfb:on */


)
