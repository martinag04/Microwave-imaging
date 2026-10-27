clear all
close all
clc

%% Load lib
addpath('lib');

%%

h1 = load('mask_brain_CST.mat');
h2 = load('mask_brain_shifted.mat');
hold on
scatter3(h1.xq.*h1.mask,h1.yq.*h1.mask,h1.zq.*h1.mask,'MarkerEdgeColor','k','MarkerFaceColor',[0 .75 .75])
scatter3(h1.xq.*h2.mask_NaN,h1.yq.*h2.mask_NaN,h1.zq.*h2.mask_NaN,'x')
legend('GIT','Shift')

tic
%%

h5_filename = ['e-field (f=1.2) [',num2str(1),'].h5']; % Change this to your file
nameFolder = 'Fields/';
h5_filename = fullfile(nameFolder,h5_filename);
% Display the HDF5 structure (optional but useful for debugging)
h5disp(h5_filename);
info = h5info(h5_filename,'/E-Field');
aux = info.Dataspace.Size;
Nx = aux(1);
Ny = aux(2);
Nz = aux(3);

%% Read structured mesh (coordinate grid points)
x = h5read(h5_filename, '/Mesh line x');  % 1D array (101 points)
y = h5read(h5_filename, '/Mesh line y');  % 1D array (101 points)
z = h5read(h5_filename, '/Mesh line z');  % 1D array (101 points)
%%
nAntennas = 22;
nPixels = Nx * Ny * Nz;
Ex_all=zeros(nPixels,nAntennas);
Ey_all=zeros(nPixels,nAntennas);
Ez_all=zeros(nPixels,nAntennas);

mask = (h1.mask).*h2.mask_NaN;

parfor contAntennas=1:nAntennas
    % Specify the HDF5 file path
    h5_filename = ['e-field (f=1.2) [',num2str(contAntennas),'].h5']; % Change this to your file
    h5_filename = fullfile(nameFolder,h5_filename);

    %% Read the E-Field dataset (which is a compound data type)
    E_data = h5read(h5_filename, '/E-Field');

    % Extract complex field components
    Ex = complex(E_data.x.re, E_data.x.im); % X-component
    Ey = complex(E_data.y.re, E_data.y.im); % Y-component
    Ez = complex(E_data.z.re, E_data.z.im); % Z-component

    % Display confirmation
    disp('HDF5 data successfully loaded from CST into MATLAB!');
    toc
    %%

    Ex = permute(reshape(Ex, [Ny, Nx, Nz]), [2, 1, 3]);
    Ey = permute(reshape(Ey, [Ny, Nx, Nz]), [2, 1, 3]);
    Ez = permute(reshape(Ez, [Ny, Nx, Nz]), [2, 1, 3]);

    Ex_all(:,contAntennas) = reshape(Ex,[nPixels,1]).*mask;
    Ey_all(:,contAntennas) = reshape(Ey,[nPixels,1]).*mask;
    Ez_all(:,contAntennas) = reshape(Ez,[nPixels,1]).*mask;
end

%% Electric Field [dBuV/m^2] % Compute the total E-field magnitude
[X, Y, Z] = meshgrid(x, y, z);
sel_Antenna = 1;
Mag_E_fieldX = sqrt(real(Ex_all(:,sel_Antenna)).^2 + imag(Ex_all(:,sel_Antenna)).^2);
Mag_E_fieldY = sqrt(real(Ey_all(:,sel_Antenna)).^2 + imag(Ey_all(:,sel_Antenna)).^2);
Mag_E_fieldZ = sqrt(real(Ez_all(:,sel_Antenna)).^2 + imag(Ez_all(:,sel_Antenna)).^2);

Mag_E_Field = sqrt(Mag_E_fieldX.^2 + Mag_E_fieldY.^2 + Mag_E_fieldZ.^2);
Mag_E_Field_dB = 20*log10(Mag_E_Field/1e-6);

% Permute the Ex field data to match meshgrid format
data2plot =reshape(Mag_E_Field_dB, [Ny, Nx, Nz]); % Swap X and Y dimensions

% Plot the slice
figure
slice(X, Y, Z, data2plot, 0, 0, 0);
xlabel('X (mm)');
ylabel('Y (mm)');
zlabel('Z (mm)');
shading flat

c = colorbar;
c.Label.String = 'dBuV/m^2';
colormap('jet')


%%
IND_brain = find(~isnan(mask));
Ex_DOI = Ex_all(IND_brain,:);
Ey_DOI = Ey_all(IND_brain,:);
Ez_DOI = Ez_all(IND_brain,:);
%%

I = itriu(size(zeros(nAntennas,nAntennas)),1);
[row,col] = ind2sub([nAntennas nAntennas],I);

L_op2=zeros(size(Ex_DOI,1),(nAntennas*(nAntennas-1)/2));

for contM=1:(nAntennas*(nAntennas-1)/2)
    L_op2(:,contM)=(Ex_DOI(:,row(contM)).*Ex_DOI(:,col(contM)) ...
        + Ey_DOI(:,row(contM)).*Ey_DOI(:,col(contM))...
        + Ez_DOI(:,row(contM)).*Ez_DOI(:,col(contM)) );
end

[Uc, Sc, Vc]=svd(L_op2.','econ');%);%

Operator.Uc = Uc;
Operator.Sc = Sc;
Operator.Vc = Vc;

figure
plotSV(Operator.Sc);
%%
% save('CartesianOperator_MT-triu_brain2','Operator','X','Y','Z',"x","y","z","Ex_all","Ey_all","Ez_all","IND_brain");
% save('CartesianOperator_MT-triu_brain_1G2.mat','Operator','X','Y','Z',"x","y","z","Ex_all","Ey_all","Ez_all","IND_brain");
