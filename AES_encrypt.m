function ct = AES_encrypt(pt, key, ptType, keyType, keyLen)
%TESTED:WORKING || The AES encryption process
% input:    pt = plain text
%           key = they encryption key
%           ptType and keyType = type of input: 'hex' or 'dec'
%           keyLen = the length of the key: '128', '192', '256'    
% output:   ct = the cipher text
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ct =[];

%Build keys for all rounds in hex and return the number of encryption rounds
[keysX, crypRnd] = AES_keyBuild(key,keyType,keyLen);

%Format the input message to 16 2 digit hex segments and get the number of 
%those segments ('SzX') in the array ('msgX').
[msgX, szX] = AES_format(pt,ptType);

%Encrypting the message in segments of 16 2byte hex values. Each function
%has a detailed writeup of what it does inside of that function. They all
%have uniq output value names to make debugging easier but they could all
%be the same.
for XBlock = 1:szX
    rndKeyOut = AES_keyAdd(msgX(:,XBlock),keysX(:,1));

    for rnd = 2:crypRnd
        byteSubOut = AES_byteSub(rndKeyOut, 'encrypt');
        shiftRowOut = AES_shftRow(byteSubOut, 'encrypt');
        mixColumnOut = AES_mixCol(shiftRowOut, 'encrypt');
        rndKeyOut = AES_keyAdd(mixColumnOut,keysX(:,rnd));
    end
    
    byteSubOut = AES_byteSub(rndKeyOut, 'encrypt');
    shiftRowOut = AES_shftRow(byteSubOut, 'encrypt');
    rndKeyOut = AES_keyAdd(shiftRowOut, keysX(:,crypRnd+1));
end

ct = [ct rndKeyOut];
   
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ECE 6357 Cybersecurity, University of Houston 
% Spring 2021, class project
% Created by: K.M.Patrick Krueger
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%