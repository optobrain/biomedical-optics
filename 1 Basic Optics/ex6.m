%% Constants and given values: all lengths are in [mm].

clear;


## use the FOR for local averaging first, and then use convn for 2D convolution + the down sampling (picking the center) maybe there is an option in convn?.

% sample x and make f(x)
x = 1:100;  % sampled x [0 100]
f = exp(-0.2*(x-40));  
f(x<40) = 0;
