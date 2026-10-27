%By D.R. To update to n antennas sim
%addr,sim --> [n,n,f] Spar-matrix, n:number of port, f:number of freqPoints
%addr,sim,freq --> [n,n,1],at closest sim freq
%addr,meas --> [n,n,f]
%addr,meas,measFreq,freq_idx --> [n,n,1]
%v.2 04/02/2022
%v.3 12/07/2023 DR - new format MG-DR


function [AllSpar,freq] = getSpar(adressSpar,method,varargin)

aux1 = load(adressSpar);
disp(method)

switch lower(method)
        case 'sim'
        disp('Loading Simulated data FEM-POLITO Format')

        % Formato colonne:
        % frequenza [Hz], porta i, porta j, parte reale, parte immaginaria
        nPorts = max(max(aux1(:,2:3)));
        rowsPerFreq = nPorts^2;

        nFreq = floor(size(aux1,1) / rowsPerFreq);
        extraRows = mod(size(aux1,1), rowsPerFreq);

        if nFreq == 0
            error('Dati insufficienti per una matrice %dx%d.', ...
                  nPorts, nPorts);
        end

        if extraRows > 0
            warning(['Ignoro le ultime %d righe: non costituiscono ' ...
                     'un blocco completo di %d righe.'], ...
                     extraRows, rowsPerFreq);
        end

        AllSpar = complex(zeros(nPorts, nPorts, nFreq));
        freq = zeros(nFreq,1);

        for k = 1:nFreq

            rows = (k-1)*rowsPerFreq + (1:rowsPerFreq);
            block = aux1(rows,:);

            % Ogni blocco deve riferirsi a una sola frequenza
            if any(block(:,1) ~= block(1,1))
                error('Il blocco %d contiene frequenze diverse.', k);
            end

            i = block(:,2);
            j = block(:,3);
            idx = sub2ind([nPorts, nPorts], i, j);

            if numel(unique(idx)) ~= rowsPerFreq
                error('Il blocco %d contiene coppie duplicate o mancanti.', k);
            end

            values = complex(block(:,4), block(:,5));

            % Mantiene la convenzione della funzione originale:
            % sottrae 1 agli elementi diagonali
            isDiagonal = (i == j);
            values(isDiagonal) = values(isDiagonal) - 1;

            Spar = complex(zeros(nPorts));
            Spar(idx) = values;

            AllSpar(:,:,k) = Spar;
            freq(k) = block(1,1);
        end

        % Se richiesta, seleziona la frequenza più vicina [Hz]
        if ~isempty(varargin)
            qfreq = varargin{1};
            [~,idx] = min(abs(freq - qfreq));

            freq = freq(idx);
            AllSpar = AllSpar(:,:,idx);

            fprintf('Spar at %.9g Hz\n', freq);
        end
        
    case {'meas'}
        disp('Loading Measured data Format *.s12_tot(:,:,freqSel)')
        
        if nargin == 4
            measFreq = varargin{1};%Vector with the freq meas
            qfreq = varargin{2};%query freq
            
            [~,freq_idx]=min(abs(measFreq-qfreq));%get the closest freq
            
            freq = measFreq(freq_idx);
            disp(['Spar at ', num2str(freq),'Hz'])
            
            
            Spar = aux1;
            Spar = Spar.s12_tot(:,:,freq_idx);
            Spar = Spar - diag(diag(Spar));
            Spar(9,:) = Spar(:,9); %due to problem in the sw matrix
            
            AllSpar = Spar;
            
        else
            AllSpar = aux1.s12_tot;
            freq = [];
        end
 
    case 'meas_mg-dr'%This use the struct as format

        % Freq in GHz
        measFreq =aux1.Sparameters.Frequency*1e-9;
        qfreq = varargin{1};%query freq
        [~,freq_idx]=min(abs(measFreq-qfreq));%get the closest freq
        freq = measFreq(freq_idx);
        disp(['Spar at ', num2str(freq),'Gz'])

        AllSpar = squeeze(aux1.Sparameters.S_par(:,:,freq_idx));
        
        AllSpar(1:2,:) = [];
        AllSpar(:,1:2) = [];
        
        
        
    otherwise
        disp('Unknown method.')
end


    
    
    
    
    
    
    
    
    
    
        
    
 

    
    
    
end

