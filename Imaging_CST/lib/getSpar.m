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
        
        Sparameters = [];
        freq = [];
        contFreq = 0;
        for n = 0:(length(aux1)/576)-1
            SparametersAux = aux1(1+(576*n):576+(576*n),:);
            if sum(SparametersAux(:,4)) ~= 0
                contFreq = contFreq + 1;
                Sparameters = [Sparameters; SparametersAux];
                Spar = ones(24);
                for cont=1:576
                    if SparametersAux(cont,2)==SparametersAux(cont,3)
                        Spar(SparametersAux(cont,2),SparametersAux(cont,3)) = complex(SparametersAux(cont,4)-1,SparametersAux(cont,5));
                    else
                        Spar(SparametersAux(cont,2),SparametersAux(cont,3)) = complex(SparametersAux(cont,4),SparametersAux(cont,5));
                    end
                end
                freq = [freq ; SparametersAux(1)];
                AllSpar(:,:,contFreq) = Spar;
                
            end
        end
        
        if nargin == 3
            qfreq = varargin{1};
            [~,idx]=min(abs(freq-qfreq));%get the closest freq
            freq=freq(idx);
            AllSpar = AllSpar(:,:,idx);
            disp(['Spar at ', num2str(freq),'Hz'])
            
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

