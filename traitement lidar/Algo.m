

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
B=0;% Bias a la pose de Lidar sur Y
Theta=30;% Inconnu au bataillon
e=90;  % longueur essieu/2(cm)
ymax=100;% 1/2 largeur voiture utilisé détection droite
xmax=850;% longuer max devant la voiture pour detection droite
phy=15;% angle des roues
valLimitePhy=5;% limite entre détection courbe et détection droite
angleResolution=110/1100;% step d'angle entre mesures
angleRangeLeft=50;
angleRangeRight=-50;
Epsilon=35; % ajouter en fct vitesse;
%
%pc desiré( liste { x; y;}}
%
%fig=figure();

pc=acquireLidar();

algoFct(pc,3,valLimitePhy,angleRangeLeft,angleResolution,xmax,ymax,L,e,B,Epsilon);
algoFct(pc,15,valLimitePhy,angleRangeLeft,angleResolution,xmax,ymax,L,e,B,Epsilon);
[StopGo,pListPtsDetected,tabCg,tabCd]=algoFct(pc,-15,valLimitePhy,angleRangeLeft,angleResolution,xmax,ymax,L,e,B,Epsilon);
algoFct(pc,-35,valLimitePhy,angleRangeLeft,angleResolution,xmax,ymax,L,e,B,Epsilon);



% affichage des points

%subplot(2,2,1);
%plot (pc.pointList.distance,pc.pointList.nbTick)
%subplot(2,2,2);
%test={pListXY.X;pListXY.Y};
%test=cell2mat(test);
%plot (test(1,:),test(2,:));
%plot ([pListXY.Y,pListXY.X]);
%subplot(2,2,3)
%test2={pListXY2.X;pListXY2.Y};
%test2=cell2mat(test2);
%plot (test2(1,:),test2(2,:));
%plot ([pListXY2.Y,pListXY2.X]);

