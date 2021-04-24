function pt = AES_decrypt(ct, key, ctType, keyType, keyLen)
%TESTED: WORKING || The AES decryption process
% input:    ct = cipher text
%           key = they encryption key
%           ctType and keyType = type of input: 'hex' or 'dec'
%           keyLen = the length of the key: '128', '192', '256'    
% output:   pt = the deciphered plain text
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pt =[];

%Build keys for all rounds in hex and return the number of encryption rounds
[keysCreated, crypRnd] = AES_keyBuild(key,keyType,keyLen);
%Reorder the keys so they are in the reverse of the order calculated, as
%neeed for the decryption rounds.
keysX = AES_reorderKeys(keysCreated);

%Format the input message to 16 2 digit hex segments and get the number of 
%those segments ('SzX') in the array ('msgX').
[msgX, szX] = AES_format(ct,ctType);

%Decrypting the message in segments of 16 2byte hex values using the same,
%or similar processes as the encryption just a slightly different order.
%Differnt values are used as the output of each function to make it easier 
%to troubleshoot if necessary.
for XBlock = 1:szX
        rndKeyOut = AES_keyAdd(msgX(:,XBlock),keysX(:,1));
        shiftRowOut = AES_shftRow(rndKeyOut, 'decrypt');
        byteSubOut = AES_byteSub(shiftRowOut, 'decrypt');
        
    for rnd = 2:crypRnd
        rndKeyOut = AES_keyAdd(byteSubOut,keysX(:,rnd));
        mixColumnOut = AES_mixCol(rndKeyOut, 'decrypt');
        shiftRowOut = AES_shftRow(mixColumnOut, 'decrypt');
        byteSubOut = AES_byteSub(shiftRowOut, 'decrypt');
    end
    rndKeyOut = AES_keyAdd(byteSubOut, keysX(:,crypRnd+1));
end


pt = [pt rndKeyOut];
   


end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ECE 6357 Cybersecurity, University of Houston 
% Spring 2021, class project
% Created by: K.M.Patrick Krueger
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%