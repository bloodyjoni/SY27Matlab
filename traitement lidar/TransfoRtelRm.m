
function [ result ] = TransfoRtelRm( pc,L,B )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    %for i from 1 to pc.size do
     result={};
    for i=1: size(pc)
        pointXY=ClassScanPointXY();
        pointXY.X=pc(i).X+ B;
        pointXY.Y=pc(i).X + L;
        result=cat(1,result,pointXY);
    end
end

