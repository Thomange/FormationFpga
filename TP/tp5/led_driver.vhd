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

entity led_driver is
    Port ( clk      	: in STD_LOGIC;
           resetn   	: in STD_LOGIC;
           update		: in std_logic;
           color_code   : in std_logic_vector(1 downto 0);
           led_r   	 	: out STD_LOGIC;
           led_g    	: out std_logic;
           led_b    	: out std_logic;
           end_cycle    : out std_logic
           );
end led_driver;

architecture Behavioral of led_driver is

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
    
    -- fsm pour commander led allum�e ou non
    type state is (idle, led_on);
    signal current_state        : state;
    signal next_state           : state; 
    
       
    signal s_end_counter        : std_logic;    -- fsm : nombre de p�riode calcul� par le compteur, signal d'entr�e
    signal s_led_on             : std_logic;    -- fsm : signal de sortie qui indique que la led peut �tre allum�
       

     
    signal color_code_mem       : std_logic_vector(1 downto 0);
    signal couleur              : std_logic_vector(2 downto 0);
    
    -- signaux pour d�tection de fin de cycle sur front montant
    signal led_on_sync  : std_logic;
    signal led_on_prev  : std_logic;
    
    --signal resetn               : std_logic := '0';
    
    begin
    
    -- compteur 
    count: counter_unit
    generic map(
        counter_max => 100000000
        )
    port map(
        clk => clk,
        resetn => resetn,
        end_counter => s_end_counter
        ); 
        
        
    led : process(clk, resetn)
    begin
    
        if (resetn = '1') then
            current_state       <= idle;
           
            led_on_sync         <= '0';
            led_on_prev         <= '0';
            color_code_mem      <= "00";
            
			
            
        elsif(rising_edge(clk)) then
            current_state <= next_state;
            
            --gestion du code couleur
            if(update = '1') then
                color_code_mem <= color_code;
            else
                color_code_mem <= color_code_mem;
            end if;
            
            -- registres pour end_cycle avec led_on
            led_on_sync <= s_led_on;
            led_on_prev <= led_on_sync;
            
        end if;
    end process led;

        
         ----------------------------------------------------------------------- 
       -- commande de clignotement et choix des couleurs des led
         -----------------------------------------------------------------------
    -- multiplexeur qui indique quelle couleur sera active
    with color_code_mem select
        couleur <= "100" when "01",
                    "010" when "10",
                    "001" when "11",
                    "000" when others;
   
     -- allumage de la led en fonction de la couleur active et le led_on            
     led_r <= (couleur(2) and s_led_on);  
     led_g <= (couleur(1) and s_led_on);  
     led_b <= (couleur(0) and s_led_on);  
  
    -- d�tection front descendant pour end_cycle
    end_cycle <= (led_on_prev and (not(led_on_sync)));
    
    
    -- signal resetn � 0 pour impl�mentation sur carte du code (pas assez de bouton)
   -- resetn <= '0';   
    
    
    
    
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
