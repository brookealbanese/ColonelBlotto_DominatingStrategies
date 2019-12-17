function [mixedEq,payoff,iterations,error] = findSomeBestResponseStrategies(num_cyber_nodes,CONNECTIONS,COST,threshold,RESOURCE_MATRIX_ARRAY,forPlayer,repetitions)
    % Goal is to hold strategies for PX and PY constant, compute the best
    % response for PZ, update PX and PY strategies, and repeat N times for
    % some N
    
    % if forPlayer = 1, hold A2 and D constant- computation for A1
    % if forPlayer = 2, hold A1 and D constant- computation for A2
    % if forPlayer = 3, hold A1 and A2 constant- computation for D
    
    % 1. determine the maximum number of repetitions
    % 2. generate 2 (num players-1) randi vector 'repetitions' corresponding to the
    % constant strategies that will be used for each player in the loop.
    % Obviously if repetitions == maxReps, all strategies will be used and
    % this won't be necessary.
    %%%% START LOOP
    % 3. create a dummy matrix with 1 strategy for each player being held
    % constant and the full strategy set for the player corresponding to
    % 'forPlayer'
    % 4. build the game cost matrix for ONLY mode 1
    % 5. find number of strategies (vector) being used for each player,i.e. 1,1,rows
    % of 'forPlayer' resource matrix array
    % 6. solve nash for num strategies vector and dummy matrix
    % 7. add npg2 output eq (mixed stategies) to the end of the output matrix,
    % likewise for the npg2 output payoffs, etc.
    %%%% LOOP
    
    mixedEq = [];
    payoff = [];
    iterations = [];
    error = [];
    
    RESOURCE_MATRIX_ATTACKER1 = RESOURCE_MATRIX_ARRAY{1};
    RESOURCE_MATRIX_ATTACKER2 = RESOURCE_MATRIX_ARRAY{2};
    RESOURCE_MATRIX_DEFENDER  = RESOURCE_MATRIX_ARRAY{3};

    [a1_rows,~] = size(RESOURCE_MATRIX_ATTACKER1);
    [a2_rows,~] = size(RESOURCE_MATRIX_ATTACKER2);
    [d_rows,~] = size(RESOURCE_MATRIX_DEFENDER);
    
    lenRowVect = findMinNumStrats(a1_rows,a2_rows,d_rows,forPlayer);
    [reps] = determineNumReps(repetitions,lenRowVect);
    [loopStrat1,loopStrat2] = generateStratsToPick(a1_rows,a2_rows,d_rows,reps,forPlayer);
    
    
    for r = 1:reps
        [tempResourceMatrix,a1StratLen,a2StratLen,a3StratLen] = buildNewResourceMatrix(loopStrat1(r),loopStrat2(r),RESOURCE_MATRIX_ARRAY,forPlayer);
        numStrategies = [a1StratLen a2StratLen a3StratLen];
        gameCostMatMode1 = GameBuild(1,num_cyber_nodes,tempResourceMatrix,CONNECTIONS,COST,threshold);
        [nash,pay,iters,errs] = NPG2(numStrategies,gameCostMatMode1);
        
        mixedEq = [mixedEq; nash];
        payoff = [payoff; pay];
        iterations = [iterations; iters];
        error = [error; errs];
    end
        
end