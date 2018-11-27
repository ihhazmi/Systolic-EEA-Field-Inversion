----------------------------------------------------------------------------------
-- Company: 	UVic
-- Engineer: 	Ibrahim Hazmi
-- 
-- Create Date:    20:41:58 12/05/2017 
-- Design Name: 	 Systolic EEA-Based Inversion
-- Module Name:    Reg_1bit - Behavioral 
-- Target Devices: SPARTAN6 - XC6SLX45T
-- Tool versions:  ISE 13.4
-- Dependencies: 
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;


entity Reg_1bit is
	port (
				clock, reset, En: in STD_LOGIC;
				D: in STD_LOGIC; -- Input bus
				Q: out STD_LOGIC 
			); 
end Reg_1bit;

architecture beh of Reg_1bit is
-- Is it ok to add a signal to initialize either to '0' or '1'?

begin

	process(clock, reset, En)
	begin
		if (reset = '1') then
			Q <= '0';
		else if (rising_edge(clock)) then
			IF (En ='1') THEN
				Q <= D;
			ELSE
				NULL;
			END IF;
		end if;
		end if;
	end process;

end beh;