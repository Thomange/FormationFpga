library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity Sobel_Filter is
generic (
       
        IMAGE_WIDTH: natural := 637; -- Largeur de l'image en pixels - 3 pixels 
        IMAGE_HEIGHT: natural := 480; -- Hauteur de l'image en pixels 
        PX_SIZE : integer := 8;      -- taille d'un pixel
        Threshold : integer := 250      -- seuil de détection des contours
  ); 

    Port ( pxl_clk : in  STD_LOGIC;
           Resetn : in  STD_LOGIC;
           input_data_valid	 : in std_logic:='0';
           output_data_valid : out std_logic:='0';
           input_data : in std_logic_vector(PX_SIZE-1 downto 0):=(others => '0');  -- Données d'entrée de l'image
           output_data : out std_logic_vector(PX_SIZE-1 downto 0):=(others => '0')  -- Données de sortie après l'application de la fenêtre glissante
           );
end Sobel_Filter;

architecture Behavioral of Sobel_Filter is
-- ======== fenetre glissante ============
type LineBuffer_1 is array (natural range 0 to IMAGE_WIDTH-1) of integer;-- line buffer
signal line_buffers_1, line_buffers_2 : LineBuffer_1;

--============== Compteur =========
signal Counter_V, Counter_H  : unsigned(9 downto 0):= (others => '0');

--============== Recalage =========
constant BUFFER_SIZE: natural := IMAGE_WIDTH + 3; -- Largeur de l'image en pixels 
type Buffer1 is array (natural range 0 to BUFFER_SIZE-1) of integer;-- line buffer pour le re
signal Buffers_1, Buffers_2, Buffers_3, Buffers_4 : Buffer1 ;

signal buffer_ptr : integer := 0;

-- --===== Siganux internes ==============
Signal input_data_tmp,input_data_prev, output_data_tmp, Data_result : integer;
signal D1, D2, D3, D4, D5, D6, D7, D8, D9 : integer := 0;
signal QV4, QV6, QH2, QH8: integer;
signal DV4, DV6, DH2,DH8: std_logic_vector(PX_SIZE -1 downto 0):=(others => '0'); -- 8 bits
Signal Data_result_x, Data_result_y: integer; -- 8 bits
 


begin

  
-- ======== Compteur ======================
Compteurs:  process (pxl_clk, buffer_ptr, resetn)
  begin
    if (resetn = '1') then
      Counter_V <= (others => '0');
      Counter_H <= (others => '0');
      output_data_valid <= '0';

    elsif rising_edge(pxl_clk) then 
     Counter_H <= Counter_H + 1;
      if(unsigned(Counter_H)= BUFFER_SIZE + 2 ) then -- BUFFER_SIZE-1 + 3 // decalage du contour
          Counter_V <= Counter_V + 1;
      end if;
        
     -- ==== ignorer la premiere ligne puis envoyer un pixel et puis ecrire-le dans le fichier
              if (unsigned(Counter_V) >= 1) then --Recalage de 1 ligne vers le haut
                 output_data_valid <= '1'; 
                 else 
                 output_data_valid <= '0'; 
                 end if;
     --================================== 
        
    end if;
  end process;
-- =========================================


  -- Processus de filtrage de l'image
 image_filtering : process (pxl_clk,Resetn)
 begin
    
    if (Resetn = '1') then
    --===========================================
    ----===== Réinitialisation des signaux internes ========
         D9<=0; 
         D8<=0;D7<=0; 
         D6<=0; D5<=0;D4<=0; 
         D3<=0; D2<=0;D1<=0; 
     --===========================================
    ----===== Réinitialisation de line_buffers_1 à zéro ----=====
    for i in line_buffers_1'range loop
        line_buffers_1(i) <= 0;
    end loop;
    --===========================================      
----===============================================    
    elsif rising_edge(pxl_clk) then
     --==========================================
      if(input_data_valid = '1') then
       --==================================
          D9 <= input_data_tmp;
          D8 <= D9;
          D7 <= D8;
          line_buffers_1(0) <= D7; -- enregistrement de la valeur actuelle du signal input_data dans la première position (0) du tableau  
          D6 <= line_buffers_1(IMAGE_WIDTH-1); 
          D5 <= D6;
          D4 <= D5;
          line_buffers_2(0) <= D4;
          D3 <= line_buffers_2(IMAGE_WIDTH-1); 
          D2 <= D3;
          D1 <= D2;
     --==== Décalage des données dans les line buffers =====
           for i in IMAGE_WIDTH-1 downto 1 loop
               line_buffers_1(i) <= line_buffers_1(i-1);
               line_buffers_2(i) <= line_buffers_2(i-1);
           end loop;
           end if;
           
       ----======= Buffer 3 =============
       --=== Remplir Buffer 3 par une ligne de l'image ===
      	   Buffers_3(0) <= input_data_tmp; 
      	   input_data_prev <= Buffers_3(BUFFER_SIZE-1) ; 
       --==== Décalage des données dans le buffer 3 =====
           for i in BUFFER_SIZE-1 downto 1 loop
               Buffers_3(i) <= Buffers_3(i-1);
           end loop;
      	   
      	 --==================================
         
      
  end if;
  end process;
  

--------------==================================
 -- ========== Partie combinatoire =============
--------------==================================
input_data_tmp <= to_integer(unsigned(input_data));
output_data <= std_logic_vector(to_unsigned(output_data_tmp, output_data'length));

-- Data_result <= (D9);
-- Data_result <= 220;

--      --============ --sans passé par le filtre  ==================

--      --==========================================
        
------        ----============ Comparaison avec le seuil pour détecter les contours ==================
        output_data_tmp<= 255 when (Data_result >= Threshold) else 0; 
------        ----==========================================
      
      --============ Comparaison avec le seuil pour détecter les points d'interet ==================
--      output_data_tmp<= 255 when (Data_result >= Threshold) else input_data_prev; 
--      ==========================================

--      -- --============ Comparaison entre image in et image out ==================
--      output_data_tmp <= input_data_prev; 
----      --==========================================

    
      -- ==== convolution 2D avec les noyaux Sobel ====
      -- Gradient horizontal => contours verticaux 
      DV4<= std_logic_vector(to_unsigned(D4,DV4'length)); 
      DV6<= std_logic_vector(to_unsigned(D6,DV6'length)); 
      QV4<= to_integer(unsigned("00000"& DV4(PX_SIZE-1 downto 0)&"0")); --(*2)    
      QV6<= to_integer(unsigned("00000"& DV6(PX_SIZE-1 downto 0)&"0")); --(*2)               

      
      -- Gradient vertical => contours horizontaux
      DH2<= std_logic_vector(to_unsigned(D2,DH2'length));  
      DH8<= std_logic_vector(to_unsigned(D8,DH8'length)); 
      QH2<= to_integer(unsigned("00000"& DH2(PX_SIZE-1 downto 0)&"0")); --(*2)    
      QH8<= to_integer(unsigned("00000"& DH8(PX_SIZE-1 downto 0)&"0")); --(*2) 

  Data_result_x <= (-D1 + D3 - QV4 + QV6 - D7 + D9 ); -- Gradient horizontal => contours verticaux
  Data_result_y <= (-D1 - QH2 - D3 + D7 + QH8 + D9 ); -- Gradient vertical => contours horizontaux
  Data_result <= abs(Data_result_x) + abs(Data_result_y);   
 
 
 end Behavioral;



