%To update - Now is just working at 1GHz
function QT = compQT(freq,volVoxel)

eps_0 =  8.8541878128*10^(-12); % vacuum
mu_0 = 1.25663706 *10^-6;
Zr = sqrt(mu_0/(eps_0*2.2));
%Zr = 50;
%
eps_r_brain = 45.38;%eps_r_brain_Mfreq;%
sigma_brain = 0.77; %sigma_brain;%S/m

eps_brain = eps_r_brain * eps_0 -1i * sigma_brain / (2*pi*freq);
Q = 1i*pi*freq*eps_brain*Zr;

QT = Q*volVoxel;
end

