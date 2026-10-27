clear all 
close all 
clc

tic
orig = pwd;
% fixed variables (vtk file 'headers')
LINE_OFFSET1 = 6;
LINE_OFFSET2 = 3;
LINE_OFFSET3 = 5;
% - - - - - - - - 
%% Open .dat file
fileID1 = fopen('namefile.txt','r');
nameFile = fscanf(fileID1,'%s');
fileID = fopen(nameFile,'r');
%% Get npoints, ncells
currline = fgetl(fileID);
while ~strcmp(currline,'Coordinates')
    currline = fgetl(fileID);
end
npoints=str2num(fgetl(fileID));

currline = fgetl(fileID);
while ~strcmp(currline,'Elements')
    currline = fgetl(fileID);
end
ncells=str2num(fgetl(fileID));
 
nfiles = 24       % %%%ANTENNAS

clear dataauxP dataauxC5 dataauxCT dataauxCV FileName

%% 
% file naming to cycle over
baseName = '01output';
baseExtension = '_rhs1_E%c_%s.vtk';
directionExtension = ['x' 'y' 'z'];
typeExtension = ["abs","angle"];


%%
idx = 1;
for m = 1 : length(directionExtension)  % x, y and z
    for n = 1 : length(typeExtension)   % abs and angle
        for k = 1 : nfiles              % sources
            extension = sprintf(baseExtension,directionExtension(m),typeExtension(n));
            if k < 10
                FileName(idx)=string([baseName,'0',num2str(k),extension]);
            else
                FileName(idx)=string([baseName,num2str(k),extension]);
            end
            idx = idx + 1;
        end
    end
end

dataauxP  = zeros(npoints,3,nfiles);
dataauxC5 = zeros(ncells,5,nfiles);
dataauxCT = zeros(ncells,nfiles);
dataauxCV = zeros(ncells,nfiles);


for m = 1 : length(directionExtension)  % x, y and z
    for n = 1 : length(typeExtension)   % abs / angle 
        fclose('all');
        parfor k = 1 : nfiles              % sources  
            idx = k + nfiles*(n-1) + nfiles*length(typeExtension)*(m-1);
            fileID = fopen(FileName(idx),'r');
            % POINTS
            % move LINE_OFFSET1 lines forward
            for l = 1 : LINE_OFFSET1
                tline = fgetl(fileID);
            end
            dataauxP(:,:,k) = fscanf(fileID,'%f',[3 npoints]).';
            
            % CELLS
            % move LINE_OFFSET2 lines forward
            for l = 1 : LINE_OFFSET2
                tline = fgetl(fileID);
            end
            dataauxC5(:,:,k) = fscanf(fileID,'%f',[5 ncells]).';

            % CELLS TYPE
            % move LINE_OFFSET2 lines forward
            for l = 1 : LINE_OFFSET2
                tline = fgetl(fileID);
            end
            dataauxCT(:,k) = fscanf(fileID,'%f',[1 ncells]).';
            
            % CELLS DATA
            for l = 1 : LINE_OFFSET3
                tline = fgetl(fileID);
            end
            dataauxCV(:,k) = fscanf(fileID,'%f',[1 ncells]).';
            
        end
        eval(sprintf('E%c_%s = dataauxCV;',directionExtension(m),typeExtension(n)));
    end
end
cells  = dataauxC5(:,2:5,1);
points = dataauxP (:,:,1);

Ex_complex_all = Ex_abs.*exp(1i*deg2rad(Ex_angle));
Ey_complex_all = Ey_abs.*exp(1i*deg2rad(Ey_angle));
Ez_complex_all = Ez_abs.*exp(1i*deg2rad(Ez_angle));

fclose('all');
clear dataauxP dataauxC5 dataauxCT dataauxCV 

save_filename = ['E_Field_ALL','.mat'];
cd(orig);
save(save_filename,'Ex_complex_all','Ey_complex_all','Ez_complex_all','points','cells','-v7.3');
toc
quit