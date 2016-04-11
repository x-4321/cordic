--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:02:38 03/29/2016
-- Design Name:   
-- Module Name:   /home/andi/programs/xilinx/sin_cos/tb.vhd
-- Project Name:  sin_cos
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: sin_cos
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
 
ENTITY tb IS
END tb;
 
ARCHITECTURE behavior OF tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT sin_cos
    PORT(
         clk : IN  std_logic;
         resetn : IN  std_logic;
         z_ip : IN  std_logic_vector(16 downto 0);
         x_ip : IN  std_logic_vector(16 downto 0);
         y_ip : IN  std_logic_vector(16 downto 0);
         cos_op : OUT  std_logic_vector(16 downto 0);
         sin_op : OUT  std_logic_vector(16 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal resetn : std_logic := '0';
   signal z_ip : std_logic_vector(16 downto 0) := (others => '0');
   signal x_ip : std_logic_vector(16 downto 0) := (others => '0');
   signal y_ip : std_logic_vector(16 downto 0) := (others => '0');
   signal cos_op : std_logic_vector(16 downto 0) := (others => '0');
   signal sin_op : std_logic_vector(16 downto 0) := (others => '0');

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: sin_cos PORT MAP (
          clk => clk,
          resetn => resetn,
          z_ip => z_ip,
          x_ip => x_ip,
          y_ip => y_ip,
          cos_op => cos_op,
          sin_op => sin_op
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
      -- hold reset state for 100 ns
      wait for 100 ns;
      resetn <= '0';
		wait for 100 ns;
      resetn <= '1';
      wait for 50 ns;		
		-- MathWorks Documentation: Compute Sine and Cosine using Cordic
		-- x_0 is set to 1 / A_n,  1/ A_n = 0.607253
		-- normalized: x_0 = 0.607 * 2^16
		x_ip <= std_logic_vector(to_signed(39796, 17));
		-- y_0 has to be set to 0
		y_ip <= std_logic_vector(to_signed(0, 17));
		-- z_0 is the angle
		-- a z value of  65536 corresponds to an angle of 1 rad
		z_ip <= std_logic_vector(to_signed(-65536/2, 17));
		wait for 100 ns;
      wait for clk_period*10;
      wait;
   end process;

END;
