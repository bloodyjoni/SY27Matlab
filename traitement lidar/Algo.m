

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
L=2.5;
B=0;
Theta=30;
e=1; 
xmax=0.75;
ymax=2;
phy=10;
valLimitePhy=30;
angleResolution=0.25;
angleRangeLeft=+50;
angleRangeRight=-50;
%
%pc desiré( liste { x; y;}}
%

pc=acquireLidar();

pListXY=TranfoTelPol2XY(pc);
pListXY=TransfoRtelRm(pc,L,B);
if (phy<valLimitePhy)
    % cas boite englobae droite
    pListXY=filtrerdroit(pc,xmax,ymax);
    
    %visualiserpc
    if pListXY~=[]
        %houston =>STOP
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


