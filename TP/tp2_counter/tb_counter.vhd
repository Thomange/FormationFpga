library ieee;
use ieee.std_logic_1164.all;

entity tb_counter is
end tb_counter;

architecture behavioral of tb_counter is

    	
	--Declaration de l'entite a tester
	component counter_unit 
		port ( 
			clk	             : in std_logic; 
			resetn		     : in std_logic; 
			end_counter	     : out std_logic;
			btn_restart      : in std_logic;
			led0_b           : out std_logic
		 );
	end component;
	

	signal resetn          : std_logic := '0';
	signal clk             : std_logic := '0';
	signal end_counter     : std_logic := '0';
	signal led0            : std_logic := '0';
	signal tb_btn_restart  : std_logic := '0';
	
	-- Les constantes suivantes permette de definir la frequence de l'horloge 
	constant hp : time := 5 ns;      --demi periode de 5ns
	constant period : time := 2*hp;  --periode de 10ns, soit une frequence de 100 MHz

	

	begin
	
	--Affectation des signaux du testbench avec ceux de l'entite a tester
	uut: counter_unit
        port map (
            clk => clk, 
            resetn=>resetn, 
            end_counter => end_counter,
            led0_b =>  led0,
            btn_restart => tb_btn_restart 
        );
		
	--Simulation du signal d'horloge en continue
	process
    begin
		wait for hp;
		clk <= not clk;
	end process;

    counter:
	process
	begin  
	resetn <= '1';
	wait for 10 ns;
	resetn <= '0';
	
	-- resetn = 0
	  wait for 448.3 us;
	
	-- test du reset
	resetn <= '1';
	wait for 30 ns;
	
	resetn <= '0';
    wait for 201 us;
    
    tb_btn_restart <= '1';
    wait for 25 ns;
    
    tb_btn_restart <= '0';
    wait for 250 us;
	   
	   
	end process counter;
	
	
end behavioral;