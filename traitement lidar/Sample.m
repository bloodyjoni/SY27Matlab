function [ pc ] = Sample( )
ClassScanPoint;
ClassPointCloud;

pc= ClassPointCloud();

for i=1: 1100
   
    pc.nbPoints=pc.nbPoints+1;
    point=ClassScanPoint();
    point.nbTick=i;
    pc.pointList=cat(1,pc.pointList,point);
   
    
end
    
pc.pointList

end

