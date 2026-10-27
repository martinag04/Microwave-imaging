data1 = load('data1.mat');
data2 = load('data2.mat');


saveFigures = true;
seldB_plot = -5;
scale = [-25 0];

qxyz = data1.qxyz;
%% Averaging
dataProjection_aux = [data1.dataProjection,data2.dataProjection];
data_avg = mean(dataProjection_aux,2);

[m_avg,I_avg] = max(abs(data_avg));

%%
[m1,I1] = max(abs(data1.dataProjection));
[m2,I2] = max(abs(data2.dataProjection));

data_Nmag1 = abs(data1.dataProjection)/m1;
data_Nmag2 = abs(data2.dataProjection)/m2;

data_Nmag = data_Nmag1 .* data_Nmag2;

%dataProjection = data_avg(I_avg)*data_Nmag;
dataProjection = data_avg.*data_Nmag;
%%
%dataProjection = data_avg;
%% Masking head
load('mask_brain_65.mat')
dataProjection2 = dataProjection.*mask;

%%
abc =  [0.06, 0.075, 0.06]; %[0.07, 0.09, 0.07];%[0.06, 0.075, 0.06];%[0.07, 0.09, 0.07];%rays elipsoid
xyz = [0,-0.005,0];%center elipsoid
f0 = figure;
%                         data3d = plotImaging(dataProjection,qxyz,'3d_db',seldB_plot);%without limiting
data3d = plotImaging(dataProjection,qxyz,'3d_db',seldB_plot,abc,xyz);
%xyz_mid_mm = data3d.xyz_mid_mm;
xyz_mid_mm = [-22,-15,15];
%%
plotCases  ={'magdb','real','imag'};


for contPlots = 1:length(plotCases)
    
    type = plotCases{contPlots};
    
   f1 = figure;
    dataMag_1 = plotImaging(dataProjection,qxyz,type,xyz_mid_mm,scale);
    plotAux_HeadBrain(xyz_mid_mm,1)
    view([1 0 0])
    
    f2 = figure;
    dataMag_2 = plotImaging(dataProjection,qxyz,type,xyz_mid_mm,scale);
    plotAux_HeadBrain(xyz_mid_mm,2)
    view([0 -1 0])

    f3 = figure;
    dataMag_3 = plotImaging(dataProjection,qxyz,type,xyz_mid_mm,scale);
    plotAux_HeadBrain(xyz_mid_mm,3)
    view([0 0 1])
    
    if saveFigures
        
        saveas(f1,[type,'.fig'])
        saveas(f1,[type,'_1.svg'])
        exportgraphics(f1,[type,'_1.png'],'Resolution',300)
        
        saveas(f2,[type,'_2.svg'])
        exportgraphics(f2,[type,'_2.png'],'Resolution',300)
        
        saveas(f3,[type,'_3.svg'])
        exportgraphics(f3,[type,'_3.png'],'Resolution',300)
        
        close([f1 f2 f3])
        
    end
    
end

save('dataCal','dataProjection','data3d','qxyz')

%%
f4 = figure;
DATA = plotImaging_3D_Slide(dataProjection,qxyz,'magdb',data3d.xyz_stroke_mm,xyz_mid_mm,data3d.dataPlotStroke_aux);
caxis(scale)
axis off
axis equal
exportgraphics(gcf,'3D_cut.png','Resolution',300)
saveas(gcf,'3D_cut.fig')
saveas(gcf,'3D_cut.svg')

close([f0 f4])
