% 
clear all;
close all;
clc;

% % fileName = 'D:\Wei_alpha_syn_data\MIP\Luc_mono\MAX_Luc mono 1.tif';
% % fileName = 'D:\Wei_alpha_syn_data\MIP\TMEM_PFF\MAX_TMEM PFF 1.tif';
% % folderName = 'D:\Wei_alpha_syn_data\MIP\Luc_mono';
% % folderName = 'D:\Wei_alpha_syn_data\MIP\TMEM_PFF';
pathFolder = 'D:\Wei_alpha_syn_data\MIP';

d = dir(pathFolder);
isub = [d(:).isdir]; %# returns logical vector
isub(1:2) = 0; % First two are '.','..'
nameFolds = {d(isub).name}';


mydir='D:\Wei_alpha_syn_data';% Output Directory


for kk = 1:length(nameFolds)
    
    mydirOut0 = fullfile(mydir,['OUT_data_20171106\',nameFolds{kk}]);
    
    if(~exist(mydirOut0)), mkdir(mydirOut0); end;

    folderName = [pathFolder,'\',nameFolds{kk}]

    fileItems = dir([folderName,'\*.tif']);

    for ii = 1:length(fileItems)
        
        tmp = fileItems(ii).name;
        fileName = [folderName,'\',tmp];
        
        %%%%%%
        %%%%%%
        
        cellsOut=fullfile(mydirOut0, ['\',tmp(1:end-4),'.csv']);
        fid_cells = fopen(cellsOut, 'wt');

        Header_cells={'fileName','Group','centroid_x','centroid_y','Size','MeanIntensity','MajorAxisLength','MinorAxisLength'};

        for ih=1:(length(Header_cells)-1),
            fprintf(fid_cells,'%s,', Header_cells{ih});
        end;
        fprintf(fid_cells,'%s\n',Header_cells{length(Header_cells)});
        
        %%%%%%
        %%%%%%

        info = imfinfo(fileName);
        num_images = numel(info);

        img0 = imread(fileName, 3, 'Info', info);

        [nrow,ncol] =size(img0);

        img = double(img0);
        minV = min(img(:));
        maxV = max(img(:));

        img = (img-minV)/(maxV-minV);

        options = struct('FrangiScaleRange', [3 11], 'FrangiScaleRatio', 2, 'FrangiBetaOne', .5, 'FrangiBetaTwo', 10, 'verbose',true,'BlackWhite',false);

        [outIm,whatScale,Direction] = FrangiFilter2D(img, options);

        minV1 = min(img(:));
        maxV1 = max(img(:));

        outIm = (outIm-minV1)/(maxV1-minV1);

        bw=adaptivethreshold(outIm,19,-0.2);
% %         bw = imopen(bw,strel('disk',2));
        bw = bwareaopen(bw,20);

        L=bwlabel(bw);

        %standard props
        s0 = regionprops(L,outIm, {'Area','MeanIntensity','MajorAxisLength','MinorAxisLength'});
        Q=ismember(L, find([s0.MajorAxisLength]./[s0.MinorAxisLength]>2.5&[s0.MajorAxisLength]>15));
        bw = Q>0;        

        L = bwlabel(bw);
        s1 = regionprops(L,outIm, {'Area','centroid','MeanIntensity','MajorAxisLength','MinorAxisLength'});
        
        for l=1:length(s1),
            fprintf(fid_cells,'%s,%s,%g,%g,%g,%g,%g,%g\n',...
                tmp(1:end-4),nameFolds{kk},s1(l).Centroid(1),s1(l).Centroid(2),s1(l).Area,s1(l).MeanIntensity,s1(l).MajorAxisLength,s1(l).MinorAxisLength);
        end;
        
        figure,
        ax1 = subplot(131);imshow(img,[]);
        ax2 = subplot(132);imshow(outIm,[]);
        ax3 = subplot(133);imshow(bw,[]);
        linkaxes([ax1,ax2,ax3],'xy')

        fullOut=[tmp(1:end-4) '_results.tif'];
        fullOut=fullfile(mydirOut0,fullOut); 

        img_out = zeros(nrow,ncol,3);
        img_out(:,:,1) = img;
        img_out(:,:,2) = 0;
        img_out(:,:,3) = 0;
        imwrite(img_out, fullOut,  'Compression','lzw','WriteMode', 'overwrite' );

        img_out(:,:,3) = bw;
        imwrite(img_out, fullOut,  'Compression','lzw','WriteMode', 'append' );
        imwrite(outIm/max(outIm(:)), fullOut,  'Compression','lzw','WriteMode', 'append' );
     close all;
     fclose(fid_cells);   
    end
end

