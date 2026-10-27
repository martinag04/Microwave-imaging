%% Reading/generating a vox-mesh

nMesh = 65;%81;%121
lInf = -0.096;%-0.12;
lSup = 0.096;%0.12;
step = (lSup - lInf)/(nMesh-1);
volVoxel = step^3;

xMesh = (lInf :step: lSup)';
lenX = length(xMesh);
[X,Y,Z] = meshgrid(xMesh,xMesh,xMesh);

nPixels = (lenX)^3;

xq = reshape(X,nPixels,1);
yq = reshape(Y,nPixels,1);
zq = reshape(Z,nPixels,1);

%%  Interpolating E-Fields
fileOperator = 'E_Field_selected_head';%'E_Field_selected';
eFields = load(fileOperator);

ox = eFields.barycenter_sel(:,1);
oy = eFields.barycenter_sel(:,2);
oz = eFields.barycenter_sel(:,3);

dataX = eFields.Ex_complex_selected;
dataY = eFields.Ey_complex_selected;
dataZ = eFields.Ez_complex_selected;

%%
nAntennas = 24;%24
dataInterpolatedFEM_x = zeros(nPixels,nAntennas);
dataInterpolatedFEM_y = zeros(nPixels,nAntennas);
dataInterpolatedFEM_z = zeros(nPixels,nAntennas);


parfor cont=1:nAntennas
    dataInterpolatedFEM_x(:,cont) = griddata(ox,oy,oz,dataX(:,cont),xq,yq,zq);
    dataInterpolatedFEM_y(:,cont) = griddata(ox,oy,oz,dataY(:,cont),xq,yq,zq);
    dataInterpolatedFEM_z(:,cont) = griddata(ox,oy,oz,dataZ(:,cont),xq,yq,zq);
end

%%

[nrows,ncols] = size(dataInterpolatedFEM_x);
nfreq=1;%length(dataObj);%TO UPDATE to multifreq
n=1;

n_values=nrows;%n tethaed or centroids
nv = ncols;
nm = ncols;

Etot_x=zeros(n_values,nv,nfreq);
Etot_y=zeros(n_values,nv,nfreq);
Etot_z=zeros(n_values,nv,nfreq);
%%
dataInterpolatedFEM_x(isnan(dataInterpolatedFEM_x))=0;
dataInterpolatedFEM_y(isnan(dataInterpolatedFEM_y))=0;
dataInterpolatedFEM_z(isnan(dataInterpolatedFEM_z))=0;
%%
Etot_x(:,:,n) = dataInterpolatedFEM_x;
Etot_y(:,:,n) = dataInterpolatedFEM_y;
Etot_z(:,:,n) = dataInterpolatedFEM_z;

%%

aux = zeros(nAntennas,nAntennas);
I = itriu(size(aux),1);
sz = [nAntennas nAntennas];
[row,col] = ind2sub(sz,I);

L_op2=zeros(n_values,(nAntennas*(nAntennas-1)/2)*nfreq);

for ff=1:nfreq
    for contM=1:(nAntennas*(nAntennas-1)/2)
        L_op2(:,contM)=(Etot_x(:,row(contM),ff).*Etot_x(:,col(contM),ff) ...
            + Etot_y(:,row(contM),ff).*Etot_y(:,col(contM),ff)...
            + Etot_z(:,row(contM),ff).*Etot_z(:,col(contM),ff) );
    end
end


% 
% L_op2=zeros(n_values,nm*nv*nfreq);
% mm=0;
% for ff=1:nfreq
%     for kk=1:nv
%         for jj=1:nm
%             mm=mm+1;
%             L_op2(:,mm)=(Etot_x(:,kk,ff).*Etot_x(:,jj,ff) + Etot_y(:,kk,ff).*Etot_y(:,jj,ff) + Etot_z(:,kk,ff).*Etot_z(:,jj,ff) );
%         end
%     end
% end

[Uc, Sc, Vc]=svd(L_op2.','econ');%);%

Operator.Uc = Uc;
Operator.Sc = Sc;
Operator.Vc = Vc;

%%
qxyz = [xq,yq,zq];
%%E_Field_REC_meas220223_BaseShift
save('CartesianOperator_EuCAP24','Operator','qxyz','volVoxel');