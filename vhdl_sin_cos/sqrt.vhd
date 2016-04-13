library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity quadratwurzel is

port(clk : in std_logic; 
     a   : in std_logic_vector(7 downto 0);
     reset: in std_logic;
	  o   : out std_logic_vector(7 downto 0));

end quadratwurzel;


architecture Behavioral of quadratwurzel is

type signed_array      is array (natural RANGE <> ) OF signed(9 downto 0);
type signed_array_long is array (natural RANGE <> ) OF signed(14 downto 0);

begin
cordic : process (reset, a)

variable x1, x2, x3, x4, x5, x_result : signed (9 downto 0);
variable b : signed_array_long(0 to 6) := (others => (others => '0'));
variable k : integer := 1;
variable m : integer := 0;

variable x_array : signed_array(0 to 20) := (others => (others => '0'));
variable y_array : signed_array(0 to 20) := (others => (others => '0'));

begin
   if (reset='1') then 
     o <= (others => '0');	
	elsif (a = "00000000") then
	  o <= (others => '0');	
	else
	   b(0) := signed( a & "000000");
		m := 0;
		while ( b(m) >= to_signed(256, 15)) loop
        b(m + 1) := b(m)/(2**2);
        m := m + 1;
      end loop; 
		
	   x_array(x_array'low) := signed('0' & b(m)(7 downto 0)) + to_signed(32, 10);     -- x_array(0)= a+0.25;
	   y_array(y_array'low) := signed('0' & b(m)(7 downto 0)) - to_signed(32, 10);     -- y_array(0)= a-0.25;
		
	   k := 1;
	   L1: for i in 1 to x_array'high - 5 loop
			  
			  if (y_array(i-1) < to_signed(0,10)) then                                -- if (y<0) 
				 x_array(k) := x_array(k-1) + (y_array(k-1)/2**(i));                --(shift_right(y_array(i-1),i));     
				 y_array(k) := y_array(k-1) + (x_array(k-1)/2**(i));                --(shift_right(x_array(i-1),i));     
			  else
				 x_array(k) := x_array(k-1) - (y_array(k-1)/2**(i));                --(shift_right(y_array(i-1),i));       
				 y_array(k) := y_array(k-1) - (x_array(k-1)/2**(i));                --(shift_right(x_array(i-1),i));	
				 --assert false report "y >= 0" severity error;
			  end if;
			  k := k + 1;
			  
			  if ((k = 4) OR (k = 7) OR (k = 10) OR (k= 13)) then
					 if (y_array(i-1) < to_signed(0,10)) then                                -- if (y<0) 
					 x_array(k) := x_array(k-1) + (y_array(k-1)/2**(i));                --(shift_right(y_array(i-1),i));     
					 y_array(k) := y_array(k-1) + (x_array(k-1)/2**(i));                --(shift_right(x_array(i-1),i));     
				  else
					 x_array(k) := x_array(k-1) - (y_array(k-1)/2**(i));                --(shift_right(y_array(i-1),i));       
					 y_array(k) := y_array(k-1) - (x_array(k-1)/2**(i));                --(shift_right(x_array(i-1),i));	
					 
				  end if;
				  k := k + 1;
           end if;			  
      end loop L1;
	
		
	   -- test data - Multiplication works! :-)
		x1 := shift_right(x_array(k-1),0);     --
      x2 := shift_right(x_array(k-1),3);		--   multiply the result 
		x3 := shift_right(x_array(k-1),4);     --   by 1.207 = 1.00110101001
		x4 := shift_right(x_array(k-1),6);		--
      x5 := shift_right(x_array(k-1),8);     --
      
		
      x_result := x1 + x2 + x3 + x4 + x5 ;
		b(m) := "0000000" & x_result(7 downto 0);
		b(m):= shift_left(b(m), m);
		o <= std_logic_vector(b(m)(10 downto 2));         -- use only bits with value from 8 to 1/16
		--o <= std_logic_vector(x_result(7 downto 0));
	 end if;	
end process cordic ;
end Behavioral;