function playdbtHandler( dbt_struct, index )
%PLAYDBTHANDLER Summary of this function goes here
%   Detailed explanation goes here
    
%     h = dbt_struct.alt_msl(index) + dbt_struct.d_geoidal(index);
%     disp([num2str(index) ': [' num2str(dbt_struct.h(index)) ' : ' num2str(dbt_struct.m(index)) ', ' num2str(dbt_struct.s(index)) ']']);
%     disp(['    nb_sat: ' num2str(dbt_struct.nb_sat(index))]);
%     disp(['    qual: ' num2str(dbt_struct.ind_qualite(index))]);
%     disp(['    lon: ' num2str(dbt_struct.lon(index) * 180 / pi)]);
%     disp(['    lat: ' num2str(dbt_struct.lat(index) * 180 / pi)]);
%     disp(['    alt: ' num2str(h)]);

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

global cmd;
global v_speed;
global r_speed;

%     disp([num2str(index) ':']);
%     disp(['    v_speed: ' num2str(dbt_struct.vehiculeSpeed(index))]);
%     disp(['    r_speed: ' num2str(dbt_struct.regulate_speed(index))]);
%     disp(['    diff_s: ' num2str(dbt_struct.diffSpeedCumulated(index))]);
%     disp(['    s_P: ' num2str(dbt_struct.regulate_speed_gain(index))]);
%     disp(['    b_P: ' num2str(dbt_struct.regulate_brake_gain(index))]);
%     disp(['    a_I: ' num2str(dbt_struct.regulate_accel_gain(index))]);
%     disp(['    d_I: ' num2str(dbt_struct.regulate_decel_gain(index))]);
%     disp(['    cmd: ' num2str(dbt_struct.cmd(index))]);

    r_speed = [r_speed dbt_struct.regulate_speed(index)];
    v_speed = [v_speed dbt_struct.vehiculeSpeed(index)];
    cmd = [cmd dbt_struct.cmd(index)];
end

