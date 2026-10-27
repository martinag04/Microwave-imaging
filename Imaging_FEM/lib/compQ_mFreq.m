%nelemnets of eps_ref should be equal to qfreqs

function QT = compQ_mFreq(qfreqs,volVoxel,eps_ref)

eps_0 =  8.8541878128*10^(-12); % vacuum
%Zr = 50;
mu_0 = 1.25663706 *10^-6;
Zr = sqrt(mu_0/(eps_0*2.2));

nFreq = length(qfreqs);
Q = zeros(1,nFreq);

for contFreq = 1:nFreq
    % epsilon background
    %eps_r_b = 12.7;%
    %sigma_b = 0.087857;%
    eps_r_b = eps_ref(contFreq,1);
    sigma_b = eps_ref(contFreq,2);
    freq = qfreqs(contFreq);
    
    eps_b = eps_r_b * eps_0 -1i * sigma_b / (2*pi*freq);
    Q(contFreq) = 1i*pi*freq*eps_b*Zr;
end
QT = Q*volVoxel;
end