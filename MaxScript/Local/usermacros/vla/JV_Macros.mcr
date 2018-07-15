--	JV_MacroScript collection
--	Vla J.
--	
--	Use and modify at your own risk
--	Updated 2013-07-14



macroScript JV_NitroHQ_Consistent
category:"Vla"
	toolTip:"JV Set Nitrous to HiQuality Consistent Shading"
	buttonText:"NiHQ"
	Icon:#("jvMaxTame",4)
(
if dispCond = NitrousGraphicsManager.IsEnabled() then (
		actDisp = NitrousGraphicsManager.GetActiveViewportSetting()
		actDisp.VisualStyleMode =  #ConsistentColors as name
		--actDisp.UseTextureEnabled =  true
		actDisp.ShowSelectionBracketsEnabled = false
		actDisp.ShadeSelectedFacesEnabled  = true

		actDisp.SelectedEdgedFacesEnabled  = true
		actDisp.ShowEdgedFacesEnabled = true

		actDisp.ShowHighlightEnabled = false
		actDisp.ShadowsEnabled = false
		actDisp.AmbientOcclusionEnabled = false

		NitroLarge() --set texture size to 2048
		NitrousGraphicsManager.MakePreviewQuality = 1
		NitrousGraphicsManager.ChangeCursorOnMouseMove = true
		NitrousGraphicsManager.ProgressiveRendering() false
	)
else print "Not Nitro Mode"
)

macroScript JV_NitroLowQuality
category:"Vla"
	toolTip:"JV Set Nitrous to Low Quality Settings"
	buttonText:"NiLQ"
	Icon:#("jvMaxTame",6)
(
NitroSmall() --set texture size to 256
)

macroScript JV_EPoly_UnHide
category:"Vla"
	toolTip:"JV Unhide All Faces (EPoly)"
	buttonText:"Unh"
	Icon:#("jvMaxTame",1)
(
	-- Active in Vertex, Face, Element levels:
	On IsEnabled Return Filters.Is_EPolySpecifyLevel #{2,5..6}
	On IsVisible Return Filters.Is_EPolySpecifyLevel #{2,5..6}

	On Execute Do (
		Try (
			local A = Filters.GetModOrObj()
			if (Filters.Is_This_EditPolyMod A) then
			(
				if (subobjectlevel == 1) then A.ButtonOp #UnhideAllVertex
				else A.ButtonOp #UnhideAllFace
			)
			else A.buttonOp #UnhideAll
		)
		Catch(MessageBox "UnHide All Polygons Error" Title:"JV Macros")
	)
)

macroScript JV_EPoly_HideSelected
category:"Vla"
	toolTip:"JV Hide Selected Faces (EPoly)"
	buttonText:"Hide"
	Icon:#("jvMaxTame",2)
(
	-- Active in Vertex, Face, Element levels:
	On IsEnabled Return Filters.Is_EPolySpecifyLevel #{2,5..6}
	On IsVisible Return Filters.Is_EPolySpecifyLevel #{2,5..6}

	On Execute Do (
		Try(
			local A = Filters.GetModOrObj()
			if (Filters.Is_This_EditPolyMod A) then
			(
				if (subobjectlevel == 1) then A.ButtonOp #HideVertex
				else A.ButtonOp #HideFace
			)
			else A.buttonOp #HideSelection
		)
		Catch(MessageBox "Hide Selected Polygons Error" Title:"JV Macros")
	)

)

macroScript JV_EPoly_HideUnSelected
category:"Vla"
	toolTip:"JV Hide UnSelected Faces (EPoly)"
	buttonText:"HidU"
	Icon:#("jvMaxTame",3)
(
	-- Active in Vertex, Face, Element levels:
	On IsEnabled Return Filters.Is_EPolySpecifyLevel #{2,5..6}
	On IsVisible Return Filters.Is_EPolySpecifyLevel #{2,5..6}

	On Execute Do (
		Try(
			local A = Filters.GetModOrObj()
			if (Filters.Is_This_EditPolyMod A) then
			(
				if (subobjectlevel == 1) then A.ButtonOp #HideUnselectedVertex
				else A.ButtonOp #HideUnselectedFace
			)
			else A.buttonOp #HideUnselected
		)
		Catch(MessageBox "Hide UnSelected Polygons Error" Title:"JV Macros")
	)
)

macroScript JV_SnapDisplay
category:"Vla"
	toolTip:"JV Make snap mode obvious"
	buttonText:"SnVis"
	Icon:#("jvMaxTame",3)
(
	-- Active in Vertex, Face, Element levels:
	--On IsEnabled Return Filters.Is_EPolySpecifyLevel #{2,5..6}
	--On IsVisible Return Filters.Is_EPolySpecifyLevel #{2,5..6}
	
	On IsEnabled Return snapMode.active
	On IsVisible Return snapMode.active

)

macroScript JV_Duplicate
category:"Vla"
	toolTip:"JV Duplicate whatever is selected (EPoly subobjects or whole objects)"
	buttonText:"Dupe"
	Icon:#("AddPreset",1)
(
	
	case of
		(
	(selection.count == 0): print "None"
	(Filters.Is_EPolySpecifyLevel #{2,5..6} == true): (
					Try (
				local A = Filters.GetModOrObj()
				if (Filters.Is_This_EditPolyObj A) then (
					if (A.GetMeshSelLevel() != #Object) then $.EditablePoly.buttonOp #Detach
				) else (
					if (subobjectlevel == 1) then (A.PopupDialog #DetachVertex)
					else if (subobjectLevel > 1) then (A.PopupDialog #DetachFace)
				)
			)
			Catch(MessageBox "crapped out" Title:PolyDetach)
		)
		
	--(Filters.Is_EPolySpecifyLevel #{1} == true): print "EPoly Object"
	--(Filters.Is_EPolySpecifyLevel #{2} == true): jv_detach() 
	--(Filters.Is_EPolySpecifyLevel #{3} == true): print "edge"
	--(Filters.Is_EPolySpecifyLevel #{4} == true): print "border"
	--(Filters.Is_EPolySpecifyLevel #{5} == true): print "face"
	--(Filters.Is_EPolySpecifyLevel #{6} == true): print "element"
	--(classof selection[1].baseobject == Editable_Mesh): print "Mesh"

	(selection.count > 0): actionMan.executeAction 0 "40213"  -- Edit: Clone
	--(selection.count > 0): maxops.cloneNodes $ --Direct Clone, no questions asked

		default: print "oops.."
		)
)

macroScript JV_SwitchCoordCenter
category:"Vla"
	toolTip:"JV Switch Coordinate Center"
	buttonText:"Coord"
	icon:#("standard", 1)
(

case of ( 
	(getCoordCenter() == #local) : setCoordCenter #selection 
	(getCoordCenter() == #selection)  : setCoordCenter #system
	(getCoordCenter() == #system) :  setCoordCenter #local
	)
enableCoordCenter false
enableCoordCenter true	
--toolMode.selectionCenter() 
)



macroScript JV_SwitchCoordCenter
category:"Vla"
	toolTip:"JV TiCount"
	buttonText:"Tri"
	icon:#("standard", 1)
(

unregisterRedrawViewsCallback GW_drawTriangleCount
fn GW_drawTriangleCount =
(
	fn getTriCount obj =
	(
		local triCount = 0
		local totalCount = 0
		if selection.count != 0 then
			(
				-- Count triangles in selected objects and keep a running total count
                for i in selection do
				(
					triCount = (getTrimeshFaceCount i)[1]
					totalCount += triCount
				)
				return (totalCount as string) + " Triangles"
			)
		else return "Nothing selected"
	)
-- get the center of the window's width
local winWidth = (gw.getWinSizeX() / 2 - 20)
-- run the function and display the triangle count in the ~upper center of the viewport
gw.wtext [winWidth, 19, 10] (getTriCount selection) color:yellow
)
registerRedrawViewsCallback GW_drawTriangleCount
)




macroScript JV_SaveAs2011
category:"Vla"
	toolTip:"JV save2011"
	buttonText:"2011"
	icon:#("jvMaxTame", 10)
(
maxFile = (maxFilePath + maxFileName);

if (maxFile == "") then max file saveAs;
	else (
	saveRes = saveMaxFile maxfile saveAsVersion:2011 clearNeedSaveFlag:true useNewFile:false quiet:false;
		--print saveRes;
		if (saveRes == false) then (max file saveAs;)
	)
)


