----------------------------------------------------------------------------------
-- Company: 	UVic
-- Engineer: 	Ibrahim Hazmi
-- 
-- Create Date:   18:20:50 12/05/2017 
-- Design Name: 	Systolic EEA-Based Inversion
-- Module Name:   PE0 - Behavioral 
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

entity PE0 is
    Port ( 	ain, vin, rn_1, pk_1, ak_1 : in  STD_LOGIC; -- gm=1
				clock, reset: in  STD_LOGIC;
				selq_PE0, sela_PEi, sela2_PEi, selp_PEi, selv_PEi : in  STD_LOGIC; --, Select
				Enqk_PE0, Enak_PEi, Envk_PEi, Enuk_PEi : in  STD_LOGIC; -- Enablers , Enpk_PEi
				qk, uk, vk : inout  STD_LOGIC; -- pki might be only a signal in PE0 since it's not required outside the cell
				An	: out  STD_LOGIC); --, pk 
end PE0;

architecture Behavioral of PE0 is

Signal qki, ani, pki, MUXao, MUXvo, MUXpo, XORuo : STD_LOGIC; -- r_RegEn = GN! 

begin

-- Multiplixer1 (It can be replaced by: qk<= not(sel_PE0) or rn_1 -- Demorgan Theorem 13B)
MUXq_PE0: entity work.MUX2_1bit Port Map ('1', rn_1, selq_PE0, qki); --gm<='1'
-- Multiplixers
MUXp_PE0: entity work.MUX2_1bit Port Map ('0', pk_1, selp_PEi, MUXpo);
MUXv_PE0: entity work.MUX2_1bit Port Map (vin, XORuo, selv_PEi, MUXvo); -- V should be initialized at 1 so, we might get rid of MUXv!
MUXa_PE0: entity work.MUX2_1bit Port Map (MUXao, rn_1, sela_PEi, ani); --ak after MUX
MUXa2_PE0: entity work.MUX2_1bit Port Map (ain, ak_1, sela2_PEi, MUXao); --ak after MUX
-- Registers
Reg_qk_PE0: entity work.Reg_1bit Port Map (clock, reset, Enqk_PE0, qki, qk); -- Always enabled
Reg_vk_PE0: entity work.Reg_1bit Port Map (clock, reset, Envk_PEi, MUXvo, vk); -- Always enabled
Reg_uk_PE0: entity work.Reg_1bit Port Map (clock, reset, Enuk_PEi, vk, uk); -- Always enabled
--Reg_pk_PE0: entity work.Reg_1bit Port Map (clock, reset, Enpk_PEi, pki, pk); -- Always enabled
Reg_ak_PEi: entity work.Reg_1bit Port Map (clock, reset, Enak_PEi, ani, An); -- Always enabled

--
pki 	<= (vk and qk) xor MUXpo; --MUXuo
XORuo <= pki xor uk;
end Behavioral;