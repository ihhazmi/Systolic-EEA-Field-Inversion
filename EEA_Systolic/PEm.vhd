----------------------------------------------------------------------------------
-- Company: 	UVic
-- Engineer: 	Ibrahim Hazmi
-- 
-- Create Date:   18:20:50 12/05/2017 
-- Design Name: 	Systolic EEA-Based Inversion
-- Module Name:   PEi - Behavioral 
-- Dependencies: 
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity PEm is
    Port ( 	qk, gin, ain, vin, rk_1, pk_1, ak_1, g0, a_r  : in  STD_LOGIC; --inputs to PE, ak1=a_{k+1}, rk_1=r_{k+1}^{(i-1)}
				clock, reset: in  STD_LOGIC;
				selg_PEi : in  STD_LOGIC_VECTOR (1 DOWNTO 0); -- MUXg Selector 
				sela_PEi, sela2_PEi, selv_PEi : in  STD_LOGIC; -- Selectors 
				Engk_PEi, Enak_PEi, Envk_PEi, Enuk_PEi, Enpk_PEi : in  STD_LOGIC; -- Enablers
				gk, ak, uk, vk, rki, pk : inout  STD_LOGIC); --  Cascaded input qk and Output of PEi
end PEm; 

architecture Behavioral of PEm is

-- If the feedback to each PE is coming from (XOR) directly, then rki, and pki should be inout!
Signal gki, pki, MUXao, MUXvo, MUXa2o, XORuo : STD_LOGIC; -- r_RegEn = GN! rk?Enrk_PEi,  

begin

-- Multiplixers
-- 4x1 MUXg
MUXg_PEi: entity work.MUX4_1bit Port Map (gin, ak, rk_1, g0, selg_PEi, gki); --gk after MUX
-- 2x1 MUXa, MUXa2, MUXu, MUXv
--MUXp_PEi: entity work.MUX2_1bit Port Map ('0', pk_1, selp_PEi, MUXpo);
MUXa_PEi: entity work.MUX2_1bit Port Map (MUXa2o, a_r, sela_PEi, MUXao); --ak after MUX
MUXv_PEi: entity work.MUX2_1bit Port Map (vin, XORuo, selv_PEi, MUXvo); 
MUXa2_PEi: entity work.MUX2_1bit Port Map (ain, ak_1, sela2_PEi, MUXa2o);
-- V should be initialized at 1 so, we might get rid of MUXv!
-- SOOO Maybe the idea is to make the register v_k of PE0 different, in which its initialization is 1!
-- Extra multiplixers for the new iteration values of a and g!
-- For U there should be another MUX, but it can replaced by selecting (p_{k-1}^{(i-1)}) as the initial value of U, 
-- then (v_k) should be the U value of each iteration after that! So the MUXu can be enough for the task

-- Register should be enable controlled
Reg_ak_PEi: entity work.Reg_1bit Port Map (clock, reset, Enak_PEi, MUXao, ak); -- Always enabled
Reg_gk_PEi: entity work.Reg_1bit Port Map (clock, reset, Engk_PEi, gki, gk); -- Always enabled
--Reg_rk_PEi: entity work.Reg_1bit Port Map (clock, reset, Enrk_PEi, rki, rk); -- Always enabled
-- V should be initialized to 1 and P to 0 (as U0=0)
Reg_vk_PEi: entity work.Reg_1bit Port Map (clock, reset, Envk_PEi, MUXvo, vk); -- Always enabled
Reg_uk_PEi: entity work.Reg_1bit Port Map (clock, reset, Enuk_PEi, vk, uk); -- Always enabled
Reg_pk_PEi: entity work.Reg_1bit Port Map (clock, reset, Enpk_PEi, pki, pk); -- Always enabled
--
rki 	<= (ak and qk) xor gk; -- gki=MUXgo
pki 	<= (vk and qk) xor pk_1; --MUXpo
XORuo <=	pki xor uk; 

end Behavioral;