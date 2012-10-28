function s = reduce(p)
    s = cell(length(p),1);
    for i=1:length(p)
        s{i} = i;
    end
    
    while numel(s) > 2