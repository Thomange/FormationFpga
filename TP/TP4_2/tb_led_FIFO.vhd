----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.05.2023 09:59:54
-- Design Name: 
-- Module Name: tb_led_driver - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_led_fifo is
end tb_led_fifo;

architecture Behavioral of tb_led_fifo is
-- Les constantes suivantes permette de definir la frequence de l'horloge 
	constant hp : time := 5 ns;      --demi periode de 5ns
	constant period : time := 2*hp;  --periode de 10ns, soit une frequence de 100Hz
	


    signal s_clk            : std_logic := '0';
    signal s_resetn         : std_logic := '0';
    signal s_bouton_0       : std_logic := '0';
    signal s_bouton_1       : std_logic := '0';
    signal s_led_r          : std_logic := '0';
    signal s_led_g          : std_logic := '0';
    signal s_led_b          : std_logic := '0';
    
    component led_command is
        Port ( clk      : in STD_LOGIC;
               resetn   : in STD_LOGIC;
               bouton_0 : in std_logic;
               bouton_1 : in std_logic;
               led_r    : out STD_LOGIC;
               led_g    : out std_logic;
               led_b    : out std_logic
               );
    end component; 
    
    begin
        dut : led_command 
        port map (
            clk         => s_clk,
            resetn      => s_resetn,
            bouton_0    => s_bouton_0,
            bouton_1    => s_bouton_1,
            led_r       => s_led_r,
            led_g       => s_led_g,
            led_b       => s_led_b
        );
    
    process 
    begin
        wait for hp;
        s_clk <= not s_clk;
    end process;
    
    process
    begin
    
        -- intialisation 
        s_resetn <= '1';
        wait for hp;
        s_resetn <= '0';
        
        -- parti initial,attente de plusieurs cycle de clignotement pour voir la sortie de FIFO qui maintient un signal.
        wait for 4*20*period;       -- end_cycle tout les 20 périodes d'horloge 
                                    -- (avec un compteur de cycle d'horloge à 10 pour le changement d'état)
        
        
        -- alternance de bleue, vert ajouté au fifo (update avec bouton_0 front montant
        s_bouton_0 <= '1';      -- écriture dans fifo (couleur bleue)
        wait for period;
        s_bouton_0 <= '0';
        wait for 4*period;
        
        s_bouton_1 <= '1';      -- couleur verte
        
        wait for 4*period;
        s_bouton_0 <= '1';      -- écriture dans FIFO
        wait for 2*period;
        s_bouton_0 <= '0';
        wait for 6*period;
        
        s_bouton_1 <= '0';      --couleur bleue
        wait for 4*period;
        s_bouton_0 <= '1';      -- écriture dans FIFO
        wait for period;
        s_bouton_0 <= '0';
        wait for 6*period;
        
        s_bouton_1 <= '1';      -- couleur verte
        
        wait for 4*period;
        s_bouton_0 <= '1';      -- écriture dans FIFO
        wait for period;
        s_bouton_0 <= '0';
        wait for 6*period;
        
         s_bouton_1 <= '0';      --couleur bleue
        s_bouton_0 <= '1';      -- écriture dans FIFO
        wait for period;
        s_bouton_0 <= '0';
     
        s_bouton_1 <= '1';
        
        
        wait for 3*20*period;
        s_bouton_0 <= '1';      -- écriture dans FIFO
        wait for period;
        s_bouton_0 <= '0';
        
        wait for 3*20*period;
        
        
        wait for 10*20*period;
        
        s_resetn <= '1';
        wait for period;
        s_resetn <= '0';
        wait for 2*20*period;
        
     
        
        
    
    end process;
    


end Behavioral;
