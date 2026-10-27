function SV_fig = plotSV(Sc)
% SV Image creation
SV=diag(Sc);
valsingn=(abs(SV/SV(1)));
%figure,
vs = 20*log10(valsingn);
SV_fig = plot(vs,'LineWidth',2);
grid on
xlabel('Singular Values')
ylabel('dB')
%xlim([0 260])
%ylim([-50 0])
set(gca,'FontSize',12)

%savefig(gcf,fullfile(par.folderResults,'SingularValues.fig'))
%saveas(gcf,fullfile(par.folderResults,'SingularValues.png'))
end

