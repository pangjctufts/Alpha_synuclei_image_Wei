function createThumbnailTable(Dir,HtmlName, TSize, imagesPerRow)

%
% function createThumbnailTable(Dir,HtmlName, TSize, imagesPerRow)
% 
% This function generates an html file that contains a table with
% thumbnails (and respective links) of the images stored in a provided
% directory.
%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%
% ARGUMENTS:
%  - Dir: the directory name in which the images are stored
%  - HtmlName: the name of the html file to be generated
%  - TSize: The size (in pixels) of the thumbnails images to be generated (the largest
%           of the two dimensions (width or height), depending on the image
%           orientation
%  - imagesPerRow: The number of thumbnails per row in the html page.
%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%
%
% % % % % % % % % % % % % % % % % % % % % % % %
% Theodoros Giannakopoulos
% Dep. of Informatics and Telecommunications
% University of Athens
% http://www.di.uoa.gr/~tyiannak
% % % % % % % % % % % % % % % % % % % % % % % %
%

% generate thumbnails:
Dir2 = 'Thumbnails';
mkdir(Dir,Dir2);
resizeImageDir(Dir,Dir2,'ThumbNail_',TSize);

ext='.tif';
exttb='.png';
D = dir([Dir '/*' ext]);
numOfCells = 0;

% Start writing the html file:
fp = fopen(HtmlName,'wt');
fprintf(fp,'<html>\n');
fprintf(fp,'<body bgcolor="808080">\n');

fprintf(fp,'<p align = ''center''><font size = "4" color = "000000">folder <b>''%s''</b></font>\n',Dir);

fprintf(fp,'<table border="1" cellpadding="0" cellspacing="0">\n');
for (i=1:length(D))            
    curFileName = D(i).name;
    %curThumbName = ['ThumbNail_' D(i).name];
    curThumbName = ['ThumbNail_' regexprep(D(i).name, ext, exttb)];
    if (mod(numOfCells, imagesPerRow)==0)
        if (numOfCells>0)
            fprintf(fp, '</tr>\n');
        end
        fprintf(fp, '<tr>\n');
    end
    fprintf(fp, '  <td>\n  <a href = "./%s/%s" target = "new"> <img src="./%s/%s/%s"> </a> </td>\n',...
        Dir, curFileName, Dir, Dir2, curThumbName);
    numOfCells = numOfCells + 1;
end
if (numOfCells>0)
    fprintf(fp, '</tr>\n');
end
fprintf(fp,'</table>\n');

fprintf(fp,'</body>\n');
fprintf(fp,'</html>\n');
fclose(fp);

%open(HtmlName);