%Stand-alone encryption to test the timing
%TESTED: WORKING || The AES decryption process
% input:    ct = cipher text
%           key = they encryption key
%           ctType and keyType = type of input: 'hex' or 'dec'
%           keyLen = the length of the key: '128', '192', '256'    
% output:   pt = the deciphered plain text
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;clc;
load('AES_ciphertext_out.mat');  %<-- load what was stored during encryption

pt_out =[];
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

pt_out = [pt_out rndKeyOut];




%Put these in the right format to output to the screen:
%ct is a decimal so needs to be converted to hex, then made into a string,
%then put into a 1 line output.
%pt is a 2 digit hex string column. It needs to be reshaped first so it doesn't 
%put out the first column, then the second column and mess up the plaintext
%after all this work. Then tun it from cell to a matrix, then a from a
%number to a string.
ct = reshape(num2str(dec2hex(ct)),1,[]);
pt_out1 = num2str(cell2mat(reshape(pt_out,1,[])));

disp(append('Input Plaintext:    ',string(pt_in)));
disp(append('Output ciphertext:  ',string(ct)));
disp(append('Returned Plaintext: ',string(pt_out1)));
disp(append('Key:                ',string(key)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ECE 6357 Cybersecurity, University of Houston 
% Spring 2021, class project
% Created by: K.M.Patrick Krueger
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%