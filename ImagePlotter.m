%% ImagePlotter
% By Robert J Scales

clear
clc
close all

saveOnTF = false; % Have on false to not save images automatically and on true to save them automatically.

NumberOfImages = input('Type the number of images to compare: ');

Folder_Code = cd;

Im = [];

[status,msg] = mkdir(Folder_Code,'ImageDifferenceFolder');
Folder_Save = sprintf('%s/ImageDifferenceFolder',Folder_Code);

for i = 1:NumberOfImages
    [File_Images,Folder_Image] = uigetfile({'.bmp'},'MultiSelect','off');
    Im = cat(3,Im,im2gray(imread(sprintf('%s/%s',Folder_Image,File_Images))));
end


%%

for i = 1:NumberOfImages
    subplot(1,NumberOfImages,i), imshow(Im(:,:,i));
end