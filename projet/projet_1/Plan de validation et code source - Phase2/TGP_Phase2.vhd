
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity TGP_Phase2 is
generic (
        FRAME_WIDTH : natural := 640;
        FRAME_HEIGHT : natural := 480
  );      
Port ( 
           CLK_IN : in  STD_LOGIC;
           Active_Video : in  STD_LOGIC;
           Resetn : in  STD_LOGIC;
           h_cntr_reg  : in std_logic_vector(11 downto 0) := (others =>'0'); -- Registre de compteur horizontal
           V_cntr_reg : in std_logic_vector(11 downto 0) := (others =>'0'); -- Registre de compteur vertical
           VGA_R : out  STD_LOGIC_VECTOR (3 downto 0);
           VGA_B : out  STD_LOGIC_VECTOR (3 downto 0);
           VGA_G : out  STD_LOGIC_VECTOR (3 downto 0));
end TGP_Phase2;

architecture Behavioral of TGP_Phase2 is
signal Active : std_logic := '0';


--Sync Generation constants

--***640x480@60Hz***--  Requires 25 MHz clock

-- Signaux pour les horloges et les signaux de synchronisation

signal vga_red : std_logic_vector(3 downto 0); -- Signal de couleur rouge
signal vga_green : std_logic_vector(3 downto 0); -- Signal de couleur verte
signal vga_blue : std_logic_vector(3 downto 0); -- Signal de couleur bleue



begin
  
 process (CLK_IN) 
  begin
    if (resetn = '1') then 
       Active <= '0';
    elsif (rising_edge(CLK_IN)) then
      Active <=Active_Video;
    end if;
  end process;
  
  
  
--  vga_red <= (others=>'1') when (Active = '1' and ((v_cntr_reg < FRAME_HEIGHT/4 and (h_cntr_reg < FRAME_WIDTH/4  or (FRAME_WIDTH/2 < h_cntr_reg and h_cntr_reg < 3*FRAME_WIDTH/4))) or 
--                                 ((v_cntr_reg > FRAME_HEIGHT/2 and v_cntr_reg < 3*FRAME_HEIGHT/4) and (h_cntr_reg < FRAME_WIDTH/4  or (FRAME_WIDTH/2 < h_cntr_reg and h_cntr_reg < 3*FRAME_WIDTH/4))) or
--                                 ((v_cntr_reg < FRAME_HEIGHT/2 and v_cntr_reg > FRAME_HEIGHT/4) and ((h_cntr_reg > FRAME_WIDTH/4 and h_cntr_reg < FRAME_WIDTH/2) or (3*FRAME_WIDTH/4 < h_cntr_reg and h_cntr_reg < FRAME_WIDTH))) or
--                                 ((v_cntr_reg < FRAME_HEIGHT and v_cntr_reg > 3*FRAME_HEIGHT/4) and (h_cntr_reg > FRAME_WIDTH/4 and h_cntr_reg < FRAME_WIDTH/2)))) else 

--             (others=>'0');
                    
                    
                                 
--    vga_blue<= (others=>'1') when (Active = '1' and ((v_cntr_reg < FRAME_HEIGHT/4 and (h_cntr_reg < FRAME_WIDTH/4  or (FRAME_WIDTH/2 < h_cntr_reg and h_cntr_reg < 3*FRAME_WIDTH/4))) or 
--                                 ((v_cntr_reg > FRAME_HEIGHT/2 and v_cntr_reg < 3*FRAME_HEIGHT/4) and (h_cntr_reg < FRAME_WIDTH/4  or (FRAME_WIDTH/2 < h_cntr_reg and h_cntr_reg < 3*FRAME_WIDTH/4))) or
--                                 ((v_cntr_reg < FRAME_HEIGHT/2 and v_cntr_reg > FRAME_HEIGHT/4) and ((h_cntr_reg > FRAME_WIDTH/4 and h_cntr_reg < FRAME_WIDTH/2)  or (3*FRAME_WIDTH/4 < h_cntr_reg and h_cntr_reg < FRAME_WIDTH))) or
--                                 ((v_cntr_reg < FRAME_HEIGHT and v_cntr_reg > 3*FRAME_HEIGHT/4) and (h_cntr_reg > 3*FRAME_WIDTH/4 and h_cntr_reg <FRAME_WIDTH)))) else 

--             (others=>'0');                              
                                 
                                 
--  vga_green <= (others=>'1') when (Active = '1' and ((v_cntr_reg < FRAME_HEIGHT/4 and (h_cntr_reg < FRAME_WIDTH/4  or (FRAME_WIDTH/2 < h_cntr_reg and h_cntr_reg < 3*FRAME_WIDTH/4))) or 
--                                 ((v_cntr_reg > FRAME_HEIGHT/2 and v_cntr_reg < 3*FRAME_HEIGHT/4) and (h_cntr_reg < FRAME_WIDTH/4  or (FRAME_WIDTH/2 < h_cntr_reg and h_cntr_reg < 3*FRAME_WIDTH/4))) or
--                                 ((v_cntr_reg < FRAME_HEIGHT/2 and v_cntr_reg > FRAME_HEIGHT/4) and ((h_cntr_reg > FRAME_WIDTH/4 and h_cntr_reg < FRAME_WIDTH/2)  or (3*FRAME_WIDTH/4 < h_cntr_reg and h_cntr_reg < FRAME_WIDTH))) or
--                                 ((v_cntr_reg < FRAME_HEIGHT and v_cntr_reg > 3*FRAME_HEIGHT/4) and (h_cntr_reg > FRAME_WIDTH/2 and h_cntr_reg < 3*FRAME_WIDTH/4))))  else 

--             (others=>'0'); 

  
--     -- Génération des signaux RVB en fonction du compteur horizontal et vertical, et de l'état actif
--  vga_red <= (others=>'1')when (Active = '1' and v_cntr_reg < 100 and (h_cntr_reg < 50 or (100 < h_cntr_reg and h_cntr_reg < 150)or (200 <h_cntr_reg and h_cntr_reg < 512))) else
--              h_cntr_reg(5 downto 2) when (Active = '1' and 100 < v_cntr_reg and  h_cntr_reg < 512 and h_cntr_reg(8) = '1')else 
--              (others=>'1')          when (Active = '1' and ((not(h_cntr_reg < 512) and (v_cntr_reg(8) = '1' and h_cntr_reg(3) = '1')) or
--                                          (not(h_cntr_reg < 512) and (v_cntr_reg(8) = '0' and v_cntr_reg(3) = '1')))) else
--              (others=>'0');
              
      
--  vga_blue <= (others=>'1')when (Active = '1' and v_cntr_reg < 100 and (h_cntr_reg < 50 or (100 < h_cntr_reg and h_cntr_reg < 150)or (200 <h_cntr_reg and h_cntr_reg < 512))) else
--              h_cntr_reg(5 downto 2) when (Active= '1' and 100 < v_cntr_reg and  h_cntr_reg < 512 and h_cntr_reg(6) = '1')else 
--              (others=>'1')          when (Active = '1' and ((not(h_cntr_reg < 512) and (v_cntr_reg(8) = '1' and h_cntr_reg(3) = '1')) or
--                                          (not(h_cntr_reg < 512) and (v_cntr_reg(8) = '0' and v_cntr_reg(3) = '1')))) else
--              (others=>'0');
              
--  vga_green <= (others=>'1')when (Active = '1' and v_cntr_reg < 100 and (h_cntr_reg < 50 or (100 < h_cntr_reg and h_cntr_reg < 150)or (200 <h_cntr_reg and h_cntr_reg < 512))) else
--              h_cntr_reg(5 downto 2) when (Active = '1' and 100 < v_cntr_reg and  h_cntr_reg < 512 and h_cntr_reg(7) = '1')else 
--              (others=>'1')          when (Active = '1' and ((not(h_cntr_reg < 512) and (v_cntr_reg(8) = '1' and h_cntr_reg(3) = '1')) or
--                                          (not(h_cntr_reg < 512) and (v_cntr_reg(8) = '0' and v_cntr_reg(3) = '1')))) else
--              (others=>'0');

  
 
----- ============= filter test ==================
   
  -- je traite que la couleur rouge pour l'instant
  --vga_red <= (others=>'1') when (Active = '1' and v_cntr_reg <3 and  h_cntr_reg < FRAME_WIDTH) else (others=>'0'); 
  --vga_red <= (others=>'1') when (Active = '1' and v_cntr_reg <3) else (others=>'0'); 

  
  
-- vga_red <= (others=>'1') when (Active = '1' and ((v_cntr_reg < FRAME_HEIGHT/4 and (h_cntr_reg < FRAME_WIDTH/4  or (FRAME_WIDTH/2 <= h_cntr_reg and h_cntr_reg < 3*FRAME_WIDTH/4))) or 
--                                ((v_cntr_reg > FRAME_HEIGHT/2 and v_cntr_reg <= 3*FRAME_HEIGHT/4) and (h_cntr_reg < FRAME_WIDTH/4  or (FRAME_WIDTH/2 <= h_cntr_reg and h_cntr_reg < 3*FRAME_WIDTH/4))) or
--                                ((v_cntr_reg < FRAME_HEIGHT/2 and v_cntr_reg >= FRAME_HEIGHT/4) and ((h_cntr_reg >= FRAME_WIDTH/4 and h_cntr_reg < FRAME_WIDTH/2) or (3*FRAME_WIDTH/4 < h_cntr_reg and h_cntr_reg < FRAME_WIDTH))) or
--                                ((v_cntr_reg <= FRAME_HEIGHT and v_cntr_reg > 3*FRAME_HEIGHT/4) and ((h_cntr_reg > FRAME_WIDTH/4 and h_cntr_reg <= FRAME_WIDTH/2) or (h_cntr_reg >= 3*FRAME_WIDTH/4 and h_cntr_reg < FRAME_WIDTH))))) else 
--                                --((v_cntr_reg < FRAME_HEIGHT and v_cntr_reg > 3*FRAME_HEIGHT/4) and ((h_cntr_reg > FRAME_WIDTH/4 and h_cntr_reg < FRAME_WIDTH))))) else 

--           (others=>'0');



vga_red <= (others=>'1') when (Active = '1' and ((v_cntr_reg < FRAME_HEIGHT/4 and (h_cntr_reg < FRAME_WIDTH/4 or (FRAME_WIDTH/2 <= h_cntr_reg and h_cntr_reg < 3*FRAME_WIDTH/4))) or
((v_cntr_reg < FRAME_HEIGHT/2 and v_cntr_reg >= FRAME_HEIGHT/4) and ((h_cntr_reg >= FRAME_WIDTH/4 and h_cntr_reg <= FRAME_WIDTH/2) or (3*FRAME_WIDTH/4 <= h_cntr_reg and h_cntr_reg < FRAME_WIDTH))) or
((v_cntr_reg >= FRAME_HEIGHT/2 and v_cntr_reg < 3*FRAME_HEIGHT/4) and (h_cntr_reg < FRAME_WIDTH/4 or (FRAME_WIDTH/2 <= h_cntr_reg and h_cntr_reg < 3*FRAME_WIDTH/4))) or
((v_cntr_reg <= FRAME_HEIGHT and v_cntr_reg >= 3*FRAME_HEIGHT/4) and ((h_cntr_reg >= FRAME_WIDTH/4 and h_cntr_reg < FRAME_WIDTH/2) or (h_cntr_reg >= 3*FRAME_WIDTH/4 and h_cntr_reg < FRAME_WIDTH))))) else

(others=>'0');



  
  -- Sorties pour les signaux de couleur VGA

      VGA_R  <= vga_red;
      VGA_G <= vga_green;
      VGA_B <= vga_blue;


end Behavioral;
