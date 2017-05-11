// Written by Puifai Santisakultarm on 5/11/2017
// requires Bio-Formats

// This script creates time-series videos for each image color
// Input:  .nd2 files. Each file with multiple channels, but 1 time point
// Output:  .avi files for each channel
// Example:  Your folder contains 10 .nd2 files. Each file has 4 channels. You will end up with 4 .avi files, each with 10 frames

// when this is true, the script runs faster but images are hidden
setBatchMode(true);

// get array of file names inside the selected folder
path = getDirectory("Select folder which contain files to be analyzed");
print(path) 
filelist = getFileList(path);

for (i=0; i< filelist.length; i++) {

	print("Opening: "+ filelist[i]);
	
	// process .nd2 files only
	if (endsWith(filelist[i], ".nd2"))  {
		 // open each file with Bio-Formats
         run("Bio-Formats Importer", "open=[" + path + filelist[i] + "] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	}
}

// concatenate the stacks
run("Concatenate...", "all_open title=[Time Series]");
		 
// split channels
run("Split Channels");

// save each as a video file
for (i=0; i< 4; i++) {
	fileToSave = "C" + i+1 + "-Time Series";
	selectWindow(fileToSave);
	print("Saving:  " + fileToSave);
	savePathAndName = path + fileToSave + ".avi";
	run("AVI... ", "compression=JPEG frame=7 save=[savePathAndName]");
}

print("Analysis Completed");
run("Close All");
setBatchMode(false);