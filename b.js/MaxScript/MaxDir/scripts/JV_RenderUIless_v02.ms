	-- Added 320x480 render mode
	-- Updated quality settinngs
	-- help on naming: dir_sign03_0203 (mark the camers that hide this object)
	
	
	-- JV_RenderUIless_v02

(
	
		/*SETTINGS*/
			ShadowQ = 12 --skylight shadow quality should be 12
			ShortName = trimright maxFileName ".max" --filename without extension
			sceneName = maxFilePath + ShortName + "_HQ";  --filename prefix
			linear_exposure = Linear_Exposure_Control();
			if lights.count > 1 do yesNoCancelBox  "Too many lights" --lights check
			
					select cameras; explodeGroup selection; --free cameras from their groups 
					select cameras; deselect $*Target;  camcount = selection.count; print camcount; --count cameras 
					
					for i = 1 to camcount do (
					if i == 1 do (print "1st camera"
						/*prepare Camera01 scene render*/

						SceneExposureControl.exposureControl = linear_exposure
						linear_exposure.active = true
						backgroundColor = color 55 66 77
						ambientColor = color 0 0 0
						useEnvironmentMap = off

						unhide objects
						select $arrows_camera*
						hide $
						select $dir_sign*_*01*
						hide $

						select lights
						for i in selection do 
													(
													i.on = true
													i.multiplier = 1
													i.baseObject.castShadows = on
													i.rays_per_sample = ShadowQ
													)
							
						/* render current scene setup */ /* render c outputFile:(c.name + ".bmp") vfb:off */
						
						render camera:$Camera01 outputFile:(sceneName + "_200cam01" + ".png") outputwidth:200 outputheight:216 pixelaspect:1 progressbar:true vfb:on
						render camera:$Camera01 outputFile:(sceneName + "_320cam01" + ".png") outputwidth:320 outputheight:480 pixelaspect:1 progressbar:true vfb:on

						/*prepare arrow render*/

						SceneExposureControl.exposureControl = linear_exposure
						linear_exposure.active = false

						hide objects
						select $arrows_camera01
						unhide $
													
						select lights
						for i in selection do 
													(
													i.on = true
													i.multiplier = 1
													i.baseObject.castShadows = off
													i.rays_per_sample = ShadowQ
													)
							
						/* render current arrow setup */
						
						render camera:$Camera01 outputFile:(sceneName + "_200dir01" + ".png") outputwidth:200 outputheight:216 pixelaspect:1 progressbar:true vfb:on
						render camera:$Camera01 outputFile:(sceneName + "_320dir01" + ".png") outputwidth:320 outputheight:480 pixelaspect:1 progressbar:true vfb:on
						unhide objects
						)
					if i == 2 do (print "2nd camera"
						/*prepare Camera02 scene render*/

						SceneExposureControl.exposureControl = linear_exposure
						linear_exposure.active = true

						unhide objects
						select $arrows_camera*
						hide $
						select $dir_sign*_*02*
						hide $
						
						select lights
						for i in selection do 
													(
													i.on = true
													i.multiplier = 1
													i.baseObject.castShadows = on
													i.rays_per_sample = ShadowQ
													)
							
						/* render current scene setup */ /* render c outputFile:(c.name + ".bmp") vfb:off */
						
						render camera:$Camera02 outputFile:(sceneName + "_200cam02" + ".png") outputwidth:200 outputheight:216 pixelaspect:1 progressbar:true vfb:on
						render camera:$Camera02 outputFile:(sceneName + "_320cam02" + ".png") outputwidth:320 outputheight:480 pixelaspect:1 progressbar:true vfb:on

						/*prepare arrow render*/

						SceneExposureControl.exposureControl = linear_exposure
						linear_exposure.active = false

						hide objects
						select $arrows_camera02
						unhide $
																			
						select lights
						for i in selection do 
													(
													i.on = true
													i.multiplier = 1
													i.baseObject.castShadows = off
													i.rays_per_sample = ShadowQ
													)
							
						/* render current arrow setup */
						
						render camera:$Camera02 outputFile:(sceneName + "_200dir02" + ".png") outputwidth:200 outputheight:216 pixelaspect:1 progressbar:true vfb:on
						render camera:$Camera02 outputFile:(sceneName + "_320dir02" + ".png") outputwidth:320 outputheight:480 pixelaspect:1 progressbar:true vfb:on
						unhide objects
						) 
					if i == 3 do (print "3rd camera"
						/*prepare Camera03 scene render*/

						SceneExposureControl.exposureControl = linear_exposure
						linear_exposure.active = true

						unhide objects
						select $arrows_camera*
						hide $
						select $dir_sign*_*03*
						hide $
						
						select lights
						for i in selection do 
													(
													i.on = true
													i.multiplier = 1
													i.baseObject.castShadows = on
													i.rays_per_sample = ShadowQ
													)
							
						/* render current scene setup */ /* render c outputFile:(c.name + ".bmp") vfb:off */
						
						render camera:$Camera03 outputFile:(sceneName + "_200cam03" + ".png") outputwidth:200 outputheight:216 pixelaspect:1 progressbar:true vfb:on
						render camera:$Camera03 outputFile:(sceneName + "_320cam03" + ".png") outputwidth:320 outputheight:480 pixelaspect:1 progressbar:true vfb:on

						/*prepare arrow render*/

						SceneExposureControl.exposureControl = linear_exposure
						linear_exposure.active = false

						hide objects
						select $arrows_camera03
						unhide $
																			
						select lights
						for i in selection do 
													(
													i.on = true
													i.multiplier = 1
													i.baseObject.castShadows = off
													i.rays_per_sample = ShadowQ
													)
							
						/* render current arrow setup */
						
						render camera:$Camera03 outputFile:(sceneName + "_200dir03" + ".png") outputwidth:200 outputheight:216 pixelaspect:1 progressbar:true vfb:on
						render camera:$Camera03 outputFile:(sceneName + "_320dir03" + ".png") outputwidth:320 outputheight:480 pixelaspect:1 progressbar:true vfb:on
						unhide objects
						)
					if i == 4 do (print "4th camera"
						/*prepare Camera04 scene render*/

						SceneExposureControl.exposureControl = linear_exposure
						linear_exposure.active = true

						unhide objects
						select $arrows_camera*
						hide $
						select $dir_sign*_*04*
						hide $
						
						select lights
						for i in selection do 
													(
													i.on = true
													i.multiplier = 1
													i.baseObject.castShadows = on
													i.rays_per_sample = ShadowQ
													)
							
						/* render current scene setup */ /* render c outputFile:(c.name + ".bmp") vfb:off */
						
						render camera:$Camera04 outputFile:(sceneName + "_200cam04" + ".png") outputwidth:200 outputheight:216 pixelaspect:1 progressbar:true vfb:on
						render camera:$Camera04 outputFile:(sceneName + "_320cam04" + ".png") outputwidth:320 outputheight:480 pixelaspect:1 progressbar:true vfb:on

						/*prepare arrow render*/

						SceneExposureControl.exposureControl = linear_exposure
						linear_exposure.active = false

						hide objects
						select $arrows_camera04
						unhide $
													
						select lights
						for i in selection do 
													(
													i.on = true
													i.multiplier = 1
													i.baseObject.castShadows = off
													i.rays_per_sample = ShadowQ
													)
							
						/* render current arrow setup */
						
						render camera:$Camera04 outputFile:(sceneName + "_200dir04" + ".png") outputwidth:200 outputheight:216 pixelaspect:1 progressbar:true vfb:on
						render camera:$Camera04 outputFile:(sceneName + "_320dir04" + ".png") outputwidth:320 outputheight:480 pixelaspect:1 progressbar:true vfb:on
						unhide objects
						)
					if i == 5 do (print "5th camera"
						/*prepare Camera05 scene render*/

						SceneExposureControl.exposureControl = linear_exposure
						linear_exposure.active = true

						unhide objects
						select $arrows_camera*
						hide $
						select $dir_sign*_*05*
						hide $
						
						select lights
						for i in selection do 
													(
													i.on = true
													i.multiplier = 1
													i.baseObject.castShadows = on
													i.rays_per_sample = ShadowQ
													)
							
						/* render current scene setup */ /* render c outputFile:(c.name + ".bmp") vfb:off */
						
						render camera:$Camera05 outputFile:(sceneName + "_200cam05" + ".png") outputwidth:200 outputheight:216 pixelaspect:1 progressbar:true vfb:on
						render camera:$Camera05 outputFile:(sceneName + "_320cam05" + ".png") outputwidth:320 outputheight:480 pixelaspect:1 progressbar:true vfb:on

						/*prepare arrow render*/

						SceneExposureControl.exposureControl = linear_exposure
						linear_exposure.active = false

						hide objects
						select $arrows_camera05
						unhide $
																			
						select lights
						for i in selection do 
													(
													i.on = true
													i.multiplier = 1
													i.baseObject.castShadows = off
													i.rays_per_sample = ShadowQ
													)
							
						/* render current arrow setup */
						
						render camera:$Camera05 outputFile:(sceneName + "_200dir05" + ".png") outputwidth:200 outputheight:216 pixelaspect:1 progressbar:true vfb:on
						render camera:$Camera05 outputFile:(sceneName + "_320dir05" + ".png") outputwidth:320 outputheight:480 pixelaspect:1 progressbar:true vfb:on
								unhide objects
						)
					if i == 6 do (print "6th camera"
						/*prepare Camera06 scene render*/

						SceneExposureControl.exposureControl = linear_exposure
						linear_exposure.active = true

						unhide objects
						select $arrows_camera*
						hide $
						select $dir_sign*_*06*
						hide $
						
						select lights
						for i in selection do 
													(
													i.on = true
													i.multiplier = 1
													i.baseObject.castShadows = on
													i.rays_per_sample = ShadowQ
													)
							
						/* render current scene setup */ /* render c outputFile:(c.name + ".bmp") vfb:off */
						
						render camera:$Camera06 outputFile:(sceneName + "_200cam06" + ".png") outputwidth:200 outputheight:216 pixelaspect:1 progressbar:true vfb:on
						render camera:$Camera06 outputFile:(sceneName + "_320cam06" + ".png") outputwidth:320 outputheight:480 pixelaspect:1 progressbar:true vfb:on

						/*prepare arrow render*/

						SceneExposureControl.exposureControl = linear_exposure
						linear_exposure.active = false

						hide objects
						select $arrows_camera06
						unhide $
																			
						select lights
						for i in selection do 
													(
													i.on = true
													i.multiplier = 1
													i.baseObject.castShadows = off
													i.rays_per_sample = ShadowQ
													)
							
						/* render current arrow setup */
						
						render camera:$Camera06 outputFile:(sceneName + "_200dir06" + ".png") outputwidth:200 outputheight:216 pixelaspect:1 progressbar:true vfb:on
						render camera:$Camera06 outputFile:(sceneName + "_320dir06" + ".png") outputwidth:320 outputheight:480 pixelaspect:1 progressbar:true vfb:on
								unhide objects
						)
					if i == 7 do (print "7th camera"
						/*prepare Camera07 scene render*/

						SceneExposureControl.exposureControl = linear_exposure
						linear_exposure.active = true

						unhide objects
						select $arrows_camera*
						hide $
						select $dir_sign*_*07*
						hide $
						
						select lights
						for i in selection do 
													(
													i.on = true
													i.multiplier = 1
													i.baseObject.castShadows = on
													i.rays_per_sample = ShadowQ
													)
							
						/* render current scene setup */ /* render c outputFile:(c.name + ".bmp") vfb:off */
						
						render camera:$Camera07 outputFile:(sceneName + "_cam07" + ".png") outputwidth:200 outputheight:216 pixelaspect:1 progressbar:true vfb:on

						/*prepare arrow render*/

						SceneExposureControl.exposureControl = linear_exposure
						linear_exposure.active = false

						hide objects
						select $arrows_camera07
						unhide $
																			
						select lights
						for i in selection do 
													(
													i.on = true
													i.multiplier = 1
													i.baseObject.castShadows = off
													i.rays_per_sample = ShadowQ
													)
							
						/* render current arrow setup */
						
						render camera:$Camera07 outputFile:(sceneName + "_dir07" + ".png") outputwidth:200 outputheight:216 pixelaspect:1 progressbar:true vfb:on
						unhide objects
						)
					if i == 8 do (print "8th camera"
						/*prepare Camera08 scene render*/

						SceneExposureControl.exposureControl = linear_exposure
						linear_exposure.active = true

						unhide objects
						select $arrows_camera*
						hide $
						select $dir_sign*_*08*
						hide $
						
						select lights
						for i in selection do 
													(
													i.on = true
													i.multiplier = 1
													i.baseObject.castShadows = on
													i.rays_per_sample = ShadowQ
													)
							
						/* render current scene setup */ /* render c outputFile:(c.name + ".bmp") vfb:off */
						
						render camera:$Camera08 outputFile:(sceneName + "_cam08" + ".png") outputwidth:200 outputheight:216 pixelaspect:1 progressbar:true vfb:on

						/*prepare arrow render*/

						SceneExposureControl.exposureControl = linear_exposure
						linear_exposure.active = false

						hide objects
						select $arrows_camera08
						unhide $
																			
						select lights
						for i in selection do 
													(
													i.on = true
													i.multiplier = 1
													i.baseObject.castShadows = off
													i.rays_per_sample = ShadowQ
													)
							
						/* render current arrow setup */
						
						render camera:$Camera08 outputFile:(sceneName + "_dir08" + ".png") outputwidth:200 outputheight:216 pixelaspect:1 progressbar:true vfb:on
						unhide objects
						)
					if i == 9 do (print "9th camera"
						/*prepare Camera09 scene render*/

						SceneExposureControl.exposureControl = linear_exposure
						linear_exposure.active = true

						unhide objects
						select $arrows_camera*
						hide $
						select $dir_sign*_*09*
						hide $
						
						select lights
						for i in selection do 
													(
													i.on = true
													i.multiplier = 1
													i.baseObject.castShadows = on
													i.rays_per_sample = ShadowQ
													)
							
						/* render current scene setup */ /* render c outputFile:(c.name + ".bmp") vfb:off */
						
						render camera:$Camera09 outputFile:(sceneName + "_cam09" + ".png") outputwidth:200 outputheight:216 pixelaspect:1 progressbar:true vfb:on

						/*prepare arrow render*/

						SceneExposureControl.exposureControl = linear_exposure
						linear_exposure.active = false

						hide objects
						select $arrows_camera09
						unhide $
																			
						select lights
						for i in selection do 
													(
													i.on = true
													i.multiplier = 1
													i.baseObject.castShadows = off
													i.rays_per_sample = ShadowQ
													)
							
						/* render current arrow setup */
						
						render camera:$Camera09 outputFile:(sceneName + "_dir09" + ".png") outputwidth:200 outputheight:216 pixelaspect:1 progressbar:true vfb:on
						unhide objects
						)
					if i == 10 do (print "10th camera"
						/*prepare Camera10 scene render*/

						SceneExposureControl.exposureControl = linear_exposure
						linear_exposure.active = true

						unhide objects
						select $arrows_camera*
						hide $
						select $dir_sign*_*10*
						hide $
						
						select lights
						for i in selection do 
													(
													i.on = true
													i.multiplier = 1
													i.baseObject.castShadows = on
													i.rays_per_sample = ShadowQ
													)
							
						/* render current scene setup */ /* render c outputFile:(c.name + ".bmp") vfb:off */
						
						render camera:$Camera10 outputFile:(sceneName + "_cam10" + ".png") outputwidth:200 outputheight:216 pixelaspect:1 progressbar:true vfb:on

						/*prepare arrow render*/

						SceneExposureControl.exposureControl = linear_exposure
						linear_exposure.active = false

						hide objects
						select $arrows_camera10
						unhide $
																			
						select lights
						for i in selection do 
													(
													i.on = true
													i.multiplier = 1
													i.baseObject.castShadows = off
													i.rays_per_sample = ShadowQ
													)
							
						/* render current arrow setup */
						
						render camera:$Camera10 outputFile:(sceneName + "_dir10" + ".png") outputwidth:200 outputheight:216 pixelaspect:1 progressbar:true vfb:on
						unhide objects
						)
					if i == 11 do (print "11th camera"
						/*prepare Camera11 scene render*/

						SceneExposureControl.exposureControl = linear_exposure
						linear_exposure.active = true

						unhide objects
						select $arrows_camera*
						hide $
						select $dir_sign*_*11*
						hide $
						
						select lights
						for i in selection do 
													(
													i.on = true
													i.multiplier = 1
													i.baseObject.castShadows = on
													i.rays_per_sample = ShadowQ
													)
							
						/* render current scene setup */ /* render c outputFile:(c.name + ".bmp") vfb:off */
						
						render camera:$Camera11 outputFile:(sceneName + "_cam11" + ".png") outputwidth:200 outputheight:216 pixelaspect:1 progressbar:true vfb:on

						/*prepare arrow render*/

						SceneExposureControl.exposureControl = linear_exposure
						linear_exposure.active = false

						hide objects
						select $arrows_camera11
						unhide $
																			
						select lights
						for i in selection do 
													(
													i.on = true
													i.multiplier = 1
													i.baseObject.castShadows = off
													i.rays_per_sample = ShadowQ
													)
							
						/* render current arrow setup */
						
						render camera:$Camera11 outputFile:(sceneName + "_dir11" + ".png") outputwidth:200 outputheight:216 pixelaspect:1 progressbar:true vfb:on
						unhide objects
						)
					if i == 12 do (print "12th camera"
						/*prepare Camera12 scene render*/

						SceneExposureControl.exposureControl = linear_exposure
						linear_exposure.active = true

						unhide objects
						select $arrows_camera*
						hide $
						select $dir_sign*_*12*
						hide $
						
						select lights
						for i in selection do 
													(
													i.on = true
													i.multiplier = 1
													i.baseObject.castShadows = on
													i.rays_per_sample = ShadowQ
													)
							
						/* render current scene setup */ /* render c outputFile:(c.name + ".bmp") vfb:off */
						
						render camera:$Camera12 outputFile:(sceneName + "_cam12" + ".png") outputwidth:200 outputheight:216 pixelaspect:1 progressbar:true vfb:on

						/*prepare arrow render*/

						SceneExposureControl.exposureControl = linear_exposure
						linear_exposure.active = false

						hide objects
						select $arrows_camera12
						unhide $
																			
						select lights
						for i in selection do 
													(
													i.on = true
													i.multiplier = 1
													i.baseObject.castShadows = off
													i.rays_per_sample = ShadowQ
													)
							
						/* render current arrow setup */
						
						render camera:$Camera12 outputFile:(sceneName + "_dir12" + ".png") outputwidth:200 outputheight:216 pixelaspect:1 progressbar:true vfb:on
						unhide objects
						
						/* reset render and light settings*/
						SceneExposureControl.exposureControl = linear_exposure
						linear_exposure.active = true
						backgroundColor = color 55 66 77
						ambientColor = color 0 0 0
						useEnvironmentMap = off
						
						select lights
						for i in selection do 
													(
													i.on = true
													i.multiplier = 1
													i.baseObject.castShadows = on
													i.rays_per_sample = ShadowQ
													)						
						/* end reset render and light settings*/
						)
					)
				)