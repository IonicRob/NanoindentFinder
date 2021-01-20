%% Image Difference Finder
% By Robert J Scales

clear
clc
close all

saveOnTF = true; % Have on false to not save images automatically and on true to save them automatically.

Folder_Code = cd;
[File_Images,Folder_Image] = uigetfile({'.bmp'},'MultiSelect','on');
[status,msg] = mkdir(Folder_Image,'ImageDifferenceFolder');
Folder_Save = sprintf('%s/ImageDifferenceFolder',Folder_Image);

%%

clc

Im_1 = rgb2gray(imread(sprintf('%s/%s',Folder_Image,File_Images{1,1})));
Im_2 = rgb2gray(imread(sprintf('%s/%s',Folder_Image,File_Images{1,2})));

cd(Folder_Code);

close all

beforeImageFileName = File_Images{1,1};

mns=nan(2,1);
mns(1) = mean2(Im_1);
mns(2) = mean2(Im_2);
[a,b] = min(mns);
[c,d] = max(mns);
Im_2 = Im_2 * (mns(d)/mns(b));

tform = imregcorr(Im_2,Im_1);
Rfixed = imref2d(size(Im_1));
[Im_2,RB] = imwarp(Im_2,tform,'OutputView',Rfixed); % ,'OutputView',Rfixed

% tform_1 = imregcorr(Im_1,Im_2);
% Rfixed_1 = imref2d(size(Im_2));
% Im_1 = imwarp(Im_1,tform_1); % ,'OutputView',Rfixed_1

[Im_2,Im_1] = ImageAnalystCode(Im_2,Im_1);


figure('Name','Im_1');
imshow(Im_1);

figure('Name','Im_2');
imshow(Im_2);

K = imabsdiff(Im_1,Im_2);
figure('Name','Abs Difference (K)');
imshow(K,[])

K2 = imlocalbrighten(K);
figure('Name','Local Brighten K');
imshow(K2,[])

K3 = imsharpen(K2);
figure('Name','Sharpen Brightened K');
imshow(K3,[])

figure('Name','adapthisteq K');
K4 = adapthisteq(K);
imshow(K4,[])

figure('Name','Brightened K4');
K5 = imlocalbrighten(K4);
imshow(K5,[])


% figure
% L = imshowpair(Im_1,Im_2,'diff'); % ,'Scaling','joint'
% figure
% M = imshowpair(Im_1,Im_2,'diff','Scaling','joint'); % 
% figure
% N = imshowpair(Im_1,Im_2,'falsecolor','ColorChannels',[1 0 2]);

cd(Folder_Save);
saveimage(Im_1,beforeImageFileName,'0_BeforeImage',saveOnTF);
saveimage(Im_2,beforeImageFileName,'2_AfterImage',saveOnTF);
saveimage(K,beforeImageFileName,'K_abs_diff',saveOnTF);
saveimage(K2,beforeImageFileName,'K2_Local_Brighten_K',saveOnTF);
saveimage(K3,beforeImageFileName,'K3_sharpened_K2',saveOnTF);
saveimage(K4,beforeImageFileName,'K4_adapthisteq_K',saveOnTF);
saveimage(K5,beforeImageFileName,'K5_Local_Brighten_K4',saveOnTF);

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