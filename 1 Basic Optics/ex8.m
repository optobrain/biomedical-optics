%% Constants and given values

clear;

c = 3e8;  % speed of light (m/s)

E0 = 2.0;  % amplitude
nu = 1e8;  % frequency
omega = 2*pi*nu;  % angular frequency
k_hat = [2 1 0] / norm([2 1 0]);  % unit vector of k

k = omega/c*k_hat;  % k vector


%% Make a 2D grid of (x,y)

dx = 0.1;  % sampling interval [m]
x = -10:dx:10;
y = -5:dx:5;  % set dy = dx
[gx,gy] = ndgrid(x,y);
size(gx)  % check the size


%% Plot for each time point to make a video

tMax = 20e-9;  % the maximum time until which we will make a video
dt = 0.1e-9;  % time step for each frame in the video
t = 0:dt:tMax;  % an array of time points
nt = length(t);

v = VideoWriter('ex8.mp4','MPEG-4');  % the result video will be saved as ex6.mp4
v.Quality = 95;
v.FrameRate = 10;  % 10 frames per second.  Each frame is 0.1 ns, thus 1 ns video per second (i.e., 200 frames or 20 s in total)
open(v);

figure;  colormap(jet);
hold on;  
for it=1:nt
    t1 = t(it);
    
    E = E0 * cos(k(1)*gx + k(2)*gy + k(3)*0 - omega*t1);  % z = 0 on the xy plane, t = t1
    imagesc(x,y,E');  % use the transpose because imagesc() plots the first dimension of the 2D array (x here) in the vertical axis
    axis image;  % make x and y scale identical
    set(gca,'ydir','normal');  % without this, imagesc() has the vertical axis start from the top
    set(gca,'clim',[-2 2]);  % we know the E field magnitude should be between -2 and 2.
    cb = colorbar;
    cb.Label.String = 'E field magnitude';
%     cb.Label.Rotation = 270;  cb.Label.Position(1) = 3;
    xlabel('x [m]');
    ylabel('y [m]');
    title(['E(x,y) at t = ' num2str(t1*1e9) ' ns']);    

    frm = getframe(gcf);
    writeVideo(v,frm);
end

close(v);





