%function [out] = findGreenOrb(image, chariotX, chariotY)
function [out] = findGreenOrb(image)
    minThresh = 0.2; % Minimum intensity for threshold
    maxThresh = 255; % Minimum intesity for threshold
    
    rectLength = 200;
    
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
    
    greenChannel = imsubtract(convertToGrey(image,0,1,0), convertToGrey(image,0.33,0.33,0.33)); % Get green component of the image
    greenChannel = 2*medfilt2(greenChannel, [filterSize filterSize]); % Filter out the noise using median filter
    
    imshow(greenChannel);
    
    binFrame = threshold(greenChannel,minThresh,maxThresh); % Convert the image into binary image with the green objects as white
    
    figure, imshow(binFrame);
    
    [centroid, bbox] = step(hblob, binFrame); % Get the centroids and bounding boxes of the blobs
    
    centroid = uint16(centroid); % Convert the centroids into Integer for further steps
    
    for object = 1:1:length(bbox(:,1)) % Write the corresponding centroids
        orbX = centroid(object,1);
        orbY = centroid(object,2);
    end

    out = [orbX orbY];
end

