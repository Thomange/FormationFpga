library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.NUMERIC_STD.ALL;



entity tp_fsm is
    generic (
        constant counter_led_max    : positive :=50
    );
    port ( 
		clk			    : in std_logic; 
        resetn		    : in std_logic;
        end_led_counter : out std_logic
     );
end tp_fsm;





architecture behavioral of tp_fsm is

    component counter_unit is
    generic(
        constant counter_max    : positive
    );
    port ( 
		clk			: in std_logic; 
        resetn		: in std_logic;
        end_counter	: out std_logic
        
     );
end component;
    -- signaux pour le compteur de cycle de led
    signal s_counter            : std_logic_vector (7 downto 0);
    signal s_end_led_counter    : std_logic := '0';
    signal s_end_counter        : std_logic := '0';
    
    
    type state is (idle, state1, state2); --a modifier avec vos etats
    
    signal current_state : state;  --etat dans lequel on se trouve actuellement
    signal next_state : state;	   --etat dans lequel on passera au prochain coup d'horloge
    

	
	
	begin
    
    count: counter_unit
    generic map(
        counter_max => 200
    )
    port map(
        clk => clk,
        resetn => resetn,
        end_counter => s_end_counter
    );
    
    
        led_counter : process(clk, resetn)
        begin
            if(resetn = '1') then
                s_counter <= (others => '0');
            elsif (rising_edge(clk)) then     
                if (s_end_led_counter = '1') then
                    s_counter <= (others => '0');
                else
                    if(s_end_counter = '1') then
                        s_counter <= s_counter + 1;
                    else
                        s_counter <= s_counter;
                    end if;
                end if;  
            end if;          
        end process led_counter;
	
	
	-- comparateur pour compteur de led
	s_end_led_counter <= '1' when (s_counter = std_logic_vector(to_unsigned(counter_led_max,8)))
	else '0';
	
	-- récupération du signal de fin de comptage de led
	end_led_counter <= s_end_led_counter;
	
	
	--------------------------------------------------------------------------
	-- state --
		process(clk,resetn)
		begin
            if(resetn='1') then
            
                current_state <= idle;
                 
			elsif(rising_edge(clk)) then
			
				current_state <= next_state;
				
				--a completer avec votre compteur de cycles
				
				
            end if;
		end process;
		
		
		
		
--		-- FSM
--		process(current_state,XX) --a completer avec vos signaux
--		begin		
--           case current_state is
--              when idle =>
--				next_state <= state1; --prochain etat
				
--                --signaux pilotes par la fsm
              
--              when state1 =>
--				next_state <= state1;
				
--                --signaux pilotes par la fsm
              
--              when state2 =>
--				next_state <= state1;
				
--                --signaux pilotes par la fsm
              
              
--              end case;
              
          
--		end process;
		
		
		

end behavioral;