library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity ImageFilter is
generic (
       
        --COMPTEUR_MAX_H, COMPTEUR_MAX_V  : natural := 480  -- Valeur maximale du compteur
        IMAGE_WIDTH: natural := 637; -- Largeur de l'image en pixels - 3 pixels 
        IMAGE_HEIGHT: natural := 480 -- Hauteur de l'image en pixels 
  ); 

    Port ( pxl_clk : in  STD_LOGIC;
           Resetn : in  STD_LOGIC;
           Data_valid : in std_logic:='0';
           
           Hpos_Filtre : in std_logic_vector(11 downto 0) := (others =>'0'); -- Registre de compteur horizontal
           Vpos_Filtre : in std_logic_vector(11 downto 0) := (others =>'0'); -- Registre de compteur vertical
           
           input_data : in std_logic_vector(3 downto 0):=(others => '0');  -- Données d'entrée de l'image
           output_data : out std_logic_vector(3 downto 0):=(others => '0')  -- Données de sortie après l'application de la fenêtre glissante
           );
end ImageFilter;

architecture Behavioral of ImageFilter is
type LineBuffer_1 is array (natural range 0 to IMAGE_WIDTH-1) of std_logic_vector(3 downto 0);-- line buffer
type LineBuffer_2 is array (natural range 0 to IMAGE_WIDTH-1) of std_logic_vector(3 downto 0);

signal line_buffers_1, line_buffers_2 : LineBuffer_1 :=(others => (others => '0'));
signal D1, D2, D3, D4, D5, D6, D7, D8, D9 : std_logic_vector(3 downto 0):=(others => '0'); -- 4 bits
signal Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9 : std_logic_vector(7 downto 0):=(others => '0'); -- 8 bits

Signal Data_result: std_logic_vector(7 downto 0):=(others => '0');
 
 
begin
  -- Processus de filtrage de l'image
    image_filtering : process (pxl_clk,Resetn, Data_valid)
 begin
    if (Resetn = '1') then
      -- Réinitialisation des signaux internes
      line_buffers_1 <= (others => (others => '0'));
      line_buffers_2 <= (others => (others => '0'));
      D9<=(others => '0'); D8<=(others => '0');D7<=(others => '0'); 
      D6<=(others => '0'); D5<=(others => '0');D4<=(others => '0'); 
      D3<=(others => '0'); D2<=(others => '0');D1<=(others => '0'); 
                  
    elsif rising_edge(pxl_clk) then
  
     if (Data_valid ='1') then
     -- Décalage des données dans les line buffers
       for i in IMAGE_WIDTH-1 downto 1 loop
           line_buffers_1(i) <= line_buffers_1(i-1);
           line_buffers_2(i) <= line_buffers_2(i-1);
       end loop;
       end if;


    --if (Hpos_Filtre > IMAGE_WIDTH and Vpos_Filtre > IMAGE_HEIGHT) then 
    
    if (Vpos_Filtre > IMAGE_HEIGHT) then 

      line_buffers_1 <= (others => (others => '0'));
      line_buffers_2 <= (others => (others => '0'));
      D9<=(others => '0'); D8<=(others => '0');D7<=(others => '0'); 
      D6<=(others => '0'); D5<=(others => '0');D4<=(others => '0'); 
      D3<=(others => '0'); D2<=(others => '0');D1<=(others => '0'); 
    end if;

D9 <= input_data;
           D8 <= D9;
           D7 <= D8;
           line_buffers_1(0) <= D7; -- enregistrement de la valeur actuelle du signal input_data  dans la première position (0) du tableau  
           D6 <= line_buffers_1(IMAGE_WIDTH-1); 
           D5 <= D6;
           D4 <= D5;
           line_buffers_2(0) <= D4;
           D3 <= line_buffers_2(IMAGE_WIDTH-1); 
           D2 <= D3;
           D1 <= D2;
     
  end if;
  end process;
  
         -- ==== Application du filtre gaussien ====
          ---- --Décalage vers la gauche avec insertion de 0
         Q1<= "0000"& D1; --(*1)
         Q2<= "000"& D2(3 downto 0)&"0"; --(*2)
         Q3<= "0000"&D3; --(*1)
         
         Q4 <= "000"& D4(3 downto 0)&"0"; --(*2)
         Q5<=  "00"& D5(3 downto 0)&"00"; --(*4)
         Q6<= "000"& D6(3 downto 0)&"0"; --(*2)
         
         Q7<= "0000"&D7; --(*1)
         Q8<= "000"& D8(3 downto 0)&"0"; --(*2)
         Q9<= "0000"& D9; --(*1)
         
         Data_result <= Q9 + Q8 + Q7 + Q6+ Q5 + Q4 + Q3 + Q2 + Q1;
         output_data <= Data_result(7 downto 4);


 
 
 end Behavioral;



