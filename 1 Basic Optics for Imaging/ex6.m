%% Constants and given values: all lengths are in [um].

clear;

nx = 100;  ny = 80;  % number of sampling points (pixels of the camera)

dxSamp = 5;  % the sampling interval on the focal plane [um]

load("virtualTarget.mat","phySamp");  % phySamp : the virtual resolution test target
phySamp = double(phySamp);  % convert the boolean array to a double array for further computation
[nxp,nyp] = size(phySamp);  % size of the physical sample [pixels]
dxp = 0.1;  % um per pixel of the physical sample


%% Manually implement the convolution

% define kernel size
dxKernPhy = round(dxSamp/dxp);  % the kernel size in terms of physical pixels 

% empty array as a resulting image
img = zeros(nx,ny);
ixKern = 0;  iyKern = 0;  % starting position of the sampling kernel
for iy=1:ny
    for ix=1:nx
        % for each (ix,iy)th pixel of the image
        % average the corresponding area (kernel) of the virtual sample
        sam1 = phySamp(ixKern+(1:dxKernPhy),iyKern+(1:dxKernPhy));  % extract the piece of the virtual sample
        img(ix,iy) = mean(sam1(:));  % average the information within the piece
        
        ixKern = ixKern + dxKernPhy;  % update ix for the next kernel position in X
    end
    iyKern = iyKern + dxKernPhy;  ixKern = 0;  % update iy and ix for the next kernel position
end

figure;  colormap(gray);
imagesc(img');
set(gca,'ydir','normal');
axis image;


%% Use convn()

% define kernel
kern = ones(dxKernPhy,dxKernPhy);
kern = kern/sum(kern(:));  % normalize the kernel when using convn()

% convolution of the phySamp
phySampConv = convn(phySamp,kern,'same');  

% pick the data from the center of each "camera pixel" on the sample plane
dxSamPhy = round(dxSamp/dxp);  % the sampling interval in terms of the physical pixel number
img2 = phySampConv(round(dxSamPhy/2):dxSamPhy:end,round(dxSamPhy/2):dxSamPhy:end);

% crop img if it is larger than the FOV
if size(img2,1) > nx
    img2 = img2(1:nx,:);
end
if size(img2,2) > ny
    img2 = img2(:,1:ny);
end

figure;  colormap(gray);
imagesc(img2');
set(gca,'ydir','normal');
axis image;

disp(['Difference between the two methods: ' num2str(mean((img(:)-img2(:)).^2),3)]);


%% Resolution

% visually, 2^6=64 pixels or 6.4-um pattern (6-dots column) is clear.  
% Thus, the resolution is better than 6.4 um, similar to the kernel size 5 um.
% quantitatively, we can use the Rayleigh criterion (minimum 25% dip).

ix64 = 13;  % the center X position of the 6.4-um pattern
ix32 = 8; 

figure;
subplot(211);  
    I = img2(ix64,:);
    [pks,locs] = findpeaks(I);
    plot(I);
    line(locs,pks,'linestyle','none','marker','o','color','r');
    ylim([0 1]);  set(gca,'ytick',(0:.1:1));  grid on;
subplot(212);  
    I = img2(ix32,:);
    [pks,locs] = findpeaks(I);
    plot(I);
    line(locs,pks,'linestyle','none','marker','o','color','r');
    ylim([0 1]);  set(gca,'ytick',(0:.1:1));  grid on;

% we can see 3 peaks in 6.4-um but not in 3.2-um patterns.




