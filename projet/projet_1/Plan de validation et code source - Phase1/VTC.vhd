
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity VTC is
generic (
        FRAME_WIDTH : natural := 640;
        FRAME_HEIGHT : natural := 480
  ); 

    Port ( pxl_clk : in  STD_LOGIC;
           Resetn : in  STD_LOGIC;
           VGA_HS_O : out  STD_LOGIC;
           VGA_VS_O : out  STD_LOGIC;
           
           Hpos : out std_logic_vector(11 downto 0) := (others =>'0'); -- Registre de compteur horizontal
           Vpos : out std_logic_vector(11 downto 0) := (others =>'0'); -- Registre de compteur vertical
           Active_Video : out STD_LOGIC := '0'
           );
end VTC;

architecture Behavioral of VTC is


--Sync Generation constants

--***640x480@60Hz***--  Requires 25 MHz clock
constant H_FP : natural := 16; --H front porch width (pixels)
constant H_PW : natural := 96; --H sync pulse width (pixels)
constant H_MAX : natural := 800; --H total period (pixels)

constant V_FP : natural := 10; --V front porch width (lines)
constant V_PW : natural := 2; --V sync pulse width (lines)
--constant V_MAX : natural := 525; --V total period (lines)
constant V_MAX : natural := 521; --V total period (lines) 25MHz/(800*60) = 520,83

constant H_POL : std_logic := '0';
constant V_POL : std_logic := '0';


-- Signaux pour les horloges et les signaux de synchronisation
signal active : std_logic;  -- Signal actif pour déterminer si un pixel est affiché ou non

signal h_cntr_reg : std_logic_vector(11 downto 0) := (others =>'0'); -- Registre de compteur horizontal
signal v_cntr_reg : std_logic_vector(11 downto 0) := (others =>'0'); -- Registre de compteur vertical

signal h_sync_reg : std_logic := not(H_POL); -- Registre d'impulsion de synchronisation horizontale
signal v_sync_reg : std_logic := not(V_POL); -- Registre d'impulsion de synchronisation verticale

signal h_sync_dly_reg : std_logic := not(H_POL); -- Registre retardé d'impulsion de synchronisation horizontale
signal v_sync_dly_reg : std_logic :=  not(V_POL); -- Registre retardé d'impulsion de synchronisation verticale

begin
  
  
  
 ------------------------------------------------------
 -------         SYNC GENERATION                 ------
 ------------------------------------------------------
 
  process (pxl_clk, Resetn)
  begin
    if (resetn = '1') then 
       h_cntr_reg <= (others =>'0');
    elsif (rising_edge(pxl_clk)) then
      if (h_cntr_reg = (H_MAX - 1)) then
        h_cntr_reg <= (others =>'0');
      else
        h_cntr_reg <= h_cntr_reg + 1;
      end if;
    end if;
  end process;
  
  process (pxl_clk, Resetn)
  begin
  if (resetn = '1') then 
     v_cntr_reg <= (others =>'0');
    elsif (rising_edge(pxl_clk)) then
      if ((h_cntr_reg = (H_MAX - 1)) and (v_cntr_reg = (V_MAX - 1))) then
        v_cntr_reg <= (others =>'0');
      elsif (h_cntr_reg = (H_MAX - 1)) then
        v_cntr_reg <= v_cntr_reg + 1;
      end if;
    end if;
  end process;
  
  process (pxl_clk, Resetn)
  begin
  if (resetn = '1') then 
      h_sync_reg <= H_POL; -- 0
    elsif (rising_edge(pxl_clk)) then
      if (h_cntr_reg >= (H_FP + FRAME_WIDTH - 1)) and (h_cntr_reg < (H_FP + FRAME_WIDTH + H_PW - 1)) then
        h_sync_reg <= H_POL; -- 0
      else
        h_sync_reg <= not(H_POL); -- 1
      end if;
    end if;
  end process;
  
  
  process (pxl_clk, Resetn)
  begin
  
  if(resetn = '1') then 
    v_sync_reg <= V_POL;
  elsif (rising_edge(pxl_clk)) then
      if (v_cntr_reg >= (V_FP + FRAME_HEIGHT - 1)) and (v_cntr_reg < (V_FP + FRAME_HEIGHT + V_PW - 1)) then
        v_sync_reg <= V_POL;
      else
        v_sync_reg <= not(V_POL);
      end if;
    end if;
  end process;
  
  
  Active_Video<= '1' when ((h_cntr_reg < FRAME_WIDTH) and (v_cntr_reg < FRAME_HEIGHT))else
            '0';

--  process (pxl_clk)
--  begin
--    if (rising_edge(pxl_clk)) then
--      v_sync_dly_reg <= v_sync_reg;
--      h_sync_dly_reg <= h_sync_reg;
--    end if;
--  end process;
  
  -- Sorties pour les signaux de couleur VGA
  VGA_HS_O <= h_sync_reg;
  VGA_VS_O <= v_sync_reg;
  
  Hpos<= h_cntr_reg ;
  Vpos<= v_cntr_reg ;
end Behavioral;
