function [picks1,picks2] = generateStratsToPick(a1r,a2r,dr,reps,player)
    
    % generate 2 (num players-1) sorted randi vector 'repetitions' corresponding to the
    % constant strategies that will be used for each player in the loop.
    % If repetitions == maxReps, all strategies will be used 
    
    % It is possible the way this is set up that if reps=rows, we use some
    % rows multiple times instead of every row once
    if player == 1
        picks1 = sort(randi(a2r,1,reps));
        picks2 = sort(randi(dr,1,reps));
    elseif player == 2
        picks1 = sort(randi(a1r,1,reps));
        picks2 = sort(randi(dr,1,reps)); 
    else
        picks1 = sort(randi(a1r,1,reps));
        picks2 = sort(randi(a2r,1,reps));
    end
    
end