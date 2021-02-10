%{
    License Plate Recogniton

    - This file is used to extract characters from a image, Invert them
    into two-dimensional Images and store the output to feed the training
    file
    

    Forked from: https://ch.mathworks.com/matlabcentral/fileexchange/54456-licence-plate-recognition

    Author: Nicola Wipfli, Maurus Michel, Yannick Gerber
    License: MIT
    Copyright: 2021 Nicola Wipfli, Maurus Michel, Yannick Gerber
    
    Required Dependencies: None
    Optional Dependencies: None
%}

% clear
clc
close all;
clear;

%load trainingfile (this file is our reference for the image detection)
load imgfildata;

% prompt for picture to scan
[file,path]=uigetfile({'*.jpg;*.bmp;*.png;*.tif'},'Choose an image');
s=[path,file];
picture=imread(s);
[~,cc]=size(picture);
picture=imresize(picture,[240 500]);

%RGB image is transformed into greyscale image
if size(picture,3)==3
  picture=rgb2gray(picture);
end

%character detection
threshold = graythresh(picture);
picture =~im2bw(picture,threshold);
picture = bwareaopen(picture,24);
imshow(picture)
if cc>2000
    picture1=bwareaopen(picture,7500);
else
picture1=bwareaopen(picture,5000);
end
figure,imshow(picture1)
picture2=picture-picture1;
figure,imshow(picture2)
picture2=bwareaopen(picture2,20);
figure,imshow(picture2)


%bounding box
[L,Ne]=bwlabel(picture2);
propied=regionprops(L,'BoundingBox');
hold on
pause(1)
for n=1:size(propied,1)
  rectangle('Position',propied(n).BoundingBox,'EdgeColor','g','LineWidth',2)
end
hold off

figure
final_output=[];
t=[];

%image resize to 24x42 px
kb=1;
for n=1:Ne
    
  
  [r,c] = find(L==n);
  n1=picture(min(r):max(r),min(c):max(c));
  n1=imresize(n1,[42,24]);
  imshow(n1)
  pause(0.2)
  x=[ ];

totalLetters=size(imgfile,2);

% saves all the detected characters to individual files.

baseFileName='bildli'; 
    baseFileName=[baseFileName,num2str(kb),'.tif']
    fullFileName = fullfile('D:\matlab\testtraining', baseFileName);
    imwrite(n1, fullFileName);
    kb = kb + 1;

 for k=1:totalLetters
    
    y=corr2(imgfile{1,k},n1);
    x=[x y];
  
 end
 
% Use to define the accuracy from image to reference file
% define max(x)>.5 as you preffer
% 1 > correlation > 0 

 t=[t max(x)];
 if max(x)>.45
 z=find(x==max(x));
 out=cell2mat(imgfile(2,z));

final_output=[final_output out];
end
end

