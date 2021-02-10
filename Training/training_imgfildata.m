% Erstellung der imgfiledate Datei (Trainingsdatei)

%clearen
clc;          
clear;       
close all;

% Variablen deklaration 
di=dir('letters_numbers');
st={di.name};
nam=st(3:end);
imgfile=cell(2,length(nam));
endchar = '.';

%Für jedes Zeichen eine Cell anlegen
for i=1:length(nam)
   imgfile(1,i)={imread(['letters_numbers','\',cell2mat(nam(i))])};
   temp=cell2mat(nam(i));
   imgfile(2,i)={extractBefore(temp,'.')};
  
end

%Speicherung des imgfildata
save('..\imgfildata.mat','imgfile');
save('imgfildata.mat','imgfile');
clear;