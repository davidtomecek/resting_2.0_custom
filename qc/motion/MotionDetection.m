function MotionDetection(subs)

currTime = datestr(now,'yyyymmdd_HHMMSS');

[rootSubs,~,~] = fileparts(subs);
sub_files = importdata(subs);

in = 1;
for sub = 1:size(sub_files,1)
    
    [~,sub_name,~] = fileparts(fileparts(fileparts(sub_files{sub})));
    [sub_path,~,~] = fileparts(sub_files{sub});
    
    motion = importdata(sub_files{sub});
    fd{:,sub} = FDcalculation(motion);
    
    list15(sub) = length(find(fd{:,sub}>1.5));
    list15p(sub) = list15(sub)/size(fd{sub},2);
    
    list05(sub) = length(find(fd{:,sub}>0.5));
    list05p(sub) = list05(sub)/size(fd{sub},2);
    
    if list15(sub)
        disp(['Subject ',sub_name ': fd>1.5mm ' mat2str(list15(sub))  ]);
        showMotion(motion, sub_name);
    end
    
    if list05p(sub)>0.25
        disp(['Subject ',sub_name ': fd>0.5mm ' mat2str(list05(sub))]);
        showMotion(motion, sub_name);
    end
    
    if ~or(logical(list15(sub)),list05p(sub)>0.25)
        subs_in_list{in,1} = sub_path;
        in = in + 1;
    end
    
end

% list15(list15 > 0) = 1;
% list05p(list05p > 0.25) = 1;
% list05p(list05p < 1) = 0;
subs_in_ind = double(~or(logical(list15),list05p>0.25))';

writecell(subs_in_list,fullfile(rootSubs,['motion_qc_passed_list_',currTime,'.txt']));
writematrix(subs_in_ind,fullfile(rootSubs,['motion_qc_passed_ind_',currTime,'.txt']));
