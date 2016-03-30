----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:57:13 03/29/2016 
-- Design Name: 
-- Module Name:    sin_cos - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sin_cos is
    Port ( clk : in  STD_LOGIC;
           resetn : in  STD_LOGIC;
           z_ip : in  STD_LOGIC_VECTOR (16 downto 0);
           x_ip : in  STD_LOGIC_VECTOR (16 downto 0);
           y_ip : in  STD_LOGIC_VECTOR (16 downto 0);
           cos_op : out  STD_LOGIC_VECTOR (16 downto 0);
           sin_op : out  STD_LOGIC_VECTOR (16 downto 0));
end ENTITY sin_cos;

architecture rtl of sin_cos is

TYPE signed_array IS ARRAY (natural RANGE <> ) OF signed(17 DOWNTO 0);


--ARCTAN  arctan(2^ 0) = 51471 / 2^16
--        arctan(2^-1) = 30385 / 2^16
--        ....
CONSTANT tan_array : signed_array(0 to 16) := (to_signed(51471,18), to_signed(30385,18), to_signed(16054, 18), to_signed(8149, 18), to_signed(4090, 18), to_signed(2047, 18), to_signed(1023, 18), to_signed(511, 18), to_signed(255, 18), to_signed(127, 18), to_signed(63, 18), to_signed(31, 18), to_signed(15, 18), to_signed(7, 18), to_signed(3, 18), to_signed(1, 18), to_signed(0, 18));

SIGNAL x_array : signed_array(0 TO 14) := (OTHERS => (OTHERS => '0'));
SIGNAL y_array : signed_array(0 TO 14) := (OTHERS => (OTHERS => '0'));
SIGNAL z_array : signed_array(0 TO 14) := (OTHERS => (OTHERS => '0'));

BEGIN

--convert inputs into signed format

PROCESS(resetn, clk)
  BEGIN
    IF resetn = '0' THEN
      x_array <= (OTHERS => (OTHERS => '0'));
      z_array <= (OTHERS => (OTHERS => '0'));
      y_array <= (OTHERS => (OTHERS => '0'));
    ELSIF rising_edge(clk) THEN
      IF signed(z_ip) < to_signed(0,18) THEN
        x_array(x_array'low) <= signed(x_ip) + signed('0' & y_ip);
        y_array(y_array'low) <= signed(y_ip) - signed('0' & x_ip);        
        z_array(z_array'low) <= signed(z_ip) + tan_array(0);                
      ELSE
        x_array(x_array'low) <= signed(x_ip) - signed('0' & y_ip);
        y_array(y_array'low) <= signed(y_ip) + signed('0' & x_ip);        
        z_array(z_array'low) <= signed(z_ip) - tan_array(0);        
      END IF;
      
      FOR i IN 1 TO 14 LOOP
        IF z_array(i-1) < to_signed(0, 17) THEN
          x_array(i) <= x_array(i-1) + (y_array(i-1)/2**i);
          y_array(i) <= y_array(i-1) - (x_array(i-1)/2**i);
          z_array(i) <= z_array(i-1) + tan_array(i);
        ELSE
          x_array(i) <= x_array(i-1) - (y_array(i-1)/2**i);
          y_array(i) <= y_array(i-1) + (x_array(i-1)/2**i);
          z_array(i) <= z_array(i-1) - tan_array(i);
        END IF;
      END LOOP;
    END IF;
  END PROCESS;
cos_op <= std_logic_vector(x_array(x_array'high)(16 DOWNTO 0));
sin_op <= std_logic_vector(y_array(x_array'high)(16 DOWNTO 0));         

end ARCHITECTURE rtl;