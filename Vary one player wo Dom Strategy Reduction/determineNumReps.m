function [reps] = determineNumReps(repetitions,lenRowVect)
    
    % determine number of reps, make sure that this is less
    % than or equal to the player with the smallest number of available
    % strategies. If the repetitions variable is too big, update it to the
    % max
    
    reps = repetitions;
    if repetitions > min(lenRowVect)
        reps = min(lenRowVect);
    end
    
end