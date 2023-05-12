----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.05.2023 16:56:00
-- Design Name: 
-- Module Name: tb_led_counter - Behavioral
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

entity tb_led_counter is
end tb_led_counter;

architecture Behavioral of tb_led_counter is
    component  tp_fsm is
        generic (
            constant counter_led_max    : positive :=200
        );
        port ( 
            clk			    : in std_logic; 
            resetn		    : in std_logic;
            end_led_counter : out std_logic
         );
     end component;

    signal s_clk                : std_logic := '0';
    signal s_resetn             : std_logic := '0';
    signal s_end_led_counter    : std_logic := '0';
    
    
    -- Les constantes suivantes permette de definir la frequence de l'horloge 
	constant hp : time := 5 ns;      --demi periode de 5ns
	constant period : time := 2*hp;  --periode de 10ns, soit une frequence de 100 MHz
	
    begin
        led_counter : tp_fsm
            generic map(
                counter_led_max => 10
            )
            port map (
                clk => s_clk,
                resetn => s_resetn,
                end_led_counter => s_end_led_counter
            );
        clock : process
        begin
            wait for hp;
            s_clk <= not s_clk;
        end process clock;
        
        process
        begin
            -- intialisation du process
            s_resetn <= '1';
            wait for 10 ns;
            s_resetn <= '0';
            
            -- vérification du compteur qui s'incrémente :
            -- end_counter toutes les 2 us (200 * 10 ns)
            -- end_led_counter toutes les 20 us (10 * 2ns)
             
            wait for 70 us;
            
            
            -- reset du compteur 
            s_resetn <= '1';
            wait for 15 ns;
            s_resetn <= '0';
            
            
        end process;

end Behavioral;
