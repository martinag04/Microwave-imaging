%% Open .dat file
fileID1 = fopen('namefile.txt','r');
FileName = fscanf(fileID1,'%s');
fileID = fopen(FileName,'r');
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

fclose('all');

%% Open .dat file
fileID1 = fopen('namefile.txt','r');
FileName = fscanf(fileID1,'%s');
fileID = fopen(FileName,'r');

tline = fgetl(fileID);
tline = fgetl(fileID);
tline = fgetl(fileID);

clear dataaux1
dataaux1(1:npoints,1:3) = fscanf(fileID,'%f',[3 npoints]).';

verts = dataaux1;

tline = fgetl(fileID);
tline = fgetl(fileID);
tline = fgetl(fileID);

tline = fgetl(fileID);
tline = fgetl(fileID);
    
%%%

clear dataaux1
dataaux1(1:ncells,1:5) = fscanf(fileID,'%f',[5 ncells]).';

elems = dataaux1(:,1:4);
materialElem = dataaux1(:,5);

barycenter_all(:,:) = (verts(elems(:,1),:)+verts(elems(:,2),:)+verts(elems(:,3),:)+verts(elems(:,4),:))/4;

%radio_cent = sqrt(barycenter_all(:,1).^2 + barycenter_all(:,2).^2);
%radio_cent = sqrt(barycenter_all(:,1).^2 + barycenter_all(:,2).^2 + barycenter_all(:,3).^2);

selected = find(materialElem==51 | materialElem==52 ); % BRAIN & HEAD
% selected_Brain = find( materialElem==52 ); % BRAIN
% selected = find(materialElem==4); 
%selected = find(radio_cent < 0.06);

%% Brain + Head
barycenter_sel = barycenter_all(selected,:);
selected_cells = elems(selected,:);

fclose('all');

load('E_Field_ALL.mat')

Ex_complex_selected = Ex_complex_all(selected,:);
Ey_complex_selected = Ey_complex_all(selected,:);
Ez_complex_selected = Ez_complex_all(selected,:);

save_filename = ['E_Field_selected_head','.mat'];
save(save_filename,'Ex_complex_selected','Ey_complex_selected','Ez_complex_selected','barycenter_sel','-v7.3');

%% Brain
% barycenter_sel = barycenter_all(selected_Brain,:);
% selected_cells = elems(selected_Brain,:);
% 
% Ex_complex_selected = Ex_complex_all(selected_Brain,:);
% Ey_complex_selected = Ey_complex_all(selected_Brain,:);
% Ez_complex_selected= Ez_complex_all(selected_Brain,:);
% 
% save_filename = ['E_Field_selected_Brain','.mat']
% save(save_filename,'Ex_complex_selected','Ey_complex_selected','Ez_complex_selected','barycenter_sel','-v7.3');
% quit