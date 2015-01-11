function [out] = threshold2(image, minT, maxT)
    out1 = image > minT;
    out2 = image <= maxT;
    out = out1 & out2;
end
