
function [ result ] = TransfoRtelRm( pc,L,B )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    %for i from 1 to pc.size do
     
    for i=1: size(pc)
        result(i).x=pc(i).x+ B;
        result(i).y=pc(i).y + L;

    end
end

