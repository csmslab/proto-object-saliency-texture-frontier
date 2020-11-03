function cPyr = makeComplexEdge(EPyr, OPyr)
%make complex edges from edges computed using even and odd gabor functions
%
%Inputs
%EPyr - even Gabor filter edge pyramid
%OPyr - odd Gabor filter edge pyramid
%
%Outputs:
%cPyr - complex edge pyramid

for l = 1:size(EPyr,2)
    for ori = 1:size(EPyr(l).orientation,2)
        cPyr(l).orientation(ori).data = sqrt(EPyr(l).orientation(ori).data.^2 ...
            +OPyr(l).orientation(ori).data.^2);
    end
end
