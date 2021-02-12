%% RTM and rOut in symbolic

clear all;

syms f positive  % zImg = f
syms xIn theta positive

rIn = [xIn -theta]'

rtmSys = [1 f; 0 1] * [1 0; -1/f 1]

rOut = rtmSys * rIn

rOut(1)


%% Calculate value

xOut(f,theta) = rOut(1)  % declare a function explicitly

xOutVal = xOut(100,atan(1/10))

xOutVal = eval(xOutVal)  % test from Oscar





