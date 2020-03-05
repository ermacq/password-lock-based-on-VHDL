----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2019/08/30 14:49:50
-- Design Name: 
-- Module Name: pi - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------



LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pi is
  Port (
  clk:in std_logic;--ʱ���ź�
  led:out std_logic_vector(15 downto 0):="0000000000000000";--LED�ƶ˿ں�
  input:in bit_vector(10 downto 0):="00000000000";--���ְ�����0-9�����˸���˿�
  disp_number:out std_logic_vector(6 downto 0):="1111111";--������߶�LED�˿�
  disp_place:out std_logic_vector(7 downto 0):="11111111";--�����ʹ�ܶ˿�
  red:out std_logic:='0';--��ɫLED�˿�
  blue:out std_logic:='0';--��ɫLED�˿�
  spe:in bit:='0';        --ר�ð����˿�
  keyinput:in bit:='0';  --�������밴���˿�
  sure:in bit:='0');     --ȷ�ϼ��˿�
  
end pi;

architecture Behavioral of pi is
begin
process(clk)
variable spe_state:integer:=0;                               --ר�ð���״̬����
variable sure_state:integer:=0;                            --ȷ�ϼ�״̬����
variable keyinput_state:integer:=0;                         --���������״̬����
variable count:integer:=0;                         --�����������
variable input_temp:bit_vector(10 downto 0):="00000000000";--��һ��ʱ�̵����ְ���״̬
variable input_next:bit_vector(10 downto 0):="00000000000";--���󷵻ص����ְ���״̬����
variable spe_temp:bit:='0';                       --��һ��ʱ��ר�ð���״̬
variable keyinput_temp:bit:='0';--��һ��ʱ���������밴��״̬
variable sure_temp:bit:='0';--��һ��ʱ��ȷ�ϼ�״̬
variable spe_check:bit:='0';--�������ת���õ��ķ�ӳר�ð����Ƿ��µı���
variable sure_check:bit:='0';    --�������ת���õ��ķ�ӳȷ�ϼ��Ƿ��µı���
variable keyinput_check:bit:='0';--��������õ��ķ�ӳ�������밴���Ƿ��µı���
variable count1:integer:=0;--��̬ɨ������ڼ�������
variable count2:integer:=0;--��̬ɨ��С���ڼ�������
variable count3:integer:=0;--��̬ɨ������ڼ�������
variable count4:integer:=0;--��̬ɨ��С���ڼ�������
variable ledcnt:integer:=0;--LED����ʾ�����������
variable reg1:std_logic_vector(6 downto 0):="1111111";--�����1��ʾ����
variable reg2:std_logic_vector(6 downto 0):="1111111";--�����2��ʾ����
variable reg3:std_logic_vector(6 downto 0):="1111111";--�����3��ʾ����
variable reg4:std_logic_vector(6 downto 0):="1111111";--�����4��ʾ����
variable reg5:std_logic_vector(6 downto 0):="1111111";--����ʱ��ʾ����
variable reg6:std_logic_vector(6 downto 0):="1111111";--����ʱ��ʾ����
variable reg1_temp:std_logic_vector(6 downto 0):="1000000";--�������ô洢����
variable reg2_temp:std_logic_vector(6 downto 0):="1000000";--�������ô洢����
variable reg3_temp:std_logic_vector(6 downto 0):="1000000";--�������ô洢����
variable reg4_temp:std_logic_vector(6 downto 0):="1000000";--�������ô洢����
variable reg1_temp2:std_logic_vector(6 downto 0):="1111111";--��������洢����
variable reg2_temp2:std_logic_vector(6 downto 0):="1111111";--��������洢����
variable reg3_temp2:std_logic_vector(6 downto 0):="1111111";--��������洢����
variable reg4_temp2:std_logic_vector(6 downto 0):="1111111";--��������洢����
variable period:integer :=0;--��ʱ�����ڼ�������
variable speriod:integer :=0;--���ְ���������ʱ����
variable spe_period:integer:=0;--ר�ð���������ʱ����
variable sure_period:integer:=0;--ȷ�ϼ�������ʱ����
variable errcnt:integer:=0;--��error����ʾ�����ʱ����
variable enable:bit:='0';--�ȴ�������������
variable enable2:bit:='0';--����Ƚϳ�����������
variable led_enable:bit:='0';--LED��ȫ��������������
variable lose_time:integer:=0;--ʧ�ܴ���
variable lock:bit:='0';--����״̬����
variable open_return:bit:='0';--�����ɹ����صȴ������������
variable lose_return:bit:='0';--����ʧ�ܷ��صȴ������������
variable sure_lock:bit:='0';--ȷ�ϼ���������������
variable spe_lock:bit:='0';--ר�ð�����������������
variable lose_lock:bit:='0';--����ʧ�ܴ��������������
variable time:integer:=0;--ʱ�ӷ�Ƶ����
variable lose_wait:integer:=0;--����ʧ�ܵȴ�ʱ�����
variable lose_wait_time:integer:=0;--�ȴ�ʱ��У׼����
variable lose_wait_count:integer:=0;--����ʧ�ܵȴ���ʱ�����
variable suc_wait:integer:=0;--�����ɹ��ȴ�ʱ�����
variable lose_wait_count_lock:bit:='0';--�����ȴ�ʱ��ָ�����
begin 
if(clk 'event and clk='1')then --���ʱ��������
time:=time+1;
if(time=25) then     --ʱ�ӷ�Ƶ����ʱ������Ϊ250ns
time:=0;
period:=period+1;

if(period =27) then    --�趨ִ������Ϊ27����ʱ������
period:=0;
end if;
         
if(sure_lock='1') then
if(period<4 or period>20) then
period:=4;
end if;
if(period=5) then
period:=6;
end if;
if(period>6 and period<20) then
period:=20;
end if;
end if;   ----�����ɹ���ĳ�����ã���������ɹ�����ֻ����ִ�е�5��7��21�����ڵĳ��򣬷ֱ���LED��ȫ������ȷ�ϼ���⼰�ȴ����س�������ܶ�̬ɨ����ʾ��OPEN������

if(lose_lock='1' and lock='0') then
if(period<3 or period>25) then
period:=3;
end if;
if(period=4) then
period:=5;
end if;
if(period>5 and period<21) then
period:=21;
end if;
if(period>22 and period<25) then
period:=25;
end if;
end if;-----����ʧ���������ڵĳ�����ã��������ʧ����ʧ�ܴ��������������ڣ���ֻ����ִ�е�4��6��22��23��26���ڵĳ��򣬷ֱ��Ӧ����Ƚϣ�����״̬��⣬�ȴ��������˵���ERROR��˸������ʱ��ʾ��ȷ�ϼ���⣩

if(lock='1') then
if(period<5 or period>25) then
period:=5;
end if;
if(period>5 and period<23) then
period:=23;
end if;
end if;    ----����ʧ�����εĳ�����ã��������ʧ���Ҵ����ﵽ�����Σ���ֻ����ִ�е�6��24��25���ڳ��򣬷ֱ��Ӧ����״̬��⣬������������˸���򣬡�CLOSE��������˸����

if(enable='0') then
period:=0;
end if;       ---����ȴ�������������Ϊ0����ֻ����ѭ��ִ�д����ڳ���ֱ��ר�ð������������밴������

if(period=0) then --��һ�����ڣ����ר�ð������������밴��
if(spe_state=0 and keyinput_state=0) then

count3:=count3+1;
if(count3>400)then
count3:=0;
count4:=count4+1;
if(count4=1000)then
led<="0000000110000000";
end if;
if(count4=2000)then
led<="0000001001000000";
end if;
if(count4=3000)then
led<="0000010000100000";
end if;
if(count4=4000)then
led<="0000100000010000";
end if;
if(count4=5000)then
led<="0001000000001000";
end if;
if(count4=6000)then
led<="0010000000000100";
end if;
if(count4=7000)then
led<="0100000000000010";
end if;
if(count4=8000)then
led<="1000000000000001";
end if;
if(count4=9000)then
led<="0100000000000010";
end if;
if(count4=10000)then
led<="0010000000000100";
end if;
if(count4=11000)then
led<="0001000000001000";
end if;
if(count4=12000)then
led<="0000100000010000";
end if;
if(count4=13000)then
led<="0000010000100000";
end if;
if(count4>14000)then
led<="0000001001000000";
count4:=0;
end if;
end if;             ----���Ӷ�ײ��ʾ����

errcnt:=errcnt+1;
if(errcnt<1200000)then

count1:=count1+1;
if(count1>50)then
count1:=0;
count2:=count2+1;
if(count2=10)then
disp_place<="01111111";
disp_number<="0001011";
end if;
if(count2=20)then
disp_place<="10111111";
disp_number<="1000000";
end if;
if(count2=30)then
disp_place<="11011111";
disp_number<="1000111";
end if;
if(count2=40)then
disp_place<="11101111";
disp_number<="0100001";
end if;
if(count2=50)then
disp_place<="11111011";
disp_number<="1000000";
end if;
if(count2>60)then
disp_place<="11111101";
disp_number<="1001000";
count2:=0;
end if;
end if;

end if;
if(errcnt>1200000 and errcnt<2400000) then

disp_place<="11111111";
disp_number<="1111111";
end if;
if(errcnt>2400000) then
errcnt:=0;
end if;                         ---��hold on����˸����

spe_period:=spe_period+1;
if(spe_period=1) then  ----��ֹÿ�����������ס��һ�ε�״̬
spe_temp:=spe;
keyinput_temp:=keyinput;
end if;
if(spe_period>20000) then 
spe_check:=spe xor spe_temp;--��ǰ״̬��20msǰ��״̬��򣬷���ֵ�ɱ��������Ƿ���
spe_temp:=spe;
if(spe_check='1') then    ---����������£�����Ӧ��������ֵ
spe_state:=1;
disp_number<="1111111";
disp_place<="11111111";
lose_wait:=0;
enable:='1';
input_temp:=input;  ---��֤���ⰴ�������ְ�����������Ӱ��
end if;           ---���ר�ð����Ƿ���

keyinput_check:=keyinput xor keyinput_temp;
keyinput_temp:=keyinput;
if(keyinput_check='1') then
keyinput_state:=1;
lose_wait:=0;
enable:='1';
input_temp:=input;
end if;          ----����������밴���Ƿ���

spe_period:=0;
end if;  


end if;

end if;

if(period=1) then   ---��2�����ڣ����ȷ�ϼ��Ƿ��£����ڻع����˵����������õ�һϵ�в���
if(enable2='0') then
if(sure_state=0) then
sure_period:=sure_period+1;
if(sure_period=1) then
sure_temp:=sure;
end if;
if(sure_period>20000) then
sure_check:=sure xor sure_temp;
sure_temp:=sure;
if(sure_check='1') then
sure_state:=1;
lose_wait:=0;
end if;
sure_period:=0;
end if;
end if;
end if;
end if;   --���ȷ�ϼ��Ƿ���

if(period=2) then ---��3�����ڣ������������û������������Ӧ�ı�����¼���������ֵ
if(sure_state=1) then
if(spe_state=1) then
if(count>3) then---ֻ����������������4�Ұ���ȷ�ϼ�������²Ż�ִ��
reg1_temp:=reg1;
reg2_temp:=reg2;
reg3_temp:=reg3;
reg4_temp:=reg4;
reg1:="1111111";
reg2:="1111111";
reg3:="1111111";
reg4:="1111111";
disp_number<="1111111";
disp_place<="11111111";
count:=0;
sure_state:=0;
spe_state:=0;
enable:='0';
else
sure_state:=0;
end if;
end if;
end if;           --ȷ�ϼ����£����������ݴ�,��ʾ������ȷ�ϼ�����

if(sure_state=1) then
if(keyinput_state=1) then
if(count>3) then
reg1_temp2:=reg1;
reg2_temp2:=reg2;
reg3_temp2:=reg3;
reg4_temp2:=reg4;
reg1:="1111111";
reg2:="1111111";
reg3:="1111111";
reg4:="1111111";
disp_number<="1111111";
disp_place<="11111111";
count:=0;
sure_state:=0;
keyinput_state:=0;
enable2:='1';
else
sure_state:=0;
end if;
end if;
end if;         --ȷ�ϼ����£����������ݴ�
end if;

if(period=3) then      ---��4�����ڣ���������Ƚϣ��ı���Ӧ״̬����ֵ��������Ӧ��״̬����

if(enable2='1') then 
if(reg1_temp=reg1_temp2 and reg2_temp=reg2_temp2 and reg3_temp=reg3_temp2 and reg4_temp=reg4_temp2) then
  led_enable:='1'; --�����ɹ���ʾ��������
  sure_lock:='1';--ȷ�ϼ�����������
  enable2:='0';
else
lose_time:=lose_time+1;--����ʧ�ܴ�����1
lose_lock:='1'; --����ʧ�ܳ�������
enable2:='0';--����Ƚϳ���ر�
end if;
end if;

end if;

if( period=4) then    
if(led_enable='1') then
led<="1111111111111111";--LED��ȫ��
end if;
end if;  --�����ɹ�����

if( period=5) then     ---��6�����ڣ�����״̬ר�ð���������
if(lose_time=3) then
lock:='1';
lose_lock:='0';
if(spe_state=0) then
spe_period:=spe_period+1;
if(spe_period=1) then
spe_temp:=spe;
end if;
if(spe_period>20000) then 

spe_check:=spe xor spe_temp;
spe_temp:=spe;
if(spe_check='1') then
spe_state:=1;
end if;   
spe_period:=0;
end if;


end if;

if(spe_state=1 ) then
lose_time:=0;
lock:='0';
spe_state:=0;
enable:='0';
reg1:="1111111";
reg2:="1111111";
reg3:="1111111";
reg4:="1111111";
disp_number<="1111111";
disp_place<="11111111";
red<='0';
blue<='0';
count:=0;                        ----����״̬��λ
end if;
end if;


end if;  --����ʧ�ܳ���

if(period=6) then                 ---��7�����ڣ������ɹ�ȷ�ϼ����͵ȴ����س���
if(sure_lock='1') then

suc_wait:=suc_wait+1;
if(suc_wait<1330000) then
reg5:="1000000";
reg6:="0100100";
end if;
if(suc_wait>1330000 and suc_wait<2660000) then
reg5:="0010000";
reg6:="1111001";
end if;
if(suc_wait>2660000 and suc_wait<3990000) then
reg5:="0000000";
reg6:="1111001";
end if;
if(suc_wait>3990000 and suc_wait<5320000) then
reg5:="1111000";
reg6:="1111001";
end if;
if(suc_wait>5320000 and suc_wait<6650000) then
reg5:="0000010";
reg6:="1111001";
end if;
if(suc_wait>6650000 and suc_wait<7980000) then
reg5:="0010010";
reg6:="1111001";
end if;
if(suc_wait>7980000 and suc_wait<9310000) then
reg5:="0011001";
reg6:="1111001";
end if;
if(suc_wait>9310000 and suc_wait<10640000) then
reg5:="0110000";
reg6:="1111001";
end if;
if(suc_wait>10640000 and suc_wait<11970000) then
reg5:="0100100";
reg6:="1111001";
end if;
if(suc_wait>11970000 and suc_wait<13300000) then
reg5:="1111001";
reg6:="1111001";
end if;
if(suc_wait>13300000 and suc_wait<14630000) then
reg5:="1000000";
reg6:="1111001";
end if;
if(suc_wait>14630000 and suc_wait<15960000) then
reg5:="0010000";
reg6:="1000000";
end if;
if(suc_wait>15960000 and suc_wait<17290000) then
reg5:="0000000";
reg6:="1000000";
end if;
if(suc_wait>17290000 and suc_wait<18620000) then
reg5:="1111000";
reg6:="1000000";
end if;
if(suc_wait>18620000 and suc_wait<19950000) then
reg5:="0000010";
reg6:="1000000";
end if;
if(suc_wait>19950000 and suc_wait<21280000) then
reg5:="0010010";
reg6:="1000000";
end if;
if(suc_wait>21280000 and suc_wait<22610000) then
reg5:="0011001";
reg6:="1000000";
end if;
if(suc_wait>22610000 and suc_wait<23940000) then
reg5:="0110000";
reg6:="1000000";
end if;
if(suc_wait>23940000 and suc_wait<25270000) then
reg5:="0100100";
reg6:="1000000";
end if;
if(suc_wait>25270000 and suc_wait<26600000) then
reg5:="1111001";
reg6:="1000000";
end if;
if(suc_wait>26600000) then
reg5:="1000000";
reg6:="1000000";
end if;

if(suc_wait>26600000) then
open_return:='1';
suc_wait:=0;
end if;                                      ----����ʱ״̬ö��


if(sure_state=0) then
sure_period:=sure_period+1;
if(sure_period=1) then
sure_temp:=sure;
end if;
if(sure_period>20000) then
sure_check:=sure xor sure_temp;
sure_temp:=sure;
if(sure_check='1') then
sure_state:=1;
suc_wait:=0;
end if;
sure_period:=0;
end if;
end if;

if(sure_state=1 or open_return='1') then
sure_lock:='0';
open_return:='0';
lose_time:=0;
sure_state:=0;
enable:='0';
reg1:="1111111";
reg2:="1111111";
reg3:="1111111";
reg4:="1111111";
disp_number<="1111111";
disp_place<="11111111";
led_enable:='0';
led<="0000000000000000";
count:=0;
end if;

end if;
end if;                      --ȷ�ϼ����
if(period=7) then          ----��8�����ڣ����ְ���������
--count3:=count3+1;
--if(count3=100)then
--count3:=0;
input_next:="00000000000";   --��֤״̬������
speriod:=speriod+1;
if(speriod=1) then
input_temp:=input;
end if;
if(speriod>10000) then         --��ʱ20ms����
input_next:=input_temp xor input;
input_temp:=input;
speriod:=0;
end if;
if(count>4) then
count:=4;
end if;

end if;
if(period=8) then             ----��9-19���ڣ����ְ�������ִ�г���
if(input_next(9)='1') then
lose_wait:=0;                ----�ȴ����ر�����0
if(count=0) then
reg1:="0010000";
end if;
if(count=1) then
reg2:=reg1;
reg1:="0010000";
end if;
if(count=2) then
reg3:=reg2;
reg2:=reg1;
reg1:="0010000";
end if;
if(count=3) then
reg4:=reg3;
reg3:=reg2;
reg2:=reg1;
reg1:="0010000";
end if;
count:=count+1;               ---��������������������Ӧ�ļĴ����ƶ���ֵ
end if;
end if;

if(period=9) then
if(input_next(8)='1') then
lose_wait:=0;
if(count=0) then
reg1:="0000000";
end if;
if(count=1) then
reg2:=reg1;
reg1:="0000000";
end if;
if(count=2) then
reg3:=reg2;
reg2:=reg1;
reg1:="0000000";
end if;
if(count=3) then
reg4:=reg3;
reg3:=reg2;
reg2:=reg1;
reg1:="0000000";
end if;
count:=count+1;
end if;
end if;

if(period=10) then
if(input_next(7)='1') then
lose_wait:=0;
if(count=0) then
reg1:="1111000";
end if;
if(count=1) then
reg2:=reg1;
reg1:="1111000";
end if;
if(count=2) then
reg3:=reg2;
reg2:=reg1;
reg1:="1111000";
end if;
if(count=3) then
reg4:=reg3;
reg3:=reg2;
reg2:=reg1;
reg1:="1111000";
end if;
count:=count+1;
end if;
end if;

if(period=11) then
if(input_next(6)='1') then
lose_wait:=0;
if(count=0) then
reg1:="0000010";
end if;
if(count=1) then
reg2:=reg1;
reg1:="0000010";
end if;
if(count=2) then
reg3:=reg2;
reg2:=reg1;
reg1:="0000010";
end if;
if(count=3) then
reg4:=reg3;
reg3:=reg2;
reg2:=reg1;
reg1:="0000010";
end if;
count:=count+1;
end if;
end if;

if(period=12) then
if(input_next(5)='1') then
lose_wait:=0;
if(count=0) then
reg1:="0010010";
end if;
if(count=1) then
reg2:=reg1;
reg1:="0010010";
end if;
if(count=2) then
reg3:=reg2;
reg2:=reg1;
reg1:="0010010";
end if;
if(count=3) then
reg4:=reg3;
reg3:=reg2;
reg2:=reg1;
reg1:="0010010";
end if;
count:=count+1;
end if;
end if;

if(period=13) then
if(input_next(4)='1') then
lose_wait:=0;
if(count=0) then
reg1:="0011001";
end if;
if(count=1) then
reg2:=reg1;
reg1:="0011001";
end if;
if(count=2) then
reg3:=reg2;
reg2:=reg1;
reg1:="0011001";
end if;
if(count=3) then
reg4:=reg3;
reg3:=reg2;
reg2:=reg1;
reg1:="0011001";
end if;
count:=count+1;
end if;
end if;

if(period=14) then
if(input_next(3)='1') then
lose_wait:=0;
if(count=0) then
reg1:="0110000";
end if;
if(count=1) then
reg2:=reg1;
reg1:="0110000";
end if;
if(count=2) then
reg3:=reg2;
reg2:=reg1;
reg1:="0110000";
end if;
if(count=3) then
reg4:=reg3;
reg3:=reg2;
reg2:=reg1;
reg1:="0110000";
end if;
count:=count+1;
end if;
end if;

if(period=15) then
if(input_next(2)='1') then
lose_wait:=0;
if(count=0) then
reg1:="0100100";
end if;
if(count=1) then
reg2:=reg1;
reg1:="0100100";
end if;
if(count=2) then
reg3:=reg2;
reg2:=reg1;
reg1:="0100100";
end if;
if(count=3) then
reg4:=reg3;
reg3:=reg2;
reg2:=reg1;
reg1:="0100100";
end if;
count:=count+1;
end if;
end if;

if(period=16) then
if(input_next(1)='1') then
lose_wait:=0;
if(count=0) then
reg1:="1111001";
end if;
if(count=1) then
reg2:=reg1;
reg1:="1111001";
end if;
if(count=2) then
reg3:=reg2;
reg2:=reg1;
reg1:="1111001";
end if;
if(count=3) then
reg4:=reg3;
reg3:=reg2;
reg2:=reg1;
reg1:="1111001";
end if;
count:=count+1;
end if;
end if;

if(period=17) then
if(input_next(0)='1') then
lose_wait:=0;
if(count=0) then
reg1:="1000000";
end if;
if(count=1) then
reg2:=reg1;
reg1:="1000000";
end if;
if(count=2) then
reg3:=reg2;
reg2:=reg1;
reg1:="1000000";
end if;
if(count=3) then
reg4:=reg3;
reg3:=reg2;
reg2:=reg1;
reg1:="1000000";
end if;
count:=count+1;
end if;
end if;

if(period=18) then
if(input_next(10)='1') then
lose_wait:=0;
if(count=1) then
reg1:="1111111";
end if;
if(count=2) then
reg1:=reg2;
reg2:="1111111";
end if;
if(count=3) then
reg1:=reg2;
reg2:=reg3;
reg3:="1111111";
end if;
if(count=4) then
reg1:=reg2;
reg2:=reg3;
reg3:=reg4;
reg4:="1111111";
end if;
if(count/=0) then
count:=count-1;
end if;
end if;
end if;


if(period=19) then         ---��20�����ڣ���̬ɨ����ʾ���ֳ���

count1:=count1+1;
if(count1>25)then
count1:=0;
count2:=count2+1;
if(count2=10)then
disp_place<="11110111";
disp_number<=reg4;
end if;
if(count2=20)then
disp_place<="11111011";
disp_number<=reg3;
end if;
if(count2=30)then
disp_place<="11111101";
disp_number<=reg2;
end if;
if(count2>40)then
disp_place<="11111110";
disp_number<=reg1;
count2:=0;
end if;
end if;
end if;

if(period=20 and sure_lock='1') then    ---��21�����ڣ������ɹ���ʾ��OPEN���͵���ʱ����
errcnt:=errcnt+1;
if(errcnt<600000)then

count1:=count1+1;
if(count1=25)then
count1:=0;
count2:=count2+1;
if(count2=10)then
disp_place<="11110111";
disp_number<="1000000";
end if;
if(count2=20)then
disp_place<="11111011";
disp_number<="0001100";
end if;
if(count2=30)then
disp_place<="11111101";
disp_number<="0000110";
end if;
if(count2=40)then
disp_place<="11111110";
disp_number<="1001000";
end if;
if(count2=50) then
disp_place<="10111111";
disp_number<=reg5;
end if;
if(count2>60) then
disp_place<="01111111";
disp_number<=reg6;
count2:=0;
end if;

end if;
end if;
if(errcnt>600000 and errcnt<1200000) then

count1:=count1+1;
if(count1=25)then
count1:=0;
count2:=count2+1;
if(count2=10)then
disp_place<="11110111";
disp_number<="1111111";
end if;
if(count2=20)then
disp_place<="11111011";
disp_number<="1111111";
end if;
if(count2=30)then
disp_place<="11111101";
disp_number<="1111111";
end if;
if(count2=40)then
disp_place<="11111110";
disp_number<="1111111";
end if;
if(count2=50) then
disp_place<="10111111";
disp_number<=reg5;
end if;
if(count2>60) then
disp_place<="01111111";
disp_number<=reg6;
count2:=0;
end if;

end if;
end if;
if(errcnt>1200000) then
errcnt:=0;
end if;
end if;

if(period=21) then            ----��22�����ڣ�����ʧ��ȷ�ϼ�������
if(lose_lock='1') then

if(sure_state=0) then
sure_period:=sure_period+1;
if(sure_period=1) then
sure_temp:=sure;
end if;
if(sure_period>20000) then
sure_check:=sure xor sure_temp;
sure_temp:=sure;
if(sure_check='1') then
sure_state:=1;
end if;
sure_period:=0;
end if;
end if;

if(sure_state=1 or lose_return='1') then
lose_return:='0';
lose_wait:=0;
if(sure_state=1) then
lose_wait_time:=0;
end if;
lose_wait_count:=0;
lose_wait_count_lock:='0';
lose_lock:='0';
sure_state:=0;
enable:='0';
reg1:="1111111";
reg2:="1111111";
reg3:="1111111";
reg4:="1111111";
disp_number<="1111111";
disp_place<="11111111";
count:=0;
end if;                        ------����ʧ�ܺ�����ɴ˴��������˵�

end if;
end if;

if(period=22 and lose_lock='1') then    ----��23�����ڣ�����ʧ����ʾ��err���͵���ʱ����
led<="0000000000000000";
errcnt:=errcnt+1;
if(errcnt<600000)then

count1:=count1+1;
if(count1>25)then
count1:=0;
count2:=count2+1;
if(count2=10)then
disp_place<="11111011";
disp_number<="0000110";
end if;
if(count2=20)then
disp_place<="11111101";
disp_number<="0001000";
end if;
if(count2=30)then
disp_place<="11111110";
disp_number<="0001000";
end if;
if(count2=40)then
if(lose_time=1)then
disp_place<="11110111";
disp_number<="1111001";
end if;
if(lose_time=2) then
disp_place<="11110111";
disp_number<="0100100";
end if;
end if;
if(count2=50) then
disp_place<="10111111";
disp_number<=reg5;
end if;
if(count2>60) then
count2:=0;
disp_place<="01111111";
disp_number<=reg6;
end if;
end if;

end if;
if(errcnt>600000 and errcnt<1200000) then

count1:=count1+1;
if(count1>25)then
count1:=0;
count2:=count2+1;
if(count2=10)then
disp_place<="11111011";
disp_number<="1111111";
end if;
if(count2=20)then
disp_place<="11111101";
disp_number<="1111111";
end if;
if(count2=30)then
disp_place<="11111110";
disp_number<="1111111";
end if;
if(count2=40)then
if(lose_time=1)then
disp_place<="11110111";
disp_number<="1111111";
end if;
if(lose_time=2) then
disp_place<="11110111";
disp_number<="1111111";
end if;
end if;
if(count2=50)then
disp_place<="10111111";
disp_number<=reg5;
end if;
if(count2>60) then
disp_place<="01111111";
disp_number<=reg6;
count2:=0;
end if;

end if;
end if;
if(errcnt>1200000) then
errcnt:=0;
end if;
end if;

if(period=23 and lock='1') then     ----��24�����ڣ�����״̬������������

ledcnt:=ledcnt+1;
if(ledcnt<150000) then
red<='1';
blue<='0';
end if;

if(ledcnt>150000 and ledcnt<300000) then
red<='0';
blue<='0';
end if;

if(ledcnt>300000 and ledcnt<450000) then
red<='1';
blue<='0';
end if;

if(ledcnt>450000 and ledcnt<600000) then
red<='0';
blue<='0';
end if;

if(ledcnt>600000 and ledcnt<750000) then
red<='0';
blue<='1';
end if;

if(ledcnt>750000 and ledcnt<900000) then
red<='0';
blue<='0';
end if;

if(ledcnt>900000 and ledcnt<1050000) then
red<='0';
blue<='1';
end if;

if(ledcnt>1050000 and ledcnt<1200000) then
red<='0';
blue<='0';
end if;
if(ledcnt>1200000) then
ledcnt:=0;
end if;

end if;

if(period=24 and lock='1') then     ---��25�����ڣ�����״̬��ʾ"CLOCK"����

led<="0000000000000000";
errcnt:=errcnt+1;
if(errcnt<600000)then

count1:=count1+1;
if(count1=25)then
count1:=0;
count2:=count2+1;
if(count2=10)then
disp_place<="11101111";
disp_number<="1000110";
end if;
if(count2=20)then
disp_place<="11110111";
disp_number<="1000111";
end if;
if(count2=30)then
disp_place<="11111011";
disp_number<="1000000";
end if;
if(count2=40)then
disp_place<="11111101";
disp_number<="0010010";
end if;
if(count2>50)then
disp_place<="11111110";
disp_number<="0000110";
count2:=0;
end if;
end if;
end if;

if(errcnt>600000 and errcnt<1200000) then

disp_place<="11111111";
disp_number<="1111111";
end if;

if(errcnt>1200000) then
errcnt:=0;
end if;
end if;

if(period=25) then             -----��26�����ڣ�����ʧ�ܵȴ����س���
if(sure_lock='0' and lock='0' ) then
lose_wait:=lose_wait+1;
if(lose_lock='1') then
if(lose_wait_count_lock='0') then
lose_wait_count:=0;
lose_wait_count_lock:='1';
end if;
lose_wait_count:=lose_wait_count+1;
end if;
if(lose_wait_count<1000000) then
reg5:="1000000";
reg6:="1111001";
end if;
if(lose_wait_count>1000000 and lose_wait_count<2000000) then
reg5:="0010000";
reg6:="1000000";
end if;
if(lose_wait_count>2000000 and lose_wait_count<3000000) then
reg5:="0000000";
reg6:="1000000";
end if;
if(lose_wait_count>3000000 and lose_wait_count<4000000) then
reg5:="1111000";
reg6:="1000000";
end if;
if(lose_wait_count>4000000 and lose_wait_count<5000000) then
reg5:="0000010";
reg6:="1000000";
end if;
if(lose_wait_count>5000000 and lose_wait_count<6000000) then
reg5:="0010010";
reg6:="1000000";
end if;
if(lose_wait_count>6000000 and lose_wait_count<7000000) then
reg5:="0011001";
reg6:="1000000";
end if;
if(lose_wait_count>7000000 and lose_wait_count<8000000) then
reg5:="0110000";
reg6:="1000000";
end if;
if(lose_wait_count>8000000 and lose_wait_count<9000000) then
reg5:="0100100";
reg6:="1000000";
end if;
if(lose_wait_count>9000000 and lose_wait_count<10000000) then
reg5:="1111001";
reg6:="1000000";
end if;
if(lose_wait_count>10000000) then
reg5:="1000000";
reg6:="1000000";
end if;
                                     -----ö�ٷ��г�����ʱ״̬
if(lose_wait>2000000) then
if(lose_lock='1') then
lose_wait_time:=lose_wait_time+1;
if(lose_wait_time>4) then
lose_return:='1';
lose_wait_time:=0;
lose_wait_count:=0;
end if;
lose_wait:=0;
else
enable:='0';
lose_wait:=0;
lose_wait_count:=0;
sure_state:=0;
keyinput_state:=0;
spe_state:=0;
reg1:="1111111";
reg2:="1111111";
reg3:="1111111";
reg4:="1111111";
disp_number<="1111111";
disp_place<="11111111";
count:=0;
end if;
end if;
end if;
end if;              ------ʱ�䵽���Զ�����


if(period=26) then          -----��27�����ڣ�LED��ˮ�ƶ�������

count3:=count3+1;
if(count3>20)then
count3:=0;
count4:=count4+1;
if(count4=1000)then
led<="0000000000000001";
end if;
if(count4=2000)then
led<="0000000000000010";
end if;
if(count4=3000)then
led<="0000000000000100";
end if;
if(count4=4000)then
led<="0000000000001000";
end if;
if(count4=5000)then
led<="0000000000010000";
end if;
if(count4=6000)then
led<="0000000000100000";
end if;
if(count4=7000)then
led<="0000000001000000";
end if;
if(count4=8000)then
led<="0000000010000000";
end if;
if(count4=9000)then
led<="0000000100000000";
end if;
if(count4=10000)then
led<="0000001000000000";
end if;
if(count4=11000)then
led<="0000010000000000";
end if;
if(count4=12000)then
led<="0000100000000000";
end if;
if(count4=13000)then
led<="0001000000000000";
end if;
if(count4=14000)then
led<="0010000000000000";
end if;
if(count4=15000)then
led<="0100000000000000";
end if;
if(count4>16000)then
led<="1000000000000000";
count4:=0;
end if;
end if;



end if;


end if;
end if;
end process;
end Behavioral;
