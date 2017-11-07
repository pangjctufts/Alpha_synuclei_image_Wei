% 
clear all;
close all;
clc;

fileName = 'D:\Wei_alpha_syn_data\MIP\Luc_mono\MAX_Luc mono 1.tif';
% % fileName = 'D:\Wei_alpha_syn_data\MIP\TMEM_PFF\MAX_TMEM PFF 1.tif';

info = imfinfo(fileName);
num_images = numel(info);

img = double(imread(fileName, 3, 'Info', info));
minV = min(img(:));
maxV = max(img(:));

img = (img-minV)/(maxV-minV);

options = struct('FrangiScaleRange', [3 11], 'FrangiScaleRatio', 2, 'FrangiBetaOne', .5, 'FrangiBetaTwo', 10, 'verbose',true,'BlackWhite',false);

[outIm,whatScale,Direction] = FrangiFilter2D(img, options);

minV1 = min(img(:));
maxV1 = max(img(:));

outIm = (outIm-minV1)/(maxV1-minV1);

bw=adaptivethreshold(outIm,19,-0.2);
bw = imopen(bw,strel('disk',2));
bw = bwareaopen(bw,20);

L=bwlabel(bw);

%standard props
s0 = regionprops(L,outIm, {'Area','MeanIntensity','MajorAxisLength','MinorAxisLength'});
Q=ismember(L, find([s0.MajorAxisLength]./[s0.MinorAxisLength]>2.5&[s0.MajorAxisLength]>15));
bw = Q>0;        

figure,
ax1 = subplot(131);imshow(img,[]);
ax2 = subplot(132);imshow(outIm,[]);
ax3 = subplot(133);imshow(bw,[]);
linkaxes([ax1,ax2,ax3],'xy')

