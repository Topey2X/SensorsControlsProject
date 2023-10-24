function ImageSubscriber()
close all;
rgbSub = rossubscriber('/usb_cam/image_raw');
pause(1); 
img = readImage(rgbSub.LatestMessage);
imshow(img)