function [ pr_value ] = PR( Timg,Gimg )
%function to calculate the performance ration (PR) of edge detector
%Note: Timg=Test image, Gimg=Ground truth image

t1=Gimg;
c=Timg;
ct=0;
cm=0;
[m1 n1]=size(t1);
for i=1:m1
    for j=1:n1
        if t1(i,j)~=0 && c(i,j)~=0
            ct=ct+1;
        end
        
               
        if (t1(i,j)~=0 && c(i,j)==0 || t1(i,j)==0 && c(i,j)~=0) 
            cm=cm+1;
        end
            
        
    end
end
CR=(ct/cm)*100;

pr_value=num2str(CR);disp(pr_value);
end

