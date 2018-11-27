----------------------------------------------------------------------------------
-- Company: 	UVic
-- Engineer: 	Ibrahim Hazmi
-- 
-- Create Date:   18:20:50 12/05/2017 
-- Design Name: 	Systolic EEA-Based Inversion
-- Module Name:   MUX2_1bit - Behavioral 
-- Dependencies: 
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity MUX2_1bit is
    Port ( in0 : in  STD_LOGIC;
           in1 : in  STD_LOGIC;
           ctl : in  STD_LOGIC;
           result : out  STD_LOGIC );
end MUX2_1bit;

architecture Behavioral of MUX2_1bit is

begin
result <= in1
	when (ctl = '1') 
	else in0;

end Behavioral;

