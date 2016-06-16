function [out] = findBlueOrb(image, chariotX, chariotY, rectSize)
    minThresh = 0.30; % Minimum intensity for threshold
    %minThresh = 0.20; % Minimum intensity for threshold - 2015 VALUE
    %minThresh = 150; % TEST IMAGE VALUE Minimum intensity for threshold
    maxThresh = 255; % Minimum intesity for threshold
    
    minBlobArea = 300;
    maxBlobArea = 100000;
    count = 1;
    filterSize = 1;
    orbX = 0;
    orbY = 0;
    
    rectX = chariotX - (rectSize / 2);
    rectY = chariotY - (rectSize / 2);

    croppedImage = imcrop(image, [rectX rectY rectSize rectSize]);
    
    hblob = vision.BlobAnalysis('AreaOutputPort', false, ... % Set blob analysis handling
        'CentroidOutputPort', true, ...
        'BoundingBoxOutputPort', true', ...
        'MinimumBlobArea', minBlobArea, ...
        'MaximumBlobArea', maxBlobArea, ...
        'MaximumCount', count);
    
    blueChannel = imsubtract(convertToGrey(croppedImage,0,0,1), rgb2gray(croppedImage)); % Get blue component of the image
    blueChannel = 2 * medfilt2(blueChannel, [filterSize filterSize]); % Filter out the noise using median filter

    binFrame = threshold(blueChannel,minThresh,maxThresh); % Convert the image into binary image with the blue objects as white
    binFrame = imdilate(binFrame, strel('disk', 5));
    binFrame = imclose(binFrame, strel('disk', 10));
    
    imshow(binFrame);
    
    [centroid, bbox] = step(hblob, binFrame); % Get the centroids and bounding boxes of the blobs
    
    centroid = uint16(centroid); % Convert the centroids to 16 bit ints for further steps
    
    objectCount = length(bbox(:,1));
    
    if (objectCount > 0)
        for object = 1:1:objectCount % Write the corresponding centroids
            orbX = centroid(object,1);
            orbY = centroid(object,2);
            center = rectSize/2;
            if (orbX < center)
               orbX = chariotX - (center - orbX);
            elseif (orbX == center)
                orbX = chariotX;
            elseif (orbX > center)
                orbX = chariotX + (orbX - center);
            end
            
            if (orbY < center)
                orbY = chariotY - (center - orbY);
            elseif (orbY == center)
                orbY = chariotY;
            elseif (orbY > center)
                orbY = chariotY + (orbY - center);
            end
        end
    else
        orbX = 0;
        orbY = 0;
    end

    out = [orbX orbY];
end

