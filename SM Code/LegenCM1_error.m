% LegenCM1_error.m
% Legendre-collocation method for the model equation:
% -u''(x)+alpha*u(x)=f(x), x in (-1,1);
% boundary condition: u(-1)=u(1)=0;
% exact solution: u=sin(kw*pi*x);
% RHS: f=kw*kw*pi^2*sin(kw*pi*x)+alpha*sin(kw*pi*x);
% Rmk: Use routines lepoly(); legslb(); legslbdm();
clear, clf
alp=1;
kw=1;
Nvec=4:2:30;
% Nvec=[32:2:76];  % kw=10
% Initialization for error
L2_Err=[];  Max_Err=[];
for N=Nvec
    [xv,wv]=legslb(N);          % compute LGL nodes and weights
    u=sin(kw*pi*xv);           % test solution
    udprime=-kw*kw*pi*pi*sin(kw*pi*xv);
    f=-udprime+alp*u;       % RHS
    % Setup and solve the collocation system
    D1=legslbdm(N);           % 1st order differentiation matrices
    %D1=legslbdiff(N,x);      % 1st order differentiation matrices
    D2=D1*D1;                 % 2nd order differentiation matrices
    D=(-D2(2:N-1,2:N-1)+alp*eye(N-2)); % coefficient matrix
    b=f(2:N-1);               % RHS
    un=D\b;
    un=[0;un;0];              % Solve the system
    
    L2_error=sqrt(((un-u).^2)'*wv);  % L^2 error
    Max_error=norm(abs(un-u),inf);  % maximum pointwise error 
    L2_Err=[L2_Err;L2_error];
    Max_Err=[Max_Err;Max_error];
end
% Plot L^2 and maximum pointwise error
plot(Nvec,log10(L2_Err),'bo-','MarkerFaceColor','w','LineWidth',1)
hold on
plot(Nvec,log10(Max_Err),'rd-','MarkerFaceColor','w','LineWidth',1)
grid on
legend('L^2 error','L^{\infty} error','location','NorthEast')
%title('Convergence of Legendre-collocation method','fontsize',12)
set(gca,'fontsize',12)
xlabel('N','fontsize', 14), ylabel('log_{10}Error','fontsize',14)

% sets axis tick and axis limits
xticks(0:5:30)
yticks(-16:2:0)
xlim([0 30])
ylim([-16 0])

% print -dpng -r600  LegenCM1_error.png
