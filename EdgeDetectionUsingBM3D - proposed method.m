%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by :  
%             Ajith Rao A S and Aishwarya K M for simulating the paper titled
%             "Qualitative Approach towards Edge Detection using BM3D Filter"

%Reading images
img_sample=imread('artificial.png');
gtruth_sample=imread('24G.jpg');
img=im2double(img_sample);
img=rgb2gray(img);disp(size(img));
gimg=im2double(img);%disp(size(gimg));gimg=resizem(gimg,[321 481]);disp(size(gimg));

%Adding the AWGN with zero mean and standard deviation 'sigma'
sigma=25;
I = img;% + (sigma/255)*randn(size(img));
%J = imnoise(I,'salt & pepper',0.01);
%K=imnoise (J,'speckle',0.01);
%figure,imshow(J);

%Smoothing with BM3D filter
[NA, y_est] = BM3D(1,I,25);
%figure,imshow(I),title('original noisy image');
%figure,imshow(y_est);title('bm3d image');

%Smoothing with Gaussian filter
G = fspecial('gaussian',[3 3],1.4);
Ig = imfilter(I,G,'same');

%Smoothing with Median filter
Im = medfilt2(I);

%Smoothing with Bilateral filter
%I=I/255;
I(I<0) = 0; I(I>1) = 1;
Ib=bfilter2(I,3,[3 0.1]);%figure,imshow(Ib);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% APPLYING DIFFERENT OPERATORS %%%%%%%%%%%%%%%%%%%%%%%

%%%%"SOBEL EDGE OPERATOR"%%%%
figure,
%subplot(2,2,1);
imshow(I);title('Original noisy image');

%Sobel Edge operation using BM3D fillter
[ sobel_bm3d ] = edge( y_est,'sobel');
%[ sobel_bm3d ] = sobel( y_est,150 );
%subplot(2,2,2)
figure,imshow(sobel_bm3d);title('Sobel Edge operator using BM3D filter');

%Sobel Edge operation using Gaussian filter
[ sobel_im_G ] = edge(Ig,'sobel');
%[ sobel_im_G ] = sobel( Ig,150 );
%subplot(2,2,3),
figure,imshow(sobel_im_G);title('Sobel Edge operator using Gaussian filter ');

%Sobel Edge operation using Median filter
[ sobel_im_M ] = edge( Im,'sobel' );
%subplot(2,2,4),
figure,imshow(sobel_im_M);title('Sobel Edge operator using Median filter ');

%Sobel Edge operation using Bilateral filter
[ sobel_im_B ] = edge( Ib,'sobel' );
%[ sobel_im_B ] = sobel( Ib,150 );
figure,imshow(sobel_im_B);title('Sobel Edge operator using Bilateral filter ');

%Calculate PSNR, PR, MSE
%bm3d filtered 
%sobel_bm3d=resizem(sobel_bm3d,[321 481]);
[ psnrb,mseb ] = pme(sobel_bm3d,gimg);disp('PSNR of bm3d(Sobel)=');disp(psnrb);disp('MSE of bm3d(Sobel)=');disp(mseb);
prb=PR(sobel_bm3d,gimg);disp('PR of bm3d(Sobel)=');disp(prb);

%Gaussian filtered
%sobel_im_G=resizem(sobel_im_G,[321 481]);
[ psnrg,mseg ] = pme(sobel_im_G,gimg);disp('PSNR of Gaussing(Sobel)=');disp(psnrg);disp('MSE of Gaussian(Sobel)=');disp(mseg);
prg=PR(sobel_im_G,gimg);disp('PR of Gaussian(Sobel)=');disp(prg);

%Median filtered
%sobel_im_M=resizem(sobel_im_M,[321 481]);
[ psnrm,msem ] = pme(sobel_im_M,gimg);disp('PSNR of Median(Sobel)=');disp(psnrm);disp('MSE of Median(Sobel)=');disp(msem);
prm=PR(sobel_im_M,gimg);disp('PR of Median(Sobel)=');disp(prm);

%Bilateral filtered
%sobel_im_B=resizem(sobel_im_B,[321 481]);
[ psnrbi,msebi ] = pme(sobel_im_B,gimg);disp('PSNR of Bilateral(Sobel)=');disp(psnrbi);disp('MSE of Bilateral(Sobel)=');disp(msebi);
prbi=PR(sobel_im_B,gimg);disp('PR of Bilateral(Sobel)=');disp(prbi);


%%%%"PREWITT EDGE OPERATOR"%%%%
%figure,subplot(2,2,1);imshow(I);title('Original noisy image');

%Prewitt Edge operation using BM3D fillter
%[ prewitt_bm3d ] = prewitt(y_est,100);
[ prewitt_bm3d ] = edge(y_est,'prewitt');
figure,imshow(prewitt_bm3d);title('Prewitt Edge operator using BM3D filter');

%Prewitt Edge operation using Gaussian filter
%[ prewitt_im_G ] = prewitt( Ig,100 );
[ prewitt_im_G ] = edge(Ig,'prewitt');
figure,imshow(prewitt_im_G);title('Prewitt Edge operator using Gaussin filter');

%Prewitt Edge operation using Median filter
[ prewitt_im_M ] = edge(Im,'prewitt');
%[ prewitt_im_M ] = prewitt( Im,100 );
figure,imshow(prewitt_im_M);title('Prewitt Edge operator using Median filter ');

%Prewitt Edge operation using Bilateral filter
[ prewitt_im_B ] = edge( Ib,'prewitt' );
figure,imshow(prewitt_im_B);title('Prewitt Edge operation using Bilateral filter');
%Calculate PSNR, PR, MSE, Time taken, F-measure here
%Calculate PSNR, PR, MSE,
%bm3d filtered 
%prewitt_bm3d=resizem(prewitt_bm3d,[321 481]);
[ psnrb,mseb ] = pme(prewitt_bm3d,gimg);disp('PSNR of bm3d(Prewitt)=');disp(psnrb);disp('MSE of bm3d(Sobel)=');disp(mseb);
prb=PR(prewitt_bm3d,gimg);disp('PR of bm3d(Prewitt)=');disp(prb);

%Gaussian filtered
%sobel_im_G=resizem(sobel_im_G,[321 481]);
[ psnrg,mseg ] = pme(prewitt_im_G,gimg);disp('PSNR of Gaussian(Prewitt)=');disp(psnrg);disp('MSE of Gaussian(Sobel)=');disp(mseg);
prg=PR(prewitt_im_G,gimg);disp('PR of Gaussian(Prewitt)=');disp(prg);

%Median filtered
%sobel_im_M=resizem(sobel_im_M,[321 481]);
[ psnrm,msem ] = pme(prewitt_im_M,gimg);disp('PSNR of Median(Prewitt)=');disp(psnrm);disp('MSE of Median(Sobel)=');disp(msem);
prm=PR(prewitt_im_M,gimg);disp('PR of Median(Prewitt)=');disp(prm);

%Bilateral filtered
%sobel_im_B=resizem(sobel_im_B,[321 481]);
[ psnrbi,msebi ] = pme(prewitt_im_B,gimg);disp('PSNR of Bilateral(Prewitt)=');disp(psnrbi);disp('MSE of Bilateral(Sobel)=');disp(msebi);
prbi=PR(prewitt_im_B,gimg);disp('PR of Bilateral(Prewitt)=');disp(prbi);


%%%%"ROBERT EDGE OPERATOR%%%%
%figure,subplot(2,2,1);imshow(I);title('Original noisy image');

%Robert Edge operation using BM3D fillter
[ robert_bm3d ] = edge(y_est,'roberts');
%[ robert_bm3d ] = robert( y_est, 20);
figure,imshow(robert_bm3d);title('Robert Edge operator using BM3D filter');

%Robert Edge operation using Gaussian filter
[ robert_im_G ] = edge(Ig,'roberts');
%[ robert_im_G ] = robert( Ig,20 );
figure,imshow(robert_im_G);title('Robert Edge operator on Gaussian image ');

%Robert Edge operation using Median filter
[ robert_im_M ] = edge(Im,'roberts');
%[ robert_im_M ] = robert( Im,100 );
figure,imshow(robert_im_M);title('Robert Edge operator using Median filter ');

%Robert Edge operation using Bilateral filter
[ robert_im_B ] = edge(Ib,'roberts');
figure,imshow(robert_im_B);title('Robert Edge operator using Bilateral filter');


%Calculate PSNR, PR, MSE, Time taken, F-measure here
%Calculate PSNR, PR, MSE,
%bm3d filtered 
%prewitt_bm3d=resizem(prewitt_bm3d,[321 481]);
[ psnrb,mseb ] = pme(robert_bm3d,gimg);disp('PSNR of bm3d(Robert)=');disp(psnrb);disp('MSE of bm3d(Sobel)=');disp(mseb);
prb=PR(robert_bm3d,gimg);disp('PR of bm3d(Robert)=');disp(prb);

%Gaussian filtered
%sobel_im_G=resizem(sobel_im_G,[321 481]);
[ psnrg,mseg ] = pme(robert_im_G,gimg);disp('PSNR of Gaussian(Robert)=');disp(psnrg);disp('MSE of Gaussian(Sobel)=');disp(mseg);
prg=PR(robert_im_G,gimg);disp('PR of Gaussian(Robert)=');disp(prg);

%Median filtered
%sobel_im_M=resizem(sobel_im_M,[321 481]);
[ psnrm,msem ] = pme(robert_im_M,gimg);disp('PSNR of Median(Robert)=');disp(psnrm);disp('MSE of Median(Sobel)=');disp(msem);
prm=PR(robert_im_M,gimg);disp('PR of Median(Robert)=');disp(prm);

%Bilateral filtered
%sobel_im_B=resizem(sobel_im_B,[321 481]);
[ psnrbi,msebi ] = pme(robert_im_B,gimg);disp('PSNR of Bilateral(Robert)=');disp(psnrbi);disp('MSE of Bilateral(Sobel)=');disp(msebi);
prbi=PR(robert_im_B,gimg);disp('PR of Bilateral(Robert)=');disp(prbi);



%%%%"CANNY EDGE OPERATOR%%%%
%figure,subplot(2,2,1);imshow(I);title('Original noisy image');

%Canny Edge operation using BM3D fillter
[ canny_bm3d ]= canny( y_est, 0, []);
figure,imshow(canny_bm3d);title('Canny Edge operator using BM3D filter');


%Canny Edge operation using Gaussian filter
[ canny_im_G ]= canny( Ig, 0, []);
figure,imshow(canny_im_G);title('Canny Edge operator using Gaussian filter ');

%Canny Edge operation using Median filter
[ canny_im_M ] = canny( Im, 0, []);
figure,imshow(canny_im_M);title('Canny Edge operator using Median filter ');

%Canny Edge operation using Bilateral filter
[ canny_im_B ] = canny(Ib,0, [] );
figure,imshow(canny_im_B);title('Canny Edge operator using bilateral filter');

%Calculate PSNR, PR, MSE,
%bm3d filtered 
%prewitt_bm3d=resizem(prewitt_bm3d,[321 481]);
[ psnrb,mseb ] = pme(canny_bm3d,gimg);disp('PSNR of bm3d(Canny)=');disp(psnrb);disp('MSE of bm3d(Sobel)=');disp(mseb);
prb=PR(canny_bm3d,gimg);disp('PR of bm3d(Canny)=');disp(prb);

%Gaussian filtered
%sobel_im_G=resizem(sobel_im_G,[321 481]);
[ psnrg,mseg ] = pme(canny_im_G,gimg);disp('PSNR of Gaussian(Canny)=');disp(psnrg);disp('MSE of Gaussian(Sobel)=');disp(mseg);
prg=PR(canny_im_G,gimg);disp('PR of Gaussian(Canny)=');disp(prg);

%Median filtered
%sobel_im_M=resizem(sobel_im_M,[321 481]);
[ psnrm,msem ] = pme(canny_im_M,gimg);disp('PSNR of Median(Canny)=');disp(psnrm);disp('MSE of Median(Sobel)=');disp(msem);
prm=PR(canny_im_M,gimg);disp('PR of Median(Canny)=');disp(prm);

%Bilateral filtered (Non linear filtering)
%sobel_im_B=resizem(sobel_im_B,[321 481]);
[ psnrbi,msebi ] = pme(canny_im_B,gimg);disp('PSNR of Bilateral(Canny)=');disp(psnrbi);disp('MSE of Bilateral(Sobel)=');disp(msebi);
prbi=PR(canny_im_B,gimg);disp('PR of Bilateral(Canny)=');disp(prbi);






