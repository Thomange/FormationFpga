library ieee;
use ieee.std_logic_1164.all;

entity tb_tp_fsm is
end tb_tp_fsm;

architecture behavioral of tb_tp_fsm is

	signal resetn          : std_logic := '0';
	signal clk             : std_logic := '0';
	signal s_btn_restart   : std_logic := '0';
	signal s_led_r         : std_logic := '0';	
    signal s_led_g         : std_logic := '0';	
    signal s_led_b         : std_logic := '0';	
	
	-- Les constantes suivantes permette de definir la frequence de l'horloge 
	constant hp : time := 5 ns;      --demi periode de 5ns
	constant period : time := 2*hp;  --periode de 10ns, soit une frequence de 100Hz
	
	
	component tp_fsm is
    generic (
        counter_led_max    : positive
    );
    port ( 
		clk			: in std_logic; 
        resetn		: in std_logic;
        btn_restart : in std_logic;
        led_r       : out std_logic;
        led_b       : out std_logic;
        led_g       : out std_logic
     );
end component;

	

	begin
	dut: tp_fsm
	generic map(
            counter_led_max  => 6
            )
        port map (
            clk => clk, 
            resetn => resetn,
            btn_restart => s_btn_restart,
            led_r => s_led_r,
            led_g => s_led_g,
            led_b => s_led_b
        );
		
	--Simulation du signal d'horloge en continue
	process
    begin
		wait for hp;
		clk <= not clk;
	end process;


	process
	begin        
	
		resetn <= '1';
		wait for period*10;    
		resetn <= '0';
		
	   -- observation du cycle d'initalisation et de 5 états successifs : allumage led rouge, puis bleu, puis verte, puis rouge
	   --- puis bleu 
	   -- changement un état allumé led : 10 * period, durée d'un état = 6, soit une durée de 6*10*period;
	   -- observation donc 6*60*period. 
		wait for period *360;
		
		-- observation du signal restart au milieu d'un état (wait 1 period)
		wait for 10*period;
		s_btn_restart <= '1';
		wait for 4 * period;
		s_btn_restart <= '0';
		wait for 3*6*10*period;       -- observation de 3 états 
		
		-- test resetn 
		resetn <= '1'; 
		wait for 6*period;
		resetn <= '0';
	   
	   
		wait;
	    
	end process;
	
	
end behavioral;