function [ sobel_edge_image ] = sobel( img,thresh )
%Function to find sobel edges in an image with given threshold
F1=[-1 0 1;-2 0 2; -1 0 1];
F2=[-1 -2 -1;0 0 0; 1 2 1];

C=double(img);
for i=1:size(C,1)-2
    for j=1:size(C,2)-2
        %Sobel mask for x-direction:
        %Gx=((2*C(i+2,j+1)+C(i+2,j)+C(i+2,j+2))-(2*C(i,j+1)+C(i,j)+C(i,j+2)));
        Gx=sum(sum(F1.*C(i:i+2,j:j+2)));
        Gy=sum(sum(F2.*C(i:i+2,j:j+2)));
               
        %Sobel mask for y-direction:
        %Gy=((2*C(i+1,j+2)+C(i,j+2)+C(i+2,j+2))-(2*C(i+1,j)+C(i,j)+C(i+2,j)));
      
        %The gradient of the image
         B(i,j)=sqrt(Gx.^2+Gy.^2);
      
    end
end
B=B*255;

%Thresholding the gradient
Thresh=thresh;
B=max(B,Thresh);
B(B==round(Thresh))=0;
B=im2bw(B);

sobel_edge_image=B;
end

