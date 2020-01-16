close all; clear all; clc;

% 
% nPop = 10;
% nvar = 50;
% varsize = [1 nvar];
% 
% Position = unidrnd(200, varsize);

% for i=1:nPop
%     Position(i) = unifrnd(1, 200, varsize);
% end


nPop = 10;
nvar = 50;
varsize = [1 nvar];

Position = unidrnd(200, varsize); 
 x=zeros(50,8);
% x=[];

data = load ('Stromaprocesseddata.mat');
p=1;

for j = Position
    x(p,1:8) = data.StromaData(j,1:8);
    p=p+1;
end







