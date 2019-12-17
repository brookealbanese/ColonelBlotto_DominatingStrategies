% Main - Colonel Blotto Game With Dominating Strategies. Solve a non co-op game between 3 players (2 attackers 1 defender)
% +HDR-------------------------------------------------------------------------
% FILE NAME      : Main.m
% TYPE           : MATLAB File
% COURSE         : Binghamton University
%                  EECE580A - Cyber Physical Systems Security
% -----------------------------------------------------------------------------
% PURPOSE : Colonel Blotto Game With Dominating Strategies
%           Solve a non co-op game between 3 players (2 attackers 1 defender)
% 
% -HDR-------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CLEAR THE WORKSPACE AND COMMAND WINDOW %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
clc;



%%%%%%%%%%%%%%%%%%%%%%%%
%% START ELAPSED TIME %%
%%%%%%%%%%%%%%%%%%%%%%%%
start_time = clock;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SET UP THE GAME CONFIGURABLES %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HOW MANY CYBER NODES ARE THERE?
num_cyber_nodes = 4;

% HOW ARE THE PHYSICAL NODES CONNECTED TO THE CYBER NODES?
%   [PHYSICAL_NODE_1; PHYSICAL_NODE_2]
%   [CYBER_NODE_1 CYBER_NODE_2 ... CYBER_NODE_N; CYBER_NODE_1 CYBER_NODE_2 ... CYBER_NODE_N]
CONNECTIONS = [1 1 1 0 ; 0 1 1 1];

% WHAT ARE THE AVAILABLE PLAYER RESOURCES FOR EACH GAME?
%   [GAME_1; GAME_2; GAME_3]
% attacker1 = [3;3;3];
% attacker2 = [3;3;3];
% defender  = [6;7;8];
attacker1 = [2;2;2];
attacker2 = [2;2;2];
defender  = [4;5;6];
RESOURCES = [attacker1 attacker2 defender];

% WHAT IS THE COST OF EACH PHYSICAL NODE TO EACH PLAYER WHEN DOWN?
%   [PHYSICAL_NODE_1; PHYSICAL_NODE_2]
%   A POSITIVE SIGN DENOTES AN ATTACKER (MAXIMIZER)
%   A NEGATIVE SIGN DENOTES A DEFENDER (MINIMIZER)
%   NOTE: IF THESE VALUES CHANGE, RE-EVALUATE PlayerPreference.m VALUES!!!
attacker1_cost = [1;.25];
attacker2_cost = [.25;1];
defender_cost  = [-.75;-.75];
COST = [attacker1_cost attacker2_cost defender_cost];

% HOW MANY CYBER NODES MUST BE DOWN FOR EACH PHYSICAL NODE TO BE DOWN?
%   [PHYSICAL_NODE_1; PHYSICAL_NODE_2]
threshold = [1;1];



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CREATE THE RESOURCE MATRIX [RESOURCE_MATRIX] BASED ON ALL COMBINATIONS %%
%% THAT COULD BE PLAYED BETWEEN BOTH ATTACKERS VERSUS DEFENDER            %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CREATE AN ARRAY OF 2-D MATRICES CONTAINING ALL NECESSARY COMBINATIONS OF RESOURCE ALLOCATIONS
[RESOURCE_COMBOS_ARRAY] = ResourceCombos(num_cyber_nodes,RESOURCES);

% CREATE AN ARRAY OF 2-D RESOURCE MATRICES FOR EACH GAME BY SELECTING THE APPROPRIATE
%   RESOURCE ALLOCATIONS MATRIX BASED ON THE PLAYER'S AVAILABLE RESOURCES
RESOURCE_MATRIX_ARRAY_1 = {RESOURCE_COMBOS_ARRAY{attacker1(1)} RESOURCE_COMBOS_ARRAY{attacker2(1)} RESOURCE_COMBOS_ARRAY{defender(1)}};
RESOURCE_MATRIX_ARRAY_2 = {RESOURCE_COMBOS_ARRAY{attacker1(2)} RESOURCE_COMBOS_ARRAY{attacker2(2)} RESOURCE_COMBOS_ARRAY{defender(2)}};
RESOURCE_MATRIX_ARRAY_3 = {RESOURCE_COMBOS_ARRAY{attacker1(3)} RESOURCE_COMBOS_ARRAY{attacker2(3)} RESOURCE_COMBOS_ARRAY{defender(3)}};

% BUILD THE THREE 3-D GAME COST MATRICES USING THE SETTINGS AND RESPECTIVE GAME RESOURCE MATRIX ARRAY
GAME_COST_MATRIX_1 = GameBuild(0,num_cyber_nodes,RESOURCE_MATRIX_ARRAY_1,CONNECTIONS,COST,threshold);
GAME_COST_MATRIX_2 = GameBuild(0,num_cyber_nodes,RESOURCE_MATRIX_ARRAY_2,CONNECTIONS,COST,threshold);
GAME_COST_MATRIX_3 = GameBuild(0,num_cyber_nodes,RESOURCE_MATRIX_ARRAY_3,CONNECTIONS,COST,threshold);

config_time = clock;
config_time_seconds = etime(config_time,start_time);
config_time_minutes = floor(config_time_seconds/60)
config_time_seconds = rem(config_time_seconds,60)



%%%%%%%%%%%%%%%%%%%%%%
%% EVALUATE GAME #1 %%
%%%%%%%%%%%%%%%%%%%%%%
% CREATE THE DOMINATING STRATEGIES MATRICES FOR EACH PLAYER
DOM_STRAT_1_DEFENDER  = DominatingStrategies(GAME_COST_MATRIX_1, 'defender');
DOM_STRAT_1_ATTACKER1 = DominatingStrategies(GAME_COST_MATRIX_1, 'attacker1');
DOM_STRAT_1_ATTACKER2 = DominatingStrategies(GAME_COST_MATRIX_1, 'attacker2');

% REDUCE THE RESOURCE ALLOCATIONS MATRICES FOR EACH PLAYER (THROW AWAY DOMINATED STRATEGIES)
NEW_STRAT_1_DEFENDER  = ReducedMatrix(DOM_STRAT_1_DEFENDER,  RESOURCE_MATRIX_ARRAY_1, 'defender');
NEW_STRAT_1_ATTACKER1 = ReducedMatrix(DOM_STRAT_1_ATTACKER1, RESOURCE_MATRIX_ARRAY_1, 'attacker1');
NEW_STRAT_1_ATTACKER2 = ReducedMatrix(DOM_STRAT_1_ATTACKER2, RESOURCE_MATRIX_ARRAY_1, 'attacker2');

% CREATE AN ARRAY OF 2-D RESOURCE MATRICES (REDUCED)
REDUCED_RESOURCE_MATRIX_ARRAY_1 = {NEW_STRAT_1_ATTACKER1 NEW_STRAT_1_ATTACKER2 NEW_STRAT_1_DEFENDER};

% BUILD THE 2-D GAME COST MATRICES USING THE SETTINGS AND RESPECTIVE GAME REDUCED RESOURCE MATRIX ARRAY
REDUCED_GAME_COST_MATRIX_1 = GameBuild(1,num_cyber_nodes,REDUCED_RESOURCE_MATRIX_ARRAY_1,CONNECTIONS,COST,threshold);

% FIND THE SIZE OF EACH REDUCED RESOURCE ALLOCATIONS MATRIX FOR EACH PLAYER
len_new_strat_1_defender  = size(NEW_STRAT_1_DEFENDER);
len_new_strat_1_attacker1 = size(NEW_STRAT_1_ATTACKER1);
len_new_strat_1_attacker2 = size(NEW_STRAT_1_ATTACKER2);

% CREATE AN ARRAY OF REDUCED RESOURCE ALLOCATIONS MATRIX SIZES
num_of_strat_1 = [len_new_strat_1_attacker1(1) len_new_strat_1_attacker2(1) len_new_strat_1_defender(1)];

% EXECUTE THE GAME CALCULATION
[NASH_EQ_1,payoff_1,iterations_1,err_1] = NPG2(num_of_strat_1,REDUCED_GAME_COST_MATRIX_1);

game_1_time = clock;
game_1_time_seconds = etime(game_1_time,config_time);
game_1_time_minutes = floor(game_1_time_seconds/60)
game_1_time_seconds = rem(game_1_time_seconds,60)



%%%%%%%%%%%%%%%%%%%%%%
%% EVALUATE GAME #2 %%
%%%%%%%%%%%%%%%%%%%%%%
% CREATE THE DOMINATING STRATEGIES MATRICES FOR EACH PLAYER
DOM_STRAT_2_DEFENDER  = DominatingStrategies(GAME_COST_MATRIX_2, 'defender');
DOM_STRAT_2_ATTACKER1 = DominatingStrategies(GAME_COST_MATRIX_2, 'attacker1');
DOM_STRAT_2_ATTACKER2 = DominatingStrategies(GAME_COST_MATRIX_2, 'attacker2');

% REDUCE THE RESOURCE ALLOCATIONS MATRICES FOR EACH PLAYER (THROW AWAY DOMINATED STRATEGIES)
NEW_STRAT_2_DEFENDER  = ReducedMatrix(DOM_STRAT_2_DEFENDER,  RESOURCE_MATRIX_ARRAY_2, 'defender');
NEW_STRAT_2_ATTACKER1 = ReducedMatrix(DOM_STRAT_2_ATTACKER1, RESOURCE_MATRIX_ARRAY_2, 'attacker1');
NEW_STRAT_2_ATTACKER2 = ReducedMatrix(DOM_STRAT_2_ATTACKER2, RESOURCE_MATRIX_ARRAY_2, 'attacker2');

% CREATE AN ARRAY OF 2-D RESOURCE MATRICES (REDUCED)
REDUCED_RESOURCE_MATRIX_ARRAY_2 = {NEW_STRAT_2_ATTACKER1 NEW_STRAT_2_ATTACKER2 NEW_STRAT_2_DEFENDER};

% BUILD THE 2-D GAME COST MATRICES USING THE SETTINGS AND RESPECTIVE GAME REDUCED RESOURCE MATRIX ARRAY
REDUCED_GAME_COST_MATRIX_2 = GameBuild(1,num_cyber_nodes,REDUCED_RESOURCE_MATRIX_ARRAY_2,CONNECTIONS,COST,threshold);

% FIND THE SIZE OF EACH REDUCED RESOURCE ALLOCATIONS MATRIX FOR EACH PLAYER
len_new_strat_2_defender  = size(NEW_STRAT_2_DEFENDER);
len_new_strat_2_attacker1 = size(NEW_STRAT_2_ATTACKER1);
len_new_strat_2_attacker2 = size(NEW_STRAT_2_ATTACKER2);

% CREATE AN ARRAY OF REDUCED RESOURCE ALLOCATIONS MATRIX SIZES
num_of_strat_2 = [len_new_strat_2_attacker1(1) len_new_strat_2_attacker2(1) len_new_strat_2_defender(1)];

% EXECUTE THE GAME CALCULATION
[NASH_EQ_2,payoff_2,iterations_2,err_2] = NPG2(num_of_strat_2,REDUCED_GAME_COST_MATRIX_2);

game_2_time = clock;
game_2_time_seconds = etime(game_2_time,game_1_time);
game_2_time_minutes = floor(game_2_time_seconds/60)
game_2_time_seconds = rem(game_2_time_seconds,60)



%%%%%%%%%%%%%%%%%%%%%%
%% EVALUATE GAME #3 %%
%%%%%%%%%%%%%%%%%%%%%%
% CREATE THE DOMINATING STRATEGIES MATRICES FOR EACH PLAYER
DOM_STRAT_3_DEFENDER  = DominatingStrategies(GAME_COST_MATRIX_3, 'defender');
DOM_STRAT_3_ATTACKER1 = DominatingStrategies(GAME_COST_MATRIX_3, 'attacker1');
DOM_STRAT_3_ATTACKER2 = DominatingStrategies(GAME_COST_MATRIX_3, 'attacker2');

% REDUCE THE RESOURCE ALLOCATIONS MATRICES FOR EACH PLAYER (THROW AWAY DOMINATED STRATEGIES)
NEW_STRAT_3_DEFENDER  = ReducedMatrix(DOM_STRAT_3_DEFENDER,  RESOURCE_MATRIX_ARRAY_3, 'defender');
NEW_STRAT_3_ATTACKER1 = ReducedMatrix(DOM_STRAT_3_ATTACKER1, RESOURCE_MATRIX_ARRAY_3, 'attacker1');
NEW_STRAT_3_ATTACKER2 = ReducedMatrix(DOM_STRAT_3_ATTACKER2, RESOURCE_MATRIX_ARRAY_3, 'attacker2');

% CREATE AN ARRAY OF 2-D RESOURCE MATRICES (REDUCED)
REDUCED_RESOURCE_MATRIX_ARRAY_3 = {NEW_STRAT_3_ATTACKER1 NEW_STRAT_3_ATTACKER2 NEW_STRAT_3_DEFENDER};

% BUILD THE 2-D GAME COST MATRICES USING THE SETTINGS AND RESPECTIVE GAME REDUCED RESOURCE MATRIX ARRAY
REDUCED_GAME_COST_MATRIX_3 = GameBuild(1,num_cyber_nodes,REDUCED_RESOURCE_MATRIX_ARRAY_3,CONNECTIONS,COST,threshold);

% FIND THE SIZE OF EACH REDUCED RESOURCE ALLOCATIONS MATRIX FOR EACH PLAYER
len_new_strat_3_defender  = size(NEW_STRAT_3_DEFENDER);
len_new_strat_3_attacker1 = size(NEW_STRAT_3_ATTACKER1);
len_new_strat_3_attacker2 = size(NEW_STRAT_3_ATTACKER2);

% CREATE AN ARRAY OF REDUCED RESOURCE ALLOCATIONS MATRIX SIZES
num_of_strat_3 = [len_new_strat_3_attacker1(1) len_new_strat_3_attacker2(1) len_new_strat_3_defender(1)];

% EXECUTE THE GAME CALCULATION
[NASH_EQ_3,payoff_3,iterations_3,err_3] = NPG2(num_of_strat_3,REDUCED_GAME_COST_MATRIX_3);

game_3_time = clock;
game_3_time_seconds = etime(game_3_time,game_2_time);
game_3_time_minutes = floor(game_3_time_seconds/60)
game_3_time_seconds = rem(game_3_time_seconds,60)



%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GENERATE RESULTS PLOT %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOOKING INTO THE ORIGINAL FIGURE THAT WAS CREATED THE DATA BEING PLOTTED DOESN'T MAKE SENSE...
%   EACH GAME PAYOFF IS A ROW VECTOR OF PAYOFF AMOUNTS FOR EACH PLAYER [ATTACKER1, ATTACKER2, DEFENDER] @ THE NASH EQUILIBRIUM...
%   SO WHY WOULD YOU PLOT EACH GAME PAYOFF ROW VECTOR WITH THE DEFENDER'S AVAILABLE RESOURCES FOR EACH GAME?
%   THIS DOESN'T MAKE MUCH SENSE SO CREATE DIFFERENT FIGURES THAT SHOW THE DATA IN A LOGICAL MANNER...
% figure;
% plot(defender,payoff_1,'-+r');
% hold on
% plot(defender,payoff_2,':*g')
% plot(defender,payoff_3,'-.xk')
% % legend('Payoff Player 1','Payoff Player 2','Payoff Defender')
% title('Defender resources vs value of game')
% xlabel('Defender resources')
% ylabel('Value of n-person game')
% hold off

figure1 = figure;
  fig1_x_axis = categorical({'Game 1', 'Game 2', 'Game 3'});
  fig1_x_axis = reordercats(fig1_x_axis,{'Game 1', 'Game 2', 'Game 3'});

  subplot(2,1,1);
    fig1_bar1 = bar(fig1_x_axis,[RESOURCES(1,:); RESOURCES(2,:); RESOURCES(3,:)]);
    legend({'Attacker 1','Attacker 2','Defender'},'Location','bestoutside');
    title('Player Available Resources Per Game');
    ylabel('Available Resources');
    fig1_bar1_y_axis_min = 0;
    fig1_bar1_y_axis_max = max(unique(RESOURCES)) + 1;
    ylim([fig1_bar1_y_axis_min fig1_bar1_y_axis_max]);
    grid on;
    box on;

  subplot(2,1,2);
    fig1_bar2 = bar(fig1_x_axis,[payoff_1; payoff_2; payoff_3]);
    legend({'Attacker 1','Attacker 2','Defender'},'Location','bestoutside');
    title('Player Payoff @ Nash Equilibrium');
    ylabel('Payoff');
    fig1_bar2_y_axis_min = 0;
    fig1_bar2_y_axis_max = max(unique([payoff_1; payoff_2; payoff_3])) * 1.1;
    ylim([fig1_bar2_y_axis_min fig1_bar2_y_axis_max]);
    grid on;
    box on;

figure2 = figure;
  fig2_bar1_x_axis = categorical({'Game 1', 'Game 2', 'Game 3'});
  fig2_bar1_x_axis = reordercats(fig2_bar1_x_axis,{'Game 1', 'Game 2', 'Game 3'});
  fig2_bar1 = bar(fig2_bar1_x_axis,[etime(game_1_time,config_time); etime(game_2_time,game_1_time); etime(game_3_time,game_2_time)]);
  title('Elapsed Time Per Game');
  ylabel('Time (Seconds)');
  grid on;
  box on;



%%%%%%%%%%%%%%%%%%%%%%%
%% STOP ELAPSED TIME %%
%%%%%%%%%%%%%%%%%%%%%%%
stop_time = clock;
elapsed_seconds = etime(stop_time,start_time);
elapsed_minutes = floor(elapsed_seconds/60)
elapsed_seconds = rem(elapsed_seconds,60)


