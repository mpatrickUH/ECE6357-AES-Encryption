function keyOut = AES_reorderKeys(keys)
%TESTED:WORKING || Reversethe key order to make decryption easier
% input:    keys = the keys that have been recursively calculated
% output:   keyOut = the keys in reverse order to use in decryption
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
keyOut = [];
keys = hex2dec(keys);

rnds = size(keys,2);
col = rnds + 1;

for i = 1:rnds
    keyOut(:,col-i) = keys(:,i);
end
keyOut = string(dec2hex(keyOut));
keyOut = reshape(keyOut,16,[]);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ECE 6357 Cybersecurity, University of Houston 
% Spring 2021, class project
% Created by: K.M.Patrick Krueger
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
