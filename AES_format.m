function [hexOut,SzX] = AES_format(input,type)
%TESTED: WORKING || Puts the data into 16 row arrays of 2 digit hex values.
% Starts off by putting data into 2 digit hex bytes based on if the data is
% given in hex or decimal values. Then backfill it until it is a length that
% is a multiple of 16. And finally, reshape the array into a 16 row x N
% column array and find the value of N.
%
% Input:    txt = plaintext/cipher text to be reformatted
%           type_in = what type of data being input, either 'hex' or 'dec'
% Output:   txtX = the input text in 2 digit hex arranged in a 16 row array
%           SzX = the number of columns in 'hexOut'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

txtX = [];
hexOut = [];

%Put the plain text input into 2 digit hex segments
txtX = AES_to2Byte(input,type);

%Load the hex message into the output variable 'hexOut'
hexOut = txtX;

%If the message length is not a multiple of 16, fill it with 00s until it is.
if length(txtX) <= 16             %If the message is less that 16, fill it in
    for i = 1:16-length(txtX)
        hexOut = [hexOut;'00'];
    end
elseif mod(length(hexOut),16) ~= 0  %If the message is longer than 16 but not a multiple.
    hexOut = txtX;
    for i = 1:16-mod(length(txtX),16)
        hexOut = [hexOut;'00'];     %    fill it with zeros until it is.
    end
end
%reshape the array into 16 rows by whatever number of columns are necessary.
hexOut = reshape(string(hexOut),16,[]);
SzX = size(hexOut,2);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ECE 6357 Cybersecurity, University of Houston 
% Spring 2021, class project
% Created by: K.M.Patrick Krueger
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



