clc;
clear all;
close all;
%% problem definition
data = load ('Stromaprocesseddata.mat');
nVar = 50;  % number of feature

AccuracyFunc = @(u) classification(u,nVar,data);
VarSize=[1 nVar];   % Size of Decision Variables Matrix

VarMin=1;         % Lower Bound of Variables
VarMax=19000;         % Upper Bound of Variables


%% parameter of PSO

MaxIt=20;      % Maximum Number of Iterations

nPop=47;        % Population Size (Swarm Size)

% w=1;            % Inertia Weight
% wdamp=0.99;     % Inertia Weight Damping Ratio
% c1=2;           % Personal Learning Coefficient
% c2=2;           % Global Learning Coefficient

% Constriction Coefficients
phi1=4.05;
phi2=4.05;
phi=phi1+phi2;
chi=2/(phi-2+sqrt(phi^2-4*phi));
w=chi;          % Inertia Weight
wdamp=2;        % Inertia Weight Damping Ratio
c1=chi*phi1;    % Personal Learning Coefficient
c2=chi*phi2;    % Global Learning Coefficient

% Velocity Limits
VelMax=0.5*(VarMax-VarMin);
VelMin=-VelMax;


%% Initialization
empty_particle.Position=[];
empty_particle.Accuracy=[];
empty_particle.Velocity=[];
empty_particle.Best.Position=[];
empty_particle.Best.Accuracy=[];

particle=repmat(empty_particle,nPop,1);

BestSol.Accuracy=0;

for i=1:nPop
    
    % Initialize Position
    %particle(i).Position=unidrnd(VarMax, VarSize); 
    particle(i).Position=round(unifrnd(VarMin,VarMax,VarSize));
    % Initialize Velocity
    particle(i).Velocity=zeros(VarSize);
    
    % Evaluation
    particle(i).Accuracy=AccuracyFunc(particle(i).Position);
    
    % Update Personal Best
    particle(i).Best.Position=particle(i).Position;
    particle(i).Best.Accuracy=particle(i).Accuracy;
    
    % Update Global Best
    if particle(i).Best.Accuracy>BestSol.Accuracy
        
        BestSol=particle(i).Best;
        
    end
    
end

BestAccuracy=zeros(MaxIt,1);

%% PSO Main Loop

for it=1:MaxIt
    
    for i=1:nPop
        
        % Update Velocity
        particle(i).Velocity = w*particle(i).Velocity ...
            +c1*rand(VarSize).*(particle(i).Best.Position-particle(i).Position) ...
            +c2*rand(VarSize).*(BestSol.Position-particle(i).Position);
        
        % Apply Velocity Limits
        particle(i).Velocity = max(particle(i).Velocity,VelMin);
        particle(i).Velocity = min(particle(i).Velocity,VelMax);
        
        % Update Position
        particle(i).Position = round(particle(i).Position + particle(i).Velocity);
        
        % Velocity Mirror Effect
        IsOutside=(particle(i).Position<VarMin | particle(i).Position>VarMax);
        particle(i).Velocity(IsOutside)=-particle(i).Velocity(IsOutside);
        
        % Apply Position Limits
        particle(i).Position = max(particle(i).Position,VarMin);
        particle(i).Position = min(particle(i).Position,VarMax);
        
        % Evaluation
        particle(i).Accuracy = AccuracyFunc(particle(i).Position);
        
        % Update Personal Best
        if particle(i).Accuracy>particle(i).Best.Accuracy
            
            particle(i).Best.Position=particle(i).Position;
            particle(i).Best.Accuracy=particle(i).Accuracy;
            
            
            % Update Global Best
            if particle(i).Best.Accuracy>BestSol.Accuracy
                
                BestSol=particle(i).Best;
                
            end
            
        end
        
    end
    
    BestAccuracy(it)=BestSol.Accuracy;
    
    disp(['Iteration ' num2str(it) ': Best Accuracy = ' num2str(BestAccuracy(it))]);
    
    w=w*wdamp;
    
end
%% Results

figure;
plot(BestAccuracy,'LineWidth',2);
xlabel('Iteration');
ylabel('Best Cost');



