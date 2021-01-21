%% Image Difference Finder
% By Robert J Scales

clear
clc
close all

saveOnTF = true; % Have on false to not save images automatically and on true to save them automatically.
BrightnessMethod = 'Region'; % Recommended is 'Region' as this produces the best contrast for large indents. For small indents can get away with using 'Avg'.

Folder_Code = cd;
[File_Images,Folder_Image] = uigetfile({'.bmp'},'MultiSelect','on');
[status,msg] = mkdir(Folder_Image,'ImageDifferenceFolder');
Folder_Save = sprintf('%sImageDifferenceFolder',Folder_Image);

%%

clc

Im_1 = rgb2gray(imread(sprintf('%s/%s',Folder_Image,File_Images{1,1})));
Im_2 = rgb2gray(imread(sprintf('%s/%s',Folder_Image,File_Images{1,2})));

cd(Folder_Code);

close all

beforeImageFileName = File_Images{1,1};

switch BrightnessMethod
    case 'Avg'
        [Im_1,Im_2] = brightnessMethod_Avg(Im_1,Im_2);
        tform = imregcorr(Im_2,Im_1);
        Rfixed = imref2d(size(Im_1));
        Im_2 = imwarp(Im_2,tform,'OutputView',Rfixed); % ,'OutputView',Rfixed
        [Im_2,Im_1] = ImageAnalystCode(Im_2,Im_1);
    case 'DCG'
        [Im_1,Im_2] = brightnessMethod_DCG(Im_1,Im_2);
        tform = imregcorr(Im_2,Im_1);
        Rfixed = imref2d(size(Im_1));
        Im_2 = imwarp(Im_2,tform,'OutputView',Rfixed); % ,'OutputView',Rfixed
        [Im_2,Im_1] = ImageAnalystCode(Im_2,Im_1);
    case 'Region'
        tform = imregcorr(Im_2,Im_1);
        Rfixed = imref2d(size(Im_1));
        Im_2 = imwarp(Im_2,tform,'OutputView',Rfixed); % ,'OutputView',Rfixed
        [Im_2,Im_1] = ImageAnalystCode(Im_2,Im_1);
        [Im_1,Im_2] = brightnessMethod_Region(Im_1,Im_2);
end



cd(Folder_Save);

figure('Name','Im_1');
imshow(Im_1);
saveimage(Im_1,beforeImageFileName,'0_BeforeImage',saveOnTF);

figure('Name','Im_2');
imshow(Im_2);
saveimage(Im_2,beforeImageFileName,'2_AfterImage',saveOnTF);

K = imabsdiff(Im_1,Im_2);
figure('Name','Abs Difference (K)');
imshow(K,[]);
saveimage(K,beforeImageFileName,'K_abs_diff',saveOnTF);

K2 = imlocalbrighten(K);
figure('Name','Local Brighten K');
imshow(K2,[]);
saveimage(K2,beforeImageFileName,'K2_Local_Brighten_K',saveOnTF);

K3 = imsharpen(K2);
figure('Name','Sharpen Brightened K');
imshow(K3,[]);
saveimage(K3,beforeImageFileName,'K3_sharpened_K2',saveOnTF);

figure('Name','adapthisteq K');
K4 = adapthisteq(K);
imshow(K4,[]);
saveimage(K4,beforeImageFileName,'K4_adapthisteq_K',saveOnTF);

figure('Name','Brightened K4');
K5 = imlocalbrighten(K4);
imshow(K5,[]);
saveimage(K5,beforeImageFileName,'K5_Local_Brighten_K4',saveOnTF);


% figure
% L = imshowpair(Im_1,Im_2,'diff'); % ,'Scaling','joint'
% figure
% M = imshowpair(Im_1,Im_2,'diff','Scaling','joint'); % 
% figure
% N = imshowpair(Im_1,Im_2,'falsecolor','ColorChannels',[1 0 2]);


if saveOnTF == true
    close all
end
cd(Folder_Code);

%% Functions

function saveimage(Image,beforeImageFileName,ID,saveOnTF)
    if saveOnTF == true
        savename = sprintf('Analysed-%s-%s.bmp',beforeImageFileName,ID);
        imwrite(Image, savename,'bmp');
        fprintf('Saved figure "%s" with imwrite\n',ID);
    else
        fprintf('DID NOT save figure "%s"\n',ID);
    end
end

function [Im_1_out,Im_2_out] = brightnessMethod_Avg(Im_1,Im_2)
    mns=nan(2,1);
    mns(1) = mean2(Im_1);
    mns(2) = mean2(Im_2);
    Im_2_out = Im_2 * (mns(1)/mns(2));
    Im_1_out = Im_1;
end

function [Im_1_out,Im_2_out] = brightnessMethod_DCG(Im_1,Im_2)
    mns=nan(2,1);
    mns(1) = max(max(Im_1));
    mns(2) = max(max(Im_2));
    Im_2_out = Im_2 * (mns(1)/mns(2));
    Im_1_out = Im_1;
end

function [Im_1_out,Im_2_out] = brightnessMethod_Region(Im_1,Im_2)
    figure('Name','Im_1_Fig');
    imshow(Im_1);
    roi = drawrectangle;
    Vertices = roi.Position;
    Icropped_1 = imcrop(Im_1,Vertices);
    figure();
    imshow(Icropped_1);
    pause(0.5);
    
%     figure('Name','Im_2_Fig');
%     imshow(Im_2);
%     roi = drawrectangle;
%     Vertices = roi.Position;
    Icropped_2 = imcrop(Im_2,Vertices);
    figure();
    imshow(Icropped_2);
    pause(0.5);
    
    mns=nan(2,1);
    mns(1) = mean2(Icropped_1);
    mns(2) = mean2(Icropped_2);
    Ratio = mns(1)/mns(2);
    Im_2_out = Im_2 * Ratio;
    Im_1_out = Im_1;
    
    fprintf('Ratio = %d, with image 1 being %d and image 2 being %d\n\n',Ratio,mns(1),mns(2));
    
    close all
end