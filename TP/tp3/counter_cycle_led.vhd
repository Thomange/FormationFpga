----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.05.2023 16:19:02
-- Design Name: 
-- Module Name: counter_cycle_led - Behavioral
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

entity counter_cycle_led is
    Port ( 
        clk : in STD_LOGIC;
        resetn : in STD_LOGIC;
        end_led_counter : out STD_LOGIC
    );
end counter_cycle_led;

architecture Behavioral of counter_cycle_led is

begin


end Behavioral;
