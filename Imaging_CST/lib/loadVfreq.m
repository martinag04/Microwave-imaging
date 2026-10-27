function measFreq = loadVfreq(adressSpar, varargin)

Info_S = who('-file', adressSpar);
if ismember('frequency',Info_S)
    measFreq = load(adressSpar,'frequency');
    measFreq = measFreq.frequency;
else
    
    fs = varargin{1};
    ff = varargin{2};
    
    aux = load(adressSpar,'s12_tot');
    aux = size(aux.s12_tot);
    
    nPoints = 1;
%     if length(aux) == 3
%         nPoints = aux(3);
%     end
 
    measFreq = linspace(fs,ff,nPoints);
    %----------
end
end

