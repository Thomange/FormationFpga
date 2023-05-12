library ieee;
use ieee.std_logic_1164.all;

entity tb_tp_fsm is
end tb_tp_fsm;

architecture behavioral of tb_tp_fsm is

	signal resetn      : std_logic := '0';
	signal clk         : std_logic := '0';
	--a completer 
	
	-- Les constantes suivantes permette de definir la frequence de l'horloge 
	constant hp : time := 5 ns;      --demi periode de 5ns
	constant period : time := 2*hp;  --periode de 10ns, soit une frequence de 100Hz
	
	
	component tp_fsm
		port ( 
			clk			: in std_logic; 
			resetn		: in std_logic
			--a completer
		 );
	end component;
	
	

	begin
	dut: tp_fsm
        port map (
            clk => clk, 
            resetn => resetn
			--a completer
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
	   
		--a completer
	   
	   
		wait;
	    
	end process;
	
	
end behavioral;