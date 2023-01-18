library ieee;
use ieee.std_logic_1164.all;

entity test_display is 
port(
    SRAM_Add    : out std_logic_vector(7 downto 0); -- Two Hex values
    SRAM_oData  : out std_logic_vector(15 downto 0) := (others => '0');
	 iData		 : in std_logic_vector(4 downto 0);
	 DV			 : in std_logic
	 );
end test_display;

architecture arch of test_display is
begin
	SRAM_Add (3 downto 0) <= "0001"; -- 1
	SRAM_Add (7 downto 4) <= "0000"; -- 0

	SRAM_oData (3 downto 0) <= "0101"; -- 5
	SRAM_oData (7 downto 4) <= "0100"; -- 4
	SRAM_oData (11 downto 8) <= "0011"; -- 3
	SRAM_oData (15 downto 12) <= iData(3 downto 0); -- Key value
	
end arch;

