%Stand-alone encryption to test the timing
%TESTED:WORKING || The AES encryption process
% input:    pt = plain text
%           key = they encryption key
%           ptType and keyType = type of input: 'hex' or 'dec'
%           keyLen = the length of the key: '128', '192', '256'    
% output:   ct = the cipher text
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;clc;

%LIST OF THE DATA SETS USED IN DEVELOPING AND TESTING THIS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Test data 'xxx_01.mat' taken from
%   'Cryptography and Network Security, 5th ed', William Stallings. p 169-173
%Test data 'xxx_03.mat' taken from
%   https://kavaliro.com/wp-content/uploads/2014/03/AES.pdf
%Test data 'xxx_04.mat' taken from
%   https://www.hanewin.net/encrypt/aes/aes-test.htm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('AES_Test_128_01.mat')
% load('AES_Test_128_03.mat')     %<-- There is a reson for this. 
% load('AES_Test_128_04.mat')
% load('AES_Test_128_AE_a.mat')
% load('AES_Test_128_AE_b.mat')
% load('AES_Test_192_04.mat')
% load('AES_Test_192_AE_a.mat')
% load('AES_Test_192_AE_b.mat')
% load('AES_Test_256_04.mat')
% load('AES_Test_256_AE_a.mat')
% load('AES_Test_256_AE_b.mat')

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
%Format so it works nicely going into the decryption routine.
ct  = hex2dec(ct);
ctType = 'non';
%Save the plaintext input to compare with the decrypted version
pt_in = pt;
save('AES_ciphertext_out','ct', 'ctType','key','keyLen','keyType','pt_in');


%Output the initial plaintext, ciphertext, and key used to the screen in
%hex in a string format for cut/paste into reports.
ct = reshape(num2str(dec2hex(ct)),1,[]);
disp(append('Input Plaintext:   ',string(pt)))
disp(append('output ciphertext: ',string(ct)));
disp(append('key:               ',string(key)));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ECE 6357 Cybersecurity, University of Houston 
% Spring 2021, class project
% Created by: K.M.Patrick Krueger
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%