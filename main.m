testImage = imread('SlalomTestImages\3.jpg');

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

%imshow(step(camera));

i = 0; % Frame number initialization

orientation = 0;

%% Processing Loop
while(i < frames)
    frame = step(camera); % Acquire single frame
    %frame = testImage;
    
    chariotCoordinates = findChariot(frame);
    gOrbCoordinates = findGreenOrb(frame);
    bOrbCoordinates = findBlueOrb(frame);
    
    frame = step(chariotCoordinatesText, frame, chariotCoordinates, chariotCoordinates-6);
    frame = step(gOrbCoordinatesText, frame, gOrbCoordinates, gOrbCoordinates-6);
    frame = step(bOrbCoordinatesText, frame, bOrbCoordinates, bOrbCoordinates-6);
    
    orientation = chariotOrientation(chariotCoordinates(0), chariotCoordinates(1), gOrbCoordinates(0), gOrbCoordinates(1), bOrbCoordinates(0), bOrbCoordinates(1));
    
    step(display, frame); % Output to display
    
    i = i + 1;
end
 
%% Clearing Memory
release(display); % Release all memory and buffer used

release(camera);
 
clear all;
 
clc;