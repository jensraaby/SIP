function makecode(sc,codeword)
global CODE
    if isa(sc,'cell')
        makecode(sc{1}, [codeword 0]);
        makecode(sc{2}, [codeword 1]);
    else
        CODE{sc} = char('0' + codeword);
    end
end
% 
% function codednode = codenode(node,codeword,initialnode)
%     if isa(node,'cell')
%         left_node = codenode(node{1},[codeword 0]);
%         right_node = codenode(node{2},[codeword 1]);
%     else
%         codednode = char('0' + codeword);
%     end
% 
% function coded = code(tree,codeword)
%     coded_left = codenode(tree,codeword,tree{1});
%     coded_right = codenode(tree,codeword,tree{2});
%     
%     coded = 
% 
% % Less ugly representation
% 
% function newcode = codeit1(sc,codeword,result)
%     if isa(sc,'cell')
%         left = codeit1(sc{1},[codeword 0],result);
%         right = codeit1(sc{2},[codeword 1],result);
%         newcode = result(sc)
%     else
%         result( = char('0' + codeword);
%     end
