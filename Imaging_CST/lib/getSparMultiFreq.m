% V.2 19/02/2022 D.R. Working with meas data, to update sim cases
%V.1 22/02/2022 DR. --To improve implmentation!!!
%varargin{1} antennas to remove
%varargin{2} triu 
%varargin{3} mehod
function S = getSparMultiFreq(adressSpar_S0,measFreq0,m_qfreq,varargin)

nFreq = length(m_qfreq);
S = [];
for contFreq=1:nFreq
qfreq = m_qfreq(contFreq);

method = varargin{3};
[S0,~] = getSpar2(adressSpar_S0,method,measFreq0,qfreq);

%% Removing antenna
if nargin >= 4
    remove = varargin{1};
    S0(remove,:) = [];
    S0(:,remove) = [];
    
    if ~varargin{2}
        S0 = S0.';
    end
end



I = itriu(size(S0),1);
S0= S0(I);

S = [S;S0];
end

end

