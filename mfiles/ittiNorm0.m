function h = ittiNorm0(gPyr,collapseLevel,params)
%Normalizes and combines the grouping pyramids into a saliency map
%This is performed in an identical manner to how the feature maps in the
%Itti et al (1998) paper are combined
%
%Inputs:
%gPyr - grouping pyramid
%collapseLevel - final merge level of all the conspicuity maps
%
%Outputs:
%h - saliency map data structure
%
%Modified by Takeshi Uejima, Johns Hopkins University, 2018-2020
%Proto-object saliency model is originally coded by Alexander Russell and Stefan Mihalas, Johns Hopkins Univeristy, 2012
fprintf('\nNormalizing Grouping Pyramids\n');

for m = 1:size(gPyr,2)
    if contains(gPyr{m}.type,'BigCSMises')
        resSize=round(gPyr{m}.originalSize/(sqrt(2)^(collapseLevel-1)));
    else
        resSize=round(size(gPyr{1}.subtype{1}(1).data)/(sqrt(2)^(collapseLevel-1)));
    end
      if strfind(gPyr{m}.type,'Orientation')%~strcmp(gPyr{m}.type,'Orientation')&&~strcmp(gPyr{m}.type,'Orientation-Gauss')&&~strcmp(gPyr{m}.type,'Orientation-NCRF') 
        %normalize pyramids for each angle separately then merge
        FM = gPyr{m}.subtype;
        CM{m}.data = zeros(resSize);
        clear CML
        for sub = 1:size(FM,2)
            CML{sub}.data = zeros(resSize);
            for l = 1:size(FM{sub},2)
                FML{sub}(l).data = maxNormalizeLocalMax(FM{sub}(l).data,[0 10]);
                CML{sub}.data = CML{sub}.data + imresize(FML{sub}(l).data,resSize);
            end  
            CM{m}.data = CM{m}.data + CML{sub}.data;
        end
        %Imagesc FM
        if params.save==1
            for ii=1:size(FML,2)
                for level=1:size(FML{ii},2)
                    imagesc(FML{ii}(level).data);colorbar;axis image;
                    saveas(gcf,['FML_',gPyr{m}.type,'_subtype',num2str(ii),'_l',num2str(level),'.png'])
                end
            end
        end
        
      else %if strfind(gPyr{m}.type,'Orientation')%strcmp(gPyr{m}.type,'Orientation')||strcmp(gPyr{m}.type,'Orientation-Gauss')||strcmp(gPyr{m}.type,'Orientation-NCRF')
        %first sum subtypes across levels then normalize each level
        FM = [];CML=[];
        for l = 1:size(gPyr{m}.subtype{1},2)
            FM(l).data= zeros(size(gPyr{m}.subtype{1}(l).data,1),size(gPyr{m}.subtype{1}(l).data,2));
            for sub = 1:size(gPyr{m}.subtype,2)            
                FM(l).data = FM(l).data + maxNormalizeLocalMax(gPyr{m}.subtype{sub}(l).data,[0 10]);
            end
        end
        for l = 1:size(FM,2)
            CML(l).data = FM(l).data;%maxNormalizeLocalMax(FM(l).data,[0 10]);
        end
        CM{m}.data = zeros(resSize);
        for l = 1:size(CML,2)
            CM{m}.data = CM{m}.data + imresize(CML(l).data,resSize);
        end
%         %Imagesc CML
        if params.save==1
            for level=1:size(CML,2)
                imagesc(FM(level).data);colorbar;axis image;
                saveas(gcf,['CML_',gPyr{m}.type,'_subtype',num2str(m),'_l',num2str(level),'.png'])
                save(['CML_',gPyr{m}.type,'_subtype',num2str(m),'.mat'],'CML')
            end
        end
%     else
%         error('Please ensure algorithm operates on known feature types');
    end
end

h.data = zeros(size(CM{1}.data));
for m = 1:size(CM,2)
    h.data = h.data + 1/3.*maxNormalizeLocalMax(CM{m}.data,[0 10]);% + CM{2}.data;
end
        