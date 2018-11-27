----------------------------------------------------------------------------------
-- Company:  UVic
-- Engineer: Ibrahim Hazmi
-- Create Date:    14:18:54 12/12/2017 
-- Module Name:    This is a simple up/down ripple counter
-- Revision 0.01 - File Created
-- Additional Comments: 
----------------------------------------------------------------------------------
library IEEE;	
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity UD_Cnt is
	generic (n : integer:=3 ); --n:= 5
	port (
			clock, clear	: in std_logic;
			up  				: in std_logic; -- up controls the direction where '1' mean up and '0' mean down
			dout  			: out std_logic_vector(n-1 downto 0)
				);
end UD_Cnt;

architecture Behavioral of UD_Cnt is
signal temp: std_logic_vector(n-1 downto 0);
begin
	process(clock,clear)
	begin
		if clear='1' then
		temp(0) <= '1';
		temp(n-1 downto 1) <= (others => '0'); --temp(n-1 downto 1)<= (others => '0');
		elsif (rising_edge(clock)) then
		if( up='1') then
			temp <= temp + 1;
		elsif (up='0') then
			temp <= temp - 1;
		end if;
		end if;
end process;
dout <= temp;
end Behavioral;
-- ~~~~~~~~ ~~~~~~~~ ~~~~~~~~ ~~~~~~~~ ~~~~~~~~ ~~~~~~~~