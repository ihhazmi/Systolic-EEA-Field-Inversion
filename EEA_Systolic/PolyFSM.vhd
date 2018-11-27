----------------------------------------------------------------------------------
-- Company:  UNIVERSITY OF VICTORIA - Dept. of Electrical & Computer Engineering.
-- Engineer: Ibrahim Hazmi - ihaz@ece.uvic.ca
-- 
-- Create Date:    06:51:08 12/07/2017
-- Design Name:	   
-- Module Name:    FSM - behav. 
-- Project Name:   Systolic EEA Implementation.
-- Target Devices: SPARTAN6 - XC6SLX45T
-- Tool versions:  ISE 13.4
-- Description:	   EEA FSM Controller.
-- Dependencies:   N/A
-- Revision 0.01 - File Created
-- Additional Comments: N/A
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Sel_f (MUX_f Select Signal)
ENTITY PolyEEA_FSM IS
   Generic (n: integer:= 3);
	PORT(
			clock, Reset, Start: IN  STD_LOGIC;
			An, Gz: 					IN  STD_LOGIC; -- An =MSB of A (After shift) Alignment Indicato, Shift, Up/Down_Count
			sel_g : out  STD_LOGIC_VECTOR (1 DOWNTO 0); -- MUXg Selector 
			sel_q, sel_a, sel_a2, sel_p, sel_v	: 	out  STD_LOGIC; -- Selectors
			En_q, En_g, En_a, En_u, En_v, En_p	: 	OUT STD_LOGIC; -- Enable  
			Done, Aligned, Finish: 	OUT STD_LOGIC  -- Control,    Sh is making sela_PEi='0', sela2_PEi='1'
		);
END PolyEEA_FSM;--En_r, 

ARCHITECTURE behav OF PolyEEA_FSM IS

TYPE 		StateType IS (S0, S1, S2, S3); -- S2 (Initiate, Align, Invert(g0), Invert(0))								  
SIGNAL 	CurrentState	: StateType; -- C_S
SIGNAL 	NextState		: StateType; -- N_S

SIGNAL	CLZ: 	 STD_LOGIC_VECTOR (n-1 downto 0); -- Counter 
SIGNAL	clear, up: 	 STD_LOGIC; --  Counter Starter

BEGIN

Counter: entity work.UD_Cnt Port Map (clock , clear, up, CLZ); -- Reset
	C_S: PROCESS (clock, Reset)
	BEGIN
	
	IF (Reset = '1') THEN		
		CurrentState 	<= 	S0;			
		ELSIF (rising_edge(clock)) THEN
			CurrentState 	<= 	NextState;			
	END IF;
		
	END PROCESS C_S;
	
	
	N_S: PROCESS (CurrentState, Start, CLZ, An, Gz)
	
	BEGIN

	CASE CurrentState IS
			
			WHEN S0 => -- Initialize 
				Done		<= '0';	Aligned	<= '0';	Finish	<= '0';
				clear		<= '1';	up			<= '0';
				sel_g		<= "00";	sel_q 	<= '0';
				sel_a		<= '0';	sel_a2	<= '0';	
				sel_p		<= '0';	sel_v		<= '0';	
				En_q		<= '1';	En_g		<= '1';	En_a		<= '1';	
				En_u		<= '0';	En_v		<= '1';		
				 	En_p		<= '0'; 	
				IF (Start = '1') THEN					
					NextState 	<= S1; -- Align
				ELSE 	
					NextState 	<= S0;
				END IF;								

			WHEN S1 => 	-- Align -- a=r, g=a (CLZ should count up from 1 to m-n)
				Finish <= '0';		Done		<= '0';	
				clear		<= '0';	
				sel_p		<= '1';
				sel_a		<= '0';	sel_a2	<= '1';	-- Sh is making sela_PEi='0', sela2_PEi='1'
				sel_v		<= '1';	
				En_q		<= '1';	En_u		<= '0';	En_v	<= '0';	 							
				IF (An = '1') THEN -- An=A(n)
					Aligned	<= '1';	
					up			<= '0';	
					sel_g	<= "10";		sel_q 	<= '1';			
					En_g		<= '1';	En_a		<= '0'; --   Don't Shift	Even When sela_PEi='0' and sela2_PEi='1';
					En_p		<= '1'; 	
					NextState 	<= S2;
				ELSE 	
					Aligned	<= '0';	
					up			<= '1';	
					sel_g	<= "01";		sel_q 	<= '0';			
					En_g		<= '0';	En_a		<= '1'; --  Shift When sela_PEi='0' and sela2_PEi='1';
					En_p		<= '0'; 	
					NextState 	<= S1;
				END IF;						


			WHEN S2 => -- Invert (CLZ should count down from m-n to 1)
				Aligned	<= '0';	Finish	<= '0';
				clear		<= '0';	
				sel_q 	<= '1';	sel_a		<= '1';	sel_a2	<= '1';	
				sel_v		<= '1';	sel_p		<= '1';	
				En_q		<= '1';	En_g		<= '1';	En_p		<= '1';				
				IF (CLZ="000") THEN
					IF (Gz='1') THEN  
						Finish 	<= '1';	Done <= '0';
						up			<= '1'; 					
						sel_g	<= "00";		
						En_a		<= '0'; 	En_v		<= '0';	En_u		<= '0';	 						 									
						NextState 	<= S0;
					ELSE
						Done <= '1';
						up	<= '1';
						sel_g		<= "01";			
						En_a		<= '1'; 		En_v		<= '1';	En_u		<= '1'; 	--Sh	<= '1';
						NextState 	<= S3;
					END IF;	
				ELSE
					Done 		<= '0';
					up			<= '0';
					sel_g		<= "11";			
					En_a		<= '0'; 	En_v		<= '0';	En_u		<= '0'; 	--Sh	<= '1';
					NextState 	<= S2;
				END IF;						

			WHEN S3 => -- swap (CLZ should count down from m-n to 1)
				Done		<= '0';
				clear		<= '0';	--sel_p		<= '0';
				sel_a		<= '0';	sel_a2	<= '1';	-- Sh is making sela_PEi='0', sela2_PEi='1'
				sel_v		<= '1';	
				En_q		<= '1';	En_u		<= '0';	En_v	<= '0';	--An = '1' AND Az='1' AND CLZ="001"  							
				IF (Gz='1') THEN --An=A(n) 
					Finish 	<= '1';	Aligned	<= '0';
					up			<= '1';  -- does it matter here? (don't care x)						
					sel_g	<= "00";		sel_q 	<= '1';	sel_p		<= '1';	-- Sh is making sela_PEi='0', sela2_PEi='1'
					En_g		<= '0';	En_a		<= '0';	 						 	
					En_p		<= '0'; 											
					NextState 	<= S0;
				ELSE
					Finish <= '0';
					IF (An = '1') THEN -- An=A(n)
						Aligned	<= '1';	
						up			<= '0';	sel_p		<= '0';	
						sel_g	<= "11";		sel_q 	<= '1';		
						En_g		<= '1';	En_a		<= '0'; --   Don't Shift Even When sela_PEi='0' and sela2_PEi='1';
						En_p		<= '1'; 	
						NextState 	<= S2;
					ELSE 	
						Aligned	<= '0';	
						up			<= '1';	sel_p		<= '1';	
						sel_g	<= "01";		sel_q 	<= '0';	--sel_u		<= '0';	
						En_g		<= '0';	En_a		<= '1'; --  Shift When sela_PEi='0' and sela2_PEi='1';
						En_p		<= '0'; 	
						NextState 	<= S3;
					END IF;						
				END IF;						


--
		-- Default Case	
			WHEN OTHERS =>
				Done		<= '0';	Aligned	<= '0';	Finish	<= '0';
				clear		<= '1';	up			<= '0';	sel_p		<= '1';
				sel_g		<= "00";	sel_q 	<= '0';
				sel_a		<= '0';	sel_a2	<= '0';	
				sel_v		<= '0';	
				En_q		<= '0';	En_g		<= '0';	En_a		<= '0';	
				En_u		<= '0'; 	En_v		<= '0';	
				En_p		<= '0'; 	
				NextState 		<= S0;	
		END CASE;
		
	END PROCESS N_S;

END behav;