----------------------------------------------------------------------------------
-- Company: UVIC
-- Engineer: Ibrahim Hazmi
-- Create Date:    00:58:53 12/07/2017 
-- Module Name:    EEA - Structural 
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;
entity PolyEEA is
    Generic (n: integer:= 3);
    Port ( Gx : in  STD_LOGIC_VECTOR ((2**n)-1 downto 0);
           Ax : in  STD_LOGIC_VECTOR ((2**n)-1 downto 0);
           clock, reset, Start : in  STD_LOGIC;
           GCD : out  STD_LOGIC_VECTOR ((2**n)-1 downto 0); --((2**n)-1 downto 0)
           A_inv : out  STD_LOGIC_VECTOR ((2**n)-1 downto 0); -- ((2**n)-1 downto 0)
			  Done, Aligned, Finish : out  STD_LOGIC);
end PolyEEA;

architecture Structural of PolyEEA is
Signal An, Gz: STD_LOGIC; -- FSM Signals and Alignment Indicator 
Signal sel_g : STD_LOGIC_VECTOR (1 DOWNTO 0); -- Select Signals
Signal sel_q, sel_a, sel_a2, sel_p, sel_v : STD_LOGIC; -- Select Signals
Signal En_q, En_g, En_a, En_u, En_v, En_p : STD_LOGIC; -- Enable Signals En_r, En_p will be removed!
Signal V, U : STD_LOGIC_VECTOR((2**n)-1 downto 0); --R, U, P
Signal G, A : STD_LOGIC_VECTOR((2**n)-2 downto 0); --A-An
--Signal Gr, Rr, Vr, Ur, Pr, Ashr: STD_LOGIC_VECTOR((2**n)-1 downto 0); --Ar, 
begin

-- ConcurrentDivMul
Datapath: entity work.ConcurrentDivMul Port Map  -- -- G(2**n)='1'
		(Gx, Ax, clock, reset, sel_g, sel_q, sel_a, sel_a2, sel_p, sel_v, 
		En_q, En_g, En_a, En_u, En_v, En_p, G, A, V, U, An, Gz); --En_r, 

-- FSM Contrller
FSM_0: entity work.PolyEEA_FSM Port Map 
		(clock, reset, Start, An, Gz,
		sel_g, sel_q, sel_a, sel_a2, sel_p, sel_v, -- Select
		En_q, En_g, En_a, En_u, En_v, En_p, -- Enable En_r?		
		Done, Aligned, Finish); -- Control
GCD <= An & A;
A_inv <= V;
end Structural;