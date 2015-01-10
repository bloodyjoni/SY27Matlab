

global L; %
global l;
global B; % bias sur l'alignement du capteur
global Theta;% angle max pour detection crculaire
global e;% distance entre repere et roue arriere
global xmax;
global ymax;% distance en y max de detection
global phy;
global valLimitePhy;
global angleResolution;
global angleRangeLeft;
global angleRangeRight;
global Epsilon;
L=300;% longueur voiture (cm)
l=200;%longueur entre essieu (cm)
B=0;
Theta=30;
e=90;  % longueur essieu/2(cm)
ymax=100;% 1/2 largeur voiture
xmax=850;% longuer max devant la voiture pour detection droite
phy=15;
valLimitePhy=5;
angleResolution=110/1100;
angleRangeLeft=50;
angleRangeRight=-50;
Epsilon=25; % ajouter en fct vitesse;
%
%pc desiré( liste { x; y;}}
%
fig=figure();

pc=acquireLidar();

pListXY=TranfoTelPol2XY(pc,angleRangeLeft,angleResolution);
pListXY2=TransfoRtelRm(pListXY,L,B);
if (phy<valLimitePhy)
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
    subplot(2,2,4)
    test3={pListPtsDetected.X;pListPtsDetected.Y};
    test3=cell2mat(test3);

    plot (test3(1,:),test3(2,:),limGauche(1,:),limGauche(2,:),limDroite(1,:),limDroite(2,:),carLongg(1,:),carLongg(2,:),carLongd(1,:),carLongd(2,:),carLargg(1,:),carLargg(2,:),carLargd(1,:),carLargd(2,:));
    axis([0 900 -200 200])
    %plot ([pListPtsDetected.X,pListPtsDetected.Y])
    
    if size(pListPtsDetected) ~= 0;
       disp('Houston We have a problem');
    end
else
   % phy=-90+phy;
    phy=((phy*pi)/180);
    ro=L/tan(phy)% souci négativité HERE!!!
    % placement Cir
    %Cir1=ClassScanPointXY();
    %Cir2=ClassScanPointXY();
    %Cir1.X=ro-e;%gauche % pas bon ça!QuoiQue
    %Cir1.Y=0;
    %Cir2.Y=ro+e;%droite
    %Cir2.X=0;
    Cir=ClassScanPointXY();
    Cir.X=0;
    Cir.Y=ro;
    
    %Calcul Rayon
    R1=sqrt((ro-e)^2 +L^2)
    
    R2=sqrt((ro+e)^2 +L^2)
   %calcul phygauche
    phyg=atan(L/(ro-e));%radian
    phyd=atan(L/(ro+e));%radian phyd infeirue => normal si virage à gauche
    
   %Calcul arc de cercle
    tabCg=generatePts(Cir,Epsilon,R1,phyg,L);
    tabCd=generatePts(Cir,Epsilon,R2,phyd,L);
    %
    %affichage
    testg={tabCg.X;tabCg.Y};
    testg=cell2mat(testg);
    
    testd={tabCd.X;tabCd.Y};
    testd=cell2mat(testd);
    
    plot(Cir.X,Cir.Y,testg(1,:),testg(2,:),testd(1,:),testd(2,:),carLongg(1,:),carLongg(2,:),carLongd(1,:),carLongd(2,:),carLargg(1,:),carLargg(2,:),carLargd(1,:),carLargd(2,:));
    xlabel('abscissesX');
    ylabel('ordonnéesY');
    %plot(test(1,:),test(2,:));
    % plot ([tabCg.X,tabCg.Y])
    
    pListPtsDetected=filtrercourbe(pListXY2,tabCg,tabCd,Epsilon);
    
    %visualiser pts
    subplot (2,2,4)
    testg={tabCg.X;tabCg.Y};
    testg=cell2mat(testg);

    testd={tabCd.X;tabCd.Y};
    testd=cell2mat(testd);
    test3={pListPtsDetected.X;pListPtsDetected.Y};
    test3=cell2mat(test3);
    
    % draw a car
    carLongg=generateLine(0,e,0,L);
    carLongd=generateLine(0,-e,0,L);
    carLargg=generateLine(1,0,-e,e);
    carLargd=generateLine(L,0,-e,e);
        
    plot(Cir.X,Cir.Y,testg(1,:),testg(2,:),testd(1,:),testd(2,:),test3(1,:),test3(2,:),carLongg(1,:),carLongg(2,:),carLongd(1,:),carLongd(2,:),carLargg(1,:),carLargg(2,:),carLargd(1,:),carLargd(2,:));
    axis([0 900 -400 400])
end
compteur={};
for i=1:1100
   compteur=cat(1,compteur,i); 
end

% affichage des points

subplot(2,2,1);
plot (pc.pointList.distance,pc.pointList.nbTick)
subplot(2,2,2);
test={pListXY.X;pListXY.Y};
test=cell2mat(test);
plot (test(1,:),test(2,:));
%plot ([pListXY.Y,pListXY.X]);
subplot(2,2,3)
test2={pListXY2.X;pListXY2.Y};
test2=cell2mat(test2);
plot (test2(1,:),test2(2,:));
%plot ([pListXY2.Y,pListXY2.X]);

