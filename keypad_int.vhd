library ieee;
use ieee.std_logic_1164.all;

entity keypad_int is 
generic(MAX_COUNT : integer := 250000);
port(
    clk: 						in std_logic;
	 row:							in std_logic_vector(4 downto 0);
	 column:						out std_logic_vector(3 downto 0);
	 data:						out std_logic_vector(4 downto 0) := "00000";
	 data_valid:				out std_logic
); 
end keypad_int;

architecture arch of keypad_int is
	signal clk_en, dv_reg: std_logic := '0';
	signal count: integer := 0;
	signal rowcolumn : std_logic_vector(8 downto 0);
	signal sel_column: integer := 0;
	signal row_reg: std_logic_vector(4 downto 0);
	signal cbuff: std_logic_vector(3 downto 0) := "0111";
	signal column_en: std_logic := '1';
	
	begin
	rowcolumn <= row & cbuff;
	column <= cbuff;
	data_valid <= dv_reg;
	
	ClockEnable: process (clk) 
	begin
		if (rising_edge(clk)) then
			if (count = MAX_COUNT) then
				count <= 0;
				clk_en <= '1';
			else
				clk_en <= '0';
				count <= count + 1;
			end if;
			
			if (clk_en = '1') then
				if(column_en = '1') then
					if (sel_column = 3) then
						sel_column <= 0;
					else
						sel_column <= sel_column + 1;
					end if;
				end if;
				
				if (dv_reg = '1') then
					dv_reg <= '0';
				end if;
				
				if(row /= "11111") then
					if(row /= row_reg) then
						dv_reg <= '1';
					end if;
				end if;
				
				row_reg <= row;
			end if;
		end if;
	end process;
	
	with row select
		column_en <= 	'1' when "11111",
							'0' when others;
	
	with sel_column select
		cbuff <= 	"0111" when 0,
						"1011" when 1,
						"1101" when 2,
						"1110" when 3,
						"0000" when others;
						
	-- keypad data is 5 bit long because of the extra keys "L" , "H", "Shift"
	-- The first 4 bits shoould be all the hex values 0-F
	with rowcolumn select
		data <=	"00000" when "111101011",
					"00001" when "101110111",
					"00010" when "101111011",
					"00011" when "101111101",
					"00100" when "110110111",
					"00101" when "110111011",
					"00110" when "110111101",
					"00111" when "111010111",
					"01000" when "111011011",
					"01001" when "111011101",
					"01010" when "011110111",
					"01011" when "011111011",
					"01100" when "011111101",
					"01101" when "011111110",
					"01110" when "101111110",
					"01111" when "110111110",
					"10000" when "111101110", --L
					"10001" when "111101101", --H
					"10010" when "111011110", --Shift
					"11111" when others;
end arch;