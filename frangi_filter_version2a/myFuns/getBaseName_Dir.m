function [dirPath,baseName] = getBaseName_Dir(fullFileName)
% created by Jincheng Pang
% 06/04/2015
strtmp0 = strsplit(fullFileName,'\');
baseName = strtmp0{length(strtmp0)};
dirPath = fullFileName(1:end-length(baseName));