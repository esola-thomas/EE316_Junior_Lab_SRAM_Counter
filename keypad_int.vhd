library ieee;
use ieee.std_logic_1164.all;

entity keypad_int is 
generic(MAX_COUNT : integer := 250000);
port(
    clk: 						in std_logic;
	 row:							in std_logic_vector(4 downto 0);
	 column:						out std_logic_vector(3 downto 0) := "0111";
	 data:						out std_logic_vector(4 downto 0) := "00000";
	 data_valid:				out std_logic := '0'
); 
end keypad_int;

architecture arch of keypad_int is
	signal clk_en: std_logic := '0';
	signal count: integer := 0;
	signal rowcolumn : std_logic_vector(8 downto 0);
	signal sel_column: integer := 0;
	signal data_reg: std_logic_vector(4 downto 0);
	signal cbuff: std_logic_vector(3 downto 0) := "0111";
	
	begin
	rowcolumn <= row & cbuff;
	
	process (clk) 
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
				if (sel_column = 3) then
					sel_column <= 0;
				else
					sel_column <= sel_column + 1;
				end if;
				
				case sel_column is
					when 0 => column <= "0111";
					when 1 => column <= "1011";
					when 2 => column <= "1101";
					when 3 => column <= "1110";
					when others => column <= "0111";
				end case;
				
				case sel_column is
					when 0 => cbuff <= "0111";
					when 1 => cbuff <= "1011";
					when 2 => cbuff <= "1101";
					when 3 => cbuff <= "1110";
					when others => cbuff <= "0111";
				end case;
			end if;
		end if;
	end process;
	
	set_data: process (clk)
	begin
		case rowcolumn is
			when "111101011" => data <= "00000";
			when "101110111" => data <= "00001";
			when "101111011" => data <= "00010";
			when "101111101" => data <= "00011";
			when "110110111" => data <= "00100";
			when "110111011" => data <= "00101";
			when "110111101" => data <= "00110";
			when "111010111" => data <= "00111";
			when "111011011" => data <= "01000";
			when "111011101" => data <= "01001";
			when "011110111" => data <= "01010";
			when "011111011" => data <= "01011";
			when "011111101" => data <= "01100";
			when "011111110" => data <= "01101";
			when "101111110" => data <= "01110";
			when "110111110" => data <= "01111";
			when "111101110" => data <= "10000"; --L
			when "111101101" => data <= "10001"; --H
			when "111011110" => data <= "10010"; --Shift
			when others => data <= "11111";
		end case;
	end process;
	
end arch;