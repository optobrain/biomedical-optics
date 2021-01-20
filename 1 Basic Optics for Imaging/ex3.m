%% Symbolic

clear all;

syms f zSamp zImg positive
syms xSamp thSamp positive
assume(zSamp > f)

rIn = [xSamp thSamp]'

rtmSys = [1 zImg; 0 1] * [1 0; -1/f 1] * [1 zSamp; 0 1]

rOut = rtmSys * rIn

xOut(f,zSamp,zImg,xSamp,thSamp) = rOut(1)

xOut(100,150,300,xSamp,thSamp)


%% find zImg using symbolic code

xOut(100,150,zImg,20,thSamp)

xOutDiff(f,zSamp,zImg,xSamp) = xOut(f,zSamp,zImg,xSamp,0) - xOut(f,zSamp,zImg,xSamp,0.1)

[zImgSol(f,zSamp,xSamp),solPara,solCond] = solve( xOutDiff == 0 , zImg, 'ReturnConditions',true)

zImgSol(100,150,20)


%% Numerical:
% Constants and given values: all lengths are in [mm].

clear;

f = 100;  % the lens focal length
xSamp = 20;  % the initial x position: the sample position
zSamp = -150;  % the initial z position: the sample position


%% Make z and RTMs

% sample z
dz = 1;  % step size in z; arbitrarily chosen
zEnd = 400;  % the z position at which our calculation will stop
z = zSamp:dz:zEnd;  % array of z positions
nz = length(z);  % length of the array

% RTMs
rtmLens = [1 0; -1/f 1];  % RTM of the lens
rtmAir = [1 dz; 0 1];  % RTM of a thin air slab with the thickness of dz


%% Trace a ray normal to the lens, as an example

% initial angle
thetaSamp = 0;  % the initial ray angle: a ray normal to the lens

% prepare the ray vector
r = zeros(2,nz);  % array of ray vectors (at every z position).  r(1,iz) is the height (x), and r(2,iz) is the angle at iz'th z position
r(:,1) = [xSamp thetaSamp]';  % the initial ray vector.  we need the transpose (') as r(:,1) is a column vector.

% calculate ray vector at each z position from the initial position step by step
for iz=2:nz
    r(:,iz) = rtmAir * r(:,iz-1);  % multiply the air RTM
    if z(iz) == 0  % multiply the lens RTM when z = 0 (the position of the lens)
        r(:,iz) = rtmLens * r(:,iz);
    end
end
        
% plot x positions as a function of z
figure;
plot(z,r(1,:));  
line(z,zeros(size(z)),'color','k','linewidth',2);  % optical axis
line([0 0], get(gca,'ylim'),'color','k','linewidth',2);  % lens
axis image;  % set x and z scales identical
grid on;
xlabel('z [mm]');
ylabel('x [mm]');

    
%% Trace 9 rays with different initial angles

% initial angles : many values
thetaSamp = linspace(-pi/8,pi/8,9);  % array of the initial angle
ntheta = length(thetaSamp);

% repeat the above of tracing a ray FOR each of the initial angles
r = zeros(2,nz,ntheta);  % a set of ray vectors for each z position and each initial angle
for itheta=1:ntheta  
    thetaSamp1 = thetaSamp(itheta);  % itheta'th angle value
    
    r1 = zeros(2,nz);  % array of ray vectors (at every z position) for the given angle
    r1(:,1) = [xSamp thetaSamp1]';
    for iz=2:nz
        r1(:,iz) = rtmAir * r1(:,iz-1);  % multiply the air RTM
        if z(iz) == 0  % multiply the lens RTM when z = 0 (the position of the lens)
            r1(:,iz) = rtmLens * r1(:,iz);
        end
    end
    
    % assign the calculated r1 to r
    r(:,:,itheta) = r1;
end
        
% plot x positions as a function of z, all lines
figure;
plot(z,squeeze(r(1,:,:)));  
line(z,zeros(size(z)),'color','k','linewidth',2);  % optical axis
line([0 0], get(gca,'ylim'),'color','k','linewidth',2);  % lens
axis image;  % set x and z scales identical
grid on;
xlabel('z [mm]');
ylabel('x [mm]');


%% find z position at which the rays are focused (i.e., variance in x between rays is minimized)

% iz of the lens: we will look into variance after this iz (later the lens) because the initial position has zero variance
iz0 = find(z==0);  % iz index of the lens (z=0).  

% find where variance of x is minimized (i.e., focused)
varX = squeeze(var(r(1,:,:),[],3));  % variance of x (1st element of the first dimension) along theta (the 3rd dimension)
[varXmin,iz] = min(varX(iz0:end));  % find the min variance for iz >= iz0
iz = iz-1+iz0;  % compensate for iz0

% find x at the focused position
meanX = mean(squeeze(r(1,iz,:)));  % average x position of the traced rays

% print result
disp(['The rays focus at [z x] = ' mat2str([z(iz) meanX],3) ' mm with x variance = ' num2str(varXmin,3) ...
    newline 'The magnification is ' num2str(abs(meanX/xSamp),2)]);

