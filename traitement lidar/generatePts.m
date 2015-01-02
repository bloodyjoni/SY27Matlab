function [ result ] = generatePts( Theta,Cirx,Ciry,R,ro )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    cpt;
    for cpt from 1 to Epsilon do
        result(cpt).x=(ro-e)+R*cos(cpt+Epsilon);
        result(cpt).y=(ro-e)+R*sin(cpt+Epsilon);
        
   end_for

end

