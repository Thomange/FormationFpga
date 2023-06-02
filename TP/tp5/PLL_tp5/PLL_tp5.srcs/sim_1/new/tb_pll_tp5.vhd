----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.05.2023 16:07:19
-- Design Name: 
-- Module Name: tb_pll_tp5 - Behavioral
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

entity tb_pll_tp5 is
--  Port ( );
end tb_pll_tp5;

architecture Behavioral of tb_pll_tp5 is

    component pll_tp5 is
        generic(
                cycle_led_max    : positive
            );
        Port ( 
               clk          : in STD_LOGIC;
--               clkA         : in STD_LOGIC;
--               clkB         : in STD_LOGIC;
               reset       : in STD_LOGIC;
               led_0_r      : out STD_LOGIC;
               led_0_g      : out std_logic;
               led_0_b      : out std_logic;
               led_1_r      : out STD_LOGIC;
               led_1_g      : out std_logic;
               led_1_b      : out std_logic
               );
    end component;

        signal s_clk          : STD_LOGIC  := '0';
--        signal s_clkA          : STD_LOGIC  := '0';
--        signal s_clkB        : STD_LOGIC  := '0';
        signal s_reset       : STD_LOGIC  := '0';
        signal s_led_0_r      : STD_LOGIC  := '0';
        signal s_led_0_g      : std_logic  := '0';
        signal s_led_0_b      : std_logic  := '0';
        signal s_led_1_r      : STD_LOGIC  := '0';
        signal s_led_1_g      : std_logic  := '0';
        signal s_led_1_b      : std_logic  := '0';
        
        
        constant hp : time := 5 ns;      --demi periode de 5ns
	    constant period : time := 2*hp;  --periode de 10ns, soit une frequence de 100Hz
        
        -- clkA = 250 Mhz
--        constant hpA : time := 2ns;
--        constant periodA : time := 2*hpA;
                
--        -- clkB = 50 Mhz
--        constant hpB : time := 10ns;
--        constant periodB : time := 2*hpB;        

begin
    simul : pll_tp5
    generic map(
        cycle_led_max   => 10
    )
    port map(
       clk        => s_clk,
--       clkA        => s_clkA,
--       clkB       => s_clkB,       
       reset     => s_reset,  
       led_0_r    => s_led_0_r, 
       led_0_g    => s_led_0_g ,
       led_0_b    => s_led_0_b ,
       led_1_r    => s_led_1_r ,
       led_1_g    => s_led_1_g ,
       led_1_b    => s_led_1_b 
   );
        
    
       
   
    process
    begin
        wait for hp;
        s_clk <= not s_clk;
    end process; 


--    process
--    begin
--        wait for hpA;
--        s_clkA <= not s_clkA;
--    end process; 

--process
--    begin
--        wait for hpB;
--        s_clkB <= not s_clkB;
--    end process; 


    
    process begin
    
        -- initialisation de la carte
        s_reset <= '1';
        wait for period;
        s_reset <= '0';
        
        -- durée de clignotement d'une led (allumée - éteint) : 2*6 période
        -- durée de clignotement d'une couleur : 10*12 periode
        -- clignotement de 3 couleurs : 3*120 periode
        -- resetn après 4*360 period
        wait for 4*360*period;
        s_reset <= '1';
        wait for period;
        s_reset <= '0';
        
        
    end process;
end Behavioral;
