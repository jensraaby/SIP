function matched = histogram_match( image, histogram )
%HISTOGRAM_MATCH Matches the histogram of the supplied IMAGE to the
%HISTOGRAM

     [M N] = size(image);
    
    n = numel(image);
    
    % normalise supplied histograms (sum to 1)
    h = imhist(image);
    h = h./sum(h);
    h_s = length(h);
    h2 = histogram;
    h2 = h2/sum(h2);
    h2_s = length(h2);
        
    % Build the cumulative distribution of image histogram and new histogram
    cumulative = zeros(1,h_s);
    cumulative_new = zeros(1,h2_s);

    cumulative(1) = h(1);
    cumulative_new(1) = h2(1);
    for j = 2:h_s
        cumulative(j) = cumulative(j-1) + h(j);
        cumulative_new(j) = cumulative_new(j-1) + h2(j);
    end
    
    % Find the indices in the specimen histogram which are closest to the
    % values in the original histogram
    lookup = zeros(h_s+1);
    j = 1; % j is indexed from 1-256, 
    %         - 0 is possible but matlab indices must start at 1
    for i=1:256
        if (cumulative(i) <= cumulative_new(j))
            lookup(i)=j;
        else
            while j<=255 && (cumulative(i) > cumulative_new(j)) 
                j=j+1;
            end
            if (cumulative_new(j) - cumulative(i)) > (cumulative(i) - cumulative_new(j-1))
                j = j-1;
                lookup(i) = j;
            else
                lookup(i) = j;
            end
        end
    end
    
    % process the pixels of the original image as a vector
    im_vec = reshape(image,1,n);
    t_vec = zeros(size(im_vec));
    for k=1:n
        t_vec(k) = lookup(im_vec(k)+1); % plus one because 0 is min. val
    end
    % ensure the returned image is in integer form:
    matched = cast(reshape(t_vec,M,N),'uint8');
end

