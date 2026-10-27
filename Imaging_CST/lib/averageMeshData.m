% v.1 DR 11-04-2021
% The input should be double
%v.2 DR 21-02-2022

function dataAvg = averageMeshData(dataProjection,qxyz)


nMesh = uint32(length(qxyz)^(1/3));%beacause is a square mesh
data = reshape(dataProjection,nMesh,nMesh,nMesh);
dataAvg = NaN(size(data));


for x = 1:size(data,1)
    for y = 1:size(data,2)
        for z = 1:size(data,3)
            
            cond = [abs(x+1)<size(data,1), abs(x-1)<size(data,1), ...
                abs(y+1)<size(data,2), abs(y-1)<size(data,2), ...
                abs(z+1)<size(data,3), abs(z-1)<size(data,3)];
            dataAux = [];
            if all(cond)
                dataAux(1) = data(x,y,z);
                
                if abs(x+1) <size(data,1)
                    dataAux(2) = data(x+1,y,z);
                end
                
                if abs(x-1) <size(data,1) && x>1
                    dataAux(3) = data(x-1,y,z);
                end
                
                if abs(y+1) <size(data,2)
                    dataAux(4) = data(x,y+1,z);
                end
                
                if abs(y-1) <size(data,2) && y>1
                    dataAux(5) = data(x,y-1,z);
                end
                
                if abs(x+1) <size(data,1) && abs(y+1) <size(data,2)
                    dataAux(6) = data(x+1,y+1,z);
                end
                
                if abs(x-1) <size(data,1) && abs(y-1) <size(data,2) && x>1 && y>1
                    dataAux(7) = data(x-1,y-1,z);
                end
                
                if abs(x-1) <size(data,1) && abs(y+1) <size(data,2) && x>1
                    dataAux(8) = data(x-1,y+1,z);
                end
                
                if abs(x+1) <size(data,1) && abs(y-1) <size(data,2) && y>1
                    dataAux(9) = data(x+1,y-1,z);
                end
                
                if abs(z+1) <size(data,3)
                    dataAux(10) = data(x,y,z+1);%%up
                end
                
                if abs(x+1) <size(data,1) && abs(z+1) <size(data,3)
                    dataAux(11) = data(x+1,y,z+1);
                end
                
                if abs(x-1) <size(data,1) && abs(z+1) <size(data,3) && x>1
                    dataAux(12) = data(x-1,y,z+1);
                end
                
                if abs(y+1) <size(data,2) && abs(z+1) <size(data,3)
                    dataAux(13) = data(x,y+1,z+1);
                end
                
                if abs(y-1) <size(data,2) && abs(z+1) <size(data,3) && y>1
                    dataAux(14) = data(x,y-1,z+1);
                end
                
                if abs(x+1) <size(data,1) && abs(y+1) <size(data,2) && abs(z+1) <size(data,3)
                    dataAux(15) = data(x+1,y+1,z+1);
                end
                
                if abs(x-1) <size(data,1) && abs(y-1) <size(data,2) && abs(z+1) <size(data,3) && x>1 && y>1
                    dataAux(16) = data(x-1,y-1,z+1);
                end
                
                if abs(x-1) <size(data,1) && abs(y+1) <size(data,2) && abs(z+1) <size(data,3) && x>1
                    dataAux(17) = data(x-1,y+1,z+1);
                end
                
                if abs(x+1) <size(data,1) && abs(y-1) <size(data,2) && abs(z+1) <size(data,3) && y>1
                    dataAux(18) = data(x+1,y-1,z+1);
                end
                
                if abs(z-1) <size(data,3) && z>1
                    dataAux(19) = data(x,y,z-1);%BOTTOM
                end
                
                if abs(x+1) <size(data,1) && abs(z-1) <size(data,3) && z>1
                    dataAux(20) = data(x+1,y,z-1);
                end
                
                if abs(x-1) <size(data,1) && abs(z-1) <size(data,3) && x>1 && z>1
                    dataAux(21) = data(x-1,y,z-1);
                end
                
                if abs(y+1) <size(data,2) && abs(z-1) <size(data,3) && z>1
                    dataAux(22) = data(x,y+1,z-1);
                end
                
                if abs(y-1) <size(data,2) && abs(z-1) <size(data,3) && y>1 && z>1
                    dataAux(23) = data(x,y-1,z-1);
                end
                
                if abs(x+1) <size(data,1) && abs(y+1) <size(data,2) && abs(z-1) <size(data,3) && z>1
                    dataAux(24) = data(x+1,y+1,z-1);
                end
                
                if abs(x-1) <size(data,1) && abs(y-1) <size(data,2) && abs(z-1) <size(data,3) && x>1 && y>1 && z>1
                    dataAux(25) = data(x-1,y-1,z-1);
                end
                
                if abs(x-1) <size(data,1) && abs(y+1) <size(data,2) && abs(z-1) <size(data,3) && x>1 && z>1
                    dataAux(26) = data(x-1,y+1,z-1);
                end
                
                if abs(x+1) <size(data,1) && abs(y-1) <size(data,2) && abs(z-1) <size(data,3) && y>1 && z>1
                    dataAux(27) = data(x+1,y-1,z-1);
                end
            end
            
            dataAvg(x,y,z) = mean(dataAux,'omitnan');
            %clear dataAux
            
        end
    end
end


dataAvg  = reshape(dataAvg,nMesh^3,1);

end



