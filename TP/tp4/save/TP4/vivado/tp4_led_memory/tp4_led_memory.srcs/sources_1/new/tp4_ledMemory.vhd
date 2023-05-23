----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.05.2023 14:12:16
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

use ieee.std_logic_unsigned.all;
use ieee.NUMERIC_STD.ALL;




-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity led_command is
    Port ( clk      : in STD_LOGIC;
           resetn   : in STD_LOGIC;
           bouton_0 : in std_logic;
           led_r    : out STD_LOGIC;
           led_g    : out std_logic
           );
end led_command;

architecture Behavioral of led_command is

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
    
    type state is (idle, led_on);
    signal current_state        : state;
    signal next_state           : state; 
    
    signal s_end_counter        : std_logic; 
    signal s_led_on             : std_logic;  
    signal s_led_r              : std_logic;
    signal s_led_g              : std_logic;
    
    signal s_bouton_0           : std_logic;
    signal s_bouton_previous    : std_logic;
    signal cmd                  : std_logic;
    
    
    begin
    
    -- compteur 
    count: counter_unit
    generic map(
        counter_max => 10
        )
    port map(
        clk => clk,
        resetn => resetn,
        end_counter => s_end_counter
        ); 
        
        
    led : process(clk, resetn, bouton_0)
    begin
    
        if (resetn = '1') then
            current_state       <= idle;
--            s_bouton_previous   <= '0';
--            s_bouton_0          <= '0';
            
        elsif(rising_edge(clk)) then
            current_state <= next_state;
            
            s_bouton_0 <= bouton_0;         -- synchronisation du bouton 0
            
            s_bouton_previous <= s_bouton_0;  -- 
            
            
            
        end if;
    end process led;
    
       -- commande de  led lors de l'appuie sur le bouton_0
    led_g <= s_led_on when  cmd = '1'
        else '0';
        
    led_r <= '0' when cmd = '1'
        else s_led_on;
        
    -- détection rising edge/ front montant
    cmd <= (not(s_bouton_previous) and s_bouton_0);    
    
    
    ------------------------ fsm ------------------
    -- fsm pour clignotement de led    
    fsm : process(current_state,s_end_counter)
    begin
        case current_state is
        
            -- état initial, led éteinte
            when idle =>                            
                s_led_on <= '0';
                
                if (s_end_counter = '1') then       -- passage à l'état suivant
                    next_state <= led_on;
                else
                    next_state <= idle;
                end if;
           
           -- état 1 : signal pour allumer la led
            when led_on =>                          
                s_led_on <= '1';
                
                if (s_end_counter = '1') then
                    next_state <= idle;
                else
                    next_state <= led_on;
                end if;
                
        end case;
    end process fsm;
    
    

end Behavioral;
