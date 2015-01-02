function [ pc ] = Sample( )
ClassScanPoint
ClassPointCloud

pc= ClassPointCloud();

for i=1: 1100
   
    pc.nbPoints=pc.nbPoints+1;
    pc.pointList=cat(1,pc.pointList,ClassScanPoint());
   
    
end
    
pc.pointList

end

