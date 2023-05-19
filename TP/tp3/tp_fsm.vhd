library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.NUMERIC_STD.ALL;



entity tp_fsm is
    generic (
        counter_led_max    : positive :=6
    );
    port ( 
		clk			    : in std_logic; 
        resetn		    : in std_logic;
        btn_restart : in std_logic;
        led_r       : out std_logic;
        led_b       : out std_logic;
        led_g       : out std_logic
     );
end tp_fsm;


architecture behavioral of tp_fsm is

    component counter_unit is
    generic(
        counter_max    : positive 
    );
    port ( 
		clk			: in std_logic; 
        resetn		: in std_logic;
        end_counter	: out std_logic
     );
end component;
    -- signaux pour le compteur de cycle de led
    signal s_counter            : std_logic_vector (2 downto 0);
    signal s_end_led_counter    : std_logic := '0';
    signal s_end_counter        : std_logic := '0';
    
    
    type state is (idle, state_led_r, state_led_b, state_led_g); --a modifier avec vos etats
    
    signal current_state : state;  --etat dans lequel on se trouve actuellement
    signal next_state : state;	   --etat dans lequel on passera au prochain coup d'horloge
    
    
    -- signaux pour l'état de commande de led  (si le signal est à 1, alors la led clignote)
    signal s_state_led_r : std_logic := '0';      
    signal s_state_led_g : std_logic := '0';
    signal s_state_led_b : std_logic := '0';
    
    signal s_led_on     : std_logic := '0';
    
    signal s_led_r       : std_logic := '0';
    signal s_led_g       : std_logic := '0';
    signal s_led_b       : std_logic := '0';

	
	
	begin
    
    count: counter_unit
    generic map(
        counter_max => 200000000
    )
    port map(
        clk => clk,
        resetn => resetn,
        end_counter => s_end_counter
    );
    
    
        led_counter : process(clk, resetn, btn_restart)
        begin
            if(resetn = '1') then
                s_counter <= (others => '0');
             
           
            
            elsif (rising_edge(clk)) then  
                if ((s_end_led_counter = '1' and s_end_counter = '1') or btn_restart = '1')then
                    s_counter <= (others => '0');
                    
                elsif(s_end_counter = '1') then
                        s_counter <= s_counter + 1;
                else
                    s_counter <= s_counter;        
                end if;
            end if;   
        end process led_counter;
	
	
	-- comparateur pour compteur de led
	s_end_led_counter <= '1' when (s_counter = std_logic_vector(to_unsigned(counter_led_max - 1,8)))
	else '0';
	

	
	--------------------------------------------------------------------------
	-- state --
		process(clk,resetn, btn_restart)
		begin
            if(resetn = '1') then
                current_state <= idle;
                s_led_on <= '0';
            
			elsif(rising_edge(clk)) then
			     current_state <= next_state;
			     
			     
			     if(btn_restart = '1') then
                    s_led_on <= '0';
                    
                 else 
                     -- commande led allumée, pour les sychroniser
                     if( s_end_counter = '1') then
                         s_led_on <= not s_led_on;
                     else
                         s_led_on <= s_led_on;
                     end if;
                  end if;
			    end if; 
		end process;
		
		
		s_led_r <= s_led_on and s_state_led_r;
		s_led_g <= s_led_on and s_state_led_g;
		s_led_b <= s_led_on and s_state_led_b;
		
		
		
		led_r <= s_led_r;
		led_g <= s_led_g;
		led_b <= s_led_b;
		
		
--		-- FSM
		process(current_state,s_end_led_counter, s_end_counter, btn_restart) --a completer avec vos signaux
		begin		
           case current_state is
              when idle => 
                    s_state_led_r <= '1';
                    s_state_led_g <= '1';
                    s_state_led_b <= '1';
--				next_state <= 
                    if(s_end_led_counter = '1' and s_end_counter = '1') then
                        next_state <= state_led_r;
                    else 
                       next_state <= idle;
                    end if;  --prochain etat
				
--                --signaux pilotes par la fsm
              
              when state_led_r => 
                   s_state_led_r <= '1';
                   s_state_led_g <= '0';
                   s_state_led_b <= '0';

				     if(s_end_led_counter = '1' and s_end_counter = '1') then
                        next_state <= state_led_b;
                     elsif (btn_restart = '1') then
                        next_state <= idle;
                     else
                        next_state <= state_led_r;
                     end if;
                     
				when state_led_b => 
                   s_state_led_r <= '0';
                   s_state_led_g <= '0';
                   s_state_led_b <= '1';

				     if(s_end_led_counter = '1' and s_end_counter = '1') then
                        next_state <= state_led_g;
                     elsif (btn_restart = '1') then
                        next_state <= idle;
                     else
                        next_state <= state_led_b;
                     end if;
				
             when state_led_g => 
                   s_state_led_r <= '0';
                   s_state_led_g <= '1';
                   s_state_led_b <= '0';

				     if(s_end_led_counter = '1' and s_end_counter = '1') then
                        next_state <= state_led_r;
                     elsif (btn_restart = '1') then
                        next_state <= idle;
                     else
                        next_state <= state_led_g;
                     end if;
				
              end case;
              
          
		end process;
		
		
		

end behavioral;