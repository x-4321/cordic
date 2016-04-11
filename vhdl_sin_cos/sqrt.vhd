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

type signed_array is array (natural RANGE <> ) OF signed(8 downto 0);

--signal ab : ufixed (3 downto -3); 

begin
cordic : process (reset, a)

variable x1, x2, x3, x4, x5, x_result : signed (8 downto 0);
variable k : integer := 1;

variable x_array : signed_array(0 to 20) := (others => (others => '0'));
variable y_array : signed_array(0 to 20) := (others => (others => '0'));

begin
   if (reset='1') then 
     o <= (others => '0');	
	else
	   x_array(x_array'low) := signed('0' & a) + to_signed(1, 9);     -- x_array(0)= a+1;
	   y_array(y_array'low) := signed('0' & a) - to_signed(1, 9);     -- y_array(0)= a-1;
		
	   k := 1;
	   L1: for i in 1 to x_array'high - 5 loop
			  
			  if (y_array(i-1) < to_signed(0,9)) then                                -- if (y<0) 
				 x_array(k) := x_array(k-1) + (y_array(k-1)/2**(i));                --(shift_right(y_array(i-1),i));     
				 y_array(k) := y_array(k-1) + (x_array(k-1)/2**(i));                --(shift_right(x_array(i-1),i));     
			  else
				 x_array(k) := x_array(k-1) - (y_array(k-1)/2**(i));                --(shift_right(y_array(i-1),i));       
				 y_array(k) := y_array(k-1) - (x_array(k-1)/2**(i));                --(shift_right(x_array(i-1),i));	
				 --assert false report "y >= 0" severity error;
			  end if;
			  k := k + 1;
			  
			  if ((k = 4) OR (k = 7) OR (k = 10) OR (k= 13)) then
					 if (y_array(i-1) < to_signed(0,9)) then                                -- if (y<0) 
					 x_array(k) := x_array(k-1) + (y_array(k-1)/2**(i));                --(shift_right(y_array(i-1),i));     
					 y_array(k) := y_array(k-1) + (x_array(k-1)/2**(i));                --(shift_right(x_array(i-1),i));     
				  else
					 x_array(k) := x_array(k-1) - (y_array(k-1)/2**(i));                --(shift_right(y_array(i-1),i));       
					 y_array(k) := y_array(k-1) - (x_array(k-1)/2**(i));                --(shift_right(x_array(i-1),i));	
					 
				  end if;
				  k := k + 1;
           end if;			  
		end loop L1;
	
		
		--x_array(x_array'high) <= to_signed(128, 9);   -- test data - Multiplication works! :-)
		x1 := shift_right(x_array(k-1),1);     --
      x2 := shift_right(x_array(k-1),4);		--   multiply the result 
		x3 := shift_right(x_array(k-1),5);     -- with 0.6037 = 0.100110101 
		x4 := shift_right(x_array(k-1),7);		--
      x5 := shift_right(x_array(k-1),9);     --
      
		
      x_result := x1 + x2 + x3 + x4 + x5 ;
		o <= std_logic_vector(x_result(7 downto 0));
	 end if;	
end process cordic ;
end Behavioral;