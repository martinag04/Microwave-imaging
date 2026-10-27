function QT = compQT2(freq,volVoxel)

eps_0 =  8.8541878128*10^(-12); % vacuum
%Zr = 50;
mu_0 = 1.25663706 *10^-6;
Zr = sqrt(mu_0/(eps_0*2.2));

% 12.700000  0.087857
% 15 0.8

eps_r_brain = 45.38;%12.7;%45.38;%eps_r_brain_Mfreq;%
sigma_brain = 0.77; %0.087857;%sigma_brain;%S/m

%eps_r_brain = 15;
%sigma_brain = 0.8;


%eps_r_brain = 2.2;%eps_r_brain_Mfreq;%
%sigma_brain = 07;

eps_brain = eps_r_brain * eps_0 -1i * sigma_brain / (2*pi*freq);
Q = 1i*pi*freq*eps_brain*Zr;

QT = Q*volVoxel;
end
