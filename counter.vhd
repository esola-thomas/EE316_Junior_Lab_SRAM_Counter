library IEEE;

use IEEE.STD_LOGIC_1164.ALL;

use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counter is 

	generic ( CNT_MAX 	:= X”0000000F”);

	port (  clk			: in std_logic;

		direction		: in std_logic;

		halt			: in std_logic;

		ireset 			: in std_logic; 



		cout			: out std_logic_vector(7 downto 0);

	) 

end entity; 

architecture behavioral of counter is 

	signal cnt 		: std_logic_vector(7 downto 0) := (others => ‘0’);

begin 

	process(clk) begin

		if (cnt = CNT_MAX) then

			cnt <= (others => ‘0’);

		if (ireset = ‘1’) then

			cnt <= (others => ‘0’);

		if rising_edge(clk) then

			if(direction = ‘1’) then 

				cnt <= cnt + 1;

			else 

				cnt <= cnt - 1;

		end if;

	end if;

	end process; 

	cout <= cnt;

end behavioral;

