clear all
close all
clc

%% Load lib an OP
addpath('lib');
load('OP\CartesianOperator_MT-triu_half-brainDX_1G3.mat') 
figure
plotSV(Operator.Sc);

%% S-parameters Simulation CST

S0 = sparameters('healthy_41points.s22p');
S1 = sparameters('22ant_stroke_41points.s22p');

S0 = squeeze(S0.Parameters(:,:,21));
S1 = squeeze(S1.Parameters(:,:,21));


%%
useUpperTriu = true;
if ~useUpperTriu
    S0 = S0.';
    S1 = S1.';
end

I_triu = itriu(size(S0),1);

tri_S0= S0(I_triu);
tri_S1= S1(I_triu);

DifferenceTriu = tri_S1 - tri_S0;
DifferenceTriu_sqrt = zeros(size(S0));
DifferenceTriu_sqrt(I_triu) = DifferenceTriu;

delta_S = S0 - S1;
delta_S(logical(eye(size(delta_S)))) = 0;%removing diagonal

%% plot diff 22 x 22
data_plot = 20*log10(abs(delta_S));
figure
imagesc(data_plot)
colorbar
axis square
set(gca,'fontname','Times New Roman','fontSize',12)
% clim([-110  -55])


%% Preparing DifferenceQ
%QT = compQT2(freq*1e9,volVoxel);%we assume cubic voxels
%DifferenceQ = -DifferenceTriu/QT;

% Projection
dataProjection = ProjectionTriu(Operator,DifferenceTriu,-30);


%%
dataProjection_ext = NaN(numel(X),1);
dataProjection_ext(IND_brain) = dataProjection;
Matrix_dataProjection = reshape(dataProjection_ext,size(X));
nPixel = numel(X);
qx = reshape(X,[nPixel,1]);
qy = reshape(Y,[nPixel,1]);
qz = reshape(Z,[nPixel,1]);
qxyz = [qx,qy,qz];

% Smooting
% dataProjection = averageMeshData(dataProjection,qxyz);

data_Nmag = abs(Matrix_dataProjection)/max(abs(dataProjection));
data_dB = 20*log10(data_Nmag);
vq = data_dB;
%pos = [30 -40 20];

%%

seldB_plot = -3;%dB
[dataPlotStroke,xyz_stroke,pos] = selNdB(dataProjection_ext,qxyz,seldB_plot);
%xyz_mid_mm = xyz_mid*1000;
pos = round(pos);

% Ploting -3dB Data
dataPlotStroke_aux = formatData(dataPlotStroke,'db');
%xyz_stroke_mm = xyz_stroke*1000;

f0=figure;
scatter3(xyz_stroke(:,1),xyz_stroke(:,2),xyz_stroke(:,3),25,dataPlotStroke_aux,'filled');
clim([-15,0])%uncomment if dB

plotAuxiliar('brain')

%%
figure
slice(X, Y, Z, vq, [], pos(2), []); % Z-slice
xlabel('X (mm)');
ylabel('Y (mm)');
zlabel('Z (mm)');
shading flat
%shading interp;
colorbar;
clim([-25,0])
axis square
view([0 1 0])
%%
figure
slice(X, Y, Z, vq, [], [], pos(3)); % Z-slice
xlabel('X (mm)');
ylabel('Y (mm)');
zlabel('Z (mm)');
shading flat
%shading interp;
colorbar;
clim([-25,0])
axis square
view([0 0 1])
%%
figure
slice(X, Y, Z, vq, pos(1), [], []); % Z-slice
xlabel('X (mm)');
ylabel('Y (mm)');
zlabel('Z (mm)');
shading flat
%shading interp;
colorbar;
clim([-25,0])
axis square
view([1 0 0])
%%
if useUpperTriu == true
    save data1.mat dataProjection X Y Z qxyz
else
    save data2.mat dataProjection X Y Z qxyz
end

