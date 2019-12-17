function [resourceMatrix,len1,len2,len3] = buildNewResourceMatrix(strat1_in,strat2_in,RESOURCE_MATRIX_ARRAY,player)
    
    % create a temporary matrix for holding PX and PY constant at strat1_in
    % and strat2_in, respectively, of the original RESOURCE_MATRIX_ARRAY.
    % Include the full player set for PZ, the none constant player

    if player == 1
        resourceMatrix{1} = RESOURCE_MATRIX_ARRAY{1};
        resourceMatrix{2} = RESOURCE_MATRIX_ARRAY{2}(strat1_in,:);
        resourceMatrix{3} = RESOURCE_MATRIX_ARRAY{3}(strat2_in,:);
    elseif player == 2
        resourceMatrix{1} = RESOURCE_MATRIX_ARRAY{1}(strat1_in,:);
        resourceMatrix{2} = RESOURCE_MATRIX_ARRAY{2};
        resourceMatrix{3} = RESOURCE_MATRIX_ARRAY{3}(strat2_in,:);
    else
        resourceMatrix{1} = RESOURCE_MATRIX_ARRAY{1}(strat1_in,:);
        resourceMatrix{2} = RESOURCE_MATRIX_ARRAY{2}(strat2_in,:);
        resourceMatrix{3} = RESOURCE_MATRIX_ARRAY{3};
    end
    
    [len1,~] = size(resourceMatrix{1});
    [len2,~] = size(resourceMatrix{2});
    [len3,~] = size(resourceMatrix{3});


end