clear;clc;
addpath('C:/Users/csjunxu/Desktop/JunXu/Paper/Image Super-Resolution/SCDL CVPR2012/SCDL/Data');
addpath('Utilities');

load NaturalSR;
cls_num = 32;
nOuterLoop = 1;
nInnerLoop = 5;
load KMeans_5x5_32_Factor3 vec par param;




fields = fieldnames(imdong);
PSNR = zeros( length(fields), 1 );
for i = 1 : length(fieldnames(imdong))
    te_HR = double(imdong.(fields{i}));
    clear im imdong im_tr;
    [im_h, im_w, im_c] = size(te_HR);
    te_LR           =   te_HR(1 : par.nFactor : im_h, 1 : par.nFactor : im_w, :);
    imwrite(uint8(te_LR), ['Result/' fields{i} '_LR.png']);
    imwrite(uint8(te_HR), ['Result/' fields{i} '_HR.png']);
    
    [im_hout] = scdl_interp(te_LR, im_h, im_w, par.nFactor);
    if im_c == 3
        lum_out = double(rgb2ycbcr(uint8(im_hout)));
        lum_ori = double(rgb2ycbcr(uint8(te_HR)));
        PSNR(i) = csnr(lum_out(:,:,1), lum_ori(:,:,1), 5, 5);
        fprintf('\nPSNR of Semi-Coupled DL: %2.2f \n', PSNR(i));
    else
        PSNR(i) = csnr(im_hout, te_HR, 5, 5);
        fprintf('\nPSNR of Semi-Coupled DL: %2.2f \n', PSNR(i));
    end
    imwrite(uint8(im_hout), ['Result/' fields{i} '_ScDL_X' num2str(par.nFactor) '_NLM.png']);
end
mPSNR=mean(PSNR);
fprintf('The average PSNR = %2.4f. \n', mPSNR);
name = sprintf(['SCDL_X' num2str(par.nFactor) '_NLM.mat']);
save(name,'PSNR','mPSNR');

