testImage = imread('testImage.png');
ip = '255.255.255.255';
adapter = udp(ip);
fopen(adapter);

rectSize = 300;

%% Initialization
frames = 1000000;


camera = imaq.VideoDevice('winvideo', 2, 'MJPG_1280x720', ... % Acquire input video stream
    'ROI', [1 1 1280 720], ...
    'ReturnedColorSpace', 'rgb');

camInfo = imaqhwinfo(camera); % Acquire input video property
 
display = vision.VideoPlayer('Name', 'Chariotometer', ... % Output video player
    'Position', [0 0 camInfo.MaxWidth camInfo.MaxHeight]);
    %'Position', [100 50 camInfo.MaxWidth+20 camInfo.MaxHeight+25]);

    
chariotCoordinatesText = vision.TextInserter('Text', '+ X:%4d, Y:%4d', ... % set text for centroid
    'LocationSource', 'Input port', ...
    'Color', [255 0 0], ... // red text
    'FontSize', 12);
gOrbCoordinatesText = vision.TextInserter('Text', '+ X:%4d, Y:%4d', ... % set text for centroid
    'LocationSource', 'Input port', ...
    'Color', [0 255 0], ... // green text
    'FontSize', 12);
bOrbCoordinatesText = vision.TextInserter('Text', '+ X:%4d, Y:%4d', ... % set text for centroid
    'LocationSource', 'Input port', ...
    'Color', [0 0 255], ... // blue text
    'FontSize', 12);
orientationText = vision.TextInserter('Text', 'Orientation: %4d', ... % set text for centroid
    'LocationSource', 'Input port', ...
    'Color', [255 255 0], ... // yellow text
    'FontSize', 12);

imshow(step(camera));

i = 0; % Frame number initialization

orientation = 0;

previousChariotCoordinates = [0 0];
previousGreenCoordinates = [0 0];
previousBlueCoordinates = [0 0];
previousOrientation = 0;

error = 0;

%% Processing Loop

while(i < frames)
    %reset error logger
    error = 0;
    
    frame = step(camera); % Acquire single frame
    
    % Draw black borders
    frame = insertBorders(frame);
    
    chariotCoordinates = findChariot(frame);
    if ((chariotCoordinates(1) == 0) && (chariotCoordinates(2) == 0))  
        payload = getPayload(previousChariotCoordinates(1), previousChariotCoordinates(2), previousOrientation, 1, 0, 0);
        fwrite(adapter, payload);
        error = 1;
        step(display, frame);
    else
        previousChariotCoordinates = chariotCoordinates;
        frame = step(chariotCoordinatesText, frame, chariotCoordinates, chariotCoordinates-6);
    end
    
    if (error == 0)
        gOrbCoordinates = findGreenOrb(frame, chariotCoordinates(1), chariotCoordinates(2), rectSize);
        if ((gOrbCoordinates(1) == 0) && (gOrbCoordinates(2) == 0))
            payload = getPayload(previousChariotCoordinates(1), previousChariotCoordinates(2), previousOrientation, 1, 0, 0);
            fwrite(adapter, payload);
            error = 1;
            step(display, frame);
        else
            previousGreenCoordinates = gOrbCoordinates;
            frame = step(gOrbCoordinatesText, frame, gOrbCoordinates, gOrbCoordinates-6);
        end
        
        if (error == 0)
            bOrbCoordinates = findBlueOrb(frame, chariotCoordinates(1), chariotCoordinates(2), rectSize);
            if ((bOrbCoordinates(1) == 0) && (bOrbCoordinates(2) == 0))          
                payload = getPayload(previousChariotCoordinates(1), previousChariotCoordinates(2), previousOrientation, 1, 0, 0);
                fwrite(adapter, payload);
                error = 1;
                step(display, frame);
            else
                previousBlueCoordinates = bOrbCoordinates;
            end
            
            if (error == 0)
                orientation = chariotOrientation(chariotCoordinates(1), chariotCoordinates(2), gOrbCoordinates(1), gOrbCoordinates(2), bOrbCoordinates(1), bOrbCoordinates(2));
                
                frame = step(bOrbCoordinatesText, frame, bOrbCoordinates, bOrbCoordinates-6);
                frame(1:20,1:110,:) = 0; % draw a black box in the top left corner
                frame = step(orientationText, frame, orientation, int32([5 3]));
                
                payload = getPayload(chariotCoordinates(1), chariotCoordinates(2), orientation, 0, 0, 0);
    
                fwrite(adapter, payload);
    
                step(display, frame); % Output to display
            end
        end
    end
    i = i + 1;
end
 
%% Clearing Memory
release(display); % Release all memory and buffer used

release(camera);

clear all;

%fclose(adapter);

clc;