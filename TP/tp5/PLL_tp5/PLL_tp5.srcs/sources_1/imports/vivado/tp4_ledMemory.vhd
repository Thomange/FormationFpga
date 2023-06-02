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
--           resetn   : in STD_LOGIC;
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
    
    
    component fifo_generator_0 is
   PORT (
           clk                       : IN  std_logic := '0';
           srst                      : IN  std_logic := '0';
           wr_en                     : IN  std_logic := '0';
           rd_en                     : IN  std_logic := '0';
           din                       : IN  std_logic_vector(2-1 DOWNTO 0) := (OTHERS => '0');
           dout                      : OUT std_logic_vector(2-1 DOWNTO 0) := (OTHERS => '0');
           full                      : OUT std_logic := '0';
           empty                     : OUT std_logic := '1');

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
    signal color_code_mem       : std_logic_vector(1 downto 0);         -- := "01";
    signal couleur              : std_logic_vector(2 downto 0);
    
    -- signaux internes pour end_cycle
    signal end_cycle            : std_logic := '0';
    signal led_on_sync          : std_logic;
    signal led_on_prev          : std_logic;
    
    -- signaux pour FIFO
    signal s_full               : std_logic := '0';
    signal s_empty              : std_logic := '0';
    
    signal resetn               : std_logic := '1';         -- pour le test sur carte
    
    
    
   
    
    begin
    
    
    -- compteur 
    count: counter_unit
    generic map(
        counter_max => 200000000
        )
    port map(
        clk => clk,
        resetn => resetn,
        end_counter => s_end_counter
        ); 
        
   -- fifo --
   top_inst : fifo_generator_0 
    PORT MAP (
           clk                       => clk,
           srst                      =>resetn,
           wr_en 		             => update,
           rd_en                     => end_cycle,
           din                       => color_code,
           dout                      => color_code_mem,
           full                      => s_full,
           empty                     => s_empty);

   
        
    led : process(clk, resetn, bouton_0)
    begin
    
        if (resetn = '1') then
            current_state       <= idle;
            
--            color_code          <= "00";
             
            s_bouton_previous   <= '0';
            s_bouton_0          <= '0';
            led_on_prev       <= '0';
            led_on_sync       <= '0';
            
        elsif(rising_edge(clk)) then
            current_state <= next_state;
            
            -- registres pour update
            s_bouton_0 <= bouton_0;             -- synchronisation du bouton 0
            s_bouton_previous <= s_bouton_0;    -- mise à jour de l'état précédent
            
            
            -- registres pour end cycle
            led_on_sync <=  s_led_on ;          -- synchronisation de s_led_on
            led_on_prev <= led_on_sync;         -- mise à jour de l'état précédent
            
            
            
            
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
  
            --------------------------------------------------------------
            
            
    -- modification du code couleur par appuie du bouton_1
    with bouton_1 select
        color_code <= "10" when '1',
                      "11" when others;
                      
         
               
    -- détection rising edge/ front montant
    update <= (not(s_bouton_previous) and s_bouton_0); 
    
    -- détection sur front descendant pour end_cycle
    end_cycle <= (led_on_prev and (not(led_on_sync)));
    
    
    -- signal resetn à 0 pour implémentation sur carte du code (pas assez de bouton)
    resetn <= '0';   
    
    
    
    
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
