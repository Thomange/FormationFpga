----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.05.2023 17:25:21
-- Design Name: 
-- Module Name: tp4_ledMemory - Behavioral
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

entity tb_led_command is
end tb_led_command;

architecture Behavioral of tb_led_command is

	-- Les constantes suivantes permette de definir la frequence de l'horloge 
	constant hp : time := 5 ns;      --demi periode de 5ns
	constant period : time := 2*hp;  --periode de 10ns, soit une frequence de 100Hz
	


    signal s_clk            : std_logic := '0';
    signal s_resetn         : std_logic := '0';
    signal s_bouton_0       : std_logic := '0';
    signal s_led_r          : std_logic := '0';
    signal s_led_g          : std_logic := '0';
    
    component led_command is
        Port ( clk      : in STD_LOGIC;
               resetn   : in STD_LOGIC;
               bouton_0 : in std_logic;
               led_r    : out STD_LOGIC;
               led_g    : out std_logic
               );
    end component; 
    
    begin
        dut : led_command 
        port map (
            clk         => s_clk,
            resetn      => s_resetn,
            bouton_0    => s_bouton_0,
            led_r       => s_led_r,
            led_g       => s_led_g
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
        
        -- clignotement led rouge sur 4 cycle de compteur
        wait for 110*hp;
        
        -- passage led verte sur 4 cycle d'horloges
        s_bouton_0 <= '1';
        wait for 130*hp;
        
        -- repassage led rouge
        s_bouton_0 <= '0';
        wait for 30*hp;
        
        -- passage led verte allumée à led rouge allumée
        s_resetn <= '1';
        wait for hp;
        s_resetn <= '0';
        wait for 100*hp;
        
        
        
    
    end process;
    
    
end Behavioral;
