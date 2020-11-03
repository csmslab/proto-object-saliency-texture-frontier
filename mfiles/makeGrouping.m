function gPyr = makeGrouping(b1Pyr,b2Pyr,params)
%Computed grouping activity from the border ownership pyramids
%
%Inputs:
%b1Pyr - Border Ownership pyramid 1
%b2Pyr - Border Ownership pyramid 2
%params - model parameter structure
%
%Outputs: 
%gPyr - grouping pyramid
%
%Modified by Takeshi Uejima, Johns Hopkins University, 2018-2020
%Proto-object saliency model is originally coded by Alexander Russell and Stefan Mihalas, Johns Hopkins Univeristy, 2012

for m = 1:size(b1Pyr,2)
    fprintf('\nAssigning Grouping on ');
    fprintf(b1Pyr{m}.type);    
    fprintf(' channel:\n');    
    for sub = 1:size(b1Pyr{m}.subtype,2)
        fprintf('Subtype %d of %d : ',sub,size(b1Pyr{m}.subtype,2));
        fprintf(b1Pyr{m}.subname{sub});
        fprintf('\n');
        if contains(b1Pyr{m}.type ,'BigCSMises')
            [gPyr1_1{m}.subtype{sub} gPyr2_1{m}.subtype{sub}] = groupingPyramidMaxDiffTex(b1Pyr{m}.subtype{sub},b2Pyr{m}.subtype{sub},params);
        else
            [gPyr1_1{m}.subtype{sub} gPyr2_1{m}.subtype{sub}] = groupingPyramidMaxDiff(b1Pyr{m}.subtype{sub},b2Pyr{m}.subtype{sub},params);
        end
        
        g11 = mergeLevel(gPyr1_1{m}.subtype{sub});
        g21 = mergeLevel(gPyr2_1{m}.subtype{sub});
        gPyr{m}.subtype{sub} = sumPyr(g11,g21);        
    end
    gPyr{m}.type = b1Pyr{m}.type;
    if contains( b1Pyr{m}.type ,'BigCSMises')
        gPyr{m}.originalSize=b1Pyr{m}.originalSize;
    end
end
