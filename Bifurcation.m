Omega_D=2/3;
for F_Drive_step=1:0.1:13;
F_Drive=1.35+F_Drive_step/100;
% Calculate the plot of theta as a function of time for the current drive step
% using the function :- pendulum_function
[time,theta]= pendulum_function(F_Drive, Omega_D);
%Filter the results to exclude initial transient of 300 periods, note
% that the period is 3*pi.
I=find (time< 3*pi*300);
time(I)=NaN;
theta(I)=NaN;
%Further filter the results so that only results in phase with the driving force
% F_Drive are displayed.
% Replace all those values NOT in phase with NaN
Z=find(abs(rem(time, 2*pi/Omega_D)) > 0.01);
time(Z)=NaN;
theta(Z)=NaN;
% Remove all NaN values from the array to reduce dataset size
time(isnan(time)) = [];
theta(isnan(theta)) = [];
% Now plot the results
plot(F_Drive,theta,'k');
hold on;
axis([1.35 1.5 1 3]);
xlabel('F Drive');
ylabel('theta (radians)');
end;
%% 

function [time,theta] = pendulum_function(F_Drive,Omega_D);
length= 9.8; %pendulum length in metres
g=9.8; % acceleration due to gravity
q=0.5; % damping strength
npoints =100000; %Discretize time
dt = 0.04; % time step in seconds
omega = zeros(npoints,1); % initializes omega, a vector of dimension npoints X 1,to being all zeros
theta = zeros(npoints,1); % initializes theta, a vector of dimension npoints X 1,to being all zeros
time = zeros(npoints,1); % this initializes the vector time to being all zeros
theta(1)=0.2; % you need to have some initial displacement, otherwise the pendulum will
not swing
omega(1)=0;
for step = 1:npoints-1;
% loop over the timesteps
omega(step+1)=omega(step)+(-(g/length)*sin(theta(step))-
q*omega(step)+F_Drive*sin(Omega_D*time(step)))*dt;
temporary_theta_step_plus_1 = theta(step)+omega(step+1)*dt;
% Make corrections to keep theta between pi and -pi
if (temporary_theta_step_plus_1 < -pi)
 temporary_theta_step_plus_1= temporary_theta_step_plus_1+2*pi;
elseif (temporary_theta_step_plus_1 > pi)
 temporary_theta_step_plus_1= temporary_theta_step_plus_1-2*pi;
end;
% Update theta array
theta(step+1)=temporary_theta_step_plus_1;
% Increment time
time(step+1) = time(step) + dt;
end;

