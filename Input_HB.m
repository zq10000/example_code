clear
t1=clock;                 %记录.m程序开始计算的起始时间
load('Initial.mat');      %加载基础数据
load('Changsha.mat');     %加载气象数据
sample=1;                 %表示要计算500个不同的房间负荷，每个房间的特征参数都有所不同，
[sampletype]=sample_type(sample);  %随机取数矩阵，生成500*12的矩阵
PA=2;
LRE=0.05;
KY=0.5;
load_HB1=zeros(1,8);
load_HB2=zeros(1,8);
load_HB3=zeros(1,8);
urRTS=zeros(sample,24);
for hh=1:sample                     %对指定的房间数量进行循环取数计算，
cons1=sampletype(hh,1:5);           %cons1表示建筑特征
SHGC0=sampletype(hh,6);             %窗户垂直入射时的太阳得热系数
glazingratio=sampletype(hh,7);      %窗墙比
cons2=sampletype(hh,8:11);
Tr=26;  %室内设计温度，取24，25，26，27，28这几个
Rr=R0(sampletype(hh,12),:);            %R0(1,:),第12列; %窗户性质类型，与各角度的SGHC跟SHGC0的比值有关，可以根据初分的九类从R0中选取，也可自己设置，为1X6的数组 
[load1]=HB_main(N,E,TZ,year1,year2,cons1,SHGC0,Rr,glazingratio,cons2,Tr,ASHRAEWET,TD,wall_type,window_type,iwall_type,floor_type,ceiling_type);
[bb,~]=sort(load1,'descend');
maxx1=round(0.004*size(TD,1)+1);
maxx2=round(0.01*size(TD,1)+1);
maxx3=round(0.02*size(TD,1)+1);
%%
for h=1:8    %h是指8个朝向;Orientation也可以
    load_HB1(hh,h)=bb(maxx1,h);              %热平衡法计算不保证率为0.4%时的设计负荷
    load_HB2(hh,h)=bb(maxx2,h);              %热平衡法计算不保证率为1%时的设计负荷
    load_HB3(hh,h)=bb(maxx3,h);              %热平衡法计算不保证率为2%时的设计负荷
end
end
t2=clock;             %记录.m程序结束计算的终止时间
TIME=etime(t2,t1);    %t2与t1的间差，记录.m程序运行花费了多长时间
% clearvars -except weatherdata TIME load   %清除除了weatherdata以外的数据

%注1：weatherdata的1至8列分别代表北（N），东北（NE），东（E），东南（SE），南（S），西南（SW），西（W）和西北（NW）的同时发生气象数据

%注2：每一个朝向的数据中，第一行的1-4列分别代表年月日以及最大负荷时刻，3-26行为生成的同时发生气象数据，其中
            %第一列：干球温度（℃）
            %第二列：湿球温度（℃）
            %第三列：水平面总辐射（W/㎡）
            %第四列：立面直射辐射（W/㎡）
            %第五列：立面散射辐射（W/㎡）
            %第六列：地面反射辐射（W/㎡）
            %第七列：立面总辐射（W/㎡）
            %第八列：外围护结构导致的室内负荷（单位：W每平方米外围护结构面积，注意并非房间面积）
            %第九列：空气交换导致的室内负荷（单位：同上）
            %第十列：太阳辐射导致的室内负荷（单位：同上）
            %第十一列：室内总负荷（单位：同上）
