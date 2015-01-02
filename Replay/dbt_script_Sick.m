% Test de lecteur temps réel de fichier dbt

figure;

% dbt = readdbt(['20141119_chunlei_seville/trac' 'sickldrms_0.dbt'], ...
%               ['h%i32 m%i32 s%i32 ms%i32 nb_sat%i32 ' ...
%                'ind_qualite%i32 age%f32 hdop%f32 ' ...
%                'lon%f lat%f alt_msl%f d_geoidal%f ' ...
%                'dir_lat%i8 dir_lon%i8 ref_station%i32']);

% struct CelerityDbtData{
%     float vehiculeSpeed;
%     float regulate_speed;
%     float diffSpeedCumulated;
%     float regulate_speed_gain;
%     float regulate_brake_gain;
%     float regulate_accel_gain;
%     float regulate_decel_gain;
%     float cmd;
% };

dbt = readdbt(['20141119_chunlei_seville/' 'sickldrms_0.dbt'], ...
              ['cmd%f32']);
          
global cmd;
cmd = [];
global v_speed;
v_speed = [];
global r_speed;
r_speed = [];
           
playdbt(dbt, @playdbtHandler, 1, 0, 0);     

subplot(2,1,1);
plot(cmd);
title('cmd');

subplot(2,1,2);
hold on;
plot(v_speed, 'blue');
plot(r_speed, 'red');
title('speed');
hold off;