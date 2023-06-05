library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.NUMERIC_STD.ALL;

entity counter_unit is
    generic(
        constant counter_max    : positive	 := 100000000
    );
    port ( 
		clk			: in std_logic; 
        resetn		: in std_logic;
        end_counter	: out std_logic
        
     );
end counter_unit;

architecture behavioral of counter_unit is
	
	--Declaration des signaux internes
    
	signal 	counter         : std_logic_vector (26 downto 0);
	signal s_end_counter    : std_logic := '0';
	
	begin
		--Partie sequentielle
		process(clk,resetn)
		begin
		-- compteur
		   
		    -- sur front montant d'horloge
			if(rising_edge(clk)) then
			 -- cas reset
                if(resetn = '1') then 
                    counter <= (others => '0');
				-- mutltiplexeur 
				else
				
                    if(s_end_counter = '1') then
                          counter <= (others => '0');
                     else
                          counter <= counter +1;
                    end if;
                end if;
			end if;
			            
                 
		end process;
		
		-- comparateur
		 s_end_counter <= '1' when (counter = counter_Max-1)
		 else '0';
		 
		 
		 end_counter <= s_end_counter;
		 
		 
		
end behavioral;