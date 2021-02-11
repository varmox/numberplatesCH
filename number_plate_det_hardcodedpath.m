%{
    License Plate Recogniton

    - Adapted for Usage with Swiss Number Plates
    - Added Error Handling and various output formatrs

    Forked from: https://ch.mathworks.com/matlabcentral/fileexchange/54456-licence-plate-recognition

    Author: Nicola Wipfli, Maurus Michel, Yannick Gerber
    License: MIT
    Copyright: 2021 Nicola Wipfli, Maurus Michel, Yannick Gerber
    
    Required Dependencies: None
    Optional Dependencies: None
%}


%clear
clc
close all;
clear;

%load trainingfile (this file is our reference for the image detection)
load imgfildata;


% hardcoded path
s=['C:\inetpub\wwwroot\LPR\uploads\uploadphoto.jpeg'];


 

picture=imread(s);
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

for n=1:Ne
  [r,c] = find(L==n);
  n1=picture(min(r):max(r),min(c):max(c));
  n1=imresize(n1,[42,24]);
  imshow(n1)
  pause(0.2)
  x=[ ];

totalLetters=size(imgfile,2);

 for k=1:totalLetters
    y=corr2(imgfile{1,k},n1);
    x=[x y];
 end
 
% Use to define the accuracy from image to reference file
% define max(x)>.5 as you preffer
% 1 > correlation > 0 

t=[t max(x)];

if max(x)>.5
 z=find(x==max(x));
 out=cell2mat(imgfile(2,z));
 final_output=[final_output out];
end

end


%error handling
%-----------------

%check canton code. only valid combinations are marked as valid
options = ["ZH", "BE","LU", "UR","SZ", "OW","NW", "GL","ZG", "FR","SO", "BS","BL", "SH","AI", "AR","SG", "GR","AG","TG","TI","VD","VS","NE","GE","JU"];  
if ~any(strcmpi(final_output(1:2), options))
f = msgbox(sprintf('Nummernschild: %s nicht valid, bitte Bild prüfen. (Fehler Kanton)', final_output), 'Fehler','error');
error('Nummernschild: ''%s'' nicht valid, bitte Bild prüfen. (Fehler Kanton)', final_output)
end

%check if the last character is a number. If a letter is deteced, output is
%invalid
letter_in_number( regexp(final_output(3:end),['[A-Z,a-z]']) ) = true
summe = sum(letter_in_number(:))
if summe >= 1
f = msgbox(sprintf('Nummernschild: %s nicht valid, bitte Bild prüfen. (Fehler Nummer)', final_output), 'Fehler','error');
error('Nummernschild: ''%s'' nicht valid, bitte Bild prüfen. (Fehler Nummer)', final_output)
end

%final output sequence
%-----------------

%write output with space after error check
final_output = insertAfter(final_output,2,' ');

%display message box with the correct numberplate
f = msgbox(sprintf('Nummernschild: %s', final_output), 'Nummernschild','help');


% optional output to notepad as textfile
%{
file = fopen('number_Plate.txt', 'wt');
    fprintf(file,'%s\n',final_output);
    fclose(file);                     
    winopen('number_Plate.txt')
 %}

% output to JSON file
% output to JSON file
format shortg

jsonoutput = final_output;
jsonsplit = strsplit(jsonoutput);
canton = jsonsplit(1);
number = jsonsplit(2);
date = datetime;

str = jsonencode(table(date,canton,number));

% make JSON pretty :)
str = strrep(str,'[','');
str = strrep(str,']','');

%delete old json file
delete 'C:\out\out.json'

% writing the JSON file
fid1 = fopen('C:\out\out.json', 'a');

if fid1 == -1, error('Cannot create JSON file');
end

fwrite(fid1, str, 'char');

fclose(fid1);
