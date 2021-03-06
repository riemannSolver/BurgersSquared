% ex2_glimm.m: 
% Minimal example of the random choice method (Glimm scheme) using a background viscosity dependent 
% Riemann solver for two inviscid Burgers equations.
%
% This programm uses the matlab function riSolBurgers2.m
%
% AUTHOR:
% Valentin Pellhammer
% Department of Mathematics and Statistics,
% University of Konstanz, 78457 Konstanz
% homepage: http://www.math.uni-konstanz.de/~pellhammer/
%
% Date: February 2020
% Last revision: February 2020

clc;close all;clear all;

% define discretisation parameters
xmin = -1;
xmax = 1;
dt = 0.001;
N = 200;
tmax = 1;
dx = (xmax-xmin)/(N-1);
x =  linspace(xmin, xmax,N);


% define model 
kappa = 0.5;
F = @(u,v) [(1/2) .* u.^2;(1/2) .* v.^2];

% Initial data %
% Riemann data (transmissive boundary cond. recomended; cf. main loop)
uL = 1;
vL = 0;
uR =-1;
vR = 0;
init =  [(x<0) .* uL + (x>=0) .* uR;(x<0) .* vL + (x>=0) .* vR];
% other data
init = [cos(5.*x);sin(10.*x)];

sol = init;

% initialize plots
subplot(2,1,1)
h1 = plot(x,sol(1,:),'*');hold on;
T = title('Random choice method (press any key)');
axis([xmin xmax,-1.2 1.2]);
xlabel('$x$','Interpreter','latex','FontSize',14);
ylabel('$u$','Interpreter','latex','Rotation',0,'FontSize',14);

subplot(2,1,2)
h2 = plot(x,sol(2,:),'*');hold on;
xlabel('$x$','Interpreter','latex','FontSize',14);
axis([xmin xmax,-1.2 1.2]);
xlabel('$x$','Interpreter','latex','FontSize',14);
ylabel('$v$','Interpreter','latex','Rotation',0,'FontSize',14);
a = annotation('textbox',[0.8,0.07,0,0],'string','$t=0$','Interpreter','latex','FontSize',14);

pause;
T.String = 'Random choice method';

for i= 0:dt:tmax
    
    % transmissive boundary conditions
    % solm = [sol(:,1),sol(:,1:end-1)];
    % solp = [sol(:,2:end),sol(:,end)]; 
    
    % periodic boundary conditions
    solm = [sol(:,end),sol(:,1:end-1)];
    solp = [sol(:,2:end),sol(:,1)];  
           
    theta = ones(1,length(x)) .*rand(1,1);
    [Sm1,Sm2] = riemannSolverBurgersSquared(solm(1,:),solm(2,:),sol(1,:),sol(2,:),kappa,theta.*(dx/dt));
    [Sp1,Sp2] = riemannSolverBurgersSquared(sol(1,:),sol(2,:),solp(1,:),solp(2,:),kappa,(theta-1).*(dx/dt));
    sol = (theta<=(1/2)).*[Sm1;Sm2] + (theta>(1/2)) .* [Sp1;Sp2];
    
    % data update
    set(h1,'Ydata',sol(1,:));
    set(h2,'Ydata',sol(2,:));
    a.String = ['$t=',num2str(i),'$'];
    pause(0.05);
end

