function [out]=runLengthCode(in,toDo)
% Run Length Coding
% This is a special application of run length coding 
% optimized for images. the general structure is
% [out]=runLengthCode(in,toDo)
% toDo paramater optional since v3   
% when in is image file todo is 'e' for encode
% when in is run code todo is 'd' for decode
% The code auto detects the mode
% Even larger binary 1-D signals can be encoded just specify 'e' 
% 
% Encoding :
%     The encoding scheme for images used is 
%     [img_size(1) img_size(2) encode_version first_bit optimized_run_code.......]
%         
% Decoding :
%     Use same version encoded file for better compatibility.
%     Program auto checks for version number.
%  

% Auto detection of mode
if nargin==1
    if (in(1)*in(2)>1)
        toDo='d';
    else 
        toDo='e';
    end
end

% Encoding and Decoding
switch toDo
    
    case 'e'
% Convert input image to binary 
        in=im2bw(in);
        a=in(1,1);
        b=0;
        c=5;
% Define first four characteristic values
        out(1:4)=[size(in),4,a];
% Encode
        for i=1:size(in,1)
            for j=1:size(in,2)
                if (in(i,j)==a)
                    b=b+1;
                else
                    out(c)=b;
                    a=in(i,j);
                    b=1;
                    c=c+1;
                end
            end
        end
        out(c)=b;
        
    case 'd'
        a=1;
        b=0;
        c=in(4);
% Check Version number
        if (in(3)~=4) error('Vresion number incorrect.'); end
% Preassign matrix for speed
        out=zeros(in(1:2));
        for i=5:length(in)
            for j=1:in(i)
                b=b+1;
                out(a,b)=c;
                if b==in(2)
                    a=a+1;
                    b=0;
                end
            end
            c=imcomplement(c);
        end
        out=im2bw(out);
    otherwise
end

end