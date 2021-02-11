# numberplatesCH
Detections of Swiss car number plates

Original Script by: https://mathworks.com/matlabcentral/fileexchange/54456-licence-plate-recognition

This MATLAB Solution provides image detection of Swiss car number plates. The trainingfile can be trained to detect other images aswell. 
<hr>
<b> Training </b>

If you want to train the algorithm to your needs you can do so. The reference file is 'imgfildata.mat'. All image are stored in a two dimensional cell array. (black and white, 1 or 0). To "train" the 'imgfildata.mat' you shall use the 'training_imgfildata.m' script.

Images have to be two dimensional to store them into 'imgfildata.mat'. You can use our script to detect characters and automatticaly invert them and store then to a path with the file extension you need. Look at 'learning_edited.m' for that.

<hr>
<h1> Files </h1>

<i> number_plate_det.m </i> -> is the actual detection script <br>
<i> imgfildata.mat </i> -> reference file with trained characters <br>
<i> training_imgfildata.m </i>-> script to write into imgfildata.mat <br>
<i> learning_edited.m </i> -> script to parse all characters from an image, invert them and store them individually 
