function playdbt( dbt_struct, fct_handler, start_at, up_to, real_time)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    
    if (~exist('dbt_struct', 'var') || ~exist('fct_handler', 'var'))
        disp('ERROR: Not enough input arguments.');
        disp('You must set a dbt_struct (see readdbt) and a dbt @fct_handler to use this function');
        return;
    end

    if (~exist('start_at', 'var') || start_at < 1)
        start_at = 1;
    end
    
    if (~exist('up_to', 'var'))
        up_to = start_at;
    end
    
    if (~exist('real_time', 'var'))
        real_time = 1;
    end
    
    if(up_to <= start_at)
        %récupère le nombre max d'itérations entières a effectuer
        c = struct2cell(dbt_struct);
        up_to = size(cell2mat(c(1)), 2);
        for i=2:size(c,1);
            up_to = min(up_to, size(cell2mat(c(i)), 2));
        end
    end
    
    %utile pour calculer le temps de relecture
    if(real_time > 0)
        time_range = dbt_struct.t(up_to) - dbt_struct.t(start_at); %récupère le temps total en sec
        time_delta = 0;
        current_time = road_time(); %on lit le temps en sec
    end
    
    for i=start_at:up_to;
        if(real_time > 0)
            disp([''; '']);
            
            if(time_delta == 0)
                time_delta = road_time() - dbt_struct.t(start_at);
            else

                diff = ((dbt_struct.t(i) + time_delta) - road_time());

                if(diff < 0)
                    disp(['Erreur temps: ' num2str(diff) ' sec']);
                else
                    disp(['Sleep ' num2str(diff) ' sec']);
                    pause(diff); % met en pause pour N sec
                end
            end
        end
        
        fct_handler(dbt_struct, i);
    end

    %Affiche le temps de relecture VS le temps d'enregistrement 
    if(real_time > 0)
        current_time = road_time() - current_time;
        disp([''; ''; 'Temps finals: ' num2str(current_time) ' sec <?=?> ' num2str(time_range) ' sec']);
    end
end

