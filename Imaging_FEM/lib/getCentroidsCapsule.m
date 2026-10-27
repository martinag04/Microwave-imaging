%Help Math https://tutorial.math.lamar.edu/classes/calciii/eqnsoflines.aspx
%% V.0 DR 2021-03-06
function [P1,P2] = getCentroidsCapsule(orientation,len)

distance = len/2;
%line equation r = r0 + tV
%V = P0 - P1, we are assuming P0 in the origen

V = -1*(orientation);

X = sqrt(distance^2/sum((V./V(1)).^2));
Y = sqrt(distance^2/sum((V./V(2)).^2));
Z = sqrt(distance^2/sum((V./V(3)).^2));

P1 = [X,Y,Z];
P2 = -1*P1;

% To covert the cases alignt to axes
P1(isnan(P1))=0;
P2(isnan(P2))=0;

end