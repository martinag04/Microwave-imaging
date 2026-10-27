close all
clear
clc

%% Load lib
addpath('lib');


%% Setting
Setting.nameOP = 'Operator_1G0'; %
Setting.loadOP = true;%
Setting.Th =  -40;

Setting.adressSpar_0 = 'Sparameters_stroke.txt';
Setting.adressSpar_1 = 'Sparameters_healthy.txt';



%% Loading operator
if Setting.loadOP
    load([Setting.nameOP,'.mat']);%
    load('mask_brain_65.mat') %mask_avg_csf %mask_brain_65
    nMesh = uint8(length(qxyz)^(1/3));%beacause is a square mesh
    X = reshape(qxyz(:,1),nMesh,nMesh,nMesh)*1000;%[mm]
    Y = reshape(qxyz(:,2),nMesh,nMesh,nMesh)*1000;
    Z = reshape(qxyz(:,3),nMesh,nMesh,nMesh)*1000;
end

figure
plotSV(Operator.Sc);

%% Loading S-parameters
[S0,Setting.sel_freq] = getSpar(Setting.adressSpar_0,'sim');
[S1,Setting.sel_freq] = getSpar(Setting.adressSpar_1,'sim');


%% Get tri
I = itriu(size(S0),1);
tri_S0= S0(I);
tri_S1= S1(I);

DifferenceTriu = tri_S1 - tri_S0;
DifferenceTriu_sqrt = NaN(size(S0));
DifferenceTriu_sqrt(I) = DifferenceTriu;

delta_S = S0 - S1;
delta_S(logical(eye(size(delta_S)))) = 0;%removing diagonal

%% plot diff 22 x 22
data_plot = 20*log10(abs(delta_S));
figure
imagesc(data_plot)
colorbar
axis square
% clim([-130  -75])
set(gca,'fontname','Times New Roman','fontSize',12)


%% Preparing DifferenceQ
QT = compQT2(Setting.sel_freq,volVoxel);%we assume cubic voxels
DifferenceQ = -DifferenceTriu/QT;

% Projection
dataProjection = ProjectionTriu(Operator,DifferenceQ,Setting.Th);

% Smooting
dataProjection = averageMeshData(dataProjection,qxyz);

% Masking head
dataProjection = dataProjection.*mask;

seldB_plot = -3;%dB
[dataPlotStroke,xyz_stroke,xyz_mid] = selNdB(dataProjection,qxyz,seldB_plot);
xyz_mid_mm = xyz_mid*1000;

% Ploting -3dB Data
dataPlotStroke_aux = formatData(dataPlotStroke,'db');
xyz_stroke_mm = xyz_stroke*1000;

f0=figure;
scatter3(xyz_stroke_mm(:,1),xyz_stroke_mm(:,2),xyz_stroke_mm(:,3),25,dataPlotStroke_aux,'filled');
clim([-15,0])%uncomment if dB

plotAuxiliar('brain')
% view([0 0 1])
colorbar('off')
%set(gcf,'units','centimeters','InnerPosition',[0,0,5,5])


%%
Matrix_dataProjection = reshape(dataProjection,nMesh,nMesh,nMesh);
data_Nmag = abs(Matrix_dataProjection)/max(abs(dataProjection));
data_dB = 20*log10(data_Nmag);

vq = data_dB;


%%
f1=figure;
slice(X,Y,Z,vq,xyz_mid_mm(1),xyz_mid_mm(2),xyz_mid_mm(3))

shading flat
axis square

set(gca,'fontname','Times New Roman','fontSize',14)
%set(gcf,'units','centimeters','InnerPosition',[0,0,5.5,5])

xlim([-100 100])
ylim([-100 100])
zlim([-100 100])

xticks([ -50 0 50 ])
yticks([ -50 0 50 ])
zticks([ -50 0 50 ])
% view([1 0 0])
clim([-25 0])
colorbar



