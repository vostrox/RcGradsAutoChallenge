testImage = imread('testImage.png');
ip = '255.255.255.255';
adapter = udp(ip);
fopen(adapter);

rectSize = 300;

%% Initialization
frames = 1000000;

% Acquire input video stream
camera = imaq.VideoDevice('winvideo', 2, 'MJPG_1280x720', ... 
    'ROI', [1 1 1280 720], ...
    'ReturnedColorSpace', 'rgb');

% Acquire input video property
camInfo = imaqhwinfo(camera);

% Output video player
display = vision.VideoPlayer('Name', 'Chariotometer', ... 
    'Position', [0 0 camInfo.MaxWidth camInfo.MaxHeight]);
    %'Position', [100 50 camInfo.MaxWidth+20 camInfo.MaxHeight+25]);

% set text for chariot position    
chariotCoordinatesText = vision.TextInserter('Text', '+ X:%4d, Y:%4d', ... 
    'LocationSource', 'Input port', ...
    'Color', [255 0 0], ...
    'FontSize', 12);

% set text for green position
gOrbCoordinatesText = vision.TextInserter('Text', '+ X:%4d, Y:%4d', ...
    'LocationSource', 'Input port', ...
    'Color', [0 255 0], ...
    'FontSize', 12);

% set text for blue position
bOrbCoordinatesText = vision.TextInserter('Text', '+ X:%4d, Y:%4d', ...
    'LocationSource', 'Input port', ...
    'Color', [0 0 255], ...
    'FontSize', 12);

% set text for chariot orientation
orientationText = vision.TextInserter('Text', 'Orientation: %4d', ...
    'LocationSource', 'Input port', ...
    'Color', [255 255 0], ...
    'FontSize', 12);

imshow(step(camera));

% Frame number initialization
i = 0;

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
    
    % Acquire single frame
    frame = step(camera);
    
    % Draw black borders
    frame = insertBorders(frame);
    
    % Find red
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
    
    % Find green
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
        
        % Find blue
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
                % Calculate orientation
                orientation = chariotOrientation(chariotCoordinates(1), chariotCoordinates(2), gOrbCoordinates(1), gOrbCoordinates(2), bOrbCoordinates(1), bOrbCoordinates(2));
                
                frame = step(bOrbCoordinatesText, frame, bOrbCoordinates, bOrbCoordinates-6);
                
                % draw a black box in the top left corner
                frame(1:20,1:110,:) = 0;
                
                % Display orientation value in black box
                frame = step(orientationText, frame, orientation, int32([5 3]));
                
                % Format the payload to send to chariot
                payload = getPayload(chariotCoordinates(1), chariotCoordinates(2), orientation, 0, 0, 0);
                
                % Send data to chariot
                fwrite(adapter, payload);
                
                % Output to display
                step(display, frame);
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