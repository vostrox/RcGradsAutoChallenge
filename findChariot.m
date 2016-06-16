function [out] = findChariot(image)
    minThresh = 0.25; % Minimum intensity for threshold
    %minThresh = 80; % TEST IMAGE VALUE Minimum intensity for threshold
    maxThresh = 255; % Minimum intesity for threshold
    minBlobArea = 500;
    maxBlobArea = 100000;
    count = 1;
    filterSize = 1;
    chariotX = 0;
    chariotY = 0;
    
    hblob = vision.BlobAnalysis('AreaOutputPort', false, ... % Set blob analysis handling
        'CentroidOutputPort', true, ...
        'BoundingBoxOutputPort', true', ...
        'MinimumBlobArea', minBlobArea, ...
        'MaximumBlobArea', maxBlobArea, ...
        'MaximumCount', count);
    
    redChannel = imsubtract(convertToGrey(image,1,0,0), rgb2gray(image)); % Get red component of the image
    %redChannel = medfilt2(redChannel, [filterSize filterSize]); % Filter out the noise using median filter
    
    binFrame = threshold(redChannel,minThresh,maxThresh); % Convert the image into binary image with the red objects as white
    binFrame = imclose(binFrame, strel('disk', 5));
    
    %imshow(binFrame);
    
    [centroid, bbox] = step(hblob, binFrame); % Get the centroids and bounding boxes of the blobs
    
    centroid = uint16(centroid); % Convert the centroids to 16 bit ints for further steps
    
    objectCount = length(bbox(:,1));
    
    if (objectCount > 0)
        for object = 1:1:objectCount % Write the corresponding centroids
            chariotX = centroid(object,1);
            chariotY = centroid(object,2);
        end
    else
        chariotX = 0;
        chariotY = 0;
    end

    out = [chariotX chariotY];
end

