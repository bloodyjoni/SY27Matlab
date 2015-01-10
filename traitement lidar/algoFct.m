function [ StopGo, pListPtsDetected,tabCg,tabCd] = algoFct( pc,phy,valLimitePhy,angleRangeLeft,angleResolution,xmax,ymax,L,e,B,Epsilon )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
global tabCg;
global tabCd;
fig=figure();
pListXY=TranfoTelPol2XY(pc,angleRangeLeft,angleResolution);
pListXY2=TransfoRtelRm(pListXY,L,B);
if (phy<valLimitePhy && phy>-valLimitePhy)
%
% Tout droit
%
    % cas boite englobae droite
    for i=0:xmax
        limDroite=generateLine(0,ymax,L,xmax);
        limGauche=generateLine(0,-ymax,L,xmax);
        % draw a car
        carLongg=generateLine(0,e,0,L);
        carLongd=generateLine(0,-e,0,L);
        carLargg=generateLine(1,0,-e,e);
        carLargd=generateLine(L,0,-e,e);
        
    end
   pListPtsDetected=filtrerdroit(pListXY2,xmax,ymax);
    
    %visualiserpc
    %subplot(2,2,4)
    test3={pListPtsDetected.X;pListPtsDetected.Y};
    test3=cell2mat(test3);

    plot (test3(1,:),test3(2,:),limGauche(1,:),limGauche(2,:),limDroite(1,:),limDroite(2,:),carLongg(1,:),carLongg(2,:),carLongd(1,:),carLongd(2,:),carLargg(1,:),carLargg(2,:),carLargd(1,:),carLargd(2,:));
    axis([0 900 -200 200])
    %plot ([pListPtsDetected.X,pListPtsDetected.Y])
    try
    if size(pListPtsDetected) ~= 0;
       disp('Houston We have a problem');
       StopGo='Stop'
    else
        StopGo='GO'
    end
    catch exception
        StopGo='GO'
    end
elseif(phy>valLimitePhy)
%
%Virage à gauche
%
    phy=((phy*pi)/180);
    ro=L/tan(phy);% souci négativité HERE!!! Corrigé 10/01/
   
    Cir=ClassScanPointXY();
    Cir.X=0;
    Cir.Y=ro;
    
    %Calcul Rayon
    R1=sqrt((ro-e)^2 +L^2);
    
    R2=sqrt((ro+e)^2 +L^2);
   %calcul phygauche
    phyg=atan(L/(ro-e));%radian
    phyd=atan(L/(ro+e));%radian phyd infeirue => normal si virage à gauche
    
   %Calcul arc de cercle
    tabCg=generatePtsg(Cir,Epsilon,R1,phyg,L);
    tabCd=generatePtsg(Cir,Epsilon,R2,phyd,L);
    %
    %affichage
    testg={tabCg.X;tabCg.Y};
    testg=cell2mat(testg);
    
    testd={tabCd.X;tabCd.Y};
    testd=cell2mat(testd);
    
    carLongg=generateLine(0,e,0,L);
    carLongd=generateLine(0,-e,0,L);
    carLargg=generateLine(1,0,-e,e);
    carLargd=generateLine(L,0,-e,e);

    plot(Cir.X,Cir.Y,testg(1,:),testg(2,:),testd(1,:),testd(2,:),carLongg(1,:),carLongg(2,:),carLongd(1,:),carLongd(2,:),carLargg(1,:),carLargg(2,:),carLargd(1,:),carLargd(2,:));
    xlabel('abscissesX');
    ylabel('ordonnéesY');
    %plot(test(1,:),test(2,:));
    % plot ([tabCg.X,tabCg.Y])
    pListPtsDetected=[];
    pListPtsDetected=filtrercourbe(pListXY2,tabCg,tabCd,Epsilon);
    
    try
    if size(pListPtsDetected) ~= 0;
       disp('Houston We have a problem courbé');
       StopGo='Stop'
    else
        StopGo='GO'
    end
    catch exception
        StopGo='GO'
    end

    %visualiser pts
   % subplot (2,2,4)
    testg={tabCg.X;tabCg.Y};
    testg=cell2mat(testg);

    testd={tabCd.X;tabCd.Y};
    testd=cell2mat(testd);
   
    
    % draw a car
    carLongg=generateLine(0,e,0,L);
    carLongd=generateLine(0,-e,0,L);
    carLargg=generateLine(1,0,-e,e);
    carLargd=generateLine(L,0,-e,e);
    try
    test3={pListPtsDetected.X;pListPtsDetected.Y};
    test3=cell2mat(test3);   
    plot(Cir.X,Cir.Y,testg(1,:),testg(2,:),testd(1,:),testd(2,:),test3(1,:),test3(2,:),carLongg(1,:),carLongg(2,:),carLongd(1,:),carLongd(2,:),carLargg(1,:),carLargg(2,:),carLargd(1,:),carLargd(2,:));
    axis([0 900 -400 400])

    catch exception
    plot(Cir.X,Cir.Y,testg(1,:),testg(2,:),testd(1,:),testd(2,:),carLongg(1,:),carLongg(2,:),carLongd(1,:),carLongd(2,:),carLargg(1,:),carLargg(2,:),carLargd(1,:),carLargd(2,:));
    axis([0 900 -400 400])
    end

    else
%
%   Virage à droite
%
    phy=((phy*pi)/180);
    ro=L/tan(phy);% souci négativité HERE!!! Corrigé 10/01/
   
    Cir=ClassScanPointXY();
    Cir.X=0;
    Cir.Y=ro;
    
    %Calcul Rayon
    R1=sqrt((ro-e)^2 +L^2);
    R2=sqrt((ro+e)^2 +L^2);
   %calcul phygauche
    phyg=atan(L/(ro-e));%radian
    phyd=atan(L/(ro+e));%radian phyd supérieur => normal si virage à droite
    
   %Calcul arc de cercle
    tabCg=generatePtsd(Cir,Epsilon,R1,phyg,L);
    tabCd=generatePtsd(Cir,Epsilon,R2,phyd,L);
    %
    %affichage
    testg={tabCg.X;tabCg.Y};
    testg=cell2mat(testg);
    
    testd={tabCd.X;tabCd.Y};
    testd=cell2mat(testd);
    
    carLongg=generateLine(0,e,0,L);
    carLongd=generateLine(0,-e,0,L);
    carLargg=generateLine(1,0,-e,e);
    carLargd=generateLine(L,0,-e,e);

    plot(Cir.X,Cir.Y,testg(1,:),testg(2,:),testd(1,:),testd(2,:),carLongg(1,:),carLongg(2,:),carLongd(1,:),carLongd(2,:),carLargg(1,:),carLargg(2,:),carLargd(1,:),carLargd(2,:));
    xlabel('abscissesX');
    ylabel('ordonnéesY');
    %plot(test(1,:),test(2,:));
    % plot ([tabCg.X,tabCg.Y])
    pListPtsDetected=[];
    pListPtsDetected=filtrercourbed(pListXY2,tabCg,tabCd,Epsilon);
    
    try
    if size(pListPtsDetected) ~= 0;
       disp('Houston We have a problem courbé');
       StopGo='Stop'
    else
        StopGo='GO'
    end
    catch exception
        StopGo='GO'
    end

    %visualiser pts
   % subplot (2,2,4)
    testg={tabCg.X;tabCg.Y};
    testg=cell2mat(testg);

    testd={tabCd.X;tabCd.Y};
    testd=cell2mat(testd);
   
    
    % draw a car
    carLongg=generateLine(0,e,0,L);
    carLongd=generateLine(0,-e,0,L);
    carLargg=generateLine(1,0,-e,e);
    carLargd=generateLine(L,0,-e,e);
    try
    test2={pListXY2.X;pListXY2.Y};
    test2=cell2mat(test2);  
    test3={pListPtsDetected.X;pListPtsDetected.Y};
    test3=cell2mat(test3);   
    plot(Cir.X,Cir.Y,testg(1,:),testg(2,:),testd(1,:),testd(2,:),test2(1,:),test2(2,:),test3(1,:),test3(2,:),carLongg(1,:),carLongg(2,:),carLongd(1,:),carLongd(2,:),carLargg(1,:),carLargg(2,:),carLargd(1,:),carLargd(2,:));
    axis([0 900 -400 400])
   
    catch exception
    disp ('exception')
    exception
    plot(Cir.X,Cir.Y,testg(1,:),testg(2,:),testd(1,:),testd(2,:),carLongg(1,:),carLongg(2,:),carLongd(1,:),carLongd(2,:),carLargg(1,:),carLargg(2,:),carLargd(1,:),carLargd(2,:));
    axis([0 900 -400 400])
    
    end
end


