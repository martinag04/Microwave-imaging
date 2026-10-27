%by D.R.

function [dataPlotStroke,xyz_sel,xyz_mid,varargout] = selNdB(dataProjection,xyzq,seldB_plot)
%% Selecting -3dB Data
selStroke = ((abs(dataProjection)/max(abs(dataProjection)))>db2mag(seldB_plot));
%selStroke = ((abs(dataProjection)/max_48)>db2mag(-12));

if nargout == 4
    varargout{1} = selStroke;
end

dataPlotStroke = dataProjection(selStroke);
xyz_sel = xyzq(selStroke,:);

x_sel = xyz_sel(:,1);
y_sel = xyz_sel(:,2);
z_sel = xyz_sel(:,3);

%% Selecting -3dB middle
% Works if it concentrate 
% x_mid = sum(x_sel.*dataPlotStroke)/sum(dataPlotStroke);
% y_mid = sum(y_sel.*dataPlotStroke)/sum(dataPlotStroke);
% z_mid = sum(z_sel.*dataPlotStroke)/sum(dataPlotStroke);


x_mid = sum(x_sel.*abs(dataPlotStroke))/sum(abs(dataPlotStroke));
y_mid = sum(y_sel.*abs(dataPlotStroke))/sum(abs(dataPlotStroke));
z_mid = sum(z_sel.*abs(dataPlotStroke))/sum(abs(dataPlotStroke));


xyz_mid = [x_mid, y_mid, z_mid];

end



