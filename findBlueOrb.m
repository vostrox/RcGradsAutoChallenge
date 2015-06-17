%function [out] = findGreenOrb(image, chariotX, chariotY)
function [out] = findBlueOrb(image)
    minThresh = 0.50; % Minimum intensity for threshold
    %minThresh = 150; % TEST IMAGE VALUE Minimum intensity for threshold
    maxThresh = 255; % Minimum intesity for threshold
    
    %rectLength = 200;
    
    minBlobArea = 50;
    maxBlobArea = 1000;
    count = 1;
    filterSize = 1;
    orbX = 0;
    orbY = 0;
    
    %rectX = chariotX - (rectLength / 2);
    %rectY = chariotY - (rectLength / 2);
    
    %image = imcrop(image, [rectX rectY rectLength rectLength]);
    
    hblob = vision.BlobAnalysis('AreaOutputPort', false, ... % Set blob analysis handling
        'CentroidOutputPort', true, ...
        'BoundingBoxOutputPort', true', ...
        'MinimumBlobArea', minBlobArea, ...
        'MaximumBlobArea', maxBlobArea, ...
        'MaximumCount', count);
    
    blueChannel = imsubtract(convertToGrey(image,0,0,1), rgb2gray(image)); % Get blue component of the image
    blueChannel = 2 * medfilt2(blueChannel, [filterSize filterSize]); % Filter out the noise using median filter

    binFrame = threshold(blueChannel,minThresh,maxThresh); % Convert the image into binary image with the blue objects as white
    
    %imshow(binFrame);
    
    [centroid, bbox] = step(hblob, binFrame); % Get the centroids and bounding boxes of the blobs
    
    centroid = uint16(centroid); % Convert the centroids to 16 bit ints for further steps
    
    objectCount = length(bbox(:,1));
    
    if (objectCount > 0)
        for object = 1:1:objectCount % Write the corresponding centroids
            orbX = centroid(object,1);
            orbY = centroid(object,2);
        end
    else
        orbX = 0;
        orbY = 0;
    end

    out = [orbX orbY];
end

