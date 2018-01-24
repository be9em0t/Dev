// check that some tabs are open
openTabs = app.documents;

// psd options
var savePSDOptions = new PhotoshopSaveOptions();
savePSDOptions.alphaChannels = true;
savePSDOptions.annotations = true;
savePSDOptions.embedColorProfile = false;
savePSDOptions.layers = true;
savePSDOptions.spotColors = false;	

// bmp save options;
var saveBMPOptions = new BMPSaveOptions();
saveBMPOptions.alphaChannels = false;
saveBMPOptions.depth = BMPDepthType.EIGHT;

if (openTabs.length == 3)
{
   for (var i = 0; i < openTabs.length; i++)
   {
      app.activeDocument = openTabs[i]; 	// switch to document tab
      // alert(app.activeDocument.name);
      ExportIconTab();
   }		
}
else alert("Need exactly 3 icons open. Got " + openTabs.length)

CloseAll();   
   
// Export tab as BMP
function ExportIconTab()
{
   docLayers = activeDocument.layers;
   tabName = app.activeDocument.name;
	var w = app.activeDocument.width;
	var h = app.activeDocument.height;

   // Select which icon to save
   	if ((w == 80) && (h == 80))
	{
      // alert(app.activeDocument.name);
      CheckLayerCount(3);
      iconSize = "80x80";
      SaveBMP(iconSize);
      // iconPath = app.activeDocument.path;
      // iconName = app.activeDocument.name;
      // app.doAction("Convert_Icon2bmp (script only)","TomTom LM icons.ATN")
      // saveFile = new File(iconPath + "\\" + "_" + iconSize + " copy.bmp");
      // app.activeDocument.saveAs(saveFile, savePSDOptions, false, Extension.LOWERCASE);
      // app.activeDocument.saveAs(saveFile, saveBMPOptions, true, Extension.LOWERCASE);
      // app.activeDocument.close(savePSDOptions.DONOTSAVECHANGES)
      // alert(iconSize + " : " + iconPath + " : " + iconName);
	}	
	else if ((w == 64) && (h == 64))
	{
      // alert(app.activeDocument.name);
      CheckLayerCount(3);
      iconSize = "64x64";
      SaveBMP(iconSize);
      // iconPath = app.activeDocument.path;
      // iconName = app.activeDocument.name;
      // app.doAction("Convert_Icon2bmp (script only)","TomTom LM icons.ATN")
      // saveFile = new File(iconPath + "\\" + "_" + iconSize + " copy.bmp");
      // app.activeDocument.saveAs(saveFile, savePSDOptions, false, Extension.LOWERCASE);
      // app.activeDocument.saveAs(saveFile, saveBMPOptions, true, Extension.LOWERCASE);
      // app.activeDocument.close(savePSDOptions.DONOTSAVECHANGES)
      // alert(iconSize + " : " + iconPath + " : " + iconName);
	}	
	else if ((w == 32) && (h == 32))
	{
      // alert(app.activeDocument.name);
      CheckLayerCount(2);
      iconSize = "32x32";
      SaveBMP(iconSize);
      // iconPath = app.activeDocument.path;
      // iconName = app.activeDocument.name;
      // app.doAction("Convert_Icon2bmp (script only)","TomTom LM icons.ATN")
      // saveFile = new File(iconPath + "\\" + "_" + iconSize + " copy.bmp");
      // app.activeDocument.saveAs(saveFile, savePSDOptions, false, Extension.LOWERCASE);
      // app.activeDocument.saveAs(saveFile, saveBMPOptions, true, Extension.LOWERCASE);
      // app.activeDocument.close(savePSDOptions.DONOTSAVECHANGES)
      // alert(iconSize + " : " + iconPath + " : " + iconName);
	}	
   else {alert("Invalid icon sise!");}
   return;
}

function CloseAll()
{
   do
   {
   app.activeDocument.close( SaveOptions.DONOTSAVECHANGES );
   } 
   while (app.documents.length > 0);
   return;
}
     
function SaveBMP(iconSize)
{
   iconPath = app.activeDocument.path;
   iconName = app.activeDocument.name;
   saveFilePSD = new File(iconPath + "\\" + "_" + iconSize + ".psd");
   saveFileBMP = new File(iconPath + "\\" + "_" + iconSize + " copy.bmp");
   app.activeDocument.saveAs(saveFilePSD, savePSDOptions, false, Extension.LOWERCASE);
   app.doAction("Convert_Icon2bmp (script only)","TomTom LM icons.ATN")
   app.activeDocument.saveAs(saveFileBMP, saveBMPOptions, true, Extension.LOWERCASE);
	return;
   
}

   // Check layer count
function CheckLayerCount(countTarget)
{
   if (docLayers.length != countTarget)
   {
      alert("Missig layers! " + docLayers.length)
      throw new Error("First close any open documents in Photoshop");      
   }
   return;
}


