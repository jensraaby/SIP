% generate the histogram
img = imread('lena.bmp');
[W, H] = size(img);
I = imhist(img);

% normalise the probabilities
I_norm = I/sum(I);

probabilities = I_norm;
% huffman 


% find out how many symbols we need
zeroed = find(probabilities==0);
num_symbols = 256 - length(zeroed);

% get the interesting elements
interesting = find(probabilities ~= 0);

% sort from lowest probability to highest
[sorted_p,idx] = sort(probabilities(interesting),'ascend');

% check that no info has been lost yet!
if (W*H) ~= sum(sorted_p * sum(I))
    error('we lost information already. crazy');
end

% reduce the tree of probabilities
p = sorted_p;
s = cell(length(p),1);
    for i=1:length(p)
        s{i} = i;
    end
    
    while numel(s) > 2
        [p,i] = sort(p);
        p(2) = p(1) + p(2)
        p(1) = [];
        
        % reordered tree:
        s = s(i);
        s{2} = {s{1},s{2}};
        s(1) = [];
    end
   
    CODE = cell(length(p),1);
    global CODE;
    
    sc = s;
    makecode(sc,[]);
    
    x = img(:)';
    minx = min(x(:));
 compressed = CODE(x(:) - minx + 1);