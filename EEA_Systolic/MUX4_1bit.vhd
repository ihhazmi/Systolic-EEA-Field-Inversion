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

entity MUX4_1bit is
    Port ( in0, in1, in2, in3 : in  STD_LOGIC;
           ctl : in  STD_LOGIC_VECTOR (1 DOWNTO 0);
           result : out  STD_LOGIC );
end MUX4_1bit;

architecture Behavioral of MUX4_1bit is

begin

result <= 	in0	when (ctl = "00") 
		else 	in1	when (ctl = "01")
		else 	in2	when (ctl = "10")
		else 	in3;


end Behavioral;

--	process(in0, in1, in2, in3, ctl)
--		begin
--			case ctl is
--				when "00"	=> result <= in0;
--				when "01"	=> result <= in1;
--				when "10"	=> result <= in2;
--				when "11"	=> result <= in3;
--				when others => result <= 'Z';
--			end case;
--	end process;

