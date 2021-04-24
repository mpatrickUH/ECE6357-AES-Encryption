clear all;clc;
% The AES encryption/decryption implementation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   pt = plain text message to decrypt
%   ptType = how plain text message is entered: 'hex' or 'dec'
%   key = key to use for encryption
%   keyLen = length of the key: '128', '192', '256'
%   keyType = 'hex' or 'dec'
%   ct = ciphertext
%   ctType = how ciphertext is given: 'hex' or 'dec'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Each of the functions has a detailed explaination in the comments.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Keys used in testing the code = currently implemented to do immediate
%encrypt/decrypt, may need minor tweeking if want to do decrypt alone.
%Change 'non' to ctType.

%LIST OF THE DATA SETS USED IN DEVELOPING AND TESTING THIS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Test data 'xxx_01.mat' taken from
%   'Cryptography and Network Security, 5th ed', William Stallings. p 169-173
%Test data 'xxx_03.mat' taken from
%   https://kavaliro.com/wp-content/uploads/2014/03/AES.pdf
%Test data 'xxx_04.mat' taken from
%   https://www.hanewin.net/encrypt/aes/aes-test.htm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load('AES_Test_128_01.mat')
% load('AES_Test_128_03.mat')     %<-- There is a reson for this. 
% load('AES_Test_128_04.mat')
% load('AES_Test_128_AE_a.mat')
% load('AES_Test_128_AE_b.mat')
load('AES_Test_192_04.mat')
% load('AES_Test_192_AE_a.mat')
% load('AES_Test_192_AE_b.mat')
% load('AES_Test_256_04.mat')
% load('AES_Test_256_AE_a.mat')
% load('AES_Test_256_AE_b.mat')


%Begin the encryption
[ciphertext] = AES_encrypt(pt,key,ptType,keyType,keyLen);

%Take the output of the encryption and convert it to a decimal number so it
%will format correctly during 'AES_format.m' and 'AES_to2Byte.m'. Otherwise
%it messes things up.
ctext  = hex2dec(ciphertext);

%Begin the decryption
[plain_out] = AES_decrypt(ctext,key,'non',keyType,keyLen);

%put the priginal plaintext entered at the start into 2byte format so it
%will be displayed in the same way as the calculated values.
% pt_in = AES_to2Byte(pt,ptType);

%Display the final results: 
%  input plaintext | ciphertext | recovered plaintext
% FinalOut = [pt_in ciphertext plain_out]

%Put these in the right format to output to the screen:
%ct is a decimal so needs to be converted to hex, then made into a string,
%then put into a 1 line output.
%pt is a 2 digit hex string column. It needs to be reshaped first so it doesn't 
%put out the first column, then the second column and mess up the plaintext
%after all this work. Then tun it from cell to a matrix, then a from a
%number to a string.
ct_disp = reshape(num2str(dec2hex(ctext)),1,[]);
pt_in = reshape(num2str(dec2hex(pt)),1,[]);
pt_out = num2str(cell2mat(reshape(plain_out,1,[])));

% %Calculate the avalance effect 
a = ctext;
b = hex2dec(reshape(pt,2,[])');
c = str2num(keyLen);
AE = 100* nnz(reshape(dec2bin(bitxor(a,b)),1,[]))/c;


disp(append('Input Plaintext:    ',string(pt)));
disp(append('Output ciphertext:  ',string(ct_disp)));
disp(append('Returned Plaintext: ',string(pt_out)));
disp(append('Key:                ',string(key)));

disp('---------    ')
disp(append('Avalanche Effect:   ',string(AE),'%'))



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ECE 6357 Cybersecurity, University of Houston 
% Spring 2021, class project
% Created by: K.M.Patrick Krueger
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



 
