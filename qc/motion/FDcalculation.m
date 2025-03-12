function [FD] = FDcalculation(motion)

% motion - Nx6 array containing 6 motion parameters(x,y,z and angles)


for i = 2:size(motion,1)
    FD(i) = sum(abs(motion(i,1:3)-motion(i-1,1:3))) + 50*pi/180*sum(abs(motion(i,4:6)-motion(i-1,4:6)));
end

end