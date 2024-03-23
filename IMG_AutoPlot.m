function IMG_AutoPlot(solution, UAV)
%IMG_AUTOPLOT 自适应绘图函数(画的较丑)
close all; 

% 解
Tracks = solution.Tracks;                 % 航迹们
Data = solution.Alpha_Data;               % 最优航迹信息
Fitness_list = solution.Fitness_list;     % 适应度曲线
Alpha_no = solution.Alpha_no;             % α解序号
Beta_no = solution.Beta_no;               % β解序号
Delta_no = solution.Delta_no;             % γ解序号
agent_no = Alpha_no;                      % 要绘制的解的序号


% 航迹图
if UAV.PointDim<3

    %%%%%%%%% ———— 2D仿真 ———— %%%%%%%%%
    
    figure(1)
    for i = 1:UAV.num
        x = [UAV.S(i,1),Tracks{agent_no, 1}.P{i, 1}(1,:),UAV.G(i,1)];
        y = [UAV.S(i,2),Tracks{agent_no, 1}.P{i, 1}(2,:),UAV.G(i,2)];
        plot(x,y,LineWidth=2)   
        hold on
    end
    for i = 1:UAV.num
        plot(UAV.S(i,1),UAV.S(i,2),'ko',LineWidth=1,MarkerSize=9)
        hold on
        plot(UAV.G(i,1),UAV.G(i,2),'p',color='k',LineWidth=1,MarkerSize=10)
        hold on
    end
    for i = 1:size(UAV.Menace.radar,1)
        rectangle('Position',[UAV.Menace.radar(i,1)-UAV.Menace.radar(i,3),UAV.Menace.radar(i,2)-UAV.Menace.radar(i,3),2*UAV.Menace.radar(i,3),2*UAV.Menace.radar(i,3)],'Curvature',[1,1],'EdgeColor','k','FaceColor','g')
        hold on
    end
    for i = 1:size(UAV.Menace.other,1)
        rectangle('Position',[UAV.Menace.other(i,1)-UAV.Menace.other(i,3),UAV.Menace.other(i,2)-UAV.Menace.other(i,3),2*UAV.Menace.other(i,3),2*UAV.Menace.other(i,3)],'Curvature',[1,1],'EdgeColor','k','FaceColor','c')
        hold on
    end
    for i = 1:UAV.num
        leg_str{i} = ['Track',num2str(i)];  
    end
    leg_str{UAV.num+1} = 'Start';
    leg_str{UAV.num+2} = 'End';
    legend(leg_str)
    grid on
    axis equal
    dx = (max(UAV.limt.x(:,2))-min(UAV.limt.x(:,1)))*0.06;
    dy = (max(UAV.limt.y(:,2))-min(UAV.limt.y(:,1)))*0.06;
    xlim([min(UAV.limt.x(:,1))-dx,max(UAV.limt.x(:,2))+dx])
    ylim([min(UAV.limt.y(:,1))-dy,max(UAV.limt.y(:,2))+dy])
    xlabel('x(km)')
    ylabel('y(km)')
    title('路径规划图')
else

    %%%%%%%%% ———— 3D仿真 ———— %%%%%%%%%

    figure(1)
    for i = 1:UAV.num
        x = [UAV.S(i,1),Tracks{agent_no, 1}.P{i, 1}(1,:),UAV.G(i,1)];
        y = [UAV.S(i,2),Tracks{agent_no, 1}.P{i, 1}(2,:),UAV.G(i,2)];
        z = [UAV.S(i,3),Tracks{agent_no, 1}.P{i, 1}(3,:),UAV.G(i,3)];
        plot3(x,y,z,LineWidth=2)   
        hold on
    end
    for i = 1:UAV.num
        plot3(UAV.S(i,1),UAV.S(i,2),UAV.S(i,3),'ko',LineWidth=1.3,MarkerSize=12)
        hold on
        plot3(UAV.G(i,1),UAV.G(i,2),UAV.G(i,3),'p',color='k',LineWidth=1.3,MarkerSize=13)
        hold on
    end
    for i = 1:size(UAV.Menace.radar,1)
        drawsphere(UAV.Menace.radar(i,1),UAV.Menace.radar(i,2),UAV.Menace.radar(i,3),UAV.Menace.radar(i,4),true)
        hold on
    end
    for i = 1:size(UAV.Menace.other,1)
        drawsphere(UAV.Menace.other(i,1),UAV.Menace.other(i,2),UAV.Menace.other(i,3),UAV.Menace.other(i,4))
        hold on
    end
    for i = 1:UAV.num
        leg_str{i} = ['Track',num2str(i)];  
    end
    leg_str{UAV.num+1} = 'Start';
    leg_str{UAV.num+2} = 'End';
    legend(leg_str)
    grid on
    axis square
    %axis equal
    dx = (max(UAV.limt.x(:,2))-min(UAV.limt.x(:,1)))*0.06;
    dy = (max(UAV.limt.y(:,2))-min(UAV.limt.y(:,1)))*0.06;
    dz = (max(UAV.limt.z(:,2))-min(UAV.limt.z(:,1)))*0.06;
    xlim([min(UAV.limt.x(:,1))-dx,max(UAV.limt.x(:,2))+dx])
    ylim([min(UAV.limt.y(:,1))-dy,max(UAV.limt.y(:,2))+dy])
    zlim([min(UAV.limt.z(:,1))-dz,max(UAV.limt.z(:,2))+dz])
    xlabel('x(km)')
    ylabel('y(km)')
    zlabel('z(km)')
    title('路径规划图')
end



% 适应度
figure(2)
plot(Fitness_list,'k',LineWidth=1)
grid on
xlabel('iter')
ylabel('fitness')
title('适应度曲线')



% 屏幕输出信息
fprintf('\n无人机数量：%d', UAV.num)
fprintf('\n无人机导航点个数：')
fprintf('%d,  ', UAV.PointNum)
fprintf('\n无人机飞行距离：')
fprintf('%.2fkm,  ', Data.L)
fprintf('\n无人机飞行时间：')
fprintf('%.2fs,  ', Data.t)
fprintf('\n无人机飞行速度：')
fprintf('%.2fm/s,  ', Data.L./Data.t*1e3)
fprintf('\n无人机总碰撞次数：%d', Data.c)
fprintf('\n目标函数收敛值：%.2f', Fitness_list(end))
% fprintf('\nα、β、δ 解编号：%d,  %d,  %d', Alpha_no, Beta_no, Delta_no)
fprintf('\n\n')

end



%% 绘制球面
function drawsphere(a,b,c,R,useSurf)
    % 以(a,b,c)为球心，R为半径
    if (nargin<5)
        useSurf = false;
    end
    
    % 生成数据
    [x,y,z] = sphere(20);

    % 调整半径
    x = R*x; 
    y = R*y;
    z = R*z;

    % 调整球心
    x = x+a;
    y = y+b;
    z = z+c;
    
    if useSurf
        % 使用surf绘制
        axis equal;
        surf(x,y,z);
        hold on
    else
        % 使用mesh绘制
        axis equal;
        mesh(x,y,z);
        hold on
    end
end
