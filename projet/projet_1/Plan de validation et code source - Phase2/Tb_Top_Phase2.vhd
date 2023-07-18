

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;


entity Tb_Top_phase2 is
--  Port ( );
end Tb_Top_phase2;

architecture Behavioral of Tb_Top_phase2 is

signal tb_clk, tb_Resetn, tb_btn1 : std_logic := '0';
	
-- Les constantes suivantes permette de definir la frequence de l'horloge 
constant hp : time := 4 ns;      --demi periode de 4ns
constant period : time := 2*hp;  --periode de 8ns, soit une frequence de 125Hz

component top_Phase2
    port ( CLK : in  STD_LOGIC;
           Resetn : in  STD_LOGIC;
           Btn1: in  STD_LOGIC;
           VGA_HS_O : out  STD_LOGIC;
           VGA_VS_O : out  STD_LOGIC;
           VGA_R_out : out  STD_LOGIC_VECTOR (3 downto 0);
           VGA_B_out : out  STD_LOGIC_VECTOR (3 downto 0);
           VGA_G_out : out  STD_LOGIC_VECTOR (3 downto 0);
           LED_Out_R, LED_Out_G : out  STD_LOGIC := '0'
           );
	end component;



begin

--Affectation des signaux du testbench avec ceux de l'entite a tester
	uut: top_Phase2
        port map (
            CLK => tb_clk,
            Resetn => tb_Resetn,
            btn1 =>tb_btn1
        );

--Simulation du signal d'horloge en continue
	process
    begin
		wait for hp;
		tb_clk <= not tb_clk;
	end process;

		
--process
--	begin  
--   wait for 20 ms;
--   tb_Resetn <= '1';
--   wait for 0.1 ms;
--   tb_Resetn <= '0';
--   wait;
--	wait;
--end process;
	
	
--process
--	begin  
--   wait for 10 us;
--   tb_btn1 <= '1';
--   wait for 20 us;
--   tb_btn1 <= '0';
--   wait for 50 us;
--   tb_btn1 <= '1';
--   wait for 20 us;
--   tb_btn1 <= '0';
--   wait for 50 us;
--   tb_btn1 <= '1';
--   wait for 20 us;
--   tb_btn1 <= '0';
--	wait;
--end process;
	
	

process
	begin  
   wait for 3 us;
   tb_btn1 <= '1';
   wait for 20 us;
   tb_btn1 <= '0';
	wait;
end process;
	
	




end Behavioral;
