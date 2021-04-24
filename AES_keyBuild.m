function [keysX,crypRnd] = AES_keyBuild(key,type,keyLen)
%TESTED: WORKING || This function creates the encryption key for each 
% round of encryption based on the key size and returns the set of keys and 
% the number of rounds needed for each block based on key size.
% Input:    key = the encryption key
%           type = the type of encryption key: 'hex' or 'dec'
%           keyLen = the length of the key: '128','192','256'
% Output:   keysX = the array of 16 row keys in 2 hex characters.
%           crypRnd = the number of rounds based on key size
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%the Round Coefficients
RC = [0x01; 0x02; 0x04; 0x08; 0x10; 0x20; 0x40; 0x80; 0x1B; 0x36];   
keysX = []; 


% Define specifications for 128/196/256 bit keys
if keyLen == '128'
    col = 4; rnds = 11; iRC = 10; bkLim = 44; 
end
if  keyLen == '192'
     col = 6; rnds = 13; iRC = 8; bkLim = 52; 
end
if keyLen == '256'
     col = 8; rnds = 15; iRC = 7; bkLim = 60; 
end

%Return the value # of rounds needed in the main routine
crypRnd = rnds - 1;             

%Convert the given key into 2byte hex blocks 
key_work = AES_to2Byte(key,type);

% Create a 4x4/4x6/4x8 matrix the write it as the first key value
key4 = reshape(key_work,4,[]);
keyStore = key4;

%Do the shifts and xors to build the key values for all the Round Coefficients
for i = 1:iRC
 for c = 1:col
   if c == 1
     %create the 'g' function to xor with the first 
       g = [AES_sBox(key4(2,col),'encrypt'); AES_sBox(key4(3,col),'encrypt'); ...
            AES_sBox(key4(4,col),'encrypt'); AES_sBox(key4(1,col),'encrypt') ];
       %Convert the values used to decimal to simplify the xor operations
       g = hex2dec(g);
       g(1) = bitxor(g(1),RC(i));   %xor the first value with the Round Coefficient RC
       k1 = hex2dec(key4(:,1));     %Take the 1st row in keys, convert to dec for xor
	   %bitxor the first column of the keys with they g fxn to generate the new 1st column 
       newCol = [bitxor(k1(1,1),g(1,1));bitxor(k1(2,1),g(2,1)); ...
                 bitxor(k1(3,1),g(3,1));bitxor(k1(4,1),g(4,1))];
   elseif  and(c == 5, keyLen == '256')
       %create the 'h' function needed for column 4 (5 in MATLAB) when
       %key is '256' bits long
       h = [AES_sBox(key4(1,4),'encrypt');AES_sBox(key4(2,4),'encrypt'); ...
            AES_sBox(key4(3,4),'encrypt');AES_sBox(key4(4,4),'encrypt')];
       %Convert the values used to decimal to simplify the xor operation
       h = hex2dec(h);
       k1 = hex2dec(key4(:,5));
       %bitxor the 3rd column (4th in MATLAB) of keys with the next column
       %to generate the new 4th column (5th in MATLAB).
       newCol = [bitxor(k1(1,1),h(1,1));bitxor(k1(2,1),h(2,1)); ...
                 bitxor(k1(3,1),h(3,1));bitxor(k1(4,1),h(4,1))];
   else
       %bitxor all the other rows with the row preceeding it
       k1 = hex2dec(key4(:,c-1));
       k2 = hex2dec(key4(:,c));
       newCol = [bitxor(k1(1,1),k2(1,1));bitxor(k1(2,1),k2(2,1)); ...
                 bitxor(k1(3,1),k2(3,1));bitxor(k1(4,1),k2(4,1))];
           
   end
   %New word has been create as newCol. Now must be inserted into final
   %saved output but also in a usable format for the next round.
   key4(:,c) = dec2hex(newCol);  %updates colunms to be used in future calc.
   keyStore = [keyStore reshape(string(dec2hex(newCol)),4,1)];
   
  end
 end
%Take the final keyStore output with the 4 row array of 2digit hex keys and
%shorten it to only those required (as defined by 'bkLim') for the
%encryption.
keyStore = keyStore(:,1:bkLim);
keysX = reshape(keyStore,16,[]);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ECE 6357 Cybersecurity, University of Houston 
% Spring 2021, class project
% Created by: K.M.Patrick Krueger
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

