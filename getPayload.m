function [out] = getPayload(chariotX, chariotY, orientation, uncertainty, footballX, footballY) 
    chariotXstr = sprintf('%04d', chariotX);
    chariotYstr = sprintf('%04d', chariotY);
    orientationStr = sprintf('%03d', orientation);
    uncertaintyStr = sprintf('%01d', uncertainty);
    wordZero = strcat(chariotXstr, chariotYstr, orientationStr, uncertaintyStr);
    
    
    footballXstr = sprintf('%04d', footballX);
    footballYstr = sprintf('%04d', footballY);
    wordOne = strcat(footballXstr, footballYstr);
    
    payload = strcat(wordZero, wordOne);
    
    out = payload;
end

