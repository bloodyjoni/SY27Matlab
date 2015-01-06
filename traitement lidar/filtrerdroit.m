function [ result ] = filtrerdroit( pc,xmax,ymax )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
result={};
index=1;
for cpt=1 : size(pc) 
    if pc(cpt).Y<ymax % tant que l'ordonnée ne dapasse pas a droite
        if pc(cpt).Y>-ymax
            if pc(cpt).X<xmax
                result=cat(1,result,pc(cpt));
            end
        end
    end    
end

end

