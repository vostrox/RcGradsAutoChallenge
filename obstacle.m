filterSize = 5;
minT = 240;
maxT = 255;
dilationSize = 25;
erosionSize = 20;

seD = strel('disk', dilationSize);
seE = strel('disk', erosionSize);

img = imread('testImage.jpg');

grey = convertToGrey(img,0.333,0.333,0.333);

grey = medfilt2(grey, [filterSize filterSize]);

thresh = threshold(grey, minT, maxT);

thresh = imdilate(thresh, seD);
thresh = imerode(thresh, seE);

imtool(thresh);