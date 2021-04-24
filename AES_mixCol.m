function mixOut = AES_mixCol(input, crypt)
%TESTING:WORKING || Mix Columns - do a matrix multiplication with using a
% bitwise 'xor' instead of a '+' in combing the values.
% input:    input = whatever the message to be mixed is
%           crypt = whether it's an 'encryption' or 'decryption'
% output:   mixOut = the result after performing the operations
% supported by the function: AES_gFxn.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x = reshape(hex2dec(input),4,[]);
if crypt == 'encrypt'
cpt = [02, 03, 01, 01; ...
       01, 02, 03, 01; ...
       01, 01, 02, 03; ...
       03, 01, 01, 02];
end
if crypt =='decrypt'
cpt =[14, 11, 13, 09; ...
      09, 14, 11, 13; ...
      13, 09, 14, 11; ...
      11, 13, 09, 14];
end


for row = 1:4
    for column = 1:4
        a = AES_gFxn(cpt(row,1),x(1,column));
        b = AES_gFxn(cpt(row,2),x(2,column));
        c = AES_gFxn(cpt(row,3),x(3,column));
        d = AES_gFxn(cpt(row,4),x(4,column));
        y(row,column) = bitxor(bitxor(bitxor(a,b),c),d);
        
    end
end
mixOut = string(dec2hex(y));
mixOut = reshape(mixOut,16,1);


end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ECE 6357 Cybersecurity, University of Houston 
% Spring 2021, class project
% Created by: K.M.Patrick Krueger
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



















