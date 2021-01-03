%% Constants and given values: all lengths are in [mm].

clear;

% sample x and make f(x)
x = 1:100;  % sampled x [0 100]
f = exp(-0.2*(x-40));  
f(x<40) = 0;


%% Make the kernel and conduct convolution

% kernel g(x)
x1 = -10:10;  % x for g
g = ones(size(x1));
g = g/sum(g);  % normalize g 

% convolution
fConv = conv(f,g,'same');

% plot
figure;
subplot(311);  plot(x,f);  xlim([0 100]);
subplot(312);  plot(x1,g);  xlim([-50 50]);
subplot(313);  plot(x,[f',fConv']);  xlim([0 100]);


%% Change the kernel size

kerSize = (4:2:20);  % many kernel sizes: better to be even numbers to make g(x) symmetric
nk = length(kerSize);

figure;
line(x,f,'color','k');  % the original f(x) in black
clr = lines(nk);  % different color for different kerSize result
for ik=1:nk
    kerSize1 = kerSize(ik);
    
    x1 = -kerSize1/2:kerSize1/2;
    g = ones(size(x1));
    g = g/sum(g);
    
    fConv = conv(f,g,'same');
    line(x,fConv,'color',clr(ik,:));
end
legend(cat(2,{'raw'},compose('%g',kerSize)));
    



%% Exponential decay f

f = exp(-(x-4));
f(x<4) = 0;

figure;
plot(x,f);


%% Make z and RTMs

% sample z
dz = 1;  % step size in z; arbitrarily chosen
zEnd = 100;  % the z position at which our calculation will stop
z = zSam:dz:zEnd;  % array of z positions
nz = length(z);  % length of the array

