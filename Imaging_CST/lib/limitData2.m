%by D.R.

function dataProjection = limitData2(dataProjection,qxyz,abc,xyz)

xq = qxyz(:,1);
yq = qxyz(:,2);
zq = qxyz(:,3);

a = abc(1);%0.07;
b = abc(2);%0.085;
c = abc(3);%0.07;

xo = xyz(1);
yo = xyz(2);
zo = xyz(3);

sel_radio = (xq-xo).^2/a^2 + (yq-yo).^2/b^2 +(zq-zo).^2/c^2;
aux  = sel_radio < 1;


%xq = xq(aux);
%yq = yq(aux);
%zq = zq(aux);

%dataProjection = dataProjection(aux);
dataProjection(~aux) = NaN;
end