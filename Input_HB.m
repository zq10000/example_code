clear
t1=clock;                 %��¼.m����ʼ�������ʼʱ��
load('Initial.mat');      %��������
load('Changsha.mat');     %��������
% [Deday,EtYT,EtbYT,EtdYT,EtrYT,SNH]=designday1(E,N,TD,year1,year2);
sample=1;            %��ʾҪ����500����ͬ�ķ��为�ɣ�ÿ�����������������������ͬ��
[sampletype]=sample_type(sample);  %���ȡ����������500*12�ľ���
PA=2;
LRE=0.05;
KY=0.5;
%{  
20221114ע�͵�
load_er0=zeros(1,8);   %���ɲ����ʣ����趨Ϊ����󣬷������洢����
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
�������в�֣���simpletype���500*11�ľ�����4��С����
�ֱ���cons1��500*5�У�SHGC0��500*1�У�glazingratio��500*1�У�
cons2��500*4��
%}
for hh=1:sample                     %��ָ���ķ�����������ѭ��ȡ�����㣬
cons1=sampletype(hh,1:5);           %cons1��ʾ��������
SHGC0=sampletype(hh,6);             %������ֱ����ʱ��̫������ϵ��
glazingratio=sampletype(hh,7);      %��ǽ��
cons2=sampletype(hh,8:11);
% m=simpletype(hh,8);                 %����ϵ��������ΪÿСʱ����������Χ���ṹ����ı�ֵ֮ǰΪ10
% IAC=simpletype(hh,9);               %������ϵ����1��ʾ��������
% outratio=simpletype(hh,10);          %Χ���ṹ�����������
% radratio=simpletype(hh,11);          %���ڷ���������Է�����ʽת��Ϊ���ڸ��ɵĲ���ռ�ܷ�����ȵı��������ಿ��Ϊ�Զ������ȣ��Ƿ�����ʽ��ת��Ϊ���ڸ��ɣ��������õķ���ʱ�����в�ͬ
Tr=26;  %��������¶ȣ�ȡ24��25��26��27��28�⼸��
%type=randnumber1(i,11);              %2;  %���ڲ������ͣ�ȡֵΪ1��2��3���ֱ�������ͣ��򵥲��ã������ͣ��еȲ��ã������Ͳ��ã������ã��������ڲ��õĲ����Լ������������������йأ���ϵ������ʱ�����е�ѡ��
Rr=R0(sampletype(hh,12),:);            %R0(1,:),��12��; %�����������ͣ�����Ƕȵ�SGHC��SHGC0�ı�ֵ�йأ����Ը��ݳ��ֵľ����R0��ѡȡ��Ҳ���Լ����ã�Ϊ1X6������
% 20221114ע�͵�����QPR��1��
% QPR=3;  %ȡ�����ּ��㷽ʽ
% [ur]=RTS(cons1,glazingratio,wall_type,window_type,iwall_type,floor_type,ceiling_type);
% urRTS(hh,:)=ur(:,1)';
% 20221114ע�͵�����[load]��1��
%[load]=major_PRF(N,E,TZ,year1,year2,cons1,SHGC0,Rr,glazingratio,cons2,Tr,ASHRAEWET,B_D,TD,QPR,wall_type,window_type,iwall_type,floor_type,ceiling_type);   
[load1]=HB_main(N,E,TZ,year1,year2,cons1,SHGC0,Rr,glazingratio,cons2,Tr,ASHRAEWET,TD,wall_type,window_type,iwall_type,floor_type,ceiling_type);
%������ʱ�����з�����������为�ɽ����ɴ�С�Ľ������У������Ƹ�����aa
%20221114ע�͵�[aa,~]��1��
%[aa,~]=sort(load,'descend');
%����ƽ�ⷨ����������为�ɽ����ɴ�С�Ľ������У������Ƹ�����bb
[bb,~]=sort(load1,'descend');
maxx1=round(0.004*size(TD,1)+1);
maxx2=round(0.01*size(TD,1)+1);
maxx3=round(0.02*size(TD,1)+1);
%%
for h=1:8    %h��ָ8������;OrientationҲ����
    %{
    load_er0(hh,h)=(aa(1,h)-bb(1,h))/bb(1,h);%��ֵ���ɲ�����
    load_er1(hh,h)=(aa(maxx1,h)-bb(maxx1,h))/bb(maxx1,h);%���ɲ���֤0.4%��Ƹ��ɲ�����
    load_er2(hh,h)=(aa(maxx2,h)-bb(maxx2,h))/bb(maxx2,h);%���ɲ���֤1%��Ƹ��ɲ�����
    load_er3(hh,h)=(aa(maxx3,h)-bb(maxx3,h))/bb(maxx3,h);%���ɲ���֤2%��Ƹ��ɲ�����
    load_RTS1(hh,h)=aa(maxx1,h);             %����ʱ�����з����㲻��֤��Ϊ0.4%ʱ����Ƹ���
    load_RTS2(hh,h)=aa(maxx2,h);             %����ʱ�����з����㲻��֤��Ϊ1%ʱ����Ƹ���
    load_RTS3(hh,h)=aa(maxx3,h);             %����ʱ�����з����㲻��֤��Ϊ2%ʱ����Ƹ���
   %}
    load_HB1(hh,h)=bb(maxx1,h);              %��ƽ�ⷨ���㲻��֤��Ϊ0.4%ʱ����Ƹ���
    load_HB2(hh,h)=bb(maxx2,h);              %��ƽ�ⷨ���㲻��֤��Ϊ1%ʱ����Ƹ���
    load_HB3(hh,h)=bb(maxx3,h);              %��ƽ�ⷨ���㲻��֤��Ϊ2%ʱ����Ƹ���
end
end
%[bb,~]=display(load1,'descend');%ZOU�����õġ���20221114
t2=clock;             %��¼.m��������������ֹʱ��
TIME=etime(t2,t1);    %t2��t1�ļ���¼.m�������л����˶೤ʱ��
% clearvars -except weatherdata TIME load   %�������weatherdata���������

%ע1��weatherdata��1��8�зֱ������N����������NE��������E�������ϣ�SE�����ϣ�S�������ϣ�SW��������W����������NW����ͬʱ������������

%ע2��ÿһ������������У���һ�е�1-4�зֱ�����������Լ���󸺺�ʱ�̣�3-26��Ϊ���ɵ�ͬʱ�����������ݣ�����
            %��һ�У������¶ȣ��棩
            %�ڶ��У�ʪ���¶ȣ��棩
            %�����У�ˮƽ���ܷ��䣨W/�O��
            %�����У�����ֱ����䣨W/�O��
            %�����У�����ɢ����䣨W/�O��
            %�����У����淴����䣨W/�O��
            %�����У������ܷ��䣨W/�O��
            %�ڰ��У���Χ���ṹ���µ����ڸ��ɣ���λ��Wÿƽ������Χ���ṹ�����ע�Ⲣ�Ƿ��������
            %�ھ��У������������µ����ڸ��ɣ���λ��ͬ�ϣ�
            %��ʮ�У�̫�����䵼�µ����ڸ��ɣ���λ��ͬ�ϣ�
            %��ʮһ�У������ܸ��ɣ���λ��ͬ�ϣ�
% xlswrite('D:\�ж�\��������\�����ļ�\ER_QPR3.xlsx',{'��','����','��','����','��','����','��','����'},'sheet1','A1');
% xlswrite('D:\�ж�\��������\�����ļ�\ER_QPR3.xlsx',{'��','����','��','����','��','����','��','����'},'sheet2','A1');
% xlswrite('D:\�ж�\��������\�����ļ�\ER_QPR3.xlsx',{'��','����','��','����','��','����','��','����'},'sheet3','A1');
% xlswrite('D:\�ж�\��������\�����ļ�\ER_QPR3.xlsx',{'��','����','��','����','��','����','��','����'},'sheet4','A1');
% xlswrite('D:\�ж�\��������\�����ļ�\ER_QPR3.xlsx',load_er0,'sheet1','A2');
% xlswrite('D:\�ж�\��������\�����ļ�\ER_QPR3.xlsx',load_er1,'sheet2','A2');
% xlswrite('D:\�ж�\��������\�����ļ�\ER_QPR3.xlsx',load_er2,'sheet3','A2');
% xlswrite('D:\�ж�\��������\�����ļ�\ER_QPR3.xlsx',load_er3,'sheet4','A2');
% outputfilename='D:\�ж�\��������\�����ļ�\ER_QPR1.xlsx';  % the folder should be modified
% xlswrite('D:\�ж�\��������\�����ļ�\simpletype.xlsx',{'��ǽ','��ǽ','����','�ذ�','�컨��','SHGCO','��ǽ��','�·�ϵ��','������ϵ��','�����������','�����','̫������ϵ��'},'sheet1','A1');
% xlswrite('D:\�ж�\��������\�����ļ�\simpletype.xlsx',simpletype,'sheet1','A2');
%Ŀ�ģ��Ƚ���ƽ�ⷨ�����ʱ�����з���������ķ�ֵ�为�ɣ�����֤����为�ɵ�ƫ���ж�󣻽����Ƚ������ַ������ɵ�ͬʱ����������������Լ�����⣩
%ʱ�䣺20220920
%�ص㣺����¥


