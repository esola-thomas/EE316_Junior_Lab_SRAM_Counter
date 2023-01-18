library ieee;
use ieee.std_logic_1164.all;

entity keypad_int_tb is
end;

architecture arch of keypad_int_tb is
component keypad_int is 
generic(MAX_COUNT : integer := 250000);
port(
    clk: 						in std_logic;
	 row:							in std_logic_vector(4 downto 0);
	 column:						out std_logic_vector(3 downto 0) := "0111";
	 data:						out std_logic_vector(4 downto 0) := "00000";
	 data_valid:				out std_logic := '0'
); 
end component;

signal clk: std_logic := '0';
signal row: std_logic_vector(4 downto 0);
signal column: std_logic_vector(3 downto 0);
signal data: std_logic_vector(4 downto 0);
signal DV: std_logic;

begin
	clk <= not clk after 5 ns;
	
	UUT: keypad_int
	generic map(MAX_COUNT => 3)
	port map(
		clk => clk,
		row => row,
		column => column,
		data => data,
		data_valid => DV
	);
	
	process
	begin
		row <= "10111";
		wait for 300 ns;
		row <= "11111";
		wait for 300 ns;
		row <= "01111";
		wait;
	end process;
	
end arch;