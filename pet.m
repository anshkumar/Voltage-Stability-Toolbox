
global epsilon1;
global epsilon2;
global h;

epsilon1=10^(-9);
epsilon2=10^(-9);
h=10^(-7);
x0=[1 2];
tspan=[0 10];
[t,x]=ode45('algebraic',tspan,x0);
plot(t,x(:,1));
figure
plot(t,x(:,2));
