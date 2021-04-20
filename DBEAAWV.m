function DBEAAWV(Global)
% <algorithm> <D>
% K --- 5 --- Balance factor 
% fr --- 0.2 --- The frequency of employing weight vector adaptation
% "PlatEMO"

%------------------------------- Reference --------------------------------
% A Decomposition-Based Evolutionary Algorithm with Adaptive Weight
% Vectors for Multi- and Many-objective Optimization, Evostar 2020.
%------------------------------- Reference --------------------------------


    %% Parameter setting
    [K,fr] = Global.ParameterSet(5,0.2);

    %% Generate the weight vectors and random population
    [V0,Global.N] = UniformPoint(Global.N,Global.M);
    Population    = Global.Initialization();
    Z = min(Population.objs,[],1);
    T = ceil(Global.N/10);
    %% Detect the neighbours of each solution
%     %-------------------1 distance--------------------%
     B = pdist2(V0,V0);
     [~,B] = sort(B,2);
     B = B(:,1:T);
%     %-------------------2 angle--------------------%
%        B = 1 - pdist2(V0,V0,'cosine');
%        [~,B] = sort(B,2,'descend');
%        B = B(:,1:T);
  
     V = V0;

    %% Optimization
    while Global.NotTermination(Population)
        
        % For each solution
        for i = 1 : Global.N      
            % Choose the parents
            P = B(i,randperm(size(B,2)));
%-----------------------------DE operator-------------------------%
%             % Choose the parents
%             if rand < 0.9
%                 P = B(i,randperm(end));
%             else
%                 P = randperm(Global.N);
%             end
% 
%             % Generate an offspring
%             Offspring = DE(Population(i),Population(P(1)),Population(P(2)));

            % Generate an offspring
            Offspring = GAhalf(Population(P(1:2)));

            % Update the ideal point
            Z = min(Z,Offspring.obj);
                      
            % Update the neighbours
%             switch type
%                 case 1
                    % PBI approach
%---------------------replace T---------------------------%
%                       theta=5;
% %                     theta   = 1+(10-1)*(Global.gen/Global.maxgen);
% %                     theta  = exp(4*(max(V(i,:))-min(V(i,:))));
%                     normW   = sqrt(sum(V(P,:).^2,2));
%                     normP   = sqrt(sum((Population(P).objs-repmat(Z,T,1)).^2,2));
%                     normO   = sqrt(sum((Offspring.obj-Z).^2,2));
%                     CosineP = sum((Population(P).objs-repmat(Z,T,1)).*V(P,:),2)./normW./normP;
%                     CosineO = sum(repmat(Offspring.obj-Z,T,1).*V(P,:),2)./normW./normO;
%                     g_old   = normP.*CosineP + theta*normP.*sqrt(1-CosineP.^2);
%                     g_new   = normO.*CosineO + theta*normO.*sqrt(1-CosineO.^2);
% % %                     g_old   = normP.*CosineP + 20*normP.*sqrt(1-CosineP.^2);
% % %                     g_new   = normO.*CosineO + 20*normO.*sqrt(1-CosineO.^2);
% % %                     g_old   = normP.*CosineP + 700*normP.*sqrt(1-CosineP.^2);
% % %                     g_new   = normO.*CosineO + 700*normO.*sqrt(1-CosineO.^2);                
%---------------------replace T---------------------------%
%                 case 2
%                     % Tchebycheff approach
%---------------------replace 1---------------------------%
%                     g_old = max(abs(Population(associate).objs-repmat(Z,1,1)).*V(associate,:),[],2);
%                     g_new = max(repmat(abs(Offspring.obj-Z),1,1).*V(associate,:),[],2);
%---------------------replace 1---------------------------%
%---------------------replace T---------------------------%
%                     g_old = max(abs(Population(P).objs-repmat(Z,T,1)).*V(P,:),[],2);
%                     g_new = max(repmat(abs(Offspring.obj-Z),T,1).*V(P,:),[],2);
%-----------------------------simultaneously--------------------------
%                       g_old = max(abs(Population(P).objs-repmat(Z,T,1)).*V(P,:),[],2)+0.1*sum(abs(Population(P).objs-repmat(Z,T,1)),2);
%                       g_new = max(repmat(abs(Offspring.obj-Z),T,1).*V(P,:),[],2)+0.1*sum(repmat(abs(Offspring.obj-Z),T,1),2);
%---------------------replace T---------------------------%
%                 case 3
%                     % Tchebycheff approach with normalization
%                     Zmax  = max(Population.objs,[],1);
%                     g_old = max(abs(Population(P).objs-repmat(Z,T,1))./repmat(Zmax-Z,T,1).*V(P,:),[],2);
%                     g_new = max(repmat(abs(Offspring.obj-Z)./(Zmax-Z),T,1).*V(P,:),[],2);
%                 case 4
%                     % Modified Tchebycheff approach
                    %---------------------replace T---------------------------%
                    % Find the K nearest weight vectors of the offspring
                      [~,rank] = sort(1-pdist2(Offspring.obj-Z,V,'cosine'),'descend');
                      P        = rank(1:K);
                      g_old = max(abs(Population(P).objs-repmat(Z,length(P),1))./V(P,:),[],2);
                      g_new = max(repmat(abs(Offspring.obj-Z),length(P),1)./V(P,:),[],2);
                    %---------------------replace T---------------------------%
                    %---------------------replace only 1---------------------------%
%                     g_old = max(abs(Population(associate).objs-repmat(Z,1,1))./V(associate,:),[],2);
%                     g_new = max(repmat(abs(Offspring.obj-Z),1,1)./V(associate,:),[],2);
                    %---------------------replace only 1---------------------------%
%            end
% %---------------------replace only 1---------------------------%
%             if g_old>=g_new
%                 Population(associate) = Offspring;
%             end 
% %---------------------replace only 1---------------------------%
%---------------------replace T---------------------------%
%              Population(P(g_old>=g_new)) = Offspring;
             Population(P(find(g_old>=g_new,1))) = Offspring;
%---------------------replace T---------------------------%
        end
        if ~mod(Global.gen,ceil(fr*Global.maxgen))
            V(1:Global.N,:) = ReferenceVectorAdaptation(Population.objs,V0);
            B = pdist2(V,V);
            [~,B] = sort(B,2);
            B = B(:,1:T);
        end
    end
end