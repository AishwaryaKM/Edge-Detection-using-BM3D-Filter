function [ F_measure ] = fmeasure( Timg,Gimg )
%function to calculate precision and recall (f_measure)
%%Note: Timg=Test image, Gimg=Ground truth image
idx = (Gimg()==1);
p = length(Gimg(idx));
n = length(Gimg(~idx));
%N = p+n;

tp = sum(Gimg(idx)==Timg(idx));
tn = sum(Gimg(~idx)==Timg(~idx));
fp = n-tn;
%fn = p-tp;

tp_rate = tp/p;
%tn_rate = tn/n;

%accuracyb = (tp+tn)/N;
sensitivityb = tp_rate;
%specificityb = tn_rate;
precision = tp/(tp+fp);
recall = sensitivityb;
f_measure = 2*((precision*recall)/(precision + recall));
%gmeanb = sqrt(tp_rateb*tn_rate);
F_measure=num2str(f_measure);


end

