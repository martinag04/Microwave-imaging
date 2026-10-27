% 21/02/2022 D.R
%pre-load lib
%%
function DATA = plotImaging(dataProjection,qxyz,casePlot,varargin)

% for nPlot=1:length(casePlot)
%         method = casePlot{nPlot};
%
if   strcmpi(casePlot ,'3d_db')

        disp('Ploting Mag in dB')
        
        seldB_plot = varargin{1};%-3;%dB

        
        %% limiting
        
        if nargin == 6
            
            abc = varargin{2};
            xyz = varargin{3};
            
            dataProjection = limitData2(dataProjection,qxyz,abc,xyz);
            
        end
            
            %%
        
        
        [dataPlotStroke,xyz_stroke,xyz_mid,stroke_sel] = selNdB(dataProjection,qxyz,seldB_plot);
        
        DATA.stroke_sel = stroke_sel;
        
        DATA.xyz_mid_mm = xyz_mid*1000;
        DATA.data_plot= dataPlotStroke;
        
        % Ploting -3dB Data
        dataPlotStroke_aux = formatData(dataPlotStroke,'db');
        xyz_stroke_mm = xyz_stroke*1000;
        
        DATA.dataPlotStroke_aux = dataPlotStroke_aux;
        DATA.xyz_stroke_mm = xyz_stroke_mm;
        
%         figure
        scatter3(xyz_stroke_mm(:,1),xyz_stroke_mm(:,2),xyz_stroke_mm(:,3),25,dataPlotStroke_aux,...
            'filled');
        caxis([-15,0])%uncomment if dB
        
        %plotAuxiliar('ellipsoid',abc,xyz)
        plotAuxiliar('none')
        
else
    
    nMesh = uint32(length(qxyz)^(1/3));%beacause is a square mesh
    
    X = reshape(qxyz(:,1),nMesh,nMesh,nMesh)*1000;%[mm]
    Y = reshape(qxyz(:,2),nMesh,nMesh,nMesh)*1000;
    Z = reshape(qxyz(:,3),nMesh,nMesh,nMesh)*1000;
    
    Matrix_dataProjection = reshape(dataProjection,nMesh,nMesh,nMesh);
    data_Nmag = abs(Matrix_dataProjection)/max(abs(dataProjection));
    
     
%     figure
    
    switch lower(casePlot)
        
        case 'magdb'
            disp('Ploting Magnitude dB')
            if nargin == 6
                disp('hola')
                aux_max = varargin{3};
                data_Nmag = abs(Matrix_dataProjection)/aux_max;
            end
            data_plot = 20*log10(data_Nmag);
            
            
            
        
        case 'mag'
            disp('Ploting Magnitude')
            data_plot = abs(Matrix_dataProjection);
            
        case 'real'
            disp('Ploting Real')
            data_plot = real(Matrix_dataProjection);
            
        case 'real_n'
            disp('Ploting Real N')
            data_plot = real(Matrix_dataProjection);
            realMax = max(max(max(abs(data_plot))));
            data_plot = data_plot/realMax;
            
            
        case 'imag'
            disp('Ploting Imag')
            data_plot = imag(Matrix_dataProjection);
            data_plot(data_plot == 0) = NaN;

        otherwise
            disp('Unknown method.')
    end
    %end
    
    xyz_mid_mm = varargin{1};
    
DATA.data_plot =    data_plot;
slice(X,Y,Z,data_plot,xyz_mid_mm(1),xyz_mid_mm(2),xyz_mid_mm(3))%varargin{2:end}

shading flat
axis square

set(gca,'fontname','Times New Roman','fontSize',9)
% set(gcf,'units','centimeters','InnerPosition',[0,0,8,8])
set(gcf,'units','inches','InnerPosition',[1,1,1.5,1.5])

xlim([-100 100])
ylim([-100 100])
zlim([-100 100])

xticks([ -50 0 50 ])
yticks([ -50 0 50 ])
zticks([ -50 0 50 ])


if   strcmpi(casePlot ,'magdb')
    caxis([-20 0])
     if nargin == 5
         caxis(varargin{2})
     end
end


end
end
