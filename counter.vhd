library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counter is
	generic ( 
		CNT_MAX: std_logic_vector(7 downto 0) := X"0F";
		clk_delay : std_logic_vector(27 downto 0) := X"2FAF080"); -- Default 50,000,000 clk cycles (1 sec)
	port (  
		clk			: in std_logic;
		direction	: in std_logic; -- Interchangable with last signal before begin (just uncoment one)
		halt		: in std_logic; -- 0 continue counting, 1 stop counting
		ireset		: in std_logic;
		init 		: in std_logic; -- System init signal
		count		: out std_logic_vector(7 downto 0);
		clk_en		: out std_logic); 
end entity;

architecture behavioral of counter is
	
	-- Signals
	signal cnt			: std_logic_vector(7 downto 0) := (others => '0');
	signal delay_count  : std_logic_vector(27 downto 0) := (others => '0');
	signal clk_delay_reg: std_logic_vector(27 downto 0) := (others => '0');
	
	signal oClk_en 		: std_logic := '0'; 
	
	-- Interchangable with port direction input (just one can be uncomented)
	-- signal direction : std_logic := '0'; -- Fixed value 0, count up
	begin
	
	clk_delay_reg <= 	clk_delay when init = '0' else
						"0000000000000000000000000011" when init = '1';
	-- clk en process
	process (clk, ireset) begin
		if (rising_edge(clk) and halt = '0') then 
			if (ireset = '1') then
				delay_count <= (others => '0');
				oClk_en <= '0'; 
			elsif (delay_count = clk_delay_reg) then
				delay_count <= (others => '0');
				oClk_en <= '1';
			else
				delay_count <= delay_count + '1';
				oClk_en <= '0'; 
			end if;
		end if;
	end process;
	
	-- Counter process
	process(clk, ireset) begin
			if (rising_edge(clk) and oClk_en = '1') then
				if (ireset = '1') then 			-- When reset is high counter goes to 0
					cnt <= (others => '0');
				elsif(direction = '1') then 	-- If not reset and direction is set to 1 then count down
					if (cnt = 0) then
					cnt <= CNT_MAX;				-- When reached 0 and counting down set conter to MAX value
					else
					cnt <= cnt - 1;				-- Each clock cycle count down		
					end if;
				else
					if (cnt = CNT_MAX) then		-- When counting up if MAX is reach reset to 0
						cnt <= (others => '0');
					else
						cnt <= cnt + 1;			-- At clock cycle rising edge count up if direction is 0
					end if;
				end if;
			end if;
	end process;

	count		<= cnt;
	clk_en	<= oClk_en;
end behavioral;