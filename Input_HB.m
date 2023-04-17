clear
t1=clock;                 %记录.m程序开始计算的起始时间
load('Initial.mat');      %基础数据
load('Changsha.mat');     %气象数据
% [Deday,EtYT,EtbYT,EtdYT,EtrYT,SNH]=designday1(E,N,TD,year1,year2);
sample=1;            %表示要计算500个不同的房间负荷，每个房间的特征参数都有所不同，
[sampletype]=sample_type(sample);  %随机取数矩阵，生成500*12的矩阵
PA=2;
LRE=0.05;
KY=0.5;
%{  
20221114注释掉
load_er0=zeros(1,8);   %负荷差异率，先设定为零矩阵，方便后面存储数据
load_er1=zeros(1,8);
load_er2=zeros(1,8);
load_er3=zeros(1,8);
load_RTS1=zeros(1,8);
load_RTS2=zeros(1,8);
load_RTS3=zeros(1,8);
%} 
load_HB1=zeros(1,8);
load_HB2=zeros(1,8);
load_HB3=zeros(1,8);
urRTS=zeros(sample,24);
%{
将矩阵按列拆分，将simpletype这个500*11的矩阵拆成4个小矩阵，
分别是cons1是500*5列，SHGC0是500*1列，glazingratio是500*1列，
cons2是500*4列
%}
for hh=1:sample                     %对指定的房间数量进行循环取数计算，
cons1=sampletype(hh,1:5);           %cons1表示建筑特征
SHGC0=sampletype(hh,6);             %窗户垂直入射时的太阳得热系数
glazingratio=sampletype(hh,7);      %窗墙比
cons2=sampletype(hh,8:11);
% m=simpletype(hh,8);                 %换气系数，定义为每小时换气量与外围护结构面积的比值之前为10
% IAC=simpletype(hh,9);               %内遮阳系数，1表示无内遮阳
% outratio=simpletype(hh,10);          %围护结构外表面吸收率
% radratio=simpletype(hh,11);          %室内辐射得热中以辐射形式转化为室内负荷的部分占总辐射得热的比例，其余部分为以对流换热（非辐射形式）转化为室内负荷，二者适用的辐射时间序列不同
Tr=26;  %室内设计温度，取24，25，26，27，28这几个
%type=randnumber1(i,11);              %2;  %室内布置类型，取值为1，2，3。分别代表轻型（简单布置），中型（中等布置），重型布置（负责布置）。与室内布置的材质以及吸收面的数量、面积有关，关系到辐射时间序列的选择
Rr=R0(sampletype(hh,12),:);            %R0(1,:),第12列; %窗户性质类型，与各角度的SGHC跟SHGC0的比值有关，可以根据初分的九类从R0中选取，也可自己设置，为1X6的数组
% 20221114注释掉下面QPR这1行
% QPR=3;  %取第三种计算方式
% [ur]=RTS(cons1,glazingratio,wall_type,window_type,iwall_type,floor_type,ceiling_type);
% urRTS(hh,:)=ur(:,1)';
% 20221114注释掉下面[load]这1行
%[load]=major_PRF(N,E,TZ,year1,year2,cons1,SHGC0,Rr,glazingratio,cons2,Tr,ASHRAEWET,B_D,TD,QPR,wall_type,window_type,iwall_type,floor_type,ceiling_type);   
[load1]=HB_main(N,E,TZ,year1,year2,cons1,SHGC0,Rr,glazingratio,cons2,Tr,ASHRAEWET,TD,wall_type,window_type,iwall_type,floor_type,ceiling_type);
%将辐射时间序列法计算出来的冷负荷进行由大到小的降序排列，并复制给矩阵aa
%20221114注释掉[aa,~]这1行
%[aa,~]=sort(load,'descend');
%将热平衡法计算出来的冷负荷进行由大到小的降序排列，并复制给矩阵bb
[bb,~]=sort(load1,'descend');
maxx1=round(0.004*size(TD,1)+1);
maxx2=round(0.01*size(TD,1)+1);
maxx3=round(0.02*size(TD,1)+1);
%%
for h=1:8    %h是指8个朝向;Orientation也可以
    %{
    load_er0(hh,h)=(aa(1,h)-bb(1,h))/bb(1,h);%峰值负荷差异率
    load_er1(hh,h)=(aa(maxx1,h)-bb(maxx1,h))/bb(maxx1,h);%负荷不保证0.4%设计负荷差异率
    load_er2(hh,h)=(aa(maxx2,h)-bb(maxx2,h))/bb(maxx2,h);%负荷不保证1%设计负荷差异率
    load_er3(hh,h)=(aa(maxx3,h)-bb(maxx3,h))/bb(maxx3,h);%负荷不保证2%设计负荷差异率
    load_RTS1(hh,h)=aa(maxx1,h);             %辐射时间序列法计算不保证率为0.4%时的设计负荷
    load_RTS2(hh,h)=aa(maxx2,h);             %辐射时间序列法计算不保证率为1%时的设计负荷
    load_RTS3(hh,h)=aa(maxx3,h);             %辐射时间序列法计算不保证率为2%时的设计负荷
   %}
    load_HB1(hh,h)=bb(maxx1,h);              %热平衡法计算不保证率为0.4%时的设计负荷
    load_HB2(hh,h)=bb(maxx2,h);              %热平衡法计算不保证率为1%时的设计负荷
    load_HB3(hh,h)=bb(maxx3,h);              %热平衡法计算不保证率为2%时的设计负荷
end
end
%[bb,~]=display(load1,'descend');%ZOU测试用的——20221114
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
% xlswrite('D:\研二\程序试验\导出文件\ER_QPR3.xlsx',{'北','东北','东','东南','南','西南','西','西北'},'sheet1','A1');
% xlswrite('D:\研二\程序试验\导出文件\ER_QPR3.xlsx',{'北','东北','东','东南','南','西南','西','西北'},'sheet2','A1');
% xlswrite('D:\研二\程序试验\导出文件\ER_QPR3.xlsx',{'北','东北','东','东南','南','西南','西','西北'},'sheet3','A1');
% xlswrite('D:\研二\程序试验\导出文件\ER_QPR3.xlsx',{'北','东北','东','东南','南','西南','西','西北'},'sheet4','A1');
% xlswrite('D:\研二\程序试验\导出文件\ER_QPR3.xlsx',load_er0,'sheet1','A2');
% xlswrite('D:\研二\程序试验\导出文件\ER_QPR3.xlsx',load_er1,'sheet2','A2');
% xlswrite('D:\研二\程序试验\导出文件\ER_QPR3.xlsx',load_er2,'sheet3','A2');
% xlswrite('D:\研二\程序试验\导出文件\ER_QPR3.xlsx',load_er3,'sheet4','A2');
% outputfilename='D:\研二\程序试验\导出文件\ER_QPR1.xlsx';  % the folder should be modified
% xlswrite('D:\研二\程序试验\导出文件\simpletype.xlsx',{'外墙','内墙','窗户','地板','天花板','SHGCO','窗墙比','新风系数','内遮阳系数','外表面吸收率','辐射比','太阳得热系数'},'sheet1','A1');
% xlswrite('D:\研二\程序试验\导出文件\simpletype.xlsx',simpletype,'sheet1','A2');
%目的；比较热平衡法与辐射时间序列法计算出来的峰值冷负荷，不保证设计冷负荷的偏差有多大；进而比较这两种方法生成的同时发生气象参数？（自己的理解）
%时间：20220920
%地点：除尘楼


