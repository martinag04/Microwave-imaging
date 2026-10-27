function BV = plotAuxiliar_MG(varargin)
%% Ploting Auxiliar Head, Brain and Ball
% Usage: plotAuxiliar_MG('balls', 'BL') or plotAuxiliar_MG('ball', 'BR')

% Default: use BL side
side = 'BL';  % 'BL' or 'BR'

if nargin >= 2
    side = upper(varargin{2});
    if ~ismember(side, {'BL', 'BR'})
        error('Second argument must be ''BL'' or ''BR''');
    end
end

% STL file paths
headAddr = 'head.stl';
brainAddr = 'brain_pos.stl';

ballAddr_20 = ['stroke_' side '_20cc.stl'];
ballAddr_40 = ['stroke_' side '_40cc.stl'];
ballAddr_60 = ['stroke_' side '_60cc.stl'];

hold all

% Read STL files
brain = stlread(brainAddr);
brain.vertices = brain.vertices * 1000;

ball20 = stlread(ballAddr_20);
ball30 = stlread(ballAddr_40);
ball40 = stlread(ballAddr_60);

auxobj = varargin{1};

switch lower(auxobj)
    case 'brain'
        disp(['Plotting Brain + Ball (' side ')']);

        patch('Faces',brain.faces,'Vertices',brain.vertices,'FaceColor',[1 0 0], ...
            'EdgeColor',[1 0 0], 'FaceAlpha',0.1, ...
            'EdgeAlpha',0.05,'FaceLighting','gouraud','AmbientStrength',0.15);

        patch('Faces',ball20.faces,'Vertices',ball20.vertices,'FaceColor',[0 0 1], ...
              'EdgeColor','none','FaceAlpha',0.2, ...
              'FaceLighting','gouraud','AmbientStrength',0.1);

    case 'ball'
        disp(['Plotting Ball only (' side ')']);

        patch('Faces',ball20.faces,'Vertices',ball20.vertices,'FaceColor',[0 0 1], ...
            'EdgeColor','none','FaceAlpha',0.2, ...
            'FaceLighting','gouraud','AmbientStrength',0.1);
        BV = ball20.vertices;

    case 'balls'
        disp(['Plotting all 3 balls (' side ')']);

        patch('Faces',ball20.faces,'Vertices',ball20.vertices,'FaceColor',[0 0 1], ...
            'EdgeColor','none','FaceAlpha',0.3,'FaceLighting','gouraud','AmbientStrength',0.1);
        patch('Faces',ball30.faces,'Vertices',ball30.vertices,'FaceColor',[0 1 0], ...
            'EdgeColor','none','FaceAlpha',0.3,'FaceLighting','gouraud','AmbientStrength',0.1);
        patch('Faces',ball40.faces,'Vertices',ball40.vertices,'FaceColor',[1 0 1], ...
            'EdgeColor','none','FaceAlpha',0.3,'FaceLighting','gouraud','AmbientStrength',0.1);

        BV = [ball20.vertices; ball30.vertices; ball40.vertices];
        assignin('base', 'BV_all', {ball20.vertices, ball30.vertices, ball40.vertices});

    case 'ellipsoid'
        disp('Plotting Ellipsoid')
        abc = varargin{2}; % radii
        xyz = varargin{3}; % center
        [X2,Y2,Z2] = ellipsoid(xyz(1)*1000,xyz(2)*1000,xyz(3)*1000, ...
            abc(1)*1000,abc(2)*1000,abc(3)*1000);
        surf(X2,Y2,Z2,"FaceColor",[229 231 233]/255,"FaceAlpha",0.5,'EdgeAlpha',0.05);
        BV = 0;

    otherwise
        disp('Unknown object to plot')
end

% Visualization settings
axis equal
xlim([-100 100])
ylim([-100 100])
zlim([-100 100])
xticks([-50 0 50])
yticks([-50 0 50])
zticks([-50 0 50])
set(gca,'FontName','Times New Roman','FontSize',9)
set(gcf,'units','inches','position',[0.5,0.5,3,3])
view([45 30])
end
