% License Plate Recognition mit MATLAB auf CH-Kennzeichen

%clear
clc
close all;
clear;
%Laden der Trainingsdatei
load imgfildata;


% Prompt für Fileauswahl
[file,path]=uigetfile({'*.jpg;*.jpeg;*.bmp;*.png;*.tif'},'Choose an image');
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

%Imageresize auf 24x42 Px

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
 
% Einstellung der Erkennungsgenauigkeit.
% 1 > Korrelation > 0 

t=[t max(x)];

if max(x)>.5
 z=find(x==max(x));
 out=cell2mat(imgfile(2,z));
 final_output=[final_output out];
end

end


%Error Handling
%-----------------

%Check Canton
options = ["ZH", "BE","LU", "UR","SZ", "OW","NW", "GL","ZG", "FR","SO", "BS","BL", "SH","AI", "AR","SG", "GR","AG","TG","TI","VD","VS","NE","GE","JU"];  
if ~any(strcmpi(final_output(1:2), options))
f = msgbox(sprintf('Nummernschild: %s nicht valid, bitte Bild prüfen. (Fehler Kanton)', final_output), 'Fehler','error');
error('Nummernschild: ''%s'' nicht valid, bitte Bild prüfen. (Fehler Kanton)', final_output)
end

%Check Number
letter_in_number( regexp(final_output(3:end),['[A-Z,a-z]']) ) = true
summe = sum(letter_in_number(:))
if summe >= 1
f = msgbox(sprintf('Nummernschild: %s nicht valid, bitte Bild prüfen. (Fehler Nummer)', final_output), 'Fehler','error');
error('Nummernschild: ''%s'' nicht valid, bitte Bild prüfen. (Fehler Nummer)', final_output)
end

%Final output sequence
%-----------------

%Write output with space after error check
final_output = insertAfter(final_output,2,' ');

%Display message box with the correct numberplate
f = msgbox(sprintf('Nummernschild: %s', final_output), 'Nummernschild','help');


% Output TXT
%{
file = fopen('number_Plate.txt', 'wt');
    fprintf(file,'%s\n',final_output);
    fclose(file);                     
    winopen('number_Plate.txt')
 %}

% Output JSON 
format shortg

jsonoutput = final_output;
jsonsplit = strsplit(jsonoutput);
canton = jsonsplit(1);
number = jsonsplit(2);
date = datetime;

str = jsonencode(table(date,canton,number));

% JSON Formatting
str = strrep(str, ',"', sprintf(',\r"'));
str = strrep(str, '[{', sprintf('[\r{\r'));
str = strrep(str, '}]', sprintf('\r}\r]'));

% Schreiben der JSON Datei
fid1 = fopen('Daten1.json', 'a');

if fid1 == -1, error('Cannot create JSON file');
end

fwrite(fid1, str, 'char');

fclose(fid1);
