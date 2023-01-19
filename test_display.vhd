library ieee;
use ieee.std_logic_1164.all;

entity test_display is 
port(
    SRAM_Add    : out std_logic_vector(7 downto 0)		:= (others => '0'); -- Two Hex values
    SRAM_oData  : out std_logic_vector(15 downto 0) 	:= (others => '0');
	 iData		 : in std_logic_vector(4 downto 0);
	 SRAM_iData  : in std_logic_vector(15 downto 0)
	 );
end test_display;

architecture arch of test_display is
begin
	SRAM_Add (3 downto 0) <= "1111"; -- 1
	SRAM_Add (7 downto 4) <= iData(3 downto 0); -- Keypad value

	SRAM_oData (3 downto 0) <= SRAM_iData(3 downto 0); -- 5
	SRAM_oData (7 downto 4) <= SRAM_iData(7 downto 4); -- 4
	SRAM_oData (11 downto 8) <= SRAM_iData(11 downto 8); -- 3
	SRAM_oData (15 downto 12) <= SRAM_iData(15 downto 12); -- 2
	
end arch;

