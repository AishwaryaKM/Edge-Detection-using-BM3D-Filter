function [ psnr,mse ] = pme(test_image,ref_image )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

InputImage= ref_image;
ReconstructedImage= test_image;
n=size(InputImage);
 M=n(1);
 N=n(2);
 MSE = sum(sum((InputImage-ReconstructedImage).^2))/(M*N);
PSNR = 10*log10(256*256/MSE);
 psnr=PSNR;
 mse=MSE;
end

