%-----------------------------------
%
%  plot file
%  all plots are called from here
%
%-----------------------------------
close all;
i=0;
fontsize=12;


%% ---------- commanded zeta and xi --------------------------------
i=i+1;
h(i)=figure(i);
set(h(i),'Units','normalized');
%set(h(i),'Position',[0.1,0.3,0.4,0.4]);
set(h(i), 'name', 'Fig: Commanded xi and zeta','NumberTitle','off');


subplot(3,2,4);
plot(time, zeta_com(7:12, :));
title('Manipulator commanded joint rates');
xlabel('time [s]'); ylabel('[m/s]');
leg=legend('$\dot{q}_1$','$\dot q_2$','$\dot q_3$', '$\dot q_4$', '$\dot q_5$', '$\dot q_6$');
set(leg,'Interpreter','latex')
grid on;

subplot(3,2,3);
plot(time, zeta_com(1:6, :));
title('Vehichle body commanded velocities');
xlabel('time [s]'); ylabel('[m/s , deg/s]');
legend('u','v','w','p','q','r');
grid on;

subplot(3,2,1);
plot(time, [eta1_com(:,:), r2d*eta2_com(:,:)]);
title('Commanded vehicle position');
xlabel('time [s]'); ylabel('[m, deg]');
leg=legend('x','y','z','$\phi$','$\theta$','$\psi$');
set(leg,'Interpreter','latex');
grid on;

subplot(3,2,2);
plot(time, r2d*q_com(:,:));
title('Commanded joint angle');
xlabel('time [s]'); ylabel('angle [deg]');
leg=legend('$q_1$','$q_2$','$q_3$','$q_4$','$q_5$','$q_6$');
set(leg,'Interpreter','latex');
grid on;


subplot(3,2,6);
plot(time, dzeta_com(7:12, :));
title('Commanded manipulator joint acceleration');
xlabel('time [s]'); ylabel('[m/s]');
leg=legend('$\ddot{q}_1$','$\ddot q_2$','$\ddot q_3$', '$\ddot q_4$', '$\ddot q_5$', '$\ddot q_6$');
set(leg,'Interpreter','latex');
grid on;

subplot(3,2,5);
plot(time, dzeta_com(1:6, :));
title('Commanded vehichle body acceleration');
xlabel('time [s]'); ylabel('[m/s , deg/s]');
leg=legend('$\dot{u}_1$','$\dot v_2$','$\dot w_3$', '$\dot p_4$', '$\dot q_5$', '$\dot r_6$');
set(leg,'Interpreter','latex')
grid on;

if KINEMATICS_ONLY == true 
    %% ---------- end effector --------------------------------
    i=i+1;
    h(i)=figure(i);
    set(h(i), 'name', 'Fig: End Effector','NumberTitle','off');
    subplot(2,2,1);
    plot3(ee_pose_com(:,1),ee_pose_com(:,2),ee_pose_com(:,3), '-r');
    hold on;
    plot3(ee_pose_mes(:,1),ee_pose_mes(:,2),ee_pose_mes(:,3), '-g');
    legend('Commanded trajectory', 'Measured Trajectory');

    plot3(ee_pose_com(1,1),ee_pose_com(1,2),ee_pose_com(1,3), 'or');
    text(ee_pose_com(1,1),ee_pose_com(1,2),ee_pose_com(1,3),'  start','HorizontalAlignment','left','FontSize',8);
    grid on;
    axis([-4,4,-4,4,-4,4]);
    xlabel ('x') ; ylabel ('y'); zlabel('z');

    vec = [ee_pose_com(:,4:6) ; ee_pose_mes(:, 4:6) ] ;
    axismin = min(vec(:) ) * r2d - 10;
    axismax = max( vec(:)) * r2d + 10;
    clear vec;

    subplot(2,2,2);
    plot(time, ee_pose_com(:,4:6)*r2d);
    leg=legend('$\phi$', '$\theta$', '$\psi$');
    set(leg,'Interpreter','latex');
    title('Commanded End Effector Pose');
    grid on;
    yaxis([axismin,axismax]);

    subplot(2,2,4);
    aPlot = plot(time, ee_pose_mes(:,4:6)*r2d);
    leg=legend('$\phi$', '$\theta$', '$\psi$');
    set(leg,'Interpreter','latex');
    title('Measured End Effector Pose');
    grid on;
    yaxis([axismin,axismax]);


    %% ---------- weighting matrix --------------------------

    i=i+1;
    h(i)=figure(i);
    set(h(i),'Units','normalized');
    set(h(i), 'name', 'Fig: Weighting Matrix W','NumberTitle','off');

    subplot(2,3,2);
    plot(time,W_diag(:,1:6));
    leg=legend('$w_{1,1}$','$w_{2,2}$','$w_{3,3}$','$w_{4,4}$','$w_{5,5}$','$w_{6,6}$');
    set(leg,'Interpreter','latex');
    title('W matrix vehicle');
    grid on;
    xlabel('time [s]'); ylabel('w');

    subplot(2,3,4);
    plot(time,W_diag(:,7:12));
    leg=legend('$w_{7,7}$','$w_{8,8}$','$w_{9,9}$','$w_{10,10}$','$w_{11,11 }$','$w_{12,12}$');
    set(leg,'Interpreter','latex');
    title('W matrix manipulator');
    grid on;
    xlabel('time [s]'); ylabel('w');

    subplot(2,3,1);
    plot(time,VVStatusLinear, '.-b');
    title('StatusLinear of Vehicle Velocity Assigner');
    grid on;

    subplot(2,3,6);
    plot(time,VVStatusAngular, '.-b');
    title('StatusAngular of Vehicle Velocity Assigner');
    grid on;

    subplot(2,3,3);
    plot(time, Circle2EEVec);
    title('Vector from Center of circle to end effector');
    legend('x', 'y', 'z');
    grid on;


    subplot(2,3,5);
    plot(time, VdotP );
    title('Inner product between p_se and V_ee');
    xlabel('time [s]'); ylabel('p dot V ');
    grid on;


    %% ---------- Vs secondary trajectory commanded vehicle and EE trajectory --------------------------

    i=i+1;
    h(i)=figure(i);
    set(h(i),'Units','normalized');
    set(h(i), 'name', 'Fig: Vs','NumberTitle','off');
    subplot(2,1,1);
    plot(time, vs_com);
    title('V secondary trajectory - Vehichle body commanded velocities');
    xlabel('time [s]'); ylabel('[m/s , deg/s]');
    legend('u','v','w','p','q','r');
    grid on;

    subplot(2,1,2);
    plot(time, ee_v_com(:,1:6));
    title('End effector commanded velocities');
    xlabel('time [s]'); ylabel('[m/s , deg/s]');
    legend('u','v','w','p','q','r');
    grid on;
    
end % end KINEMATICS ONLY = true


%%
if KINEMATICS_ONLY == false 

    %% -------------- measured xi and zeta ---------------
    i=i+1;
    h(i)=figure(i);
    set(h(i), 'name', 'Fig: Measured xi and zeta','NumberTitle','off');
    set(h(i),'Units','normalized');
    %set(h(i),'Position',[0.1,0.3,0.4,0.4]);

    subplot(3,2,2);
    plot(time, zeta_mes(7:12, :));
    title('Measured manipulator joint rates');
    xlabel('time [s]'); ylabel('[m/s]');
    leg=legend('$\dot{q}_1$','$\dot q_2$','$\dot q_3$', '$\dot q_4$', '$\dot q_5$', '$\dot q_6$');
    set(leg,'Interpreter','latex')
    grid on;

    subplot(3,2,1);
    plot(time, zeta_mes(1:6, :));
    title('Measured vehichle body velocities');
    xlabel('time [s]'); ylabel('[m/s , deg/s]');
    legend('u','v','w','p','q','r');
    grid on;

    subplot(3,2,3);
    plot(time, [eta1_mes(:,:), r2d*eta2_mes(:,:)]);
    title('Measured vehicle position');
    xlabel('time [s]'); ylabel('[m, deg]');
    leg=legend('x','y','z','$\phi$','$\theta$','$\psi$');
    set(leg,'Interpreter','latex');
    grid on;


    subplot(3,2,4);
    plot(time, r2d*q_mes(:,:));
    title('Measured joint angle');
    xlabel('time [s]'); ylabel('angle [deg]');
    leg=legend('$q_1$','$q_2$','$q_3$','$q_4$','$q_5$','$q_6$');
    set(leg,'Interpreter','latex');
    grid on;


    subplot(3,2,5);
    plot(time, dzeta_mes(7:12, :));
    title('Measured manipulator joint acceleration');
    xlabel('time [s]'); ylabel('[m/s]');
    leg=legend('$\ddot{q}_1$','$\ddot q_2$','$\ddot q_3$', '$\ddot q_4$', '$\ddot q_5$', '$\ddot q_6$');
    set(leg,'Interpreter','latex');
    grid on;

    subplot(3,2,6);
    plot(time, dzeta_mes(1:6, :));
    title('Measured vehichle body acceleration');
    xlabel('time [s]'); ylabel('[m/s , deg/s]');
    leg=legend('$\dot{u}_1$','$\dot v_2$','$\dot w_3$', '$\dot p_4$', '$\dot q_5$', '$\dot r_6$');
    set(leg,'Interpreter','latex')
    grid on;



    %% --------------- commanded torque ---------------------
    i=i+1;
    h(i)=figure(i);
    set(h(i), 'name', 'Fig: Commanded torque','NumberTitle','off');
    set(h(i),'Units','normalized');
    %set(h(i),'Position',[0.1,0.3,0.4,0.4]);

    subplot(2,1,1);
    plot(time, tau(1:6,:));
    title('Commanded torque to vehicle (output from controller)');
    xlabel('time [s]'); ylabel('[m/s]');
    leg=legend('$\tau_1$','$\tau_2$','$\tau_3$', '$\tau_4$', '$\tau_5$', '$\tau_6$');
    set(leg,'Interpreter','latex')
    grid on;

    subplot(2,1,2);
    plot(time, tau(7:12,:));
    title('Commanded torque to manipulator (output from controller)');
    xlabel('time [s]'); ylabel('[m/s]');
    leg=legend('$\tau_7$','$\tau_8$','$\tau_9$', '$\tau_{10}$', '$\tau_{11}$', '$\tau_{12}$');
    set(leg,'Interpreter','latex')
    grid on;


    %% ------------- error states (tilde)-------------------
    i=i+1;
    h(i)=figure(i);
    set(h(i),'Units','normalized');
    %set(h(i),'Position',[0.1,0.3,0.4,0.4]);
    set(h(i), 'name', 'Fig: Error States','NumberTitle','off');


    subplot(2,2,1);
    plot(time, zeta_tilde(1:6,:));
    title('Error vehicle velocity');
    xlabel('time [s]'); ylabel('[m/s]');
    legend('u','v','w','p','q','r');
    grid on;


    subplot(2,2,2);
    plot(time, zeta_tilde(7:12,:));
    title('Error Manipulator velocity');
    xlabel('time [s]'); ylabel('[m/s]');
    leg=legend('$\dot{q}_1$','$\dot q_2$','$\dot q_3$', '$\dot q_4$', '$\dot q_5$', '$\dot q_6$');
    set(leg,'Interpreter','latex')
    grid on;


    subplot(2,2,3);
    plot(time, [xi_tilde(1:3,:); r2d*xi_tilde(4:6,:)]);
    title('Error vehicle position');
    xlabel('time [s]'); ylabel('[m, deg]');
    leg=legend('x','y','z','$\phi$','$\theta$','$\psi$');
    set(leg,'Interpreter','latex');
    grid on;


    subplot(2,2,4);
    plot(time, r2d*xi_tilde(7:12,:));
    title('Error joint angle');
    xlabel('time [s]'); ylabel('angle [deg]');
    leg=legend('$q_1$','$q_2$','$q_3$','$q_4$','$q_5$','$q_6$');
    set(leg,'Interpreter','latex');
    grid on;

    %% --------------- specific forces  ---------------------
    i=i+1;
    h(i)=figure(i);
    set(h(i), 'name', 'Fig: Specific Forces','NumberTitle','off');

    subplot(2,1,1);
    plot(time, specific_forces(1:6,:));
    title('Specific forces vehicle )');
    xlabel('time [s]'); ylabel('[m/s]');
    leg=legend('$\tau_1$','$\tau_2$','$\tau_3$', '$\tau_4$', '$\tau_5$', '$\tau_6$');
    set(leg,'Interpreter','latex')
    grid on;

    subplot(2,1,2);
    plot(time, specific_forces(7:12,:));
    title('Specific forces - Manipulator');
    xlabel('time [s]'); ylabel('[m/s]');
    leg=legend('$\tau_7$','$\tau_8$','$\tau_9$', '$\tau_{10}$', '$\tau_{11}$', '$\tau_{12}$');
    set(leg,'Interpreter','latex')
    grid on;
end % end KINEMATICS_ONLY == false


%%
%figHandles = get(0,'Children');
% # make all text in the figure to size 14 and bold
%set(findall(figHandles,'type','text'),'fontSize',13,'fontWeight','bold')

% use code below to force the plot to be vector based
%print -depsc2 -painters test3.eps

% use this to get good png .. later use linux cmd tool convert 
%print(gcf,'latex/untitled.png','-dpng','-r800','-opengl')




