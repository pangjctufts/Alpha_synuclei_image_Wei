function resizeImageDir(DirName,DirName2,newName,preferredW)
%(Dir,Dir2,'ThumbNail_',TSize)

% function for resizing the jpeg files stored in a directory:
% DirName: the folder in which the images are stored.
% DirName2: the folder in which the thumbnails will be stored.
% newName: a string to be added in front of all fileNames for the thumbnail
% files
% preferredW: preferred width of the thumbnails
ext='.tif';
exttb='.png';
D = dir([DirName '/*' ext]);
warning off;
count = 1;
for (i=1:length(D))
        fprintf('Processing file %s...',D(i).name);
        %resizepng(sprintf('%s\\%s.png',DirName,D(i).name(1:end-4)),sprintf('%s\\%s%d.png',DirName,newName,count),1);
        if (strcmp(newName,'')~=1)            
            newFileName = [DirName '/' DirName2 '/' newName D(i).name(1:end-4) exttb];
        else % replace:                      
            newFileName = [DirName '/' DirName2 '/' D(i).name(1:end-4) exttb];            
        end   
        %resizeJPG(sprintf(['%s/%s' ext],DirName,D(i).name(1:end-4)),newFileName,preferredW);
        fileName=sprintf(['%s/%s' ext],DirName,D(i).name(1:end-4));

        RGB = imread(fileName);
        [H,W,t] = size(RGB);
        if (W>H)
            ratio = preferredW / W;
        else
            ratio = preferredW / H;
        end
        RGBnew = imresize(RGB,ratio);
        [M,N] = size(RGBnew);
        %imwrite(RGBnew,newFileName,'Quality',100,'BitDepth',8);
        imwrite(RGBnew,newFileName);
        
        fprintf('\n');
        count = count + 1;
end