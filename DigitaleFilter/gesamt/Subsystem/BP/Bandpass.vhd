library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all; 

ENTITY Bandpass IS
  GENERIC(
  input_width:integer:=14;
  output_width:integer:=14
  );  
PORT(
  clk:IN STD_LOGIC;
  --rst:IN STD_LOGIC;
  x_input:IN SIGNED(input_width-1 downto 0);
  y_output:OUT SIGNED(output_width-1 downto 0)
  );
END Bandpass;

ARCHITECTURE BEHAVIOR OF Bandpass is

COMPONENT DFF_14_bit IS
  GENERIC(
  signal_width:integer:=14
  );
PORT(
  clk:IN STD_LOGIC;
  signal_input:IN SIGNED(signal_width-1 downto 0);
  signal_output:OUT SIGNED(signal_width-1 downto 0)
);
END COMPONENT; 
CONSTANT a0:SIGNED(2 downto 0):="110";  --(-0,5)
CONSTANT a1:SIGNED(2 downto 0):="000";  --0 
CONSTANT a2:SIGNED(2 downto 0):="010";  --0,5
SIGNAL S1,S2,S3:SIGNED(output_width-1 downto 0):=(others=>'0');
SIGNAL M_tmp1,M_tmp2,M_tmp3:SIGNED(output_width-1+3 downto 0):=(others=>'0');
SIGNAL M1,M2,M3:SIGNED(output_width-1 downto 0):=(others=>'0');
SIGNAL D1,D2,D3:SIGNED(output_width-1 downto 0):=(others=>'0');
BEGIN
dff1: DFF_14_bit port map(clk,x_input,D1);
dff2: DFF_14_bit port map(clk,D1,D2);
--dff2: DFF_14_bit port map(clk,D2,D3);

M_tmp1<=x_input*a0;
M1<=M_tmp1(15 DOWNTO 2);
M_tmp2<=D1*a1;
M2<=M_tmp2(15 DOWNTO 2);
M_tmp3<=D2*a2;
M3<=M_tmp3(15 DOWNTO 2);

S1<=M1+M2;
S2<=S1+M3;

PROCESS(clk)
BEGIN
  IF (rising_edge(clk)) THEN
    y_output<=S2;
  END IF;
END PROCESS;

END BEHAVIOR;