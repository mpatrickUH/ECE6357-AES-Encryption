function keyAdd = AES_keyAdd(msgX,key)
%TESTED: WORKING || Key Addition layer of AES 
% This part is simply bitxoring the key with the mssage and sending it
% along to the next phase in the mutation of the message.
% input:    msgX = whatever message needs to be mixed with the key
%           key = whatever key needs to be mixed with the message
% output:   keyAdd = the key added (bitxor'ed) to the message (shocker)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

keyAdd= [];

msgX = hex2dec(msgX);
key =  hex2dec(key);
for i = 1:16
    src = bitxor(msgX(i),key(i));
   keyAdd = [keyAdd; string(dec2hex(src,2))];
end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ECE 6357 Cybersecurity, University of Houston 
% Spring 2021, class project
% Created by: K.M.Patrick Krueger
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


