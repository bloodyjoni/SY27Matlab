function [ result ] = filtrercourbe( pc,tb1,tb2)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
    
index=1;
for cpt=1 : size(pc) 
    % On cherche dans les points des courbes des correspondances dans les
    % points g�n�r�s pour dessiner les courbes de trajectoire
    pc(cpt).Y;
    tb1.Y;
    pt1=find (tb1.Y,pc(cpt).Y);
    pt2=tb2(find (tb2.Y == pc(cpt).Y));
    if (pc(cpt).x>pt1.x && pc(cpt).x<pt2.x) % si dans l'intervalle d'ordonn�es
            if cpt.y>ymax
                result(index)=pc(cpt);
                index=index+1;
            end
        end
    end    
end




