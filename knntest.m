% clc ;clear all; close all;

data = load ('Stromaprocesseddata.mat');
% Group = {'diagnosis: IBC';
%           'diagnosis: non-IBC' };

% position =unifrnd(1,22000,50);
Group =[transpose(data.stromaGrp(1,1:8));transpose(data.stromaGrp(1,14:20))];


x= transpose(data.StromaData(1:50,1:8));
y= transpose(data.StromaData(1:50,14:20));

Trainer = [x;y];
Sample =transpose(data.StromaData(1:50,9:14));

class = knnclassify(Sample,Trainer,Group);

% SVMstruct = svmtrain(Trainer,Group,'Kernel_Function','rbf');
% class = svmclassify(SVMstruct,Sample);
nloop = 14-9+1;
rcount=0;
for i=1:nloop                   %% class = 6X1 matrix
%    if class(x,1) == data.stromaGrp(1,8+x)
%         rcount=rcount+1;
%    end;   
     if (strcmp(class(i,1),data.stromaGrp(1,8+i)))
        rcount=rcount+1;
     end;
end;
accuracy =(rcount/nloop)*100;
disp('Result:.....');
disp(class);
disp(accuracy);