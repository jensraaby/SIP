% Jens Raaby, SIP Ex 5.3
function [T1,thresholded] = doublethreshold(img,epsilon)
    [M, N] = size(img);
    
    
    % Determine iteratively the initial threshold
      
    % 1 Start with T = mean gray value of image.
    % 2 Partition the image into R1 and R2 according to T
    % 3 Compute mean values ?1 and ?2 of R1 and R2
    % 4 Select new T = 1/2(mu1 + mu2).
    % 5 Repeat steps 2-4 until convergence.

%     vec = reshape(img,1,numel(img));
%     T_prev = mean(vec);
%     T1 = max(vec);
%     while T1 ~= T_prev
%         T_prev = T1;
%         mu_1 = mean(vec(vec<T1));
%         mu_2 = mean(vec(vec>=T1));
%         T1 = 0.5 * (mu_1 + mu_2);
%     end
    
    % otsu method
    T1 = graythresh(img)


    %----------- Double thresholding----------------------
    % Compute Regions R1 , R2 , R3 :
    %  a) R1: pixels with gray value <= T1
    %  b) R2: pixels with gray value between T1 and T2 
    %  c) R3: pixels with gray value above T2
    % 3 Visit each pixel of R2 : if it has a neighbor in R1 , reassign to R1 .
    % 4 repeat previous step until no pixel of R2 is reassigned.
    % 5 assign all remaining pixels of R2 to R3.

    T2 = T1 + epsilon;

    R1 = find(img<=T1);
    R2 = find(T1<img & img<=T2);
    R3 = find(img>T2);

    % Assign pixels
    thresholded = zeros(size(img));
    thresholded(R1) = 0;
    thresholded(R2) = 0.5;
    thresholded(R3) = 1;

    % find the minimum of the neighbourhood using a simple filter
    %   if the minimum is 0, then one neighbour is in R1
    R1neighbours = colfilt(thresholded,[3 3],'sliding',@min);
    
    r2tmp = 1; %initial parameter value
    
    % Optimisation loop to reassign R2 pixels which neighbour R1 pixels
    while length(R2) ~= r2tmp
    
        r2tmp = length(R2);

        for k = 1:length(R2) % loop through all R2 pixels until we run out
            if k<=length(R2)
                if(R1neighbours(k) == 0)
                    R1 = [R1;R2(k)];    % push k index onto R1
                    R2(k) = [];         % pop k index off R2
                end

            else
                break 
                % once we have removed more items than there used to be, exit loop
            end

        end
        % update neighbourhoods
        thresholded(R1) = 0;
        thresholded(R2) = 0.5;
        R1neighbours = colfilt(thresholded,[3 3],'sliding',@min);
    
    end

    % assign remaining pixels of R2 to R3
    R3 = [R3; R2];

    thresholded = zeros(size(img));
    thresholded(R1) = 0;
    thresholded(R3) = 1;
   

