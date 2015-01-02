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

dbt = readdbt(['20141119_chunlei_seville/' 'mobileye.dbt'], ...
                ['Source_Id%i32 Obstacle_type_source%i32 Id%i32 Obstacle_type%i32 Obstacle_details%i32 ' ...
                'Type_Score%i32 Detection_Score%i32 Type_Confidence%f ' ...
                'Quality%i32 Status%i32 Age%i32 x%f y%f ']);

global cmd;
cmd = [];
global v_speed;
v_speed = [];
global r_speed;
r_speed = [];
dbt
dbt.t
dbt.tr

playdbt(dbt, @playdbtHandler);     

subplot(2,1,1);
plot(cmd);
title('cmd');

subplot(2,1,2);
hold on;
plot(v_speed, 'blue');
plot(r_speed, 'red');
title('speed');
hold off;