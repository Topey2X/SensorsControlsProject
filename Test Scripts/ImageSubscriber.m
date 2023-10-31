% function ImageSubscriber()
load("camera_calibration.mat");
cam_rgb = webcam('/dev/video10');

% img = imread("Pictures/Webcam/2023-10-30-170652.jpg");
img = snapshot(cam_rgb);
depth_img = 

imshow(img)
figure()
masked_image = YellowMask(img);
imshow(masked_image)

centroids = regionprops(masked_image, 'Centroid','Area');
blocks = centroids([centroids.Area]>500);
blockpos = blocks(:).Centroid;

blockpos_x = blockpos(1:2:end);
blockpos_y = blockpos(2:2:end);

hold on
plot(blockpos_x,blockpos_y,'b*')
hold off