library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity Compteur is
    generic (
      COMPTEUR_MAX : natural := 100  -- Valeur maximale du compteur
    );
    port ( 
		clk, resetn: in std_logic:= '0'; 
        End_Counter   : out std_logic:= '0'
     );
end Compteur;

architecture behavioral of Compteur is
signal compteur : natural range 0 to COMPTEUR_MAX := 0;  -- Compteur interne
signal ready  : std_logic:= '0';

	begin
	
		--Partie sequentielle
		process(clk,resetn)
		begin
			if(resetn = '1') then 
			-- Réinitialisation du compteur
            compteur <= 0;
			ready <= '0';
			
			elsif(rising_edge(clk)) then
			-- Incrémentation du compteur
			   if compteur = COMPTEUR_MAX then
                  ready <= '1';  -- Signal "End_Counter" à 1 lorsque la valeur maximale est atteinte
              elsif (ready = '0') then
                compteur <= compteur + 1;
            end if;
        end if;
    end process;
	     
	     End_Counter <= ready;
	     
end behavioral;