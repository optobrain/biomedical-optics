%% Constants and given values: all lengths are in [um].

clear;

nx = 100;  ny = 80;  % number of sampling points (pixels of the camera)
dxImg = 10;  % the sensor pixel size [um]
zImg = 300e3;  % the lens-sensor distance [um]
f = 100e3;  % the focal length
diaAper = 50e3;  % the aperture diameter

load("virtualTarget.mat","phySamp");  % phySamp : the virtual resolution test target
phySamp = double(phySamp);  % convert the boolean array to a double array for further computation
[nxp,nyp] = size(phySamp);  % size of the physical sample [pixels]
dxp = 0.1;  % um per pixel of the physical sample

% basic parameters
zFP = 1/(1/f-1/zImg)  % the focal plane position [um] (Eq. 1.7)
dxFP = zFP/zImg*dxImg  % the sampling interval on the focal plane [um] (Eq. 1.8)

% sample position
zSamp = zFP + 20;  % the sample position [um]

% sampling interval and kernel size
dxSamp = zSamp/zImg*dxImg  % the sampling interval on the sample plane [um] (Eq. 1.4)
dxKern = zSamp/zImg*dxImg + diaAper*abs(zSamp/zFP-1)  % kernel size [um]


%% Convolution using convn()

% define kernel
dxKernPhy = round(dxKern/dxp);  % the kernel size in terms of the physical pixel number
kern = ones(dxKernPhy,dxKernPhy);
kern = kern/sum(kern(:));  % normalize the kernel when using convn()

% convolution of the phySamp
phySampConv = convn(phySamp,kern,'same');  

% pick the data from the center of each "camera pixel" on the sample plane
dxSamPhy = round(dxSamp/dxp);  % the sampling interval in terms of the physical pixel number
img = phySampConv(round(dxSamPhy/2):dxSamPhy:end,round(dxSamPhy/2):dxSamPhy:end);

% crop img if it is larger than the FOV
if size(img,1) > nx
    img = img(1:nx,:);
end
if size(img,2) > ny
    img = img(:,1:ny);
end

figure;  colormap(gray);
imagesc(img');
set(gca,'ydir','normal');
axis image;


%% Resolution

% visually, 2^7=128 pixels or 12.8-um pattern (7-dots column) is clear.  
% Thus, the resolution is better than 12.8 um, similar to the kernel size 12 um.
% quantitatively, we can use the Rayleigh criterion (minimum 25% dip).

ix128 = 22;  % the center X position of the 12.8-um pattern
ix64 = 13;  % the center X position of the 6.4-um pattern

figure;
subplot(211);  
    I = img(ix128,:);
    [pks,locs] = findpeaks(I);
    plot(I);
    line(locs,pks,'linestyle','none','marker','o','color','r');
    ylim([0 1]);  set(gca,'ytick',(0:.1:1));  grid on;
subplot(212);  
    I = img(ix64,:);
    [pks,locs] = findpeaks(I);
    plot(I);
    line(locs,pks,'linestyle','none','marker','o','color','r');
    ylim([0 1]);  set(gca,'ytick',(0:.1:1));  grid on;

% we can see 3 peaks in 6.4-um but the dips are smaller than 25%.





