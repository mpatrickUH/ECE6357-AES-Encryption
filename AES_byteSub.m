function subOut = AES_byteSub(subIn, crypt)
%TESTED:WORKING || Byte stubstitution function to call the sBox lookup
%tables and return those values to the to the routine.
%input:     subIn = what value is going to need to be substutited
%           crypt = 'encrypt' or 'decrypt' or 'Tales from the Crypt' -
%output:    subOut = the replacement value found using the sBox /inv sBox.
% Note: using 'Tales from the Crypt' will get you nothing. Unless you are
% using a search engine to find videos. This code doesn't offer that function.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subOut=[];
for i = 1:length(subIn)
    sBxSub = AES_sBox(subIn(i), crypt);
    subOut = [subOut; sBxSub];
end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ECE 6357 Cybersecurity, University of Houston 
% Spring 2021, class project
% Created by: K.M.Patrick Krueger
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%