# numberplatesCH
Detections of Swiss car number plates

Original Script by: https://mathworks.com/matlabcentral/fileexchange/54456-licence-plate-recognition

This MATLAB Solution provides image detection of Swiss car number plates. The trainingfile can be trained to detect other images aswell. 
<hr>
<h2> Training </h2>

If you want to train the algorithm to your needs you can do so. The reference file is 'imgfildata.mat'. All image are stored in a two dimensional cell array. (black and white, 1 or 0). To "train" the 'imgfildata.mat' you shall use the 'training_imgfildata.m' script.

Images have to be two dimensional to store them into 'imgfildata.mat'. You can use our script to detect characters and automatticaly invert them and store then to a path with the file extension you need. Look at 'learning_edited.m' for that.

<hr>
<h2> Files </h2>

<i> number_plate_det.m </i> -> is the actual detection script <br>
<i> Training\imgfildata.mat </i> -> reference file with trained characters <br>
<i> Training\training_imgfildata.m </i>-> script to write into imgfildata.mat <br>
<i> learning_edited.m </i> -> script to parse all characters from an image, invert them and store them individually 

<h3> Training Folder </h3>
All data related to training is there. 'letters_numbers' folder is used for a reference when executing 'training_imgfildata.m' <br>
Make sure your images are inverted and only contain black and white (0 and 1). Also the size msut be 24x42px (can be adjusted). <br>
The filename is used to write the desired letter into the 'imgfildata.mat' file. If you name the file 'L' that means that the file named 'L' is your reference for a 'L'.

<b> Kennzeichen Folder </b>
You'll find some sample files there
