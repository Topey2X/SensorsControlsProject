%% Start Dobot Magician Node
rosshutdown;
rosinit;
pause(1);
% Start Dobot ROS
dobot = DobotMagician();

%% Initialise Variables
z_down = -0.01;
% z_down = 0.01;
z_up = 0.13;
z_seek = 0.05;
z_up_cam = 0.235;

x_default = 0.2;
y_default = 0.0;

cam_offset_x = 0.05;
cam_offset_y = 0.04;

load("camera_calibration.mat");

%% Set Dobot to Initial Position
setDobotPosition(dobot, x_default,y_default,z_up);
openDobotGripper(dobot);

%% MAIN FUNCTION
webcamlist;
cam_rgb = webcam(1); % Webcam(1) is always the realsense camera in testing

% img = imread("/home/rs1/Pictures/Webcam/2023-10-30-170652.jpg"); % Testing only
img = snapshot(cam_rgb); 

masked_image = YellowMask(img);

centroids = regionprops(masked_image, 'Centroid','Area'); % Get list of centroids
blocks = centroids([centroids.Area]>500); % Filter to only big regions (500+)
blockpos = blocks(:).Centroid; % Extract centroid location

blockpos_x = blockpos(1:2:end); % All areas X values
blockpos_y = blockpos(2:2:end); % All areas Y values

% DEBUG: Show figures
% imshow(img)
imshow(masked_image)
hold on
plot(blockpos_x,blockpos_y,'b*')
hold off

u = blockpos_x(1); % Get first found region.
v = blockpos_y(1);

% Convert camera pixel to real x-y coordinates
real_x = z_up_cam * ((u - cameraParams.PrincipalPoint(1)) / cameraParams.FocalLength(1));
real_y = z_up_cam * ((v - cameraParams.PrincipalPoint(2)) / cameraParams.FocalLength(2));

% Apply the offset (transform) and the camera values to the default position
% Note camera-xy and dobot-xy are swapped
y = (y_default-real_x+cam_offset_y); 
x = (x_default-real_y+cam_offset_x);
% [x y] % Debug

% Go to the seek height
setDobotPosition(dobot,x_default,y_default,z_seek);
pause(1);
% Hover over the block position
setDobotPosition(dobot,x,y,z_seek);
pause(1);
% Go down onto the block
setDobotPosition(dobot,x,y,z_down);
pause(3);
% Close gripper
closeDobotGripper(dobot);
% Go to the 'up' position
setDobotPosition(dobot,x,y,z_up);
pause(2);
% Go to the default position (above the deposit box)
setDobotPosition(dobot,x_default,y_default,z_up);
pause(2);
% Lower into the deposit box
setDobotPosition(dobot,x_default,y_default,z_down);
pause(3);
% Open the gripper
openDobotGripper(dobot);
% Go back to the starting position
setDobotPosition(dobot,x_default,y_default,z_up);

% End of main function

%% Functions
% Using 'DobotMagician' matlab class file
function setDobotPosition(robot, x,y,z)
    end_effector_position = [x,y,z];
    end_effector_rotation = [0,0,0];
    robot.PublishEndEffectorPose(end_effector_position,end_effector_rotation);
end

function openDobotGripper(robot)
    robot.PublishToolState(1,0);
    pause(1);
    robot.PublishToolState(0,0);
end

function closeDobotGripper(robot)
    robot.PublishToolState(1,1);
    pause(1);
    robot.PublishToolState(0,0);
end

