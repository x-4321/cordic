--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:53:46 04/15/2016
-- Design Name:   
-- Module Name:   /home/andi/programs/xilinx/cordic_sqrt_new/cordic_sqrt_tb.vhd
-- Project Name:  cordic_sqrt_new
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: quadratwurzel
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY cordic_sqrt_tb IS
END cordic_sqrt_tb;
 
ARCHITECTURE behavior OF cordic_sqrt_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT quadratwurzel
    PORT(
         a : IN  std_logic_vector(7 downto 0);
         o : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal a : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal o : std_logic_vector(7 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: quadratwurzel PORT MAP (
          a => a,
          o => o
        );
		  
   -- Stimulus process
   stim_proc: process
      begin		

		wait for 50 ns;
		a <= std_logic_vector(to_signed(1, 8));		
		wait for 50 ns;
		a <= std_logic_vector(to_signed(2, 8));		
		wait for 50 ns;
		a <= std_logic_vector(to_signed(10, 8));		
		wait for 50 ns;
		a <= std_logic_vector(to_signed(20, 8));		
		wait for 50 ns;
		a <= std_logic_vector(to_signed(36, 8));		
		wait for 50 ns;
		a <= std_logic_vector(to_signed(68, 8));		
		wait for 50 ns;
		a <= std_logic_vector(to_signed(75, 8));		
		wait for 50 ns;
		a <= std_logic_vector(to_signed(100, 8));		
		wait for 50 ns;
		a <= std_logic_vector(to_signed(128, 8));		
		wait for 50 ns;
		a <= std_logic_vector(to_signed(255, 8));		
		wait for 50 ns;
   end process;

END;
