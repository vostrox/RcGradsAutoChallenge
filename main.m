testImage = imread('testImage.png');
ip = '255.255.255.255';
adapter = udp(ip);
fopen(adapter);

%% Initialization
frames = 50;


camera = imaq.VideoDevice('winvideo', 1, 'MJPG_1280x720', ... % Acquire input video stream
    'ROI', [1 1 1280 720], ...
    'ReturnedColorSpace', 'rgb');

camInfo = imaqhwinfo(camera); % Acquire input video property
 
display = vision.VideoPlayer('Name', 'Chariotometer', ... % Output video player
    'Position', [100 50 camInfo.MaxWidth+20 camInfo.MaxHeight+25]);
 
chariotCoordinatesText = vision.TextInserter('Text', '+ X:%4d, Y:%4d', ... % set text for centroid
    'LocationSource', 'Input port', ...
    'Color', [1 0 0], ... // red text
    'FontSize', 12);
gOrbCoordinatesText = vision.TextInserter('Text', '+ X:%4d, Y:%4d', ... % set text for centroid
    'LocationSource', 'Input port', ...
    'Color', [0 1 0], ... // green text
    'FontSize', 12);
bOrbCoordinatesText = vision.TextInserter('Text', '+ X:%4d, Y:%4d', ... % set text for centroid
    'LocationSource', 'Input port', ...
    'Color', [0 0 1], ... // blue text
    'FontSize', 12);
orientationText = vision.TextInserter('Text', 'Orientation: %4d', ... % set text for centroid
    'LocationSource', 'Input port', ...
    'Color', [0 0 0], ... // black text
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
        
    chariotCoordinates = findChariot(frame);
    if ((chariotCoordinates(1) == 0) && (chariotCoordinates(2) == 0))  
        payload = getPayload(previousChariotCoordinates(1), previousChariotCoordinates(2), previousOrientation, 1, 0, 0);
        fwrite(adapter, payload);
        error = 1;
    else
        previousChariotCoordinates = chariotCoordinates;
    end
    
    if (error == 0)
        gOrbCoordinates = findGreenOrb(frame);
        if ((gOrbCoordinates(1) == 0) && (gOrbCoordinates(2) == 0))
            payload = getPayload(previousChariotCoordinates(1), previousChariotCoordinates(2), previousOrientation, 1, 0, 0);
            fwrite(adapter, payload);
            error = 1;
        else
            previousGreenCoordinates = gOrbCoordinates;
        end
        
        if (error == 0)
            bOrbCoordinates = findBlueOrb(frame);
            if ((bOrbCoordinates(1) == 0) && (bOrbCoordinates(2) == 0))          
                payload = getPayload(previousChariotCoordinates(1), previousChariotCoordinates(2), previousOrientation, 1, 0, 0);
                fwrite(adapter, payload);
                error = 1;
            else
                previousBlueCoordinates = bOrbCoordinates;
            end
            
            if (error == 0)
                orientation = chariotOrientation(chariotCoordinates(1), chariotCoordinates(2), gOrbCoordinates(1), gOrbCoordinates(2), bOrbCoordinates(1), bOrbCoordinates(2));
                
                frame = step(chariotCoordinatesText, frame, chariotCoordinates, chariotCoordinates-6);
                frame = step(gOrbCoordinatesText, frame, gOrbCoordinates, gOrbCoordinates-6);
                frame = step(bOrbCoordinatesText, frame, bOrbCoordinates, bOrbCoordinates-6);
                frame = step(orientationText, frame, orientation, chariotCoordinates-75);
                
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