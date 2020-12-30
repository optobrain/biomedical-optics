%% Constants and given values: all lengths are in [mm].

clear;

f = 50;  % the lens focal length
x0 = 20;  % the initial x position
z0 = -150;  % the initial z position


%% Trace a ray normal to the lens, as an example

dz = 1;  % step size in z; arbitrarily chosen
zMax = 100;  % the z position at which our calculation will stop

M_lens = [1 0; -1/f 1];  % RTM of the lens
M_air = [1 dz; 0 1];  % RTM of a thin air slab with the thickness of dz

z = z0:dz:zMax;  % array of z positions
nz = length(z);  % length of the array

theta0 = 0;  % a ray normal to the lens

r = zeros(2,nz);  % array of ray vectors (at every z position).  r(1,iz) is the x position, and r(2,iz) is the angle at iz'th z position
r(:,1) = [x0 theta0]';  % the initial ray vector.  we need the transpose (') as r(:,1) is a column vector.

% calculate ray vector at each z position from the initial position step by step
for iz=2:nz
    r(:,iz) = M_air * r(:,iz-1);  % multiply the air RTM
    if z(iz) == 0  % multiply the lens RTM when z = 0 (the position of the lens)
        r(:,iz) = M_lens * r(:,iz);
    end
end
        
% plot x positions as a function of z
figure;
plot(z,r(1,:));  
grid on;
xlabel('z [mm]');
ylabel('x [mm]');

    
%% Trace 10 rays with different initial angles

dz = 1;  % step size in z; arbitrarily chosen
zMax = 100;  % the z position at which our calculation will stop

M_lens = [1 0; -1/f 1];  % RTM of the lens
M_air = [1 dz; 0 1];  % RTM of a thin air slab with the thickness of dz

z = z0:dz:zMax;  % array of z positions
nz = length(z);  % length of the array

theta = linspace(-pi/16,pi/16,10);  % array of the initial angle
ntheta = length(theta);

r = zeros(2,nz,ntheta);  % a set of ray vectors for each z position and each initial angle
for itheta=1:ntheta
    theta1 = theta(itheta);  % itheta'th angle value
    
    % repeat the above to tracy a ray with the angle theta1
    r1 = zeros(2,nz);  % array of ray vectors (at every z position) for the given angle
    r1(:,1) = [x0 theta1]';
    for iz=2:nz
        r1(:,iz) = M_air * r1(:,iz-1);  % multiply the air RTM
        if z(iz) == 0  % multiply the lens RTM when z = 0 (the position of the lens)
            r1(:,iz) = M_lens * r1(:,iz);
        end
    end
    
    % assign the calculated r1 to r
    r(:,:,itheta) = r1;
end
        
% plot x positions as a function of z, all lines
figure;
plot(z,squeeze(r(1,:,:)));  
grid on;
xlabel('z [mm]');
ylabel('x [mm]');

% find z position at which the rays are focused (i.e., variance in x between rays is minimized)
iz0 = find(z==0);  % iz of z = 0.  we will look into variance after this iz0 (later the lens) because the initial position has zero variance
xVar = squeeze(var(r(1,:,:),[],3));  % variance of x (1st element of the first dimension) along theta (the 3rd dimension)
[xVarMin,iz] = min(xVar(iz0:end));  % find the min variance from iz0
iz = iz-1+iz0;  % compensate the iz0
xMean = mean(squeeze(r(1,iz,:)));  % average x position
disp(['The rays are focused at [x z] = ' mat2str([xMean z(iz)],2) ' mm with x variance = ' num2str(xVarMin,3)]);






