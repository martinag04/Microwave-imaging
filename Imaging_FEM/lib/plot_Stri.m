%% v1 03-06-2025 DR
%%%%


function plot_Stri(STri,MaskTri)

data2plot = zeros(size(MaskTri));
data2plot(logical(MaskTri)) = STri;


data_formated = 20*log10(abs(data2plot));

figure
imagesc(data_formated)
colorbar
axis square
% clim([-100  -50])
set(gca,'fontname','Times New Roman','fontSize',12)


end