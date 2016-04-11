--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:47:04 04/10/2016
-- Design Name:   
-- Module Name:   /home/andi/programs/xilinx/sqrt/tb_sqrt.vhd
-- Project Name:  sqrt
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
 
ENTITY tb_sqrt IS
END tb_sqrt;
 
ARCHITECTURE behavior OF tb_sqrt IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT quadratwurzel
    PORT(
         clk : IN  std_logic;
         a : IN  std_logic_vector(7 downto 0);
         reset : IN  std_logic;
         o : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal a : std_logic_vector(7 downto 0) := (others => '0');
   signal reset : std_logic := '0';

 	--Outputs
   signal o : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: quadratwurzel PORT MAP (
          clk => clk,
          a => a,
          reset => reset,
          o => o
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;
      reset <= '1';
		wait for 100 ns;
      reset <= '0';
      wait for 50 ns;		
		a <= std_logic_vector(to_signed(64, 8));		
		wait for 100 ns;
      wait for clk_period*10;
      wait;
   end process;

END;
