function f = plotCircle3D(center,normal,radius)
theta=-pi:0.01:pi;
v=null(normal);
points=repmat(center',1,size(theta,2))+radius*(v(:,1)*cos(theta)+v(:,2)*sin(theta));
f = plot3(points(1,:),points(2,:),points(3,:),'r-','linewidth',1);
end