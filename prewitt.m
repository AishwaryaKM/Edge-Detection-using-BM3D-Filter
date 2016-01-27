function [ prewitt_edge_image ] = prewitt( img,thresh )
%Function to find prewitt edges of the image with the given threshold

im=im2double(img);


F1=[-1 0 1;-1 0 1; -1 0 1];
F2=[-1 -1 -1;0 0 0; 1 1 1];

C=double(im);
for i=1:size(C,1)-2
    for j=1:size(C,2)-2
        %Sobel mask for x-direction:
        %Gx=((2*C(i+2,j+1)+C(i+2,j)+C(i+2,j+2))-(2*C(i,j+1)+C(i,j)+C(i,j+2)));
        Gx=sum(sum(F1.*C(i:i+2,j:j+2)));
        Gy=sum(sum(F2.*C(i:i+2,j:j+2)));
               
        %Sobel mask for y-direction:
        %Gy=((2*C(i+1,j+2)+C(i,j+2)+C(i+2,j+2))-(2*C(i+1,j)+C(i,j)+C(i+2,j)));
      
        %The gradient of the image
         U(i,j)=sqrt(Gx.^2+Gy.^2);
      
    end
end

U=U*255;

%Thresholding the gradient
Thresh=thresh;
U=max(U,Thresh);
U(U==round(Thresh))=0;
U=im2bw(U);

prewitt_edge_image=U;
end