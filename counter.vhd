library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counter is
	generic ( constant CNT_MAX: std_logic_vector(7 downto 0) := X"0F");
	port (  
		clk : in std_logic;
		direction : in std_logic;
		halt : in std_logic;
		ireset : in std_logic;
		cout : out std_logic_vector(7 downto 0));
end entity;

architecture behavioral of counter is
	
	-- Signals
	signal cnt : std_logic_vector(7 downto 0) := (others => '0');
	begin

	process(clk, ireset)
		begin
			if (rising_edge(clk)) then
				if (ireset = '1') then
					cnt <= (others => '0');
				elsif(direction = '1') then
					if (cnt = 0) then
					cnt <= CNT_MAX;
					else
					cnt <= cnt - 1;
					end if;
				else
					if (cnt = CNT_MAX) then
						cnt <= (others => '0');
					else
						cnt <= cnt + 1;
					end if;
				end if;
			end if;
	end process;

	cout <= cnt;
end behavioral;