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

entity pll_tp5 is
    generic(
        constant cycle_led_max    : positive	 := 10
        );
    Port ( 
           clk          : in STD_LOGIC;
           reset       : in STD_LOGIC;
           led_0_r      : out STD_LOGIC;
           led_0_g      : out std_logic;
           led_0_b      : out std_logic;
           led_1_r      : out STD_LOGIC;
           led_1_g      : out std_logic;
           led_1_b      : out std_logic
           );
end pll_tp5;

architecture Behavioral of pll_tp5 is
    
    component led_driver is
    port (        
        clk         : in std_logic;
        resetn   	: in STD_LOGIC;
        update		: in std_logic;
        color_code   : in std_logic_vector(1 downto 0);
        led_r   	: out STD_LOGIC;
        led_g    	: out std_logic;
        led_b    	: out std_logic;
        end_cycle    : out std_logic
    );
    end component;
    
    component clk_wiz_0 is
    port(
        reset       : in std_logic;
        clk_in1     : in std_logic;
        clk_out1    : out std_logic;
        clk_out2    : out std_logic;
        locked      : out std_logic
    );
    end component;
     -- machine à état pour le choix de couleur à allumer
     
    type state_color is (red, blue, green);
    signal current_state_color  : state_color;
    signal next_state_color     : state_color;
    
  
    signal s_update             : std_logic;
    signal s_update_tmp         : std_logic;
    signal s_color_code         : std_logic_vector(1 downto 0);
    
    
    signal s_end_count_10       : std_logic := '0';     -- fin de décompte de 10 clignotement de LED
    signal s_end_cycle_1        : std_logic;            -- signal d'un clignotement éffectué pour led_driver_1
    signal s_count              : std_logic_vector (3 downto 0);            -- compteur de cycle de clignotement de led
    
    signal s_count_stretch      : integer range 0 to 4 := 0;
    signal s_update_stretch     : std_logic;
    
    -- test par rapport à exemple internet
    signal r_metastable : std_logic := '0';
    signal r_stable     : std_logic := '0';
    
    signal clkA         : std_logic;
    signal clkB         : std_logic;
    
    -- PLL
    signal s_locked     : std_logic;
    signal s_resetn     : std_logic;

    -- signal resetn               : std_logic := '1';         -- pour le test sur carte
    
    
    begin
        led_driver_1: led_driver
        port map(
            clk => clkA,
            resetn => s_resetn,
            update => s_update,
            color_code   => s_color_code,
            led_r => led_0_r,
            led_g => led_0_g,
            led_b => led_0_b,
            end_cycle => s_end_cycle_1
        );
        
        led_driver_2 : led_driver
        port map(
            clk => clkB,
            resetn => s_resetn,
            update => s_update_stretch,
            color_code   => s_color_code,
            led_r => led_1_r,
            led_g => led_1_g,
            led_b => led_1_b
        );
        
        pll : clk_wiz_0
        port map(
            reset       => reset,   --  reset de tp5_pll
            clk_in1     => clk,
            clk_out1    => clkA,
            clk_out2    => clkB,
            locked      => s_locked
        );
        
        s_resetn <= not s_locked;
        
        led : process(clkA, s_resetn)
        begin
        
            if (s_resetn = '1') then
                s_update        <= '0';
                s_count <= (others =>'0');
                current_state_color <= red;
                
                
            elsif(rising_edge(clkA)) then
            
                current_state_color <= next_state_color;
                
                -- registre à décalage pour update (en synchronisation avec la machine à état)
                s_update <= s_end_count_10;
                
                -- compteur de clignotement
                if(s_end_count_10 = '1') then       -- remise à zéro
                    s_count <= (others => '0');
                elsif(s_end_cycle_1 = '1') then     -- incrémentation du compteur
                    s_count <= s_count + 1;
                else                                -- on maintient le compteur à sa valeur actuelle
                    s_count <= s_count;
                end if;
                
                
                -- pour étirer s_update:
                if s_update = '1' then
                    s_count_stretch <= 4;
                elsif s_count_stretch > 0 then
                    s_count_stretch <= s_count_stretch -1;
                end if;
                    
                
            end if;
        end process led;
        
        -- signal update qui sera étiré pour pouvoir être utilisé par clkB
        s_update_stretch <= '1' when s_count_stretch > 0 else '0';
        
--        process (resetn, clkB) is
--        begin
--            if (rising_edge(clkB)) then
--              r_metastable  <= s_update_stretch;
--              r_stable      <= r_metastable; 
--            end if;
--        end process;
        
        -- test d'égalité pour indiquer le passage fin d'un comptage de 10
        with s_count select
            s_end_count_10 <= '1' when std_logic_vector(to_unsigned(cycle_led_max,4)),
            '0' when others;
    
    -- signal resetn à 0 pour implémentation sur carte du code (pas assez de bouton)
    -- resetn <= '0';   
    
    
    
    
    ------------------------ fsm ------------------
    
    
     -- fsm pour le code couleur qui commande la led à allumer
    fsm_color : process(current_state_color, s_end_count_10)
    begin
        -- update <= '0';
        case current_state_color is 
            when red =>
                s_color_code <= "01";
                if (s_end_count_10 = '1') then
                    next_state_color <= blue;
                else
                    next_state_color <= red;
                end if;
            when blue =>
                s_color_code <= "11";
                if(s_end_count_10 = '1') then
                    next_state_color <= green;
                else
                    next_state_color <= blue;
                end if;
            when green =>
                s_color_code <= "10";
                if(s_end_count_10 = '1') then
                    next_state_color <= red;
                else
                    next_state_color <= green;
                end if;
        end case;
    end process;
   

end Behavioral;
