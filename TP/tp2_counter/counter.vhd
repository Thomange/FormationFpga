library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.NUMERIC_STD.ALL;

entity counter_unit is
    port ( 
		clk			: in std_logic; 
        resetn		: in std_logic;
        end_counter	: out std_logic;
        btn_restart : in std_logic;         -- restart 
        led0_b      : out std_logic
        
     );
end counter_unit;

architecture behavioral of counter_unit is
	
	--Declaration des signaux internes
    constant counter_Max    : positive	 := 200000000; 
	signal 	counter         : std_logic_vector (27 downto 0);
	signal s_end_counter    : std_logic := '0';
	signal s_led_out        : std_logic := '0';
	
	begin

		--Partie sequentielle
		process(clk,resetn)
		begin
		-- compteur
		    -- cas reset
			if(resetn = '1') then 
				counter <= (others => '0');
		    -- sur front montant d'horloge
			elsif(rising_edge(clk)) then
			    -- remise à zéro du compteur
				if (counter = std_logic_vector(to_unsigned(counter_Max-1,28))) then
					counter <= (others => '0');
				else -- incrémentation du compteur
					counter <= counter + 1 ;
				end if;
				
				-- mutltiplexeur 
				if(btn_restart = '1' OR s_end_counter = '1') then
		              counter <= (others => '0');
                end if;
		
			end if;
			            
                 
		end process;
		
		led : process(resetn,clk)
		begin
            	-- changement de led à fin de compteur
            if (resetn = '1') then
                s_led_out <= '0';
            elsif (rising_edge(clk)) then
                if (s_end_counter = '1') then
                    s_led_out <= not(s_led_out);
                else
                    s_led_out <= s_led_out;
                end if;
            end if;		
            
		end process ;
		
		-- comparateur
		 s_end_counter <= '1' when (counter = std_logic_vector(to_unsigned(counter_Max-1,28)))
		 else '0';
		 
       -- led associé à End_counter :  
       -- led0_b <= s_end_counter;
		 
		 end_counter <= s_end_counter;
		 led0_b <= s_led_out;
		 
		 
		
end behavioral;