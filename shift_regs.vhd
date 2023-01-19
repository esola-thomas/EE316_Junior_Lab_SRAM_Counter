library ieee;
use ieee.std_logic_1164.all;

entity shift_regs is
port (
	iData						: in std_logic_vector(4 downto 0);
	DV, AddOrData, clk	: in std_logic;
	oAdd						: out std_logic_vector(7 downto 0) := (others => '0');
	oData						: out std_logic_vector(15 downto 0) := (others => '0')
);
end shift_regs;

architecture arch of shift_regs is
	signal DV_reg : std_logic := '0';
	signal oAdd_reg : std_logic_vector(7 downto 0) := (others => '0');
	signal oData_reg : std_logic_vector(15 downto 0) := (others => '0');
	
begin
	oAdd(7 downto 0) <= oAdd_reg(7 downto 0);
	oData(15 downto 0) <= oData_reg(15 downto 0);
	
	process(clk)
	begin
		if((DV_reg = '0') and (DV = '1') and (iData(4) = '0')) then
			if(AddOrData = '0') then
				--Set to Address register
				oAdd_reg(7 downto 4) <= oAdd_reg(3 downto 0);
				oAdd_reg(3 downto 0) <= iData(3 downto 0);
			else
				--Set to Data register
				oData_reg(15 downto 12) <= oData_reg(11 downto 8);
				oData_reg(11 downto 8) <= oData_reg(7 downto 4);
				oData_reg(7 downto 4) <= oData_reg(3 downto 0);
				oData_reg(3 downto 0) <= iData(3 downto 0);
			end if;
		end if;
		
		DV_reg <= DV;
	end process;
end arch;