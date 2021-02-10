% Parst Bild durch und speichert die Erkennten Zeichen gleich ab

% clearen
clc
close all;
clear;

%Laden der Trainingsdatei
load imgfildata;

% Prompt für Fileauswahl
[file,path]=uigetfile({'*.jpg;*.bmp;*.png;*.tif'},'Choose an image');
s=[path,file];
picture=imread(s);
[~,cc]=size(picture);
picture=imresize(picture,[240 500]);

%RGB Image in Grayscale verwandeln
if size(picture,3)==3
  picture=rgb2gray(picture);
end

%Zeichen Erkennung
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

%Markierung der Zeichen mit grüner Umrandung (BoundingBox)
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

%Image Resize auf 24x42px
kb=1;
for n=1:Ne
    
  
  [r,c] = find(L==n);
  n1=picture(min(r):max(r),min(c):max(c));
  n1=imresize(n1,[42,24]);
  imshow(n1)
  pause(0.2)
  x=[ ];

totalLetters=size(imgfile,2);

%Speicherung der erkannten Zeichen als .tif / .bmp / .png / .jpeg
%Filename wird inkrementiert

baseFileName='bildli'; 
    baseFileName=[baseFileName,num2str(kb),'.tif']
    fullFileName = fullfile('D:\matlab\testtraining', baseFileName);
    imwrite(n1, fullFileName);
    kb = kb + 1;

 for k=1:totalLetters
    
    y=corr2(imgfile{1,k},n1);
    x=[x y];
  
 end
 
% Einstellung der Erkennungsgenauigkeit.
% 1 > Korrelation > 0 

 t=[t max(x)];
 if max(x)>.45
 z=find(x==max(x));
 out=cell2mat(imgfile(2,z));

final_output=[final_output out];
end
end

