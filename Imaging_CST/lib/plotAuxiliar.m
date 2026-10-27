%by D.R.
% The stl should be in the lib
%

function plotAuxiliar(varargin)
%% Ploting Auxiliar Head and Brain
headAddr = 'head.stl';
brainAddr = 'brain_pos.stl';

hold on

% head = stlread(headAddr);
% head.vertices(:,1) = head.vertices(:,1) - 33;
% head.vertices(:,2) = head.vertices(:,2) - 6;
% head.vertices(:,3) = head.vertices(:,3) - 0;

% sel = head.vertices(:,3) > -6;
% head.vertices(sel,3) = -6;
% select= head.vertices(:,3)>=48;
% head.vertices(select,3)=48;

%48  e 30
brain = stlread(brainAddr);
brain.vertices = brain.vertices * 1000;

% 
% select= brain.vertices(:,3)>=-6;
% brain.vertices(select,3)=-6;


% shading flat
% 
% patch('Faces',head.faces,'Vertices',head.vertices,'FaceColor',  [ 229, 231, 233 ]/252, ...
%     'EdgeColor',       [ 229, 231, 233 ]/252,        ...
%     'FaceAlpha',        0.1,...
%     'EdgeAlpha',        0.05,...
%     'FaceLighting',    'gouraud',     ...
%     'AmbientStrength', 0.15);


auxobj = varargin{1};



switch lower(auxobj)
    case {'brain'}
        disp('Plotting Brain')
        
        
        patch('Faces',brain.faces,'Vertices',brain.vertices,'FaceColor',  [255 0 0]/255, ...
            'EdgeColor',       [255 0 0]/255, ...%[ 229, 231, 233 ]/252,        ...
            'FaceAlpha',        0.1,...
            'EdgeAlpha',        0.05,...
            'FaceLighting',    'gouraud',     ...
            'AmbientStrength', 0.15);
        
    case 'ellipsoid'
        disp('Plotting Ellipsoid')
        
        abc = varargin{2};%rays elipsoid
        xyz = varargin{3};%center elipsoid
        
        
        hold on
        [X2,Y2,Z2] = ellipsoid(xyz(1)*1000,xyz(2)*1000,xyz(3)*1000,abc(1)*1000,abc(2)*1000,abc(3)*1000);
        surf(X2,Y2,Z2,"FaceColor",[ 229, 231, 233 ]/252,"FaceAlpha",0.5,'EdgeAlpha',0.05);

    otherwise
        disp('Ploting Head')
end


axis equal
% 
% xlabel('x[mm]')
% ylabel('y[mm]')
% zlabel('z[mm]')

xlim([-100 100])
ylim([-100 100])
zlim([-100 100])

ticks = [ -50 0 50 ];
xticks(ticks)
yticks(ticks)
zticks(ticks)

set(gca,'FontName','Times New Roman','fontSize',9)
set(gcf,'units','inches','position',[0.5,0.5,3,3])
%set(gcf,'units','inches','position',[0.25,0.25,1.5,1.5])
%set(gcf,'units','inches','position',[0.15,0.15,1.5,1.5])
view([45 30])
end


