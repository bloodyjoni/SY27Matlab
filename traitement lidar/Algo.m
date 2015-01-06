

global L; %
global B; % bias sur l'alignement du capteur
global Theta;% angle max pour detection crculaire
global e;% distance entre repere et roue arriere
global xmax;
global ymax;% distance en y max de detection
global Phy;
global valLimitePhy;
global angleResolution;
global angleRangeLeft;
global angleRangeRight;
L=200;
B=0;
Theta=30;
e=1; 
ymax=90;% 1/2 largeur voiture
xmax=380;% longuer max devant la voiture pour detection droite
phy=10;
valLimitePhy=30;
angleResolution=110/1100;
angleRangeLeft=50;
angleRangeRight=-50;
%
%pc desiré( liste { x; y;}}
%

pc=acquireLidar();

pListXY=TranfoTelPol2XY(pc,angleRangeLeft,angleResolution);
pListXY2=TransfoRtelRm(pListXY,L,B);
if (phy<valLimitePhy)
    % cas boite englobae droite
   pListPtsDetected=filtrerdroit(pListXY2,xmax,ymax);
    
    %visualiserpc
    if size(pListPtsDetected) ~= 0;
       disp('Houston We have a problem');
    end
else
    ro=L/ tan(Phy);
    % placement Cir
    Cir1={ro-e;0}
    Cir2={ro+e;0}
    
    %Calcul Rayon
    R1=sqrt((ro-e)^2 +L^2);
    
    R2=sqrt((ro-e)^2 +L^2);
    
    %Calcul arc de cercle
    tabCg=generatePts(Theta,Cir1.x,Cir1.y,R,ro);
    tabCd=generatePts(Theta,Cir2.x,Cir2.y,R,ro);
    
    filtrercourbe(pListXY,tabCg,tabCd);
    
    %visualiser pts
    
end
compteur={};
for i=1:1100
   compteur=cat(1,compteur,i); 
end

% affichage des points
fig=figure();
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
subplot (2,2,4)
test3={pListPtsDetected.X;pListPtsDetected.Y};
test3=cell2mat(test3);
plot (test3(1,:),test3(2,:));
%plot ([pListPtsDetected.X,pListPtsDetected.Y])

