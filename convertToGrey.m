function [out] = convertToGrey(image, redDepth, greenDepth, blueDepth)
%imaqhwinfo
%cam = videoinput('winvideo',1)
out = redDepth*image(:,:,1) + greenDepth*image(:,:,2) + blueDepth*image(:,:,3);
end

