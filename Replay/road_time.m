function [ r_time ] = road_time()
%retourne le temps écoulé depuis le Epoch (1/1/1970) en secondes

    r_time = ((now() - datenum(1970,1,1,0,0,0)) * 8.64e4);
end

