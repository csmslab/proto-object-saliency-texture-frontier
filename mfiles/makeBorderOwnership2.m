function [b1Pyr, b2Pyr]  = makeBorderOwnership2(imgPyr,params)
%Calculates grouping and border ownership for the input image im
%
%Inputs:
%   im - image structure on which to perform grouping and border ownership
%   params
%
%Outputs:
%   b1Pyr, b2Pyr - Border ownership activity (left and right)
%
%Modified by Takeshi Uejima, Johns Hopkins University, 2018-2020
%Proto-object saliency model is originally coded by Alexander Russell and Stefan Mihalas, Johns Hopkins Univeristy, 2012

%% EXTRACT EDGES

for m = 1:size(imgPyr,2)
    fprintf('\nAssigning Border Ownership on ');
    fprintf(imgPyr{m}.type);    
    fprintf(' channel:\n');    
    for sub = 1:size(imgPyr{m}.subtype,2)        
        fprintf('Subtype %d of %d : ',sub,size(imgPyr{m}.subtype,2));
        %% -----------------Edge Detection ------------------------------------
        if contains(imgPyr{m}.type ,'BigCSMises')
            EPyr = edgeEvenPyramidTex(imgPyr{m}.subtype{sub}.pyr,params);
            [OPyr, ~] = edgeOddPyramidTex(imgPyr{m}.subtype{sub}.pyr,params);
        else
            EPyr = edgeEvenPyramid(imgPyr{m}.subtype{sub}.pyr,params);
            [OPyr, ~] = edgeOddPyramid(imgPyr{m}.subtype{sub}.pyr,params);
        end
        cPyr = makeComplexEdge(EPyr,OPyr);

        %% ----------------make image pyramid ---------------------------------
        if strcmp(imgPyr{m}.type ,'OrientationOriginal')
            fprintf(imgPyr{m}.subtype{sub}.type);
            fprintf('\n');
            csPyr = gaborPyramid(imgPyr{m}.subtype{sub}.pyr,imgPyr{m}.subtype{sub}.ori,params);
            [csPyrL, csPyrD] = seperatePyr(csPyr);
            [csPyrL, csPyrD] = normCSPyr2(csPyrL,csPyrD);%Normalize N1

        elseif contains(imgPyr{m}.type ,'BigCSMises')
            depth=params.tex.maxLevel;
            fprintf(imgPyr{m}.subtype{sub}.type);
            fprintf('\n');
            csPyr = csPyramidTexture2(imgPyr{m}.subtype{sub}.pyr,params, depth, 2);
            [csPyrL, csPyrD] = seperatePyrTexture(csPyr,params, depth);
            [csPyrL, csPyrD] = normCSPyr2Texture(csPyrL,csPyrD,params, depth);%Normalize N1

        else
            fprintf(imgPyr{m}.subtype{sub}.type);
            fprintf('\n');
            csPyr = csPyramid(imgPyr{m}.subtype{sub}.pyr,params);
            [csPyrL, csPyrD] = seperatePyr(csPyr);
            [csPyrL, csPyrD] = normCSPyr2(csPyrL,csPyrD);%Normalize N1

        end

            
        %% GENERATE BORDER OWNERSHIP AND GROUPING MAPS
        %Get border Ownership Pyramids
        if contains(imgPyr{m}.type ,'BigCSMises')
            [bPyr1_1, bPyr2_1, bPyr1_2, bPyr2_2] = borderPyramid3Tex(csPyrL,csPyrD,cPyr,params);
        else
            [bPyr1_1, bPyr2_1, bPyr1_2, bPyr2_2] = borderPyramid3(csPyrL,csPyrD,cPyr,params);
        end
       
        b1Pyr{m}.subtype{sub} = sumPyr(bPyr1_1,bPyr1_2);
        b2Pyr{m}.subtype{sub} = sumPyr(bPyr2_1,bPyr2_2);        
        if strfind(imgPyr{m}.type,'Orientation')
            b1Pyr{m}.subname{sub} =   [num2str(rad2deg(imgPyr{m}.subtype{sub}.ori)) ' deg']; 
            b2Pyr{m}.subname{sub} =   [num2str(rad2deg(imgPyr{m}.subtype{sub}.ori)) ' deg'];
        else
            b1Pyr{m}.subname{sub} =   imgPyr{m}.subtype{sub}.type; 
            b2Pyr{m}.subname{sub} =   imgPyr{m}.subtype{sub}.type;
        end

    end
    b1Pyr{m}.type = imgPyr{m}.type;
    b2Pyr{m}.type = imgPyr{m}.type;
    if contains(imgPyr{m}.type ,'BigCSMises')
        b1Pyr{m}.originalSize=imgPyr{m}.originalSize;
    end
end


