/*
Setup:
Copy "JV Processor.jsx", 200x216.psd, 320x480.psd, 320x240.psd to c:\\Work\\JVProcessing

Usage:
The script loads PNG render images (arrow + render) from c:\\Work\\JVProcessing.
PNGs are created in Max, using JVRenderUI script or macroscript.
In that directory there should be also the PSD template files.
Photoshop should be running, and actions from "TomTom 2d JVs lod3.atn" should be loaded.

The script creates necessary export subdirs based on render file names.
Dont forget to copy over 3DSMax file and textures to the empty 3dscene dir.

To edit existing PSDs they need to be in their relative 320x240, 200x216 etc. dirs
*/


// store source renders in c:\\Work\\JVProcessing
var sourceFolder = Folder("c:\\Work\\JVProcessing\\");
var psdTemplates = Folder("c:\\Work\\JVProcessing\\");
var countryPref = "aus3deg"; 	//file prefix string


var fileListPNG = sourceFolder.getFiles("*.png"); 
var files200x216 = new Array(); //array of 200px files to process
var files320x480 = new Array(); //array of 320px files to process
var files320x240 = new Array(); //array of landscape 320x240px files to process
var source200x216PSD = File(psdTemplates + "\\" + "200x216.psd");
var source320x480PSD = File(psdTemplates + "\\" + "320x480.psd");
var source320x240PSD = File(psdTemplates + "\\" + "320x240.psd");
var w320 = 320;
var h320 = 480;
var w200 = 200;
var h200 = 216;
var jvNameArr = new Array(); 	//arrays of files from the same JV
var jvNameStr = "start";				//current JV name string
var fileNameExt;

var jvView;	//name of JV derived from tab in PS
var jvTime; //jv time name (i.e.d01)
var openTabs;
var tabName;

var reValidName = new RegExp("[\\|/][0-9]{6}_HQ_(200x216|320x480|320x240)(cam|dir)[0-9]{2}\.png$", "ig");

var hGuides200 = new Array(4,16,74);
var vGuides200 = new Array(4,13,187,196);
var hGuides320 = new Array(12,30,115);
var vGuides320 = new Array(12,30,290,308);

// psd options
var savePSDOptions = new PhotoshopSaveOptions();
savePSDOptions.alphaChannels = true;
savePSDOptions.annotations = true;
savePSDOptions.embedColorProfile = false;
savePSDOptions.layers = true;
savePSDOptions.spotColors = false;	

// bmp options;
var saveBMPOptions = new BMPSaveOptions();
saveBMPOptions.alphaChannels = false;

// jpg options;
var saveJPEGOptions = new JPEGSaveOptions();
saveJPEGOptions.quality = 8;

// UserUI
var dlg = new Window('dialog', 'Alert Box Builder',[500,300,765,430]);   
dlg.txt1 = dlg.add('statictext', [15,10,215,30], 'Create PDFs or export BMPs?');

// dlg.btnPnl = dlg.add('panel', [15,50,365,115], ''); abs coords: left,top,width,height 

dlg.PSDBtn = dlg.add('button', [0,45,150,75], 'Universal Create PSDs');
dlg.BMPBtn = dlg.add('button', [0,90,150,75], 'Export BMPs');
dlg.cancelBtn = dlg.add('button', [150,90,260,75], 'Cancel', {name:'cancel'});


dlg.PSDBtn.onClick = function() {
	dlg.close();
	checkCleanPS();
	generatePSDs();
	alert("Done. Now add the signboards.");
	
};

dlg.BMPBtn.onClick = function() {
	dlg.close();
	evaluateTabsBMPexport();
	alert("Finished exporting.");
};
 
dlg.show();  


// Universal function - generate PSD from folder
function generatePSDs() {
	if (sourceFolder != null)
	{		
	// Check that valid files are available
	for (var i = 0; i < fileListPNG.length; i++)
	{
		fileNameExt = fileListPNG[i].toString().match(reValidName);
		// if this is a valid filename
		if (fileNameExt != null)
		{
			jvNameArr.push(fileListPNG[i]);
		}
	}

	// stop execution if sources are not even number
	if (isOdd(jvNameArr.length))
	{
		alert("Source file count error: " + jvNameArr.length);
		return;
	}

		// Process all cam files
	for (var i = 0; i < jvNameArr.length; i++)
	{
		fileNameExt = fileListPNG[i].toString().match(reValidName);			
		jvNameStr = fileNameExt.toString().substr(1,6);
		if (fileNameExt.toString().match("cam"))
		{
			if (fileNameExt.toString().match("_200x216"))
			{
				pTemplate200x216Doc = app.open(source200x216PSD);
				create200x216(i);
			}
			else if (fileNameExt.toString().match("_320x480"))
			{
				pTemplate320x480Doc = app.open(source320x480PSD);
				create320x480(i);
			}
			else if (fileNameExt.toString().match("_320x240"))
			{
				pTemplate320x240Doc = app.open(source320x240PSD);
				create320x240(i);
			}
			else 
			{
					alert("Weird png found " + i);
			}

		}
	}
	}
}

function create200x216(item)
{	
	filenameNew = countryPref + jvNameStr + fileNameExt.toString().substr(21,2); 
	pMasterDoc = documents.add(w200, h200, 72, filenameNew, NewDocumentMode.RGB)

	// copy layers to the new document
	app.activeDocument = pTemplate200x216Doc;
	app.activeDocument.artLayers[2].duplicate(pMasterDoc);
	app.activeDocument.artLayers[1].duplicate(pMasterDoc);
	app.activeDocument.artLayers[0].duplicate(pMasterDoc);
	app.activeDocument = pMasterDoc;
	pMasterDoc.backgroundLayer.remove();
	
	// load cam PNG as layer
	app.load(fileListPNG[item]);
	app.activeDocument.artLayers[0].duplicate(pMasterDoc);
	app.activeDocument.close(savePSDOptions.DONOTSAVECHANGES);
	app.activeDocument = pMasterDoc;
	
	// sort and merge the fckin layers
	activeDocument.activeLayer.move(activeDocument.layers[activeDocument.layers.length-1],ElementPlacement.PLACEBEFORE);  
	activeDocument.activeLayer.duplicate(activeDocument.layers[activeDocument.layers.length-3],ElementPlacement.PLACEBEFORE);  
	activeDocument.activeLayer = activeDocument.layers[activeDocument.layers.length-4];
	mergeDown();
	activeDocument.activeLayer = activeDocument.layers[activeDocument.layers.length-4];
	mergeDown();
	activeDocument.activeLayer.name = "night scene";
	activeDocument.activeLayer = activeDocument.layers[activeDocument.layers.length-2];
	mergeDown();
	activeDocument.activeLayer.name = "day scene";

	// load dir PNG as layer	
	var strDir = fileListPNG[item].toString();
	var newDir = strDir.replace(/cam/g, "dir");
	app.load(File(newDir));
	app.activeDocument.artLayers[0].duplicate(pMasterDoc);
	app.activeDocument.close(savePSDOptions.DONOTSAVECHANGES)
	activeDocument.activeLayer.name = "arrows";
	app.doAction("Arrows Small 200x216","TomTom 2d JVs lod3.ATN")
	
	// create save 200x216 PSD options and folder
	saveFile = new File(sourceFolder + "\\" + jvNameStr + "\\200x216\\psd\\" + filenameNew );
	saveFolder = new Folder(sourceFolder + "\\" + jvNameStr + "\\200x216\\psd\\");
	if(!saveFolder.exists) saveFolder.create();
	
	// create guides
	buildGuides()
	
	// save as new PSD
	app.activeDocument.saveAs(saveFile, savePSDOptions, false, Extension.LOWERCASE);

	// close template PSD
	app.activeDocument = pTemplate200x216Doc;
	app.activeDocument.close(savePSDOptions.DONOTSAVECHANGES);
}

function create320x480(item)
{
	// create new document
	var filenameNew = countryPref + jvNameStr + fileNameExt.toString().substr(21,2); 
	pMasterDoc = documents.add(w320, h320, 72, filenameNew, NewDocumentMode.RGB)

	// copy layers to the new document
	app.activeDocument = pTemplate320x480Doc;
	app.activeDocument.artLayers[2].duplicate(pMasterDoc);
	app.activeDocument.artLayers[1].duplicate(pMasterDoc);
	app.activeDocument.artLayers[0].duplicate(pMasterDoc);
	app.activeDocument = pMasterDoc;
	pMasterDoc.backgroundLayer.remove();
	
	// load cam PNG as layer
	app.load(fileListPNG[item]);
	app.activeDocument.artLayers[0].duplicate(pMasterDoc);
	app.activeDocument.close(savePSDOptions.DONOTSAVECHANGES);
	app.activeDocument = pMasterDoc;
	
	// sort and merge the layers
	activeDocument.activeLayer.move(activeDocument.layers[activeDocument.layers.length-1],ElementPlacement.PLACEBEFORE);  
	activeDocument.activeLayer.duplicate(activeDocument.layers[activeDocument.layers.length-3],ElementPlacement.PLACEBEFORE);  
	activeDocument.activeLayer = activeDocument.layers[activeDocument.layers.length-4];
	mergeDown();
	activeDocument.activeLayer = activeDocument.layers[activeDocument.layers.length-4];
	mergeDown();
	activeDocument.activeLayer.name = "night scene";
	activeDocument.activeLayer = activeDocument.layers[activeDocument.layers.length-2];
	mergeDown();
	activeDocument.activeLayer.name = "day scene";

	// load dir PNG as layer	
	var strDir = fileListPNG[item].toString();
	var newDir = strDir.replace(/cam/g, "dir");
	app.load(File(newDir));
	app.activeDocument.artLayers[0].duplicate(pMasterDoc);
	app.activeDocument.close(savePSDOptions.DONOTSAVECHANGES)
	activeDocument.activeLayer.name = "arrows";
	app.doAction("Arrows Big 320x480","TomTom 2d JVs lod3.ATN")

	// create save 320x480 PSD options and folder
	saveFile = new File(sourceFolder + "\\" +  jvNameStr + "\\320x480\\psd\\" + filenameNew );	
	saveFolder = Folder(sourceFolder + "\\" + jvNameStr + "\\320x480\\psd\\");
	if (!saveFolder.exists) saveFolder.create();

	
	// create 3dscene folder
	saveFolder = Folder(sourceFolder + "\\" + jvNameStr + "\\3dscene\\");
	if(!saveFolder.exists) saveFolder.create();
	
	// create guides
	buildGuides()	
	
	// save as new 320x480 PSD
	app.activeDocument.saveAs(saveFile, savePSDOptions, false, Extension.LOWERCASE);

	// close template PSD		
	app.activeDocument = pTemplate320x480Doc;
	app.activeDocument.close(savePSDOptions.DONOTSAVECHANGES);
}

function create320x240(item)
{	
	filenameNew = countryPref + jvNameStr + fileNameExt.toString().substr(21,2); 
	// pMasterDoc = documents.add(320, 240, 72, filenameNew, NewDocumentMode.RGB)

	// copy layers to the new document
	app.activeDocument = pTemplate320x240Doc;
	pMasterDoc = app.activeDocument.duplicate(filenameNew);

	
	// load cam PNG as layer
	app.load(fileListPNG[item]);
	app.activeDocument.artLayers[0].duplicate(pMasterDoc);
	app.activeDocument.close(savePSDOptions.DONOTSAVECHANGES);
	app.activeDocument = pMasterDoc;
	pMasterDoc.backgroundLayer.remove();
	app.doAction("(3d) day and night from scene layer320x240 landscape","TomTom 2d JVs lod3.ATN");
	
	// load dir PNG as layer	
	var strDir = fileListPNG[item].toString();
	var newDir = strDir.replace(/cam/g, "dir");
	app.load(File(newDir));
	app.activeDocument.artLayers[0].duplicate(pMasterDoc);
	app.activeDocument.close(savePSDOptions.DONOTSAVECHANGES)
	app.activeDocument = pMasterDoc;
	activeDocument.activeLayer.name = "arrows";
	app.doAction("Arrows Landscape 320x240","TomTom 2d JVs lod3.ATN");

	// create save 320x240 PSD options and folder
	saveFile = new File(sourceFolder + "\\" + jvNameStr + "\\320x240\\psd\\" + filenameNew );
	saveFolder = new Folder(sourceFolder + "\\" + jvNameStr + "\\320x240\\psd\\");
	if(!saveFolder.exists) saveFolder.create();
	
	// save as new PSD
	app.activeDocument.saveAs(saveFile, savePSDOptions, false, Extension.LOWERCASE);

	// close template PSD	
	app.activeDocument = pTemplate320x240Doc;
	app.activeDocument.close(savePSDOptions.DONOTSAVECHANGES);
}


// function to build guides depending ot document size
function buildGuides()
{
	var w = app.activeDocument.width;
	var h = app.activeDocument.height;
	if ((w == 200) && (h == 216))
	{
		for (var i = 0; i < hGuides200.length; i++)
		{
			app.activeDocument.guides.add(Direction.HORIZONTAL, hGuides200[i]);
		}	
		for (var i = 0; i < vGuides200.length; i++)
		{
			app.activeDocument.guides.add(Direction.VERTICAL, vGuides200[i]);
		}	
	}
	else if ((w == 320) && (h == 480))
	{
		for (var i = 0; i < hGuides320.length; i++)
		{
			app.activeDocument.guides.add(Direction.HORIZONTAL, hGuides320[i]);
		}	
		for (var i = 0; i < vGuides320.length; i++)
		{
			app.activeDocument.guides.add(Direction.VERTICAL, vGuides320[i]);
		}	
	}
	else
	{
		alert("Wrong document size: " + w + " x " + h);
	}
}

///////////////////////////////////////////////////////////////////////////////
// Function: mergeDown
// Usage: merges the currently selected layers into one layer. If only one layer is selected it merges the current layer down into the layer below
// Input: <none> Must have an open document
// Return: <none>
///////////////////////////////////////////////////////////////////////////////
function mergeDown() 
	{
		try 
		{
			var id828 = charIDToTypeID( "Mrg2" );
			var desc168 = new ActionDescriptor();
			executeAction( id828, desc168, DialogModes.NO );
		}
		catch(e) 
		{
			; // do nothing
		}
	}

// functions to test even/odd
function isEven(n) {
   return n % 2 == 0;
}

function isOdd(n) {
   return Math.abs(n % 2) == 1;
}

// check that PS is empty
function checkCleanPS()
{
	openTabs = app.documents;
	if (openTabs.length > 0)
	{
		alert("First close any open documents in Photoshop");
		throw new Error("First close any open documents in Photoshop");
	}
}

function saveCloseTabs()
{
	// check that some tabs are open
	openTabs = app.documents;
	alert(openTabs.length);
	if (openTabs.length > 0)
	{
		for (var i = 0; i < openTabs.length; i++)
		{
			alert(i);
			// app.activeDocument = openTabs[i]; 	// switch to document tab
			app.activeDocument.save();				// save tab
			app.activeDocument.close(savePSDOptions.DONOTSAVECHANGES);
		}		
	}
	else alert("No tabs seem to be open.")
}

// Second root function - generate and save BMPs from open tabs
function evaluateTabsBMPexport()
{
	// check that some tabs are open
	openTabs = app.documents;
	if (openTabs.length > 0)
	{
		for (var i = 0; i < openTabs.length; i++)
		{
			app.activeDocument = openTabs[i]; 	// switch to document tab
			app.activeDocument.save();				// save tab
			exportBMPtab();							// export
		}		
	}
	else alert("No tabs seem to be open.")
}
	
// Export tab as BMP
function exportBMPtab()
{
	docLayers = activeDocument.layers;

	// Check layer count
	if (docLayers.length == 7) {
		// Verify and fix layer names for standard versions
		for (i = 0; i < docLayers.length; i++) {	
			switch (i) {
				case 0: if (docLayers[i].name != "signboard") { docLayers[i].name = "signboard"; };
					break;
				
				case 1: if (docLayers[i].name != "night arrows 02") { alert("Wrong layer: " + [i + 1] + " : " + docLayers[i].name); };
					break;

				case 2: if (docLayers[i].name != "night arrows 01") { alert("Wrong layer: " + [i + 1] + " : " + docLayers[i].name); };
					break;

				case 3: if (docLayers[i].name != "day arrows 02") { alert("Wrong layer: " + [i + 1] + " : " + docLayers[i].name); };
					break;

				case 4: if (docLayers[i].name != "day arrows 01") { alert("Wrong layer: " + [i + 1] + " : " + docLayers[i].name); };
					break;

				case 5: if (docLayers[i].name != "night scene") { alert("Wrong layer: " + [i + 1] + " : " + docLayers[i].name); };
					break;

				case 6: if (docLayers[i].name != "day scene") { alert("Wrong layer: " + [i + 1] + " : " + docLayers[i].name); };
					break;
				
				default: alert("Layers are screwed")
				}			
			}
		}
	else if (docLayers.length == 4) {
		// Verify and fix layer names for lanscape versions
		for (i = 0; i < docLayers.length; i++) {	
			switch (i) {
				case 0: if (docLayers[i].name != "signboard") { docLayers[i].name = "signboard"; };
					break;
				
				case 1: if (docLayers[i].name != "arrows") { alert("Wrong layer: " + [i + 1] + " : " + docLayers[i].name); };
					break;

				case 2: if (docLayers[i].name != "night scene") { alert("Wrong layer: " + [i + 1] + " : " + docLayers[i].name); };
					break;

				case 3: if (docLayers[i].name != "day scene") { alert("Wrong layer: " + [i + 1] + " : " + docLayers[i].name); };
					break;
				
				default: alert("Layers are screwed")
				}			
			}
	}
	else{ 
			alert("Missig layers!")
		return;
	}

	
	// create BMP save options and call relevant export function
	tabName = app.activeDocument.name;
	jvNameStr = tabName.toString().substr(7,6);
	jvView = tabName.toString().substr(13,2); 
	var w = app.activeDocument.width;
	var h = app.activeDocument.height;
	if ((w == 200) && (h == 216))
	{
		jvSize = "\\200x216\\"
		jvTime = "d01";
		layersExportD01();
		saveFile = new File(sourceFolder + "\\" + jvNameStr + jvSize + countryPref + jvNameStr + jvView + jvTime );
		jvTime = "d02";
		layersExportD02();
		saveFile = new File(sourceFolder + "\\" + jvNameStr + jvSize + countryPref + jvNameStr + jvView + jvTime );
		jvTime = "n01";
		layersExportN01();
		saveFile = new File(sourceFolder + "\\" + jvNameStr + jvSize + countryPref + jvNameStr + jvView + jvTime );
		jvTime = "n02";
		layersExportN02();
		saveFile = new File(sourceFolder + "\\" + jvNameStr + jvSize + countryPref + jvNameStr + jvView + jvTime );
	}	
	else if ((w == 320) && (h == 480))
	{
		jvSize = "\\320x480\\"
		jvTime = "d01";
		layersExportD01();
		saveFile = new File(sourceFolder + "\\" + jvNameStr + jvSize + countryPref + jvNameStr + jvView + jvTime );
		jvTime = "d02";
		layersExportD02();
		saveFile = new File(sourceFolder + "\\" + jvNameStr + jvSize + countryPref + jvNameStr + jvView + jvTime );
		jvTime = "n01";
		layersExportN01();
		saveFile = new File(sourceFolder + "\\" + jvNameStr + jvSize + countryPref + jvNameStr + jvView + jvTime );
		jvTime = "n02";
		layersExportN02();
		saveFile = new File(sourceFolder + "\\" + jvNameStr + jvSize + countryPref + jvNameStr + jvView + jvTime );	
	}	
	else if ((w == 320) && (h == 240))
	{
		jvSize = "\\320x240\\"
		jvTime = "d01";
		layersExportD01_4layers_jpg();
		saveFile = new File(sourceFolder + "\\" + jvNameStr + jvSize + countryPref + jvNameStr + jvView + jvTime );
		jvTime = "n01";
		layersExportN01_4layers_jpg();
		saveFile = new File(sourceFolder + "\\" + jvNameStr + jvSize + countryPref + jvNameStr + jvView + jvTime );
	}	
	
	// var input2 = confirm("Save and close all tabs?");
	// if (input2 == true)
	// {	
	// saveCloseTabs();
	// }
}

// export D1 version JPEG 4Layers
function layersExportD01_4layers_jpg()
{
	for (i = 0; i < docLayers.length; i++)
	{	
		switch (i)
		{
			case 0: docLayers[i].visible=true;
			break;
			
			case 1: docLayers[i].visible=true;
			break;

			case 2: docLayers[i].visible=false;
			break;

			case 3: docLayers[i].visible=true;
			break;
			
			default: alert("Layers are screwed")
		}						
	}
	saveFile = new File(sourceFolder + "\\" + jvNameStr + jvSize + countryPref + jvNameStr + jvView + jvTime );

	// save as new JPEG
	app.activeDocument.saveAs(saveFile, saveJPEGOptions, true, Extension.LOWERCASE);
	return;
}

// export N1 version JPEG 4Layers
function layersExportN01_4layers_jpg()
{
	for (i = 0; i < docLayers.length; i++)
	{	
		switch (i)
		{
			case 0: docLayers[i].visible=true;
			break;
			
			case 1: docLayers[i].visible=true;
			break;

			case 2: docLayers[i].visible=true;
			break;

			case 3: docLayers[i].visible=true;
			break;
			
			default: alert("Layers are screwed")
		}						
	}
	saveFile = new File(sourceFolder + "\\" + jvNameStr + jvSize + countryPref + jvNameStr + jvView + jvTime );

	// save as new JPEG
	app.activeDocument.saveAs(saveFile, saveJPEGOptions, true, Extension.LOWERCASE);
	return;
}

// export D1 version BMP
function layersExportD01()
{
	for (i = 0; i < docLayers.length; i++)
	{	
		switch (i)
		{
			case 0: docLayers[i].visible=true;
			break;
			
			case 1: docLayers[i].visible=false;
			break;

			case 2: docLayers[i].visible=false;
			break;

			case 3: docLayers[i].visible=false;
			break;

			case 4: docLayers[i].visible=true;
			break;

			case 5: docLayers[i].visible=false;
			break;

			case 6: docLayers[i].visible=true;
			break;
			
			default: alert("Layers are screwed")
		}						
	}
	saveFile = new File(sourceFolder + "\\" + jvNameStr + jvSize + countryPref + jvNameStr + jvView + jvTime );

	// save as new BMP
	app.activeDocument.saveAs(saveFile, saveBMPOptions, true, Extension.LOWERCASE);
	return;
}

// export D2 version BMP
function layersExportD02()
{
	jvTime = "d02";
	for (i = 0; i < docLayers.length; i++)
	{	
		switch (i)
		{
			case 0: docLayers[i].visible=true;
			break;
			
			case 1: docLayers[i].visible=false;
			break;

			case 2: docLayers[i].visible=false;
			break;

			case 3: docLayers[i].visible=true;
			break;

			case 4: docLayers[i].visible=false;
			break;

			case 5: docLayers[i].visible=false;
			break;

			case 6: docLayers[i].visible=true;
			break;
			
			default: alert("Layers are screwed")
		}						
	}
	saveFile = new File(sourceFolder + "\\" + jvNameStr + jvSize + countryPref + jvNameStr + jvView + jvTime );

	// save as new BMP
	app.activeDocument.saveAs(saveFile, saveBMPOptions, true, Extension.LOWERCASE);
	return;
}

// export N1 version BMP
function layersExportN01()
{
	jvTime = "n01";
	for (i = 0; i < docLayers.length; i++)
	{	
		switch (i)
		{
			case 0: docLayers[i].visible=true;
			break;
			
			case 1: docLayers[i].visible=false;
			break;

			case 2: docLayers[i].visible=true;
			break;

			case 3: docLayers[i].visible=false;
			break;

			case 4: docLayers[i].visible=false;
			break;

			case 5: docLayers[i].visible=true;
			break;

			case 6: docLayers[i].visible=false;
			break;
			
			default: alert("Layers are screwed")
		}						
	}
	saveFile = new File(sourceFolder + "\\" + jvNameStr + jvSize + countryPref + jvNameStr + jvView + jvTime );

	// save as new BMP
	app.activeDocument.saveAs(saveFile, saveBMPOptions, true, Extension.LOWERCASE);
	return;
}

// export N2 version BMP
function layersExportN02()
{
	jvTime = "n02";
	for (i = 0; i < docLayers.length; i++)
	{	
		switch (i)
		{
			case 0: docLayers[i].visible=true;
			break;
			
			case 1: docLayers[i].visible=true;
			break;

			case 2: docLayers[i].visible=false;
			break;

			case 3: docLayers[i].visible=false;
			break;

			case 4: docLayers[i].visible=false;
			break;

			case 5: docLayers[i].visible=true;
			break;

			case 6: docLayers[i].visible=false;
			break;
			
			default: alert("Layers are screwed")
		}						
	}
	saveFile = new File(sourceFolder + "\\" + jvNameStr + jvSize + countryPref + jvNameStr + jvView + jvTime );

	// save as new BMP
	app.activeDocument.saveAs(saveFile, saveBMPOptions, true, Extension.LOWERCASE);
	return;
}


