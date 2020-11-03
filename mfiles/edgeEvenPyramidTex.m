function newMap =  edgeEvenPyramidTex(map,params)
%Performs edge detection using even cells on the inputted
%image pyramid map. Convolved with the center surround operator
%these cells approximate an even gabor filter 
%
%inputs:
%map - input pyramid of images
%params - parameters structure
%
%outputs:
%newMap - pyramid structure of results
%
%Modified by Takeshi Uejima, Johns Hopkins University, 2018-2020
%By Alexander Russell and Stefan Mihalas, Johns Hopkins University, 2010

prs = params.evenCellPrs;
texPrs=params.tex;
for ori = 1:prs.numOri
    Evmsk =  makeEvenOrientationCells(prs.oris(ori),prs.lambda,prs.sigma,prs.gamma);    
    for l = texPrs.minLevel:texPrs.maxLevel
        newMap(l).orientation(ori).ori = prs.oris(ori);
        newMap(l).orientation(ori).data =  validFilt(map(l).data,Evmsk);
    end
end
