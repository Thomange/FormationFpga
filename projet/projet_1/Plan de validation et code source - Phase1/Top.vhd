
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;


entity top is
    Port ( CLK : in  STD_LOGIC;
           Resetn : in  STD_LOGIC;
           VGA_HS_O : out  STD_LOGIC;
           VGA_VS_O : out  STD_LOGIC;
           VGA_R : out  STD_LOGIC_VECTOR (3 downto 0);
           VGA_B : out  STD_LOGIC_VECTOR (3 downto 0);
           VGA_G : out  STD_LOGIC_VECTOR (3 downto 0));
end top;

architecture Behavioral of top is

signal pxl_clk_int : std_logic; -- Horloge de pixel
signal Reset_int, n_Locked: STD_LOGIC := '0';

signal Active_Video_int : STD_LOGIC := '0';
signal Vpos_int :  std_logic_vector(11 downto 0) := (others =>'0'); 
signal Hpos_int :  std_logic_vector(11 downto 0) := (others =>'0'); 


component clk_wiz_0
port
 (-- Clock in ports
  CLK_IN1  : in     std_logic;
  reset    : in     std_logic;
  -- Clock out ports
  CLK_OUT1  : out    std_logic;
  locked    : out    std_logic
  
 );
end component;


component VTC 
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

component TGP 
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




begin
  
   
clk_div_inst : clk_wiz_0
  port map
   (
    CLK_IN1 => CLK,-- Clock in ports
    CLK_OUT1 => pxl_clk_int,-- Clock out ports
    locked=> Reset_int,
    reset => Resetn
    );
VTC_com : VTC
Port map
         ( Resetn =>n_Locked,
           pxl_clk =>pxl_clk_int,
           VGA_HS_O => VGA_HS_O,
           VGA_VS_O =>VGA_VS_O,
           Hpos =>Hpos_int,
           Vpos =>Vpos_int,
           Active_Video =>Active_Video_int
         );
  
TGP_com : TGP
Port map
         ( Resetn =>n_Locked,
           CLK_IN => pxl_clk_int,
           Active_Video => Active_Video_int,
           h_cntr_reg  => Hpos_int,
           V_cntr_reg => Vpos_int,
           VGA_R  => VGA_R ,
           VGA_B  =>VGA_B, 
           VGA_G  =>VGA_G 
           );

       n_Locked <= not(Reset_int);
  
end Behavioral;
