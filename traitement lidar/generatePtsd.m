function [ result ] = generatePtsd(Cirpt, Epsilon,R,offsetPhy,L)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
  
    result={};
    for i=0:Epsilon
        %angleRad=((i*pi)-(2*pi-offsetphy))/180;%offsetphy angle entre origine0�CIR et angle roue
        %angleRad=(((3*pi)/2)+offsetPhy)+(i*pi)/180 %offsetphy angle entre origine0�CIR et angle roue
        angleRad=(((pi/2)+offsetPhy)-((i*pi)/180));
        pointXY=ClassScanPointXY();
        %g�n�ration point  arc de cercle
        % inversion car re^p�re invers�
        pointXY.X=Cirpt.X+R*cos(angleRad);%+L pour g�n�ration pts devant voiture
        pointXY.Y=Cirpt.Y+R*sin(angleRad);% pour se rapport au rep�re voiture
        
        result=cat(1,result,pointXY);
    end
end

