function QT = compQT_MT(freq,volVoxel)
eps_0 =  8.8541878128*10^(-12); 
mu_0 = 1.25663706 *10^-6;
Zr = sqrt(mu_0/(eps_0*2.2));

Q = 1i*pi*freq*Zr;
QT = Q*volVoxel;
end
