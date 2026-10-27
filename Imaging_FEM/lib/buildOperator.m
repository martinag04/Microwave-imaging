function Operator = buildOperator(Efield, volumens)

Etot_x = Efield.X;
Etot_y = Efield.Y;
Etot_z = Efield.Z;

vol_sel = volumens;

%load('C:\Users\d049876\Desktop\Calibration_v1\operator\1G0\E_field_selected.mat','Ex_complex_selected','Ey_complex_selected','Ez_complex_selected','barycenter_sel');
%load('C:\Users\d049876\Desktop\Calibration_v1\operator\1G0\vol_sel.mat','vol_sel');

%Etot_x = Ex_complex_selected;
%Etot_y = Ey_complex_selected;
%Etot_z = Ez_complex_selected;

[nrows,ncols] = size(Etot_x);
nfreq=1;%length(dataObj);%TO UPDATE to multifreq
%n=1;

n_values=nrows;%n tethaed or centroids
nv = ncols;
nm = ncols;

%% Compute Q(freq,er)
% To update with a function
freq = 1e9;
eps_0 =  8.8541878128*10^(-12); % vacuum
mu_0 = 1.25663706 *10^-6;
Zr = sqrt(mu_0/(eps_0*2.2));
%Zr = 50;

eps_r_brain = 45.38;%eps_r_brain_Mfreq;%
sigma_brain = 0.77; %sigma_brain;%S/m

eps_brain = eps_r_brain * eps_0 -1i * sigma_brain / (2*pi*freq);
Q = 1i*pi*freq*eps_brain*Zr;

%%
% dataInterpolatedFEM_x(isnan(dataInterpolatedFEM_x))=0;
% dataInterpolatedFEM_y(isnan(dataInterpolatedFEM_y))=0;
% dataInterpolatedFEM_z(isnan(dataInterpolatedFEM_z))=0;
% %%
% Etot_x(:,:,n) = dataInterpolatedFEM_x;
% Etot_y(:,:,n) = dataInterpolatedFEM_y;
% Etot_z(:,:,n) = dataInterpolatedFEM_z;

L_op2=zeros(n_values,nm*nv*nfreq);
mm=0;
for ff=1:nfreq
    for kk=1:nv
        for jj=1:nm
            mm=mm+1;
            L_op2(:,mm)=Q*vol_sel.*(Etot_x(:,kk,ff).*Etot_x(:,jj,ff) + Etot_y(:,kk,ff).*Etot_y(:,jj,ff) + Etot_z(:,kk,ff).*Etot_z(:,jj,ff) );
        end
    end
end

[Uc, Sc, Vc]=svd(L_op2.','econ');

Operator.Uc = Uc;
Operator.Sc = Sc;
Operator.Vc = Vc;

end

