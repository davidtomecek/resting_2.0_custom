function [fig] = showMotion(motion,ttl)

if nargin<2
    ttl = '';
end

fig = figure; 
subplot(3,1,1); plot(motion(:,1:3)); 
%title(['Translation ' ttl]);
title(['Translation ' ttl], 'Interpreter', 'none');
xlim([1 size(motion,1)])
subplot(3,1,2); plot(motion(:,4:6)); 
title(['Rotation ' ttl], 'Interpreter', 'none');
xlim([1 size(motion,1)])
subplot(3,1,3); plot(FDcalculation(motion));
hold on; plot([0 size(motion,1)], [0.5 0.5],'r');
hold on; plot([0 size(motion,1)], [1.5 1.5],'r');
title(['FD ' ttl], 'Interpreter', 'none');
axis([0 size(motion,1) 0 2]);
xlim([1 size(motion,1)])


end