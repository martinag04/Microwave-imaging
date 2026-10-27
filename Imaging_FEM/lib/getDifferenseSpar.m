%by D.R
%inputs method:raw,cal
%if cal then SrefSim and SrefMeas are needed
%ex. Difference = getDifferenseSpar(S0,S1,'cal',SrefSim,SrefMeas)


function Difference = getDifferenseSpar(S0,S1,varargin)

Difference = S1 - S0;

if nargin > 2
    method = varargin{1};
    SrefSim = varargin{2};
    SrefMeas = varargin{3};
else
    method = 'raw';
end

switch lower(method)
    case {'raw','noncal'}
        disp('Using RAW meas data')
        text_tittle = 'RAW';
     
    case {'cal','cal1'}
        disp('Using CAL meas data')
        %% MEAS CAL
        calFactor = SrefSim./SrefMeas;
        Difference = Difference.*calFactor;%Difference = SrefSim -((SrefSim./S0).*S1);
        text_tittle = 'CAL';
        
     
    otherwise
        disp('Unknown calibration.')
end

normFro = 20*log10(norm(Difference,'fro'));
maxDifference = max(max(Difference));
maxDifference = 20*log10(abs(maxDifference));

figure; imagesc(20*log10(abs(Difference)))
axis square
colorbar

set(gca,'fontname','Times New Roman','fontSize',12)
xlabel('N-antenna','FontWeight','bold')
ylabel('N-antenna','FontWeight','bold')

textTitle = {[text_tittle, ' S-Par Difference'],...
    ['Frequency:1GHz ',...
    'NormFrog:',num2str(normFro), ' Max:', num2str(maxDifference),'dB']};
title(textTitle)

end

