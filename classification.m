function accuracy = classification(u,nVar,data)
    

    sample_num = 30; % total number of samples from the input table
    nvar = nVar;
    %varsize = [1 nvar];
    
    Position_vec = u;

    x=zeros(nvar,8);
    y=zeros(nvar,7);
    Sample=zeros(nvar,sample_num);

    Group =[transpose(data.stromaGrp(1,1:8));transpose(data.stromaGrp(1,14:20))];

    p=1;
    q=1;
    r=1;
    for j = Position_vec
        x(p,1:8) = data.StromaData(j,1:8);
        p=p+1;
    end

    for k = Position_vec
        y(q,1:7)= data.StromaData(k,14:20);
        q=q+1;
    end

    x = transpose(x);
    y = transpose(y);

    % x= transpose(data.StromaData(1:50,1:8));
    % y= transpose(data.StromaData(1:50,14:20));

    Trainer = [x;y];


    for l = Position_vec
        Sample(r,1:sample_num) =data.StromaData(l,1:sample_num);
        r=r+1;
    end
    % Sample =transpose(data.StromaData(1:50,9:14));

    Sample = transpose(Sample);

    %% KNN Call

    %class = knnclassify(Sample,Trainer,Group);


    %% SVM Call

      SVMstruct = svmtrain(Trainer,Group,'Kernel_Function','rbf');
      class = svmclassify(SVMstruct,Sample);

 %% Accuracy
 
    %nloop = 14-9+1;
    nloop =sample_num;
    rcount=0;
    for i=1:nloop                   %% class = 6X1 matrix
    %    if class(x,1) == data.stromaGrp(1,8+x)
    %         rcount=rcount+1;
    %    end;   
         if (strcmp(class(i,1),data.stromaGrp(1,i)))
            rcount=rcount+1;
         end;
    end;
    accuracy =(rcount/nloop)*100;
    
end