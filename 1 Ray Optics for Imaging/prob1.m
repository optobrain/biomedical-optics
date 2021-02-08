%% Symbolic

clear all;

syms f zSamp zImg positive
syms thSamp positive
assume(zSamp > f)
assumptions

rIn = [0 thSamp]'

rtmSys = [1 zImg; 0 1] * [1 0; -1/f 1] * [1 zSamp; 0 1]

rOut = rtmSys * rIn

xOut(f,zSamp,zImg,thSamp) = rOut(1)

xOutDiff(f,zSamp,zImg) = xOut(f,zSamp,zImg,0) - xOut(f,zSamp,zImg,0.1)

zImgSol(f,zSamp) = solve( xOutDiff == 0 , zImg)

[zImgSol(f,zSamp),solPara,solCond] = solve( xOutDiff == 0 , zImg, 'ReturnConditions',true)

zImgSol(100,150)






