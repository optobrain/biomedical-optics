%% Constants and given values: all lengths are in [mm].

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


%% For each position of 0<x<x0, trace 5 rays with different initial angles, resulting in the focusing (x,z) position

% initial angles
thetaSamp = linspace(-pi/8,pi/8,5);  % array of the initial angle.  We can reduce the number of angles here as we will plot all rays for various x positions below
ntheta = length(thetaSamp);

% sample x for initial positions of the sample
dx = 1;  % sampling step size in x (along the object)
x = 0:dx:xSamp;
nx = length(x);

r = zeros(2,nz,ntheta,nx);  % a set of ray vectors for each z position and each initial angle and each initial x position
for ix=1:nx
    x1 = x(ix);  % ix'th initial x position
    
    for itheta=1:ntheta
        thetaSamp1 = thetaSamp(itheta);  % itheta'th angle value

        % repeat the code of Example 1.3 to tracy a ray with the angle theta1
        r1 = zeros(2,nz);  % array of ray vectors (at every z position) for the given angle
        r1(:,1) = [x1 thetaSamp1]';  % here the initial position is x1, not x0
        for iz=2:nz
            r1(:,iz) = rtmAir * r1(:,iz-1);  % multiply the air RTM
            if z(iz) == 0  % multiply the lens RTM when z = 0 (the position of the lens)
                r1(:,iz) = rtmLens * r1(:,iz);
            end
        end

        % assign the calculated r1 to r
        r(:,:,itheta,ix) = r1;
    end
end


%% Plot x positions as a function of z, all lines, for each initial x position

clr = lines(nx);  % line color for each initial x position
figure;
for ix=1:nx
    for itheta=1:ntheta
        line(z,r(1,:,itheta,ix),'color',clr(ix,:));  
    end
end
line(z,zeros(size(z)),'color','k','linewidth',2);  % optical axis
line([0 0], get(gca,'ylim'),'color','k','linewidth',2);  % lens
axis image;  % set x and z scales identical
grid on;
xlabel('z [mm]');
ylabel('x [mm]');


%% For each initial x position, find z position at which the rays are focused (i.e., variance in x between rays is minimized)

xFocus = zeros(nx,1);
zFocus = zeros(nx,1);

iz0 = find(z==0);  % iz of z = 0.  we will look into variance after this iz0 (later the lens) because the initial position has zero variance
for ix=1:nx
    r1 = r(:,:,:,ix);  % the set of ray vectors for ix'th initial x position
    xVar = squeeze(var(r1(1,:,:),[],3));  % variance of x (1st element of the first dimension) along theta (the 3rd dimension)
    [xVarMin,iz] = min(xVar(iz0:end));  % find the min variance from iz0
    iz = iz-1+iz0;  % compensate the iz0
    zFocus(ix) = z(iz);
    xFocus(ix) = mean(squeeze(r1(1,iz,:)));  % average x position
end

figure;
for ix=1:nx
    line([zSamp zFocus(ix)],[x(ix) xFocus(ix)],'color',clr(ix,:),'marker','o');  % plot a straight line between each object point and its focus point (image point)
end
line(z,zeros(size(z)),'color','k','linewidth',2);  % optical axis
line([0 0], get(gca,'ylim'),'color','k','linewidth',2);  % lens
axis image;  % set x and z scales identical
grid on;

imageLength = max(xFocus)-min(xFocus);
disp(['The image is made at z = ' num2str(mean(zFocus),3) '+/-' num2str(std(zFocus),3) ' mm, ' ...
    'and its length is ' num2str(imageLength,3) ' mm (i.e., magnification = ' num2str(imageLength/xSamp,3) ').']);

