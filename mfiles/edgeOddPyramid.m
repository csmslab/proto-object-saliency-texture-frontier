function [newMap1 newMap2] =  edgeOddPyramid(map,params)
%this function performs edge detection using odd cells on the inputted
%image pyramid
%
%inputs:
%map - input image pyramid
%params - parameters for odd cell edge detection
%
%outputs:
%newMap1 - result pyramid with polarity 1
%newMap2 - result pyramid with polarity 2

%
%By Alexander Russell and Stefan Mihalas, Johns Hopkins University, 2012

prs = params.oddCellPrs;

for ori = 1:prs.numOri    
    [Oddmsk1 Oddmsk2] = makeOddOrientationCells(prs.oris(ori),prs.lambda,prs.sigma,prs.gamma);
    for l = prs.minLevel:prs.maxLevel
        newMap1(l).orientation(ori).ori = prs.oris(ori);
        newMap1(l).orientation(ori).data = validFilt(map(l).data,Oddmsk1);
        newMap2(l).orientation(ori).ori = prs.oris(ori);
        newMap2(l).orientation(ori).data =  validFilt(map(l).data,Oddmsk2);
    end
end
