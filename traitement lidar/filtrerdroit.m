function [ result ] = filtrerdroit( pc,xmax,ymax )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

index=1;
for cpt=1 : size(pc) 
    if pc(cpt).x<xmax % tant que l'ordonnée ne dapasse pas a droite
        if pc(cpt).x>-xmax
            if cpt.y>ymax
                result(index)=pc(cpt);
                index=index+1;
            end
        end
    end    
end

end

