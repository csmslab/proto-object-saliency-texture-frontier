function imgPyr = generateChannelsPyramids(im,params)
%Generates the data structure to hold the different channels the algorithm
%operates on
%
%Inputs:
%im - input image to algorithm
%params - model parameter structure
%
%outputs:
%img - data structure holding different feature channels
%Modified by Takeshi Uejima, Johns Hopkins University, 2018-2020
%Proto-object saliency model is originally coded by Alexander Russell and Stefan Mihalas, Johns Hopkins Univeristy, 2012

[in, R,G,B,Y] = makeColors(im);

%Generate color opponency channels
rg = R-G;
by = B-Y;
gr = G-R;
yb = Y-B;
%Threshold opponency channels
rg(rg<0) = 0;
gr(gr<0) = 0;
by(by<0) = 0;
yb(yb<0) = 0;

%imagesc(exIm)
for c = 1:length(params.channels)
    if strcmp(params.channels(c),'I')
        %intensity
        fprintf('\nGenerating Intensity Pyramids\n');
        imgPyr{c}.subtype{1}.pyr = makePyramid(in,params);
        %img{c}.subtype{1}.data = in;
        imgPyr{c}.subtype{1}.type = 'Intensity';
        imgPyr{c}.type = 'Intensity';
        
    elseif strcmp(params.channels(c),'C')
        %color
        fprintf('\nGenerating Color Pyramids\n');
        imgPyr{c}.type = 'Color';
        imgPyr{c}.subtype{1}.pyr = makePyramid(rg,params);
        imgPyr{c}.subtype{1}.type = 'Red-Green Opponency';
        
        imgPyr{c}.subtype{2}.pyr = makePyramid(gr,params);
        imgPyr{c}.subtype{2}.type = 'Green-Red Opponency';
        
        imgPyr{c}.subtype{3}.pyr = makePyramid(by,params);
        imgPyr{c}.subtype{3}.type = 'Blue-Yellow Opponency';
        
        imgPyr{c}.subtype{4}.pyr = makePyramid(yb,params);
        imgPyr{c}.subtype{4}.type = 'Yellow-Blue Opponency';
        
    elseif strcmp(params.channels(c),'O')
        %orientation
        fprintf('\nGenerating Orientation Pyramids\n');
        tmpPyr = makePyramid(in,params);
        imgPyr{c}.type = 'OrientationOriginal';
        imgPyr{c}.subtype{1}.ori = 0; %orientation channel angle
        imgPyr{c}.subtype{1}.type = 'Orientation';
        fprintf('%d deg\n',0);
        imgPyr{c}.subtype{1}.pyr = makePyramid(in,params);
        imgPyr{c}.subtype{2}.ori = pi/4;
        imgPyr{c}.subtype{2}.type = 'Orientation';
        fprintf('%d deg\n',rad2deg(pi/4));
        imgPyr{c}.subtype{2}.pyr = makePyramid(in,params);
        imgPyr{c}.subtype{3}.ori = pi/2;
        imgPyr{c}.subtype{3}.type = 'Orientation';
        fprintf('%d deg\n',rad2deg(pi/2));
        imgPyr{c}.subtype{3}.pyr = makePyramid(in,params);
        imgPyr{c}.subtype{4}.ori = 3*pi/4;
        imgPyr{c}.subtype{4}.type = 'Orientation';
        fprintf('%d deg\n',rad2deg(3*pi/4));
        imgPyr{c}.subtype{4}.pyr = makePyramid(in,params);    
  
    elseif strcmp(params.channels(c),'A')
        fprintf('\nGenerating Orientation Opponency Energy Cross-Scale Pyramids\n');
        imgPyr{c}.type = 'Energy Cross-Scale Orientation-BigCSMises';
        imgPyr{c}.subtype{1}.type = '0-90_Opponency-CrossScale';
        imgPyr{c}.subtype{2}.type = '90-0_Opponency-CrossScale';
        imgPyr{c}.subtype{3}.type = '45-135_Opponency-CrossScale';
        imgPyr{c}.subtype{4}.type = '135-45_Opponency-CrossScale';
        
        tmpPyr = makePyramid(in,params);
        Gabor=cell(4,1);
        GaborOpp=cell(4,1);
        imgPyr{c}.subtype{1}.type = '0-90_Opponency';
        Gabor{1} = gaborPyramidTex(tmpPyr,0,params);
        
        imgPyr{c}.subtype{2}.type = '90-0_Opponency';
        Gabor{2} = gaborPyramidTex(tmpPyr,pi/4,params);
        
        imgPyr{c}.subtype{3}.type = '45-135_Opponency';
        Gabor{3} = gaborPyramidTex(tmpPyr,pi/2,params);
        
        imgPyr{c}.subtype{4}.type = '135-45_Opponency';
        Gabor{4} = gaborPyramidTex(tmpPyr,3*pi/4,params);
        for ii=1:4
            for jj=1:params.tex.maxLevel
                Gabor{ii}(jj).data=abs(Gabor{ii}(jj).data);
            end
        end
        for jj=1:params.tex.maxLevel
            GaborOpp{1}(jj).data=Gabor{1}(jj).data-Gabor{3}(jj).data;
            GaborOpp{2}(jj).data=Gabor{3}(jj).data-Gabor{1}(jj).data;
            GaborOpp{3}(jj).data=Gabor{2}(jj).data-Gabor{4}(jj).data;
            GaborOpp{4}(jj).data=Gabor{4}(jj).data-Gabor{2}(jj).data;
            GaborOpp{1}(jj).msk=Gabor{1}(jj).msk;
            GaborOpp{2}(jj).msk=Gabor{3}(jj).msk;
            GaborOpp{3}(jj).msk=Gabor{2}(jj).msk;
            GaborOpp{4}(jj).msk=Gabor{4}(jj).msk;
            for ii=1:4
                GaborOpp{ii}(jj).data(GaborOpp{ii}(jj).data<0)=0;
            end
        end
%         for ii=1:4
%             imgPyr{c}.subtype{ii}.pyr = GaborOpp{ii};
%         end
        
        pyrSize=cell(params.tex.maxLevel,1);
        for ii=1:params.tex.maxLevel
            pyrSize{ii}=size(GaborOpp{1}(ii).data);
        end
        for ii=1:4
            for jj=1:params.tex.maxLevel-3
                imgPyr{c}.subtype{ii}.pyr(jj*2-1).data = GaborOpp{ii}(jj).data .* imresize(GaborOpp{ii}(jj+2).data,size(GaborOpp{ii}(jj).data));
                imgPyr{c}.subtype{ii}.pyr(jj*2-1).data = imresize(imgPyr{c}.subtype{ii}.pyr(jj*2-1).data, pyrSize{jj*2-1});
                imgPyr{c}.subtype{ii}.pyr(jj*2-1).msk = GaborOpp{ii}(jj).msk;
                if jj<params.tex.maxLevel-3
                    imgPyr{c}.subtype{ii}.pyr(jj*2).data   = GaborOpp{ii}(jj).data .* imresize(GaborOpp{ii}(jj+4).data,size(GaborOpp{ii}(jj).data));
                    imgPyr{c}.subtype{ii}.pyr(jj*2).data   = imresize(imgPyr{c}.subtype{ii}.pyr(jj*2).data, pyrSize{jj*2});
                    imgPyr{c}.subtype{ii}.pyr(jj*2).msk   = GaborOpp{ii}(jj).msk;
                end
            end
        end
        imgPyr{c}.subtype{1}.ori = 0; %orientation channel angle
        imgPyr{c}.subtype{2}.ori = pi/2;
        imgPyr{c}.subtype{3}.ori = pi/4;
        imgPyr{c}.subtype{4}.ori = 3*pi/4;
        for ii=1:4 %Gaussian Filter
            for jj=1:length(imgPyr{c}.subtype{1}.pyr)
                imgPyr{c}.subtype{ii}.pyr(jj).data = imresize(maxPoolingFilt(abs(imgPyr{c}.subtype{ii}.pyr(jj).data),params.tex.maxpooling), params.tex.shrink);
            end
        end
        imgPyr{c}.originalSize=size(in);
        
    elseif strcmp(params.channels(c),'B')
        fprintf('\nGenerating Orientation Opponency Energy Cross-Orientation Pyramids\n');
        imgPyr{c}.type = 'Energy Cross-Ori Orientation-BigCSMises';
        imgPyr{c}.subtype{1}.type = '0-90_45-135_Opponency-CrossOri';
        imgPyr{c}.subtype{2}.type = '0-90_135-45_Opponency-CrossOri';
        imgPyr{c}.subtype{3}.type = '45-135_90-0_Opponency-CrossOri';
        imgPyr{c}.subtype{4}.type = '90-0_135-45_Opponency-CrossOri';

        tmpPyr = makePyramid(in,params);
        Gabor=cell(4,1);
        GaborOpp=cell(4,1);
        Gabor{1} = gaborPyramidTex(tmpPyr,0,params);
        Gabor{2} = gaborPyramidTex(tmpPyr,pi/4,params);
        Gabor{3} = gaborPyramidTex(tmpPyr,pi/2,params);
        Gabor{4} = gaborPyramidTex(tmpPyr,3*pi/4,params);
        for ii=1:4
            for jj=1:params.tex.maxLevel
                Gabor{ii}(jj).data=abs(Gabor{ii}(jj).data);
            end
        end
        for jj=1:params.tex.maxLevel
            GaborOpp{1}(jj).data=Gabor{1}(jj).data-Gabor{3}(jj).data;
            GaborOpp{2}(jj).data=Gabor{3}(jj).data-Gabor{1}(jj).data;
            GaborOpp{3}(jj).data=Gabor{2}(jj).data-Gabor{4}(jj).data;
            GaborOpp{4}(jj).data=Gabor{4}(jj).data-Gabor{2}(jj).data;
            for ii=1:4
                GaborOpp{ii}(jj).data(GaborOpp{ii}(jj).data<0)=0;
            end
        end
        for ii=1:4
            imgPyr{c}.subtype{ii}.pyr = GaborOpp{ii};
        end
        
        for jj=1:params.tex.maxLevel
            imgPyr{c}.subtype{1}.pyr(jj).data=GaborOpp{1}(jj).data .* GaborOpp{3}(jj).data;
            imgPyr{c}.subtype{2}.pyr(jj).data=GaborOpp{1}(jj).data .* GaborOpp{4}(jj).data;
            imgPyr{c}.subtype{3}.pyr(jj).data=GaborOpp{2}(jj).data .* GaborOpp{3}(jj).data;
            imgPyr{c}.subtype{4}.pyr(jj).data=GaborOpp{2}(jj).data .* GaborOpp{4}(jj).data;
            imgPyr{c}.subtype{1}.pyr(jj).msk = zeros(size(Gabor{1}(jj).msk));
            imgPyr{c}.subtype{2}.pyr(jj).msk = zeros(size(Gabor{2}(jj).msk));
            imgPyr{c}.subtype{3}.pyr(jj).msk = zeros(size(Gabor{3}(jj).msk));
            imgPyr{c}.subtype{4}.pyr(jj).msk = zeros(size(Gabor{4}(jj).msk));
        end
        imgPyr{c}.subtype{1}.ori = 0; %orientation channel angle
        imgPyr{c}.subtype{2}.ori = pi/2;
        imgPyr{c}.subtype{3}.ori = pi/4;
        imgPyr{c}.subtype{4}.ori = 3*pi/4;
        for ii=1:4 %Gaussian Filter
            for jj=1:length(imgPyr{c}.subtype{1}.pyr)
                imgPyr{c}.subtype{ii}.pyr(jj).data = imresize(maxPoolingFilt(abs(imgPyr{c}.subtype{ii}.pyr(jj).data),params.tex.maxpooling), params.tex.shrink);
            end
        end
        imgPyr{c}.originalSize=size(in);
                
    elseif strcmp(params.channels(c),'F')
        %orientation opponency Max pooling Not Rand
        fprintf('\nGenerating Orientation Opponency Max Pyramids\n');
        tmpPyr = makePyramid(in,params);
        imgPyr{c}.type = 'Orientation-Oppo-Max-BigCSMises-NonRand';
        imgPyr{c}.subtype{1}.type = '0-90_Opponency';
        Gabor0 = gaborPyramidTex(tmpPyr,0,params);
        
        imgPyr{c}.subtype{2}.type = '90-0_Opponency';
        Gabor1 = gaborPyramidTex(tmpPyr,pi/4,params);
        
        imgPyr{c}.subtype{3}.type = '45-135_Opponency';
        Gabor2 = gaborPyramidTex(tmpPyr,pi/2,params);
        
        imgPyr{c}.subtype{4}.type = '135-45_Opponency';
        Gabor3 = gaborPyramidTex(tmpPyr,3*pi/4,params);
        
        for ii=1:params.tex.maxLevel%length(Gabor0) Changed to tex.maxLevel to decrease compuation 2019/10/25
            Gabor0(ii).data=abs(Gabor0(ii).data);
            Gabor1(ii).data=abs(Gabor1(ii).data);
            Gabor2(ii).data=abs(Gabor2(ii).data);
            Gabor3(ii).data=abs(Gabor3(ii).data);
            Gabor0_2(ii).data=Gabor0(ii).data-Gabor2(ii).data;
            Gabor2_0(ii).data=Gabor2(ii).data-Gabor0(ii).data;
            Gabor1_3(ii).data=Gabor1(ii).data-Gabor3(ii).data;
            Gabor3_1(ii).data=Gabor3(ii).data-Gabor1(ii).data;
            Gabor0_2(ii).msk=Gabor0(ii).msk;
            Gabor2_0(ii).msk=Gabor2(ii).msk;
            Gabor1_3(ii).msk=Gabor1(ii).msk;
            Gabor3_1(ii).msk=Gabor3(ii).msk;            
            Gabor0_2(ii).data(Gabor0_2(ii).data<0)=0;
            Gabor2_0(ii).data(Gabor2_0(ii).data<0)=0;
            Gabor1_3(ii).data(Gabor1_3(ii).data<0)=0;
            Gabor3_1(ii).data(Gabor3_1(ii).data<0)=0;
        end
        imgPyr{c}.subtype{1}.pyr = Gabor0_2;
        imgPyr{c}.subtype{2}.pyr = Gabor2_0;
        imgPyr{c}.subtype{3}.pyr = Gabor1_3;
        imgPyr{c}.subtype{4}.pyr = Gabor3_1;
        imgPyr{c}.subtype{1}.ori = 0; %orientation channel angle
        imgPyr{c}.subtype{2}.ori = pi/2;
        imgPyr{c}.subtype{3}.ori = pi/4;
        imgPyr{c}.subtype{4}.ori = 3*pi/4;
        
        for ii=1:4 %Gaussian Filter
            for jj=1:length(imgPyr{c}.subtype{1}.pyr)
                imgPyr{c}.subtype{ii}.pyr(jj).data = imresize(maxPoolingFilt(abs(imgPyr{c}.subtype{ii}.pyr(jj).data),params.tex.maxpooling), params.tex.shrink);
            end
        end
        imgPyr{c}.originalSize=size(in);
    
    elseif strcmp(params.channels(c),'S')
        fprintf('\nGenerating Color-Orientation Opponency Energy Cross-Scale Pyramids\n');
        clear tmpPyr;
        tmpPyr{1} = makePyramid(rg,params);
        tmpPyr{2} = makePyramid(gr,params);
        tmpPyr{3} = makePyramid(by,params);
        tmpPyr{4} = makePyramid(yb,params);
        
        imgPyr{c}.type = 'Energy Color-Cross-Scale Orientation-BigCSMises';
        for kk=1:length(tmpPyr)
            imgPyr{c}.subtype{(kk-1)*4+1}.type = '0-90_Opponency-CrossScale';
            Gabor{kk,1} = gaborPyramidTex(tmpPyr{kk},0,params);
            
            imgPyr{c}.subtype{(kk-1)*4+2}.type = '90-0_Opponency-CrossScale';
            Gabor{kk,2} = gaborPyramidTex(tmpPyr{kk},pi/4,params);
            
            imgPyr{c}.subtype{(kk-1)*4+3}.type = '45-135_Opponency-CrossScale';
            Gabor{kk,3} = gaborPyramidTex(tmpPyr{kk},pi/2,params);
            
            imgPyr{c}.subtype{(kk-1)*4+4}.type = '135-45_Opponency-CrossScale';
            Gabor{kk,4} = gaborPyramidTex(tmpPyr{kk},3*pi/4,params);
                
            for ii=1:params.tex.maxLevel
                Gabor{kk,1}(ii).data=abs(Gabor{kk,1}(ii).data);
                Gabor{kk,2}(ii).data=abs(Gabor{kk,2}(ii).data);
                Gabor{kk,3}(ii).data=abs(Gabor{kk,3}(ii).data);
                Gabor{kk,4}(ii).data=abs(Gabor{kk,4}(ii).data);
                GaborOp{kk,1}(ii).data=Gabor{kk,1}(ii).data-Gabor{kk,3}(ii).data;
                GaborOp{kk,2}(ii).data=Gabor{kk,3}(ii).data-Gabor{kk,1}(ii).data;
                GaborOp{kk,3}(ii).data=Gabor{kk,2}(ii).data-Gabor{kk,4}(ii).data;
                GaborOp{kk,4}(ii).data=Gabor{kk,4}(ii).data-Gabor{kk,2}(ii).data;
                GaborOp{kk,1}(ii).msk=Gabor{kk,1}(ii).msk;
                GaborOp{kk,2}(ii).msk=Gabor{kk,3}(ii).msk;
                GaborOp{kk,3}(ii).msk=Gabor{kk,2}(ii).msk;
                GaborOp{kk,4}(ii).msk=Gabor{kk,4}(ii).msk;
                GaborOp{kk,1}(ii).data(GaborOp{kk,1}(ii).data<0)=0;
                GaborOp{kk,2}(ii).data(GaborOp{kk,2}(ii).data<0)=0;
                GaborOp{kk,3}(ii).data(GaborOp{kk,3}(ii).data<0)=0;
                GaborOp{kk,4}(ii).data(GaborOp{kk,4}(ii).data<0)=0;
            end
            imgPyr{c}.subtype{(kk-1)*4+1}.pyr = GaborOp{kk,1};
            imgPyr{c}.subtype{(kk-1)*4+2}.pyr = GaborOp{kk,2};
            imgPyr{c}.subtype{(kk-1)*4+3}.pyr = GaborOp{kk,3};
            imgPyr{c}.subtype{(kk-1)*4+4}.pyr = GaborOp{kk,4};
            imgPyr{c}.subtype{(kk-1)*4+1}.ori = 0; %orientation channel angle
            imgPyr{c}.subtype{(kk-1)*4+2}.ori = pi/2;
            imgPyr{c}.subtype{(kk-1)*4+3}.ori = pi/4;
            imgPyr{c}.subtype{(kk-1)*4+4}.ori = 3*pi/4;
        end
        
        pyrSize=cell(params.tex.maxLevel,1);
        for ii=1:params.tex.maxLevel
            pyrSize{ii}=size(GaborOp{1,1}(ii).data);
        end
        for kk=1:length(tmpPyr)
            for ii=1:4
                for jj=1:params.tex.maxLevel-3
                    imgPyr{c}.subtype{(kk-1)*4+ii}.pyr(jj*2-1).data = GaborOp{(kk-1)*4+ii}(jj).data .* imresize(GaborOp{(kk-1)*4+ii}(jj+2).data,size(GaborOp{(kk-1)*4+ii}(jj).data));
                    imgPyr{c}.subtype{(kk-1)*4+ii}.pyr(jj*2-1).data = imresize(imgPyr{c}.subtype{(kk-1)*4+ii}.pyr(jj*2-1).data, pyrSize{jj*2-1});
                    imgPyr{c}.subtype{(kk-1)*4+ii}.pyr(jj*2-1).msk = GaborOp{(kk-1)*4+ii}(jj).msk;
                    if jj<params.tex.maxLevel-3
                        imgPyr{c}.subtype{(kk-1)*4+ii}.pyr(jj*2).data   = GaborOp{(kk-1)*4+ii}(jj).data .* imresize(GaborOp{(kk-1)*4+ii}(jj+4).data,size(GaborOp{(kk-1)*4+ii}(jj).data));
                        imgPyr{c}.subtype{(kk-1)*4+ii}.pyr(jj*2).data   = imresize(imgPyr{c}.subtype{(kk-1)*4+ii}.pyr(jj*2).data, pyrSize{jj*2});
                        imgPyr{c}.subtype{(kk-1)*4+ii}.pyr(jj*2).msk   = GaborOp{(kk-1)*4+ii}(jj).msk;
                    end
                end
            end
        end
        for kk=1:length(tmpPyr)
            imgPyr{c}.subtype{(kk-1)*4+1}.ori = 0; %orientation channel angle
            imgPyr{c}.subtype{(kk-1)*4+2}.ori = pi/2;
            imgPyr{c}.subtype{(kk-1)*4+3}.ori = pi/4;
            imgPyr{c}.subtype{(kk-1)*4+4}.ori = 3*pi/4;
        end
        for kk=1:length(tmpPyr)
            for ii=1:4 %Gaussian Filter
                for jj=1:length(imgPyr{c}.subtype{(kk-1)*4+1}.pyr)
                    imgPyr{c}.subtype{(kk-1)*4+ii}.pyr(jj).data = imresize(maxPoolingFilt(abs(imgPyr{c}.subtype{(kk-1)*4+ii}.pyr(jj).data),params.tex.maxpooling), params.tex.shrink);
                end
            end
        end
        imgPyr{c}.originalSize=size(in);
                
    elseif strcmp(params.channels(c),'T')
        fprintf('\nGenerating Color-Orientation Opponency Energy Cross-Ori Pyramids\n');
        clear tmpPyr;
        tmpPyr{1} = makePyramid(rg,params);
        tmpPyr{2} = makePyramid(gr,params);
        tmpPyr{3} = makePyramid(by,params);
        tmpPyr{4} = makePyramid(yb,params);
        
        imgPyr{c}.type = 'Energy Color-Cross-Scale Orientation-BigCSMises';
        for kk=1:length(tmpPyr)
            imgPyr{c}.subtype{(kk-1)*4+1}.type = '0-90_45-135_Color-Opponency-CrossOri';
            Gabor{kk,1} = gaborPyramidTex(tmpPyr{kk},0,params);
            
            imgPyr{c}.subtype{(kk-1)*4+2}.type = '0-90_135-45_Color-Opponency-CrossOri';
            Gabor{kk,2} = gaborPyramidTex(tmpPyr{kk},pi/4,params);
            
            imgPyr{c}.subtype{(kk-1)*4+3}.type = '45-135_90-0_Color-Opponency-CrossOri';
            Gabor{kk,3} = gaborPyramidTex(tmpPyr{kk},pi/2,params);
            
            imgPyr{c}.subtype{(kk-1)*4+4}.type = '90-0_135-45_Color-Opponency-CrossOri';
            Gabor{kk,4} = gaborPyramidTex(tmpPyr{kk},3*pi/4,params);
                
            for ii=1:params.tex.maxLevel
                Gabor{kk,1}(ii).data=abs(Gabor{kk,1}(ii).data);
                Gabor{kk,2}(ii).data=abs(Gabor{kk,2}(ii).data);
                Gabor{kk,3}(ii).data=abs(Gabor{kk,3}(ii).data);
                Gabor{kk,4}(ii).data=abs(Gabor{kk,4}(ii).data);
                GaborOp{kk,1}(ii).data=Gabor{kk,1}(ii).data-Gabor{kk,3}(ii).data;
                GaborOp{kk,2}(ii).data=Gabor{kk,3}(ii).data-Gabor{kk,1}(ii).data;
                GaborOp{kk,3}(ii).data=Gabor{kk,2}(ii).data-Gabor{kk,4}(ii).data;
                GaborOp{kk,4}(ii).data=Gabor{kk,4}(ii).data-Gabor{kk,2}(ii).data;
                GaborOp{kk,1}(ii).msk=Gabor{kk,1}(ii).msk;
                GaborOp{kk,2}(ii).msk=Gabor{kk,3}(ii).msk;
                GaborOp{kk,3}(ii).msk=Gabor{kk,2}(ii).msk;
                GaborOp{kk,4}(ii).msk=Gabor{kk,4}(ii).msk;
                GaborOp{kk,1}(ii).data(GaborOp{kk,1}(ii).data<0)=0;
                GaborOp{kk,2}(ii).data(GaborOp{kk,2}(ii).data<0)=0;
                GaborOp{kk,3}(ii).data(GaborOp{kk,3}(ii).data<0)=0;
                GaborOp{kk,4}(ii).data(GaborOp{kk,4}(ii).data<0)=0;
            end
%             imgPyr{c}.subtype{(kk-1)*4+1}.pyr = GaborOp{kk,1};
%             imgPyr{c}.subtype{(kk-1)*4+2}.pyr = GaborOp{kk,2};
%             imgPyr{c}.subtype{(kk-1)*4+3}.pyr = GaborOp{kk,3};
%             imgPyr{c}.subtype{(kk-1)*4+4}.pyr = GaborOp{kk,4};
            imgPyr{c}.subtype{(kk-1)*4+1}.ori = 0; %orientation channel angle
            imgPyr{c}.subtype{(kk-1)*4+2}.ori = pi/2;
            imgPyr{c}.subtype{(kk-1)*4+3}.ori = pi/4;
            imgPyr{c}.subtype{(kk-1)*4+4}.ori = 3*pi/4;
        end
        
        pyrSize=cell(params.tex.maxLevel,1);
        for ii=1:params.tex.maxLevel
            pyrSize{ii}=size(GaborOp{1,1}(ii).data);
        end
        for kk=1:length(tmpPyr)
            for jj=1:params.tex.maxLevel
                imgPyr{c}.subtype{(kk-1)*4+1}.pyr(jj).data = GaborOp{(kk-1)*4+1}(jj).data .* GaborOp{(kk-1)*4+3}(jj).data;
                imgPyr{c}.subtype{(kk-1)*4+2}.pyr(jj).data = GaborOp{(kk-1)*4+1}(jj).data .* GaborOp{(kk-1)*4+4}(jj).data;
                imgPyr{c}.subtype{(kk-1)*4+3}.pyr(jj).data = GaborOp{(kk-1)*4+2}(jj).data .* GaborOp{(kk-1)*4+3}(jj).data;
                imgPyr{c}.subtype{(kk-1)*4+4}.pyr(jj).data = GaborOp{(kk-1)*4+2}(jj).data .* GaborOp{(kk-1)*4+4}(jj).data;
                imgPyr{c}.subtype{(kk-1)*4+1}.pyr(jj).msk = zeros(size(GaborOp{(kk-1)*4+1}(jj).msk));
                imgPyr{c}.subtype{(kk-1)*4+2}.pyr(jj).msk = zeros(size(GaborOp{(kk-1)*4+2}(jj).msk));
                imgPyr{c}.subtype{(kk-1)*4+3}.pyr(jj).msk = zeros(size(GaborOp{(kk-1)*4+3}(jj).msk));
                imgPyr{c}.subtype{(kk-1)*4+4}.pyr(jj).msk = zeros(size(GaborOp{(kk-1)*4+4}(jj).msk));
            end            
        end
        for kk=1:length(tmpPyr)
            imgPyr{c}.subtype{(kk-1)*4+1}.ori = 0; %orientation channel angle
            imgPyr{c}.subtype{(kk-1)*4+2}.ori = pi/2;
            imgPyr{c}.subtype{(kk-1)*4+3}.ori = pi/4;
            imgPyr{c}.subtype{(kk-1)*4+4}.ori = 3*pi/4;
        end
        for kk=1:length(tmpPyr)
            for ii=1:4 %Gaussian Filter
                for jj=1:length(imgPyr{c}.subtype{(kk-1)*4+1}.pyr)
                    imgPyr{c}.subtype{(kk-1)*4+ii}.pyr(jj).data = imresize(maxPoolingFilt(abs(imgPyr{c}.subtype{(kk-1)*4+ii}.pyr(jj).data),params.tex.maxpooling), params.tex.shrink);
                end
            end
        end
        imgPyr{c}.originalSize=size(in);
        
    elseif strcmp(params.channels(c),'V')
        %orientation opponency Max pooling Not Rand
        fprintf('\nGenerating Color-Orientation Opponency Max Pyramids\n');
        clear tmpPyr;
        tmpPyr{1} = makePyramid(rg,params);
        tmpPyr{2} = makePyramid(gr,params);
        tmpPyr{3} = makePyramid(by,params);
        tmpPyr{4} = makePyramid(yb,params);
        
        imgPyr{c}.type = 'Color-Orientation-Oppo-Max-BigCSMises-NonRand';
        for kk=1:length(tmpPyr)
            imgPyr{c}.subtype{(kk-1)*4+1}.type = '0-90_Opponency';
            Gabor{kk,1} = gaborPyramidTex(tmpPyr{kk},0,params);
            
            imgPyr{c}.subtype{(kk-1)*4+2}.type = '90-0_Opponency';
            Gabor{kk,2} = gaborPyramidTex(tmpPyr{kk},pi/4,params);
            
            imgPyr{c}.subtype{(kk-1)*4+3}.type = '45-135_Opponency';
            Gabor{kk,3} = gaborPyramidTex(tmpPyr{kk},pi/2,params);
            
            imgPyr{c}.subtype{(kk-1)*4+4}.type = '135-45_Opponency';
            Gabor{kk,4} = gaborPyramidTex(tmpPyr{kk},3*pi/4,params);
            
            for ii=1:params.tex.maxLevel%Change to reduce cals 2019/11/02
                Gabor{kk,1}(ii).data=abs(Gabor{kk,1}(ii).data);
                Gabor{kk,2}(ii).data=abs(Gabor{kk,2}(ii).data);
                Gabor{kk,3}(ii).data=abs(Gabor{kk,3}(ii).data);
                Gabor{kk,4}(ii).data=abs(Gabor{kk,4}(ii).data);
                GaborOp{kk,1}(ii).data=Gabor{kk,1}(ii).data-Gabor{kk,3}(ii).data;
                GaborOp{kk,2}(ii).data=Gabor{kk,3}(ii).data-Gabor{kk,1}(ii).data;
                GaborOp{kk,3}(ii).data=Gabor{kk,2}(ii).data-Gabor{kk,4}(ii).data;
                GaborOp{kk,4}(ii).data=Gabor{kk,4}(ii).data-Gabor{kk,2}(ii).data;
                GaborOp{kk,1}(ii).msk=Gabor{kk,1}(ii).msk;
                GaborOp{kk,2}(ii).msk=Gabor{kk,3}(ii).msk;
                GaborOp{kk,3}(ii).msk=Gabor{kk,2}(ii).msk;
                GaborOp{kk,4}(ii).msk=Gabor{kk,4}(ii).msk;
                GaborOp{kk,1}(ii).data(GaborOp{kk,1}(ii).data<0)=0;
                GaborOp{kk,2}(ii).data(GaborOp{kk,2}(ii).data<0)=0;
                GaborOp{kk,3}(ii).data(GaborOp{kk,3}(ii).data<0)=0;
                GaborOp{kk,4}(ii).data(GaborOp{kk,4}(ii).data<0)=0;
            end
            imgPyr{c}.subtype{(kk-1)*4+1}.pyr = GaborOp{kk,1};
            imgPyr{c}.subtype{(kk-1)*4+2}.pyr = GaborOp{kk,2};
            imgPyr{c}.subtype{(kk-1)*4+3}.pyr = GaborOp{kk,3};
            imgPyr{c}.subtype{(kk-1)*4+4}.pyr = GaborOp{kk,4};
            imgPyr{c}.subtype{(kk-1)*4+1}.ori = 0; %orientation channel angle
            imgPyr{c}.subtype{(kk-1)*4+2}.ori = pi/2;
            imgPyr{c}.subtype{(kk-1)*4+3}.ori = pi/4;
            imgPyr{c}.subtype{(kk-1)*4+4}.ori = 3*pi/4;
        end
        for kk=1:length(tmpPyr)
            for ii=1:4 %Gaussian Filter
                for jj=1:length(imgPyr{c}.subtype{(kk-1)*4+1}.pyr)
                    imgPyr{c}.subtype{(kk-1)*4+ii}.pyr(jj).data = imresize(maxPoolingFilt(abs(imgPyr{c}.subtype{(kk-1)*4+ii}.pyr(jj).data),params.tex.maxpooling), params.tex.shrink);
                end
            end
        end
        imgPyr{c}.originalSize=size(in);
        
    end
end