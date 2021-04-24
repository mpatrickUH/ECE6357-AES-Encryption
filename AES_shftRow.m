function sftOut = AES_shftRow(in, crypt)
%TESTED:WORKING || Shift the rows the designated amount to the left for
%encryption and to the right for decryption.
%input:     in = the message being shifted
%           crypt = whether 'encrypt' or 'decrypt' is happening
%output:    sftOut = the shifted output message
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

in = reshape(in,4,[]);

if crypt == 'encrypt'
    in(2,:) = circshift(in(2,:),-1);
    in(3,:) = circshift(in(3,:),-2);
    in(4,:) = circshift(in(4,:),-3);
end

if crypt == 'decrypt'
    in(2,:) = circshift(in(2,:),1);
    in(3,:) = circshift(in(3,:),2);
    in(4,:) = circshift(in(4,:),3);
end

sftOut = reshape(in,16,1);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ECE 6357 Cybersecurity, University of Houston 
% Spring 2021, class project
% Created by: K.M.Patrick Krueger
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
