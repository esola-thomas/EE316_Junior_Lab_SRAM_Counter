library ieee;
use ieee.std_logic_1164.all;

entity shift_regs_tb is
end;

architecture arch of shift_regs_tb is
component shift_regs is
port (
	iData						: in std_logic_vector(4 downto 0);
	DV, AddOrData, clk	: in std_logic;
	oAdd						: out std_logic_vector(7 downto 0) := (others => '0');
	oData						: out std_logic_vector(15 downto 0) := (others => '0')
);
end component;
	
	signal iData			: std_logic_vector(4 downto 0);
	signal clk				: std_logic := '0';
	signal DV, AddOrData	: std_logic;
	signal oAdd				: std_logic_vector(7 downto 0);
	signal oData			: std_logic_vector(15 downto 0);
	
begin
	clk <= not clk after 5 ns;
	
	UUT: shift_regs
	port map(
		iData => iData,
		DV => DV,
		AddOrData => AddOrData,
		clk => clk,
		oAdd => oAdd,
		oData => oData
	);
	
	process
	begin
		AddOrData <= '0';
		DV <= '0';
		iData <= "10111";
		wait for 100 ns;
		
		DV <= '1';
		
		wait for 25 ns;
		
		DV <= '0';
		
		wait for 100 ns;
		
		iData <= "00111";
		DV <= '1';
		
		wait for 25 ns;
		
		DV <= '0';
		
		wait for 100 ns;
		
		iData <= "01111";
		DV <= '1';
		
		wait for 25 ns;
		
		DV <= '0';
		
		wait for 100 ns;
		
		iData <= "00111";
		DV <= '1';
		
		wait for 25 ns;
		
		DV <= '0';
		
		wait for 100 ns;
		
		AddOrData <= '1';
		iData <= "01111";
		DV <= '1';
		
		wait for 25 ns;
		
		DV <= '0';
		
		wait for 100 ns;
		
		iData <= "00011";
		DV <= '1';
		
		wait for 25 ns;
		
		DV <= '0';
		
		wait for 100 ns;
		
		iData <= "01100";
		DV <= '1';
		
		wait for 25 ns;
		
		DV <= '0';
		
		wait for 100 ns;
		
		iData <= "01010";
		DV <= '1';
		
		wait for 25 ns;
		
		DV <= '0';
		
		wait for 100 ns;
		
		iData <= "00101";
		DV <= '1';
		
		wait for 25 ns;
		
		DV <= '0';
		
		wait;
	end process;
end arch;