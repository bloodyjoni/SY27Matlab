function [ pListXY ] = TranfoTelPol2XY( pc )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
    pListXY={};
    
    for i=1 :pc.nbPoints 
        inbTick=pc.pointList{i}.nbTick;
        idistance=pc.pointList{i}.distance;
        %alpha = angle par rapport au 0 �, ligne face � la voiture (
        %longitudinale , l'abscisse du repere t�l�metre
        %TODO
        iangle= 
        iX=

    
    end

end

