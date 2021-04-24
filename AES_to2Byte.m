function txtOut = AES_to2Byte(txt,type)
%TESTED:WORKING || Convert a string input into a 2 digit char array
%Then convert the in to the needed 2 byte hex strings. 
%input:     txt = input value to be converted to a character array
%output:    txtOut = the output 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

txtOut = [];
if type == 'hex'
    for i = 1:length(txt)/2
        str = string([char(txt(i*2-1)) char(txt(i*2))]);
        txtOut = [txtOut; str];
    end
elseif type == 'dec'
    for i = 1:length(txt)
        src = string(dec2hex(char(txt(i))));
        txtOut = [txtOut; src];
    end
elseif type == 'non'
    txtOut = [txtOut string(char(dec2hex(txt)))];
end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ECE 6357 Cybersecurity, University of Houston 
% Spring 2021, class project
% Created by: K.M.Patrick Krueger
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
