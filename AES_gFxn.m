function gFx = AES_gFxn(mult,x)  
%TESTING:WORKING || Supplemnt to Mix Columns for multiplication operation
% input:    mult = the multiplier value
%           x = the 2byte hex value from the message
% output:   gFx = the multiplied output < 256
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This routine uses the Galois Functions. Basically, they are all built off
%the foundation of (x*2) and ((...)+x). For each of the multiplier values:
% 01 = x * 1 = x    (kind of a no brainer for this one.)
% 02 = (x*2)        (from here to 0E, I have more instructions below)
% 03 = (x*2) + x                    (Do the math on all of these, you will
% 09 = (x*2) * 2) * 2) + x           it equals the #*x.)
% 0B = (x*2) * 2) + x) * 2)+ x      (I didn't put the leanding '((' because
% 0D = (x*2) + x) * 2) * 2) + x      I'm lazy and I prefer this look.)
% 0E = (x*2) + x) * 2) + x) * 2   
%
% Great. So now what?
%     Just follow these rules like a good little coder.
% Any time you are doing a (...) * 2) :
%   --> do a bitwise shift to the left. It's the same as multiplying by 2.
%   -->  If the original number is over 0x80m bitxor it by 0x1B.
% Anytime you are doing a (...) + x) :
%   --> do a bitwise xor with 'x'.
% 
% That's it! That's what all those ifs are doing down below.
% Note: The 'bitand(wrk,255)' is to keep it at 2 bytes. Yes, there are way
% too many of them but I was debugging it and made it easier to watch the
% numbers. Then once it was working I decided to be superstitious. The fear
% that changing anything once I finally had it working filled me with
% panic and so they stay. (Just kidding, I was too lazy to remove them yet
% I'm writing this whole thing justifying their remaining. I need to
% reprioritize.)




%If multiplier is 1, then nothing changes
if mult == 1
  gFx = x;
%If multiplier is 2, then do a bit shift. If it's greater than 255, then
%chop it back down by doing a bitxor with 256.
elseif mult == 2
    if x >= 128                 %If 128 or higher, you have to xor 27 or 0x1B
        wrk = bitshift(x,1);    %multiply by 2 = left shift of the bits
        wrk = bitxor(wrk,27);   %xor with 0x1B = 27.
    elseif x <128
        wrk = bitshift(x,1);    %If 127 or below, you only need the shift.
    end
    if wrk > 255
        wrk = bitand(wrk,255);  %Needed to keep it at 2 bytes
    end
    gFx = wrk;                  
%If the multipler is 3, then do the same as multiplication by 2, but bitxor
%it with the number for the output.
elseif mult == 3  % x * 3 = (x * 2) + x
    if x >= 128                 % This is the *2 part
        wrk = bitshift(x,1);
        wrk = bitxor(wrk,27);
    elseif x <128
        wrk = bitshift(x,1);
    end
    if wrk > 255
        wrk = bitand(wrk,255);
    end
    gFx = bitxor(x,wrk);        % This is the +x part 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%For decryption
elseif mult == 9  % x * 9 = (((x * 2) * 2) * 2) + x
    if x >= 128                   % This is the first *2 part
        wrk = bitshift(x,1);
        wrk = bitxor(wrk,27);
        wrk = bitand(wrk,255);
    elseif x <128
        wrk = bitshift(x,1);
     end

    for i = 1:2
     if wrk >= 128                % These are the next two *2 parts
        wrk = bitshift(wrk,1);
        wrk = bitxor(wrk,27);
        wrk = bitand(wrk,255);
    elseif wrk <128
        wrk = bitshift(wrk,1);
     end
    end 
    wrk = bitxor(x,wrk);          % This is the +x part 
    if wrk > 255
        wrk = bitand(wrk,255);    % Keep it at 2 bytes
    end
  gFx = wrk;
  
elseif mult == 11   % x * 11 = ((((x * 2) * 2) + x) * 2)+ x
    if x >= 128                   % This is the *2 part
        wrk = bitshift(x,1);
        wrk = bitxor(wrk,27);
        wrk = bitand(wrk,255);    % Keep it at 2 bytes
    elseif x <128
        wrk = bitshift(x,1);
    end
    
    if wrk >= 128                 % This is the second *2 part
        wrk = bitshift(wrk,1);
        wrk = bitxor(wrk,27);
        wrk = bitand(wrk,255);    % Keep it at 2 bytes
    elseif wrk <128
        wrk = bitshift(wrk,1);
    end
    wrk = bitxor(x,wrk);          % This is the +x part 
    if wrk >= 128                 % This is the *2 part
        wrk = bitshift(wrk,1);
        wrk = bitxor(wrk,27);
        wrk = bitand(wrk,255);    % Keep it at 2 bytes
    elseif wrk <128
        wrk = bitshift(wrk,1);
    end
    if wrk > 255
        wrk = bitand(wrk,255);    % Keep it at 2 bytes
    end
  gFx = bitxor(x,wrk);
  
elseif mult == 13   % x * 13 = ((((x * 2) + x) * 2) * 2) + x
    if x >= 128                   % This is the *2 part
        wrk = bitshift(x,1);
        wrk = bitxor(wrk,27);
        wrk = bitand(wrk,255);    % Keep it at 2 bytes
    elseif x <128
        wrk = bitshift(x,1);
    end
    wrk = bitxor(x,wrk);          % This is the +x part 
    
    for i = 1:2
    if wrk >= 128                 % These are the *2 parts
        wrk = bitshift(wrk,1);
        wrk = bitxor(wrk,27);
        wrk = bitand(wrk,255);    % Keep it at 2 bytes
    elseif wrk <128
        wrk = bitshift(wrk,1);
    end
    end
    if wrk > 255
        wrk = bitand(wrk,255);    % Keep it at 2 bytes
    end
  gFx = bitxor(x,wrk);
elseif mult == 14   % x * 14 = ((((x * 2) + x) * 2) + x) * 2
     if x >= 128                  % This is the *2 part
        wrk = bitshift(x,1);
        wrk = bitxor(wrk,27);
        wrk = bitand(wrk,255);    % Keep it at 2 bytes
    elseif x <128
        wrk = bitshift(x,1);
     end
    
    wrk = bitxor(x,wrk);          % This is the +x part 
    
    if wrk >= 128                 % This is the *2 part
        wrk = bitshift(wrk,1);
        wrk = bitxor(wrk,27);
        wrk = bitand(wrk,255);    % Keep it at 2 bytes
    elseif wrk <128
        wrk = bitshift(wrk,1);
    end
    
    wrk = bitxor(x,wrk);          % This is the +x part 
    
    if wrk >= 128                 % This is the *2 part
        wrk = bitshift(wrk,1);
        wrk = bitxor(wrk,27);
        wrk = bitand(wrk,255);    % Keep it at 2 bytes
    elseif wrk <128
        wrk = bitshift(wrk,1);
    end
    if wrk > 255
        wrk = bitand(wrk,255);    % Keep it at 2 bytes
    end
  gFx = wrk;


end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ECE 6357 Cybersecurity, University of Houston 
% Spring 2021, class project
% Created by: K.M.Patrick Krueger
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


