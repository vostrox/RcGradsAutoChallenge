function [out] = convertToGrey(image, redDepth, greenDepth, blueDepth)
out = redDepth*image(:,:,1) + greenDepth*image(:,:,2) + blueDepth*image(:,:,3);
end

