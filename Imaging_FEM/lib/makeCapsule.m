% %%%%%%%%%%
% % V.1 by DR, 2021-03-06
% % All units in [m]
% % coords_sel coordenates of the barycenters, units 
% % pos is the center of capsule 
% % radius0 radious of the circular part
% % len distance between centers of the Half-spheres
% % normal vector [x,y,z], ex. align with +z is [0 0 1]
% %%%%%%%%%%%
% 
% 
% function selData = makeCapsule(coords_sel,pos0,radius0,len,orientation)
% 
% radius0 = radius0*1000;%mm
% len = len*1000;%mm
% pos0 = pos0*1000;%mm
% 
% orientation = orientation/sqrt(orientation*orientation');
% [P1,P2] = getCentroidsCapsule(orientation,len);
% 
% sphere_center1 = P1 + pos0;%pos - [0 len/2 0];
% sphere_center2 = P2 + pos0;%pos + [0 len/2 0];
% 
% % scaling to meter
% sphere_center1 = sphere_center1 / 1000;
% sphere_center2 = sphere_center2 / 1000;
% radius = radius0 / 1000;
% pos = pos0/1000;
% 
% 
% nor = orientation;
% 
% d1 = -1*(dot(nor,sphere_center1));
% d2 = -1*(dot(nor,sphere_center2));
% 
% plane1 = (coords_sel * nor')+d1;
% plane2 = (coords_sel * nor')+d2;
% 
% selSp1 = plane1 >= 0;
% selSp2 = plane2 <= 0;
% 
% selCyl1 = plane1 <= 0;
% selCyl2 = plane2 >= 0;
% 
% radius_to_center1 = sqrt((coords_sel(:,1)-sphere_center1(1)).^2 ...
%     +(coords_sel(:,2)-sphere_center1(2)).^2 ...
%     + (coords_sel(:,3)-sphere_center1(3)).^2);
% 
% radius_to_center2 = sqrt((coords_sel(:,1)-sphere_center2(1)).^2 ...
%     +(coords_sel(:,2)-sphere_center2(2)).^2 ...
%     + (coords_sel(:,3)-sphere_center2(3)).^2);
% 
% sp1 = radius_to_center1 <= radius;
% sp2 = radius_to_center2 <= radius;
% 
% %%
% % Take it from https://mathworld.wolfram.com/Point-LineDistance3-Dimensional.html
% den = norm(sphere_center2 - sphere_center1);
% f1 = coords_sel - sphere_center1;
% f2 = coords_sel - sphere_center2;
% AuxNum = cross(f1,f2);
% Num = zeros(length(AuxNum),1);
% for cont = 1:length(Num)
%    Num(cont) = norm(AuxNum(cont,:)); 
% end
% 
% dCyl = Num/den; 
% selMiddle = dCyl <= radius;
% 
% 
% temporal1 = selSp1 & sp1;%HS1
% temporal2 = selSp2 & sp2;%HS2
% 
% selHSpheres = temporal1 | temporal2;
% SelCylinder = selMiddle & selCyl1 & selCyl2;
% 
% selData = selHSpheres | SelCylinder;
% 
% 
% 
% end
function selData = makeCapsule(coords, center, radius, len, direction)
% makeCapsule - Seleziona punti all'interno di una capsula 3D.
%
% coords: Nx3 matrix dei punti da testare [m]
% center: 1x3 centro della capsula [m]
% radius: raggio della capsula [m]
% len: lunghezza tra i centri delle semisfere [m]
% direction: 1x3 vettore orientazione (verrà normalizzato)

% Normalizzazione della direzione
direction = direction / norm(direction);

% Calcolo dei due centri delle semisfere
P1 = center - (direction * len/2);
P2 = center + (direction * len/2);

% Selezione punti dentro le semisfere
dist1 = vecnorm(coords - P1, 2, 2);
dist2 = vecnorm(coords - P2, 2, 2);
inSpheres = (dist1 <= radius) | (dist2 <= radius);

% Selezione punti dentro il cilindro centrale
% Formula della distanza punto-segmento in 3D
AB = P2 - P1;
AB_norm = norm(AB);
AP = coords - P1;
t = dot(AP, repmat(AB, size(coords,1), 1), 2) / (AB_norm^2);
t = max(0, min(1, t)); % Clamping tra 0 e 1
proj = P1 + t .* AB;   % Proiezione del punto sul segmento
d = vecnorm(coords - proj, 2, 2);
inCylinder = (d <= radius);

% Unione dei punti validi
selData = inSpheres | inCylinder;

end

