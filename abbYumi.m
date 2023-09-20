% startup_rvc

robot = loadrobot('abbYumi','Gravity',[0 0 -9.81]);

iviz = interactiveRigidBodyTree(robot);
ax = gca;

exampleHelperSetupWorkspace(ax);

load abbSavedConfigs.mat configSequence

% Define initial state
q0 = configSequence(:,1); % Position
dq0 = zeros(size(q0)); % Velocity
ddq0 = zeros(size(q0)); % Acceleration

open_system('modelWithSimplifiedSystemDynamics.slx');

simout = sim('modelWithSimplifiedSystemDynamics.slx');

% Visualize the motion using the interactiveRigidBodyTree object.
iviz.ShowMarker = false;
iviz.showFigure;
rateCtrlObj = rateControl(length(simout.tout)/(max(simout.tout)));
for i = 1:length(simout.tout)
    iviz.Configuration = simout.yout{1}.Values.Data(i,:);
    waitfor(rateCtrlObj);
end

open_system('modelWithControllerAndBasicRobotDynamics.slx');

simout = sim('modelWithControllerAndBasicRobotDynamics.slx');

% Visualize the motion using the interactiveRigidBodyTree
iviz.ShowMarker = false;
iviz.showFigure;
rateCtrlObj = rateControl(length(simout.tout)/(max(simout.tout)));
for i = 1:length(simout.tout)
    iviz.Configuration = simout.yout{1}.Values.Data(i,:);
    waitfor(rateCtrlObj);
end

open_system('modelWithSimscapeRobotAndEnvironmentDynamics.slx');

widgetDimensions = [0.02 0.02 0.07];

% Contact parameters
stiffness = 1e4;
damping = 30;
transition_region_width = 1e-4;
static_friction_coef = 1;
kinetic_friction_coef = 1;
critical_velocity = 1;

simout = sim('modelWithSimscapeRobotAndEnvironmentDynamics.slx');