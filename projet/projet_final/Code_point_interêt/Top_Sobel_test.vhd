library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity top_Sobel is
   
   generic(
		PX_SIZE : integer := 8      -- taille d'un pixel
		 );
    Port ( 
    clk : in  STD_LOGIC;
          Resetn : in  STD_LOGIC;
          input_data : in std_logic_vector(PX_SIZE-1 downto 0);
		  input_data_valid	: in std_logic;
		  output_data	    : out std_logic_vector(PX_SIZE-1 downto 0);
		  output_data_valid	: out std_logic
           );
end top_Sobel;

architecture Behavioral of top_Sobel is


--============== Filter de sobel =========
component Sobel_Filter is
generic (
       
        IMAGE_WIDTH: natural := 637; -- Largeur de l'image en pixels - 3 pixels 
        IMAGE_HEIGHT: natural := 480; -- Hauteur de l'image en pixels 
        PX_SIZE : integer := 8;      -- taille d'un pixel
        Threshold : integer := 600    -- seuil de détection des contours (700 pour image_americ)
  ); 

    Port ( pxl_clk : in  STD_LOGIC;
           Resetn : in  STD_LOGIC;
           input_data_valid	 : in std_logic:='0';
           output_data_valid : out std_logic:='0';
           input_data : in std_logic_vector(PX_SIZE-1 downto 0):=(others => '0');  -- Données d'entrée de l'image
           output_data : out std_logic_vector(PX_SIZE-1 downto 0):=(others => '0')  -- Données de sortie après l'application de la fenêtre glissante
           );
end component;

begin


 --=========== Sobel =====  
SobelFilter: Sobel_Filter
Port map
         ( Resetn =>Resetn,
           pxl_clk => CLK,
           input_data_valid => input_data_valid,
           output_data_valid => output_data_valid,
           input_data => input_data,
           output_data => output_data
           );

      
end Behavioral;
