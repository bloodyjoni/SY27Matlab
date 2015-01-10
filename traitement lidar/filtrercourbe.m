function [ result ] = filtrercourbe( pc,tbg,tbd,Epsilon)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
    
index=1;
result={};
xmax= max([tbg(Epsilon+1).X,tbd(Epsilon+1).X])% on repère la distance maximum de l'espace navigable Selon l'angle X

    for cpt=1 : length(pc) 
        % On cherche dans les points des courbes des correspondances dans les
        % points générés pour dessiner les courbes de trajectoire
        pc(cpt).Y;
        tbg.Y;
       % ptg=tbg(find([tbg.Y] > pc(cpt).Y));
        %ptg=ptg(1)
        %ptd=tbd(find([tbd.Y] < pc(cpt).Y));% passer à inférieur pour le virage à droite
        %ptd=ptd(length(ptd))
        for i=1:Epsilon
            if ((tbg(i).X) < (pc(cpt).X))
                ptg=tbg(i);
            end
        end
        for i=1:Epsilon
            if (tbd(i).X < pc(cpt).X)
                ptd=tbd(i);
            end
        end


        if (pc(cpt).Y<ptg.Y) 
            if(pc(cpt).Y>ptd.Y) % si dans l'intervalle d'ordonnées
                if (pc(cpt).X<xmax)
                    %result(index)=pc(cpt);
                    result=cat(1,result,pc(cpt));
                    index=index+1;
                end
            end
        end
    end    
end




