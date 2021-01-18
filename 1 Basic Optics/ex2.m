%% Symbolic

clear all;

syms f positive  % zImg = f
syms xIn theta positive

rIn = [xIn -theta]'

rtmSys = [1 f; 0 1] * [1 0; -1/f 1]

rOut = rtmSys * rIn

rOut(1)


%% calculate value

xOut(f,theta) = rOut(1)

xOutVal = xOut(100,atan(1/10))

eval(abs(xOutVal))





