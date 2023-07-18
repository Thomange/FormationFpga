

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;


entity Tb_Top is
--  Port ( );
end Tb_Top;

architecture Behavioral of Tb_Top is

signal tb_clk, tb_Resetn     : std_logic := '0';
	
-- Les constantes suivantes permette de definir la frequence de l'horloge 
constant hp : time := 4 ns;      --demi periode de 4ns
constant period : time := 2*hp;  --periode de 8ns, soit une frequence de 125Hz

component top
    port ( Resetn : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           VGA_HS_O : out  STD_LOGIC;
           VGA_VS_O : out  STD_LOGIC;
           VGA_R : out  STD_LOGIC_VECTOR (3 downto 0);
           VGA_B : out  STD_LOGIC_VECTOR (3 downto 0);
           VGA_G : out  STD_LOGIC_VECTOR (3 downto 0)
		 );
	end component;



begin

--Affectation des signaux du testbench avec ceux de l'entite a tester
	uut: top
        port map (
            CLK => tb_clk,
            Resetn => tb_Resetn
        );

--Simulation du signal d'horloge en continue
	process
    begin
		wait for hp;
		tb_clk <= not tb_clk;
	end process;

		
process
	begin  
   wait for 20 ms;
   tb_Resetn <= '1';
   wait for 0.1 ms;
   tb_Resetn <= '0';
   wait;
	wait;
end process;
	
	







end Behavioral;
