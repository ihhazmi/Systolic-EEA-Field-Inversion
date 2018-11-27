----------------------------------------------------------------------------------
-- Company: 	UVic
-- Engineer: 	Ibrahim Hazmi
-- 
-- Create Date:   18:20:50 12/05/2017 
-- Design Name: 	Systolic EEA-Based Inversion
-- Module Name:   Concurrent Polynomial Divicer/Multiplier - Behavioral 
-- Dependencies: 
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;
use IEEE.NUMERIC_STD.ALL;

entity ConcurrentDivMul is
    Generic (n: integer:=3); --:= 5
    Port ( --G : in  STD_LOGIC_VECTOR ((2**n) downto 0);   
           G : 	in  STD_LOGIC_VECTOR ((2**n)-1 downto 0); -- G(2**n)='1' always! , U
           A : 	in  STD_LOGIC_VECTOR ((2**n)-1 downto 0); -- G(2**n)='1' always! , U
           clock, reset : in  STD_LOGIC;
			  selg_PEi : in  STD_LOGIC_VECTOR (1 DOWNTO 0); -- MUXg Selector 
			  selq_PE0, sela_PEi, sela2_PEi, selp_PEi, selv_PEi	: 	in  STD_LOGIC; -- Selectors
           Enqk_PE0, Engk_PEi, Enak_PEi, Enuk_PEi, Envk_PEi, Enpk_PEi : in  STD_LOGIC; -- Enables
           Gk, Ak : inout  STD_LOGIC_VECTOR ((2**n)-2 downto 0); -- A and V are required as GCD and Inv_A!
           Vk, Uk : inout  STD_LOGIC_VECTOR ((2**n)-1 downto 0); -- A & V Before Registers, G &U After registers 
			  An, Gz : 	out  STD_LOGIC); -- Shift Alignment Indicator -- MSB of A (After shift)
end ConcurrentDivMul; --Enrk_PEi, , Az

-- V,U,P should be initialized with 1,0,0 in their declarations!
-- Is it beneficial to make the defenition of these Registers, include this initialization!
-- Like (If clear reg= 0 or 1;  V,U,P --> 1,0,0)
-- Also, there should be connectivity between the 1-bit Registers of each Variable, 
-- In case Shist Left is required, when replacing the outer Registers with the inner ones! 
architecture Behavioral of ConcurrentDivMul is

Component PEi
    Port ( 	qk, gin, ain, vin, rk_1, pk_1, ak_1, g0, a_r   : in  STD_LOGIC; --inputs to PE, ak1=a_{k+1}, rk_1=r_{k+1}^{(i-1)}
				clock, reset: in  STD_LOGIC;
				selg_PEi : in  STD_LOGIC_VECTOR (1 DOWNTO 0); -- MUXg Selector 
				sela_PEi, sela2_PEi, selp_PEi, selv_PEi : in  STD_LOGIC; -- Selectors 
				Engk_PEi, Enak_PEi, Envk_PEi, Enuk_PEi, Enpk_PEi : in  STD_LOGIC; -- Enablers
				gk, ak, uk, vk, rki, pk : inout  STD_LOGIC); --  Cascaded input qk and Output of PEi
end Component;

Signal qk: STD_LOGIC; -- qki might be deleted if there is no use for it! 
-- If the feedback to each PE is coming from (XOR) directly, then these signals are required!
-- Signal rki, pki: STD_LOGIC_VECTOR((2**n)-1 downto 0); intternal inout signals
Signal Rk, Pk, Gzz : STD_LOGIC_VECTOR ((2**n)-2 downto 0);  --Azz, Gki, 
--Signal  : STD_LOGIC_VECTOR ((2**n)-1 downto 0); -- G(2**n)='1' always!

begin
-- gm might be deleted if it replaced with '1' in PE definition!
-- qki maybe enough, if there is no need to store q valuse!

PE_0: entity work.PE0 
				Port Map (A((2**n)-1), '0', Rk((2**n)-2), Pk((2**n)-2), Ak((2**n)-2), 
				clock, reset,
				selq_PE0, sela_PEi, sela2_PEi, selp_PEi, selv_PEi, 
				Enqk_PE0, Enak_PEi, Envk_PEi, Enuk_PEi,
				qk, Uk((2**n)-1), Vk((2**n)-1), An); --, Pk((2**n)-1) , Enpk_PEi
---
G1 : FOR i IN (2**n)-2 Downto 1 GENERATE
	PE_i: PEi
   PORT MAP( qk, G(i+1),	A(i),	'0',	Rk(i-1),	Pk(i-1),	Ak(i-1), Rk(i-1),  Rk(i-1),
				 clock, reset,
             selg_PEi, sela_PEi, sela2_PEi, selp_PEi, selv_PEi, 
				 Engk_PEi, Enak_PEi, Envk_PEi, Enuk_PEi, Enpk_PEi,
             Gk(i), Ak(i), Uk(i), Vk(i), Rk(i), Pk(i) );
  END GENERATE G1;
PE_m: entity work.PEm -- V should be initialized to 1 and P to 0 (as U0=0)
   PORT MAP( qk, G(1),	A(0),	'1',	G(0),	'0',	'0',	'0', 	'0',
				 clock, reset,
             selg_PEi, sela_PEi, sela2_PEi, selv_PEi, 
				 Engk_PEi, Enak_PEi, Envk_PEi, Enuk_PEi, Enpk_PEi,
             Gk(0), Ak(0), Uk(0), Vk(0), Rk(0), Pk(0) );
---
--Gk((2**n)-1) <= G((2**n)-1);
--
Gzz(0) <= Gk(0);
ORgen2: for i in 1 to (2**n)-2 generate -- Make sure that A=0 (Pay attention, it might be (2**n)-2 instead!)
	Gzz(i) <= Gzz(i-1) or Gk(i);
end generate; 
Gz <= not Gzz((2**n)-2); 
--
--Azz(0) <= Ak(0);
--ORgen: for i in 1 to (2**n)-2 generate -- Make sure that A=0 (Pay attention, it might be (2**n)-2 instead!)
--	Azz(i) <= Azz(i-1) or Ak(i);
--end generate; 
--Az <= not Azz((2**n)-2);


end Behavioral;
--			  CLZ : 	out  STD_LOGIC_VECTOR (n-1 downto 0); -- Shift counter