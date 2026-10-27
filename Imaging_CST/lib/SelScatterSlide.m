%by D.R.
function [ScatterSlideData,xyz_sel,closestValue] = SelScatterSlide(dataProjection,xyzq,target,selView)

xq = xyzq(:,1);
yq = xyzq(:,2);
zq = xyzq(:,3);

switch lower(selView)
    case {'xy'}
        disp('XY slide')
        
        z = unique(zq);
        zTarget = target;
        [~,closestIndexZ] = min(abs(z-zTarget));
        closestValue = z(closestIndexZ);
        
        selData = zq == closestValue;
           
    case 'xz'
        disp('XZ slide')

        y = unique(yq);
        yTarget = target;
        [~,closestIndexY] = min(abs(y-yTarget));
        closestValue = y(closestIndexY);
        
        selData = yq == closestValue;
         
    case 'yz'
        disp('YZ slide')

        x = unique(xq);
        xTarget = target;
        [~,closestIndexX] = min(abs(x-xTarget));
        closestValue = x(closestIndexX);
        
        selData = xq == closestValue;
        
    otherwise
        disp('Unknown view.')
end

xyz_sel = xyzq(selData,:);
ScatterSlideData = dataProjection(selData);


end

