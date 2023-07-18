library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity top_Phase2 is
    Port ( CLK : in  STD_LOGIC;
           Resetn : in  STD_LOGIC;
           Btn1: in  STD_LOGIC;
           VGA_HS_O : out  STD_LOGIC;
           VGA_VS_O : out  STD_LOGIC;
           VGA_R_out : out  STD_LOGIC_VECTOR (3 downto 0);
           VGA_B_out : out  STD_LOGIC_VECTOR (3 downto 0);
           VGA_G_out : out  STD_LOGIC_VECTOR (3 downto 0);
           LED_Out_R, LED_Out_G : out  STD_LOGIC := '0'
           );
end top_Phase2;

architecture Behavioral of top_Phase2 is

signal pxl_clk_int : std_logic; -- Horloge de pixel
signal Reset_int, n_Locked: STD_LOGIC := '0';

signal Active_Video_int : STD_LOGIC := '0';
signal Vpos_int :  std_logic_vector(11 downto 0) := (others =>'0'); 
signal Hpos_int :  std_logic_vector(11 downto 0) := (others =>'0'); 


signal input_data : std_logic_vector(3 downto 0):= (others =>'0');
signal VGA_R_int, VGA_G_int, VGA_B_int  : STD_LOGIC_VECTOR (3 downto 0):= (others =>'0');
signal VGA_R_out_tmp, VGA_G_out_tmp, VGA_B_out_tmp : STD_LOGIC_VECTOR (3 downto 0):= (others =>'0');
signal VGA_HS_O_tmp, VGA_VS_O_tmp: std_logic := '0';


--===Update ====
signal Btn1_prev, Btn1_prev1, Enable_Filter, Update, Update_prev : std_logic := '0';
  


component clk_wiz_0
port
 (-- Clock in ports
  CLK_IN1  : in     std_logic;
  reset    : in     std_logic;
  -- Clock out ports
  CLK_OUT1 : out    std_logic;
  locked    : out    std_logic
  
 );
end component;


component VTC_Phase2 
    generic (
        FRAME_WIDTH : natural := 640;
        FRAME_HEIGHT : natural := 480
  ); 

    Port ( Resetn : in  STD_LOGIC;
           pxl_clk : in  STD_LOGIC;
           VGA_HS_O : out  STD_LOGIC;
           VGA_VS_O : out  STD_LOGIC;
           
           Hpos : out std_logic_vector(11 downto 0) := (others =>'0'); -- Registre de compteur horizontal
           Vpos : out std_logic_vector(11 downto 0) := (others =>'0'); -- Registre de compteur vertical
           Active_Video : out STD_LOGIC := '0'
           );
end component;

component TGP_Phase2 
generic (
        FRAME_WIDTH : natural := 640;
        FRAME_HEIGHT : natural := 480
        --FRAME_WIDTH : natural := 360;
        --FRAME_HEIGHT : natural := 360

  );      
    Port ( Resetn : in  STD_LOGIC;
           CLK_IN : in  STD_LOGIC;
           Active_Video : in  STD_LOGIC;
           h_cntr_reg  : in std_logic_vector(11 downto 0) := (others =>'0'); -- Registre de compteur horizontal
           V_cntr_reg : in std_logic_vector(11 downto 0) := (others =>'0'); -- Registre de compteur vertical
           VGA_R : out  STD_LOGIC_VECTOR (3 downto 0);
           VGA_B : out  STD_LOGIC_VECTOR (3 downto 0);
           VGA_G : out  STD_LOGIC_VECTOR (3 downto 0));
end component;



component ImageFilter is
generic (
        --WINDOW_SIZE : positive := 3;  -- Taille de la fenêtre glissante
        --IMAGE_WIDTH: natural := 640; -- Largeur de l'image en pixels
        --IMAGE_HEIGHT: natural := 480 -- Hauteur de l'image en pixels
        IMAGE_WIDTH: natural := 637; -- Largeur de l'image en pixels
        IMAGE_HEIGHT: natural := 480 -- Hauteur de l'image en pixels
  ); 

    Port ( pxl_clk: in  STD_LOGIC;
           Resetn : in  STD_LOGIC;
           Data_valid : in std_logic :='0';
           input_data : in std_logic_vector(3 downto 0);  -- Données d'entrée de l'image
           output_data : out std_logic_vector(3 downto 0) ; -- Données de sortie après l'application de la fenêtre glissante
           Hpos_Filtre : in std_logic_vector(11 downto 0) := (others =>'0'); -- Registre de compteur horizontal
           Vpos_Filtre : in std_logic_vector(11 downto 0) := (others =>'0') -- Registre de compteur vertical
           );
end component;

begin
  
   
clk_div_inst : clk_wiz_0
  port map
   (
    CLK_IN1 => CLK,-- Clock in ports
    CLK_OUT1 => pxl_clk_int,-- Clock out ports
    locked=> Reset_int,
    reset => Resetn
    );
VTC_com_Phase2 : VTC_Phase2
Port map
         ( Resetn =>n_Locked,
           pxl_clk =>pxl_clk_int,
           VGA_HS_O => VGA_HS_O_tmp,
           VGA_VS_O =>VGA_VS_O_tmp,
           Hpos =>Hpos_int,
           Vpos =>Vpos_int,
           Active_Video =>Active_Video_int
         );
  
TGP_com_Phase2 : TGP_Phase2
Port map
         ( Resetn =>n_Locked,
           CLK_IN => pxl_clk_int,
           Active_Video => Active_Video_int,
           h_cntr_reg  => Hpos_int,
           V_cntr_reg => Vpos_int,
           VGA_R  => VGA_R_int,
           VGA_B  =>VGA_B_int, 
           VGA_G  =>VGA_G_int 
           );

 
ImageFilter_com : ImageFilter
Port map
         ( Resetn =>n_Locked,
           pxl_clk => pxl_clk_int,
           Data_valid => Active_Video_int,
           input_data => input_data,
           output_data => VGA_R_out_tmp,
           Hpos_Filtre => Hpos_int,
           Vpos_Filtre => Vpos_int
           );


 process (CLK)
 begin
                  
    if(resetn = '1') then
        Btn1_prev <='0';
        Btn1_prev1 <='0';
    elsif rising_edge(CLK) then
      Btn1_prev <= Btn1; -- Mise à jour de l'état précédent du signal Btn1_prev (Rég_1)
      Btn1_prev1 <= Btn1_prev; -- Mise à jour de l'état précédent du signal Btn1_prev1 (Rég_2)
      Enable_Filter <= Update; -- Mise à jour de l'état précédent du signal Enable_Filter (Rég_3)

      
     end if;
end process;

--- ========--Partie combinatoire ======== ---

--==== Reset=====
  n_Locked <= not(Reset_int);
  
--======== Synchronization =========
       VGA_HS_O <= VGA_HS_O_tmp;
       VGA_VS_O <= VGA_VS_O_tmp;
 
--==== Update =====
 Update_prev <= '1' when (Btn1_prev = '1' and Btn1_prev1 = '0') else '0'; -- detector of the rising edge of the Btn1 signal
 Update <= Enable_Filter  when (Update_prev = '0') else 
           not Enable_Filter  when (Update_prev = '1') else
           '0';

 --==== LED =====
 LED_Out_R <= '1' when (Enable_Filter= '0') else '0';
 LED_Out_G <= '1' when (Enable_Filter = '1') else '0';


 
 --=== filter input signal input_data = VGA_Bus ======
  input_data <= VGA_R_int; -- -- on traite qu'une seule couleur (4 bits)
      
  -- ========= Après filtrage ======================== Sans filtre ===   
  VGA_R_out <= VGA_R_out_tmp when Enable_Filter = '1' else VGA_R_int ;
  VGA_G_out <= VGA_R_out_tmp when Enable_Filter = '1' else VGA_R_int ;
  VGA_B_out <= VGA_R_out_tmp when Enable_Filter = '1' else VGA_R_int ;
 
       

 
      
      
      
end Behavioral;
