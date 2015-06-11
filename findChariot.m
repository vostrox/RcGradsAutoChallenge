function [out] = findChariot(image)
    minThresh = 0.25; % Minimum intensity for threshold
    maxThresh = 255; % Minimum intesity for threshold
    minBlobArea = 1000;
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
    redChannel = medfilt2(redChannel, [filterSize filterSize]); % Filter out the noise using median filter

    binFrame = threshold(redChannel,minThresh,maxThresh); % Convert the image into binary image with the red objects as white

    [centroid, bbox] = step(hblob, binFrame); % Get the centroids and bounding boxes of the blobs
    
    centroid = uint16(centroid); % Convert the centroids into Integer for further steps
    
    for object = 1:1:length(bbox(:,1)) % Write the corresponding centroids
        chariotX = centroid(object,1);
        chariotY = centroid(object,2);
    end

    out = [chariotX chariotY];
end

