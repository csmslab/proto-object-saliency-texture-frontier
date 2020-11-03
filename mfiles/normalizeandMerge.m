function h = normalizeandMerge(gPyr,params,parms,level)
%normalizes and merges the grouping pyramids. This functin is for use
%in finding the best model parameters.
%
%Inputs:
%gPyr - grouping pyramids
%params - model parameters
%parms - optimization parameters
%
%Outputs:
%h - combined saliency map
%
%By Alexander Russell.


g = normalizeGrouping(gPyr,params.NieburNorm);

h.data = zeros(size(g{1}(level).data));

%decode optimization parameters

maxLevel = parms(1);

a = abs(parms(2));%pyramid depth scaling

Iw = parms(3);%image pyramid weight

Cw = parms(4);%color oppency weight



for m = 1:size(g,2)
    conspicuity{m}.data = mergePyr_params(g{m},params,maxLevel,a,level);
end


c1 =  maxNormalizeLocalMax(conspicuity{1}.data,[0 10]);
c2 =  maxNormalizeLocalMax(conspicuity{2}.data,[0 10]);
c3 =  maxNormalizeLocalMax(conspicuity{3}.data,[0 10]);


h.data = Iw.*c1 + Cw.*(c2+c3);
h.type = 'Itti, Koch, Niebur Normalization';