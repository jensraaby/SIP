function equalised = histogram_equalise( image )
%HISTOGRAM_EQUALISE Equalises the histogram of IMAGE

    [M N] = size(image);
    h = imhist(image);
    n = numel(image);

    im_vec = reshape(image,1,n);

    % Build the cumulative distribution of intensity hists
    cumulative = zeros(1,length(h));
    cumulative(1) = h(1);
    for j = 2:length(h)
        cumulative(j) = cumulative(j-1) + h(j);
    end

    % Build the equalised image vector
    eq_vec = (zeros(size(im_vec)));
    for i=1:n
       eq_vec(i) = cumulative(im_vec(i))/n; 
    end

    equalised = reshape(eq_vec,M,N);

end

