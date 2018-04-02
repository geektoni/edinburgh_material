

%% ACTION CONSTANTS:
UP_LEFT = 1 ;
UP = 2 ;
UP_RIGHT = 3 ;


%% PROBLEM SPECIFICATION:

blockSize = 5 ; % This will function as the dimension of the road basis 
% images (blockSize x blockSize), as well as the view range, in rows of
% your car (including the current row).

n_MiniMapBlocksPerMap = 5 ; % determines the size of the test instance. 
% Test instances are essentially road bases stacked one on top of the
% other.

basisEpsisodeLength = blockSize - 1 ; % The agent moves forward at constant speed and
% the upper row of the map functions as a set of terminal states. So 5 rows
% -> 4 actions.

episodeLength = blockSize*n_MiniMapBlocksPerMap - 1 ;% Similarly for a complete
% scenario created from joining road basis grid maps in a line.

%discountFactor_gamma = 1 ; % if needed

rewards = [ 1, -1, -20 ] ; % the rewards are state-based. In order: paved 
% square, non-paved square, and car collision. Agents can occupy the same
% square as another car, and the collision does not end the instance, but
% there is a significant reward penalty.

probabilityOfUniformlyRandomDirectionTaken = 0.15 ; % Noisy driver actions.
% An action will not always have the desired effect. This is the
% probability that the selected action is ignored and the car uniformly 
% transitions into one of the above 3 states. If one of those states would 
% be outside the map, the next state will be the one above the current one.

roadBasisGridMaps = generateMiniMaps ; % Generates the 8 road basis grid 
% maps, complete with an initial location for your agent. (Also see the 
% GridMap class).

noCarOnRowProbability = 0.8 ; % the probability that there is no car 
% spawned for each row

seed = 1234;
rng(seed); % setting the seed for the random nunber generator

% Call this whenever starting a new episode:
MDP = generateMap( roadBasisGridMaps, n_MiniMapBlocksPerMap, blockSize, ...
    noCarOnRowProbability, probabilityOfUniformlyRandomDirectionTaken, ...
    rewards );


%% Initialising the state observation (state features) and setting up the 
% exercise approximate Q-function:
stateFeatures = ones( 4, 5 );
action_values = zeros(1, 3);

% Weights we need to estimate the Q(s,a) value
weights = ones(4,5,3);

% Learning rate and a counter to decrease the learning rate alpha
% after each iteration.
alpha=0.01;
counter=1;

% Discounf factor
lambda=1;

%% TEST ACTION TAKING, MOVING WINDOW AND TRAJECTORY PRINTING:
% Simulating agent behaviour when following the policy defined by 
% $pi_test1$.
%
% Commented lines also have examples of use for $GridMap$'s $getReward$ and
% $getTransitions$ functions, which act as our reward and transition
% functions respectively.
for episode = 1:50
    % Initialize these everytime we change episode
    action_values = zeros(1, 3);
    
    %%
    currentTimeStep = 0 ;
    MDP = generateMap( roadBasisGridMaps, n_MiniMapBlocksPerMap, ...
        blockSize, noCarOnRowProbability, ...
        probabilityOfUniformlyRandomDirectionTaken, rewards );
    currentMap = MDP ;
    agentLocation = currentMap.Start ;
    startingLocation = agentLocation ; % Keeping record of initial location.
    
    % If you need to keep track of agent movement history:
    agentMovementHistory = zeros(episodeLength+1, 2) ;
    agentMovementHistory(currentTimeStep + 1, :) = agentLocation ;
        
    realAgentLocation = agentLocation ; % The location on the full test map.
    Return = 0;
    
    % Select a random starting action
    agent_action = randi(3); 
    
    for i = 1:episodeLength
        
        % Use the $getStateFeatures$ function as below, in order to get the
        % feature description of a state:
        stateFeatures = MDP.getStateFeatures(realAgentLocation); % dimensions are 4rows x 5columns
        
        % The $GridMap$ functions $getTransitions$ and $getReward$ act as the
        % problems transition and reward function respectively.
        %
        % Your agent might not know these functions, but your simulator
        % does! (How wlse would we get our data?)
        
        % $actionMoveAgent$ can be used to simulate agent (the car) behaviour.
        
        %     [ possibleTransitions, probabilityForEachTransition ] = ...
        %         MDP.getTransitions( realAgentLocation, actionTaken );
        %     [ numberOfPossibleNextStates, ~ ] = size(possibleTransitions);
        %     previousAgentLocation = realAgentLocation;
        
        [ agentRewardSignal, realAgentLocation, currentTimeStep, ...
            agentMovementHistory ] = ...
            actionMoveAgent( agent_action, realAgentLocation, MDP, ...
            currentTimeStep, agentMovementHistory, ...
            probabilityOfUniformlyRandomDirectionTaken ) ;        
        
        %% Start improving Q's weights using SARSA.
        
        % Get the next state's features
        next_state_features = MDP.getStateFeatures(realAgentLocation);
        
        % Select the next action using a epsilon-greedy policy
        next_action = e_greedy(0.1, weights, next_state_features);
        
        % Compute the increment of the weight
        increment = agentRewardSignal + ...
            lambda*compQ(next_state_features, weights, next_action)...
                - compQ(stateFeatures, weights, agent_action);
        
        % Update the weights.
        for col = 1:5
            for row = 1:4
                weights(row, col, agent_action) = ...
                    weights(row, col, agent_action) + ...
                        (alpha/counter)*increment*stateFeatures(row, col);
            end
        end
        
        % Print the weights at the end of each step.
        weights
    
        % Update the action the agent will take during the next step.
        agent_action = next_action;
        
        % Update the final reward
        Return = Return + agentRewardSignal;
        
        % If you want to view the agents behaviour sequentially, and with a
        % moving view window, try using $pause(n)$ to pause the screen for $n$
        % seconds between each draw:
        
        [ viewableGridMap, agentLocation ] = setCurrentViewableGridMap( ...
            MDP, realAgentLocation, blockSize );
        % $agentLocation$ is the location on the viewable grid map for the
        % simulation. It is used by $refreshScreen$.
        
        currentMap = viewableGridMap ; %#ok<NASGU>
        % $currentMap$ is keeping track of which part of the full test map
        % should be printed by $refreshScreen$ or $printAgentTrajectory$.
        
        %refreshScreen
        
        % After each update plot the weights' "surfaces", instead of the
        % representation of the agents movement. To speed up computations,
        % print them only after 10 iterations.
        if (mod(i,10)==0)
            subplot(2,2,1) 
            surf([1,2,3,4,5], [1,2,3,4], weights(:,:,1))
            title("Q(s,a) weights for action 1 (UP LEFT)")
            xlabel("Columns")
            ylabel("Row")
            linkdata on

            subplot(2,2,2) 
            surf([1,2,3,4,5], [1,2,3,4], weights(:,:,2))
            title("Q(s,a) weights for action 2 (UP)")
            xlabel("Columns")
            ylabel("Row")
            linkdata on

            subplot(2,2,3)
            surf([1,2,3,4,5], [1,2,3,4], weights(:,:,3))
            title("Q(s,a) weights for action 3 (UP RIGHT)")
            xlabel("Columns")
            ylabel("Row")
            linkdata on
        end 
        % End of plot printing
        
        % Update the counter, such to decrease the learning rate
        counter = counter+1;
    end
    
    currentMap = MDP;
    agentLocation = realAgentLocation;
    
    %Return
    
    %printAgentTrajectory
    %pause(0.01)
    
end % for each episode

%% Custom method needed by SARSA.

% Compute the Q(s,a) value given the action, the weights and the
% state features (the value is computed as a linear combination).
function [Q] = compQ(features, weights, action)
    Q= sum ( sum( weights(:,:,action) .* features) );
end

% Epsilon-greedy method to choose the next action, based on maximizing
% the computed Q value. This method will choose a random action (over 
% the optimal one) with a probability given by the argument "probability".
function [choosen_action] = e_greedy(probability, weights, features)
    
    % Compute the optimal action
    action_values = zeros(1,3);
    for action = 1:3
            action_values(action) = ...
                sum ( sum( weights(:,:,action) .* features) );
    end % for each possible action
    [~, optimal_action] = max(action_values);
    
    % Select which action will be taken (optimal or random?)
    prob = rand;
    if (prob <= (1-probability))
        choosen_action = optimal_action; 
    else
        choosen_action = randi(3);
    end

end
