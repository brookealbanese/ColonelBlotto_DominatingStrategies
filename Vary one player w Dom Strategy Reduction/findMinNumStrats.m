function lenRowVect = findMinNumStrats(a1r,a2r,dr,player)

    % find the min number of strategies for the players that are being held
    % constant. We will use the entire strategy set for 'forPlayer' so we 
    % we don't care about that here.
    
    if player == 1
        lenRowVect = [a2r dr];
    elseif player == 2
        lenRowVect = [a1r dr];
    else
        lenRowVect = [a1r a2r];
    end

end
