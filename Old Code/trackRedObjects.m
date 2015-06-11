%% Initialization
 minThresh = 0.25; % Minimum intesity for threshold
 maxThresh = 1; % Minimum intesity for threshold
 frames = 50;
 minBlobArea = 500;
 maxBlobArea = 10000000;
 maxCount = 10;
 
 vidDevice = imaq.VideoDevice('winvideo', 2, 'I420_1280x720', ... % Acquire input video stream
 'ROI', [1 1 1280 720], ...
 'ReturnedColorSpace', 'rgb');
 
 vidInfo = imaqhwinfo(vidDevice); % Acquire input video property
 
 hblob = vision.BlobAnalysis('AreaOutputPort', false, ... % Set blob analysis handling
 'CentroidOutputPort', true, ...
 'BoundingBoxOutputPort', true', ...
 'MinimumBlobArea', minBlobArea, ...
 'MaximumBlobArea', maxBlobArea, ...
 'MaximumCount', maxCount);
 
 hshapeinsRedBox = vision.ShapeInserter('BorderColor', 'Custom', ... % Set Red box handling
 'CustomBorderColor', [1 0 0], ...
 'Fill', true, ...
 'FillColor', 'Custom', ...
 'CustomFillColor', [1 0 0], ...
 'Opacity', 0.25);
 
 htextins = vision.TextInserter('Text', 'Number of Red Object: %2d', ... % Set text for number of blobs
 'Location', [7 2], ...
 'Color', [1 0 0], ... // red colour
 'FontSize', 12);
 
 htextinsCent = vision.TextInserter('Text', '+ X:%4d, Y:%4d', ... % set text for centroid
 'LocationSource', 'Input port', ...
 'Color', [1 1 0], ... // yellow colour
 'FontSize', 14);
 
 hVideoIn = vision.VideoPlayer('Name', 'Final Video', ... % Output video player
 'Position', [100 100 vidInfo.MaxWidth+20 vidInfo.MaxHeight+30]);
 
 nFrame = 0; % Frame number initialization
 %rgbFrame = imread('testImage.jpg');
 %% Processing Loop
 while(nFrame < frames)
    rgbFrame = step(vidDevice); % Acquire single frame

    %rgbFrame = flipdim(rgbFrame,2); % obtain the mirror image for displaying
    
    %diffFrame = imsubtract(rgbFrame(:,:,1), rgb2gray(rgbFrame)); % Get red component of the image
    diffFrame = imsubtract(convertToGrey(rgbFrame,1,0,0), rgb2gray(rgbFrame)); % Get red component of the image
    
    diffFrame = medfilt2(diffFrame, [3 3]); % Filter out the noise by using median filter

    binFrame = threshold(diffFrame,minThresh,maxThresh); % Convert the image into binary image with the red objects as white
    
    [centroid, bbox] = step(hblob, binFrame); % Get the centroids and bounding boxes of the blobs
    
    centroid = uint16(centroid); % Convert the centroids into Integer for further steps
    
    rgbFrame(1:20,1:165,:) = 0; % put a black region on the output stream
    
    vidIn = step(hshapeinsRedBox, rgbFrame, bbox); % Insert the red box
    
    for object = 1:1:length(bbox(:,1)) % Write the corresponding centroids
        centX = centroid(object,1);
        centY = centroid(object,2);
        vidIn = step(htextinsCent, vidIn, [centX centY], [centX-6 centY-9]);
    end
    
    vidIn = step(htextins, vidIn, uint8(length(bbox(:,1)))); % Count the number of blobs
    
    step(hVideoIn, vidIn); % Output video stream
    
    nFrame = nFrame+1;
 end
 
 %% Clearing Memory
 release(hVideoIn); % Release all memory and buffer used
 
 release(vidDevice);
 
 clear all;
 
 clc;