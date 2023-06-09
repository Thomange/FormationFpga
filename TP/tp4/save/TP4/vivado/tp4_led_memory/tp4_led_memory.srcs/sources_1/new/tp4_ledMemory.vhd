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
           bouton_1 : in std_logic;
           led_r    : out STD_LOGIC;
           led_g    : out std_logic;
           led_b    : out std_logic
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

        
    signal s_bouton_0           : std_logic;
    signal s_bouton_previous    : std_logic;
    signal update               : std_logic;
    signal color_code           : std_logic_vector(1 downto 0);
    signal color_code_mem       : std_logic_vector(1 downto 0);
    signal couleur              : std_logic_vector(2 downto 0);
    
    
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
            
--            color_code          <= "00";
             
            s_bouton_previous   <= '0';
            s_bouton_0          <= '0';
            color_code_mem      <= "11";
            
        elsif(rising_edge(clk)) then
            current_state <= next_state;
            
            s_bouton_0 <= bouton_0;         -- synchronisation du bouton 0
            
            s_bouton_previous <= s_bouton_0;  -- mise � jour de l'�tat pr�c�dent
            
            
            -- m�morisation de couleur en fonction du signal update
            if(update = '1') then
                color_code_mem <= color_code;
             else
                color_code_mem <= color_code_mem;
            end if;
            
            
            
        end if;
    end process led;
       ----------------------------------------------------------------------- 
       -- commande de  led lors de l'appuie sur le bouton_0
       -----------------------------------------------------------------------
--    led_g <= s_led_on when  cmd = '1'
--        else '0';
        
--    led_r <= '0' when cmd = '1'
--        else s_led_on;
        
         ----------------------------------------------------------------------- 
       -- commande de clignotement et choix des couleurs des led
         -----------------------------------------------------------------------
    with color_code_mem select
        couleur <= "100" when "01",
                    "010" when "10",
                    "001" when "11",
                    "000" when others;
   
                 
     led_r <= (couleur(2) and s_led_on);  
     led_g <= (couleur(1) and s_led_on);  
     led_b <= (couleur(0) and s_led_on);  
  

    -- modification du code couleur par appuie du bouton_1
    with bouton_1 select
        color_code <= "10" when '1',
                      "11" when others;
         
               
    -- d�tection rising edge/ front montant
    update <= (not(s_bouton_previous) and s_bouton_0);    
    
    
    
    
    
    ------------------------ fsm ------------------
    -- fsm pour clignotement de led    
    fsm : process(current_state,s_end_counter)
    begin
        case current_state is
        
            -- �tat initial, led �teinte
            when idle =>                            
                s_led_on <= '0';
                
                if (s_end_counter = '1') then       -- passage � l'�tat suivant
                    next_state <= led_on;
                else
                    next_state <= idle;
                end if;
           
           -- �tat 1 : signal pour allumer la led
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
