function [ pListXY ] = TranfoTelPol2XY( pc,angleRangeLeft,angleResolution )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
    pListXY={};
    
    for i=1 :pc.nbPoints 
        inbTick=pc.pointList(i,1).nbTick;
        iDistance=pc.pointList(i,1).distance;
        %alpha = angle par rapport au 0 °, ligne face à la voiture (
        %longitudinale , l'abscisse du repere télémetre
        %TODO
        iangle= angleRangeLeft -(inbTick * angleResolution); % voir pour rendre plus fiable
        iangleRad= (iangle*pi)/180;
        %disp(iangle)
        %disp(iangleRad)
        iX= cos(iangleRad)*iDistance; %les cosinus/sinus et les degrés, sale histoire.
        iY= sin(iangleRad)*iDistance;
        spXY= ClassScanPointXY();
        spXY.X=iX;
        spXY.Y=iY;
        pListXY=cat(1,pListXY,spXY);
        
    
    end

end

