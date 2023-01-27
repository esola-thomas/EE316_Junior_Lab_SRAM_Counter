library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity system_state is
port ( 
	clk 		: in std_logic;
	ireset 		: in std_logic;
	clk_en		: in std_logic;
	data_valid 	: in std_logic;

	key_press 	: in std_logic_vector(4 downto 0);

	direction 	: out std_logic := '0';   	-- to counter (0 count up 1 count down)
	halt 		: out std_logic := '1';		-- to counter (0 run 1)
	PR_mode 	: out std_logic := '0'; 	-- to SRAM Controller
	OP_mode 	: out std_logic := '0'; 	-- to SRAM Controller
	SRAM_RW 	: out std_logic := '0';		-- Outout to set read/write mode in SRAM controller
	init 		: out std_logic := '1'; 	-- System init output state
	Add_Data 	: out std_logic := '0'
);
end entity;

architecture behavioral of system_state is
	type state_type is (Initialize, OP_F_Halt, OP_R_Halt, OP_F, OP_R, PR_F_Data, PR_F_Add, PR_R_Data, PR_R_Add);
	signal state : state_type := Initialize; -- Set default state to Initialize
	signal data_valid_reg : std_logic := '0';
	signal count : std_logic_vector(27 downto 0) := X"000000F";
	signal init_count : integer := 0;
	
	begin

	init_state_counter : process(clk, clk_en) begin
		if (rising_edge(clk_en)) then
			if (init_count < 256) then 
				init_count <= init_count + 1;
			end if;
		end if;
	end process init_state_counter;

	state_machine : process(clk) begin
		if ireset = '1' then
			state <= Initialize;
			direction <= '0';
			halt <= '0';
			PR_mode <= '1';
			OP_mode <= '1';
			init <= '1';
			SRAM_RW <= '0'; -- Set SRAM Controller to write 
			
			--Add_Data <= '1'; -- Don't care

		elsif(rising_edge(clk)) then
			case state is
			-- if data_valid '1' being here makes OP_F_HALT only occur when DV = '1'
			when Initialize =>
			-- state <= OP_F_Halt;   -- RW = 0
			
			halt <= '0';
			if (init_count = 17) then 
				direction <= '0';
				halt <= '1';
				PR_mode <= '0';
				OP_mode <= '1';
				init <= '0';
				SRAM_RW <= '1';
				state <= OP_F_Halt;
			else
				state <= Initialize;
			end if;

			--Add_Data <= '1'; -- Don't care

			when OP_F_Halt =>
			if((data_valid = '1') and (data_valid_reg = '0')) then
				if (key_press = "10001") then -- H pressed -- TEST
				state <= OP_F;
				direction <= '0';
				halt <= '0';
				PR_mode <= '0';
				OP_mode <= '1';
				init <= '0';
				SRAM_RW <= '1';
				--Add_Data <= '1'; -- Don't care

				elsif (key_press = "10000") then -- L pressed RW = 1
				state <= OP_R_Halt;
				direction <= '1';
				halt <= '1';
				PR_mode <= '0';
				OP_mode <= '1';
				init <= '0';
				-- Add_Data <= '1';

				elsif (key_press = "10010") then -- SH pressed
				state <= PR_F_Data;
				-- direction <= '0'; -- Don't care
				halt <= '1';
				PR_mode <= '1';
				OP_mode <= '0';
				init <= '0';
				Add_Data <= '1';

				end if;
			end if;

			when OP_F =>
			if((data_valid = '1') and (data_valid_reg = '0')) then
				if (key_press = "10001") then -- H pressed
				state <= OP_F_Halt;
				direction <= '0';
				halt <= '1';
				PR_mode <= '0';
				OP_mode <= '1';
				init <= '0';
				--Add_Data <= '1'; -- Don't care

				elsif (key_press = "10000") then -- L pressed   RW = 1
				state <= OP_R;
				direction <= '1';
				halt <= '0';
				PR_mode <= '0';
				OP_mode <= '1';
				init <= '0';
				--Add_Data <= '1'; -- Don't care

				elsif (key_press = "10010") then -- SH pressed
				state <= PR_F_Data;
				-- direction <= '0'; -- Don't care
				halt <= '1';
				PR_mode <= '1';
				OP_mode <= '0';
				init <= '0';
				Add_Data <= '1';

				end if;
			end if;


			when OP_R_Halt =>
			if((data_valid = '1') and (data_valid_reg = '0')) then
				if (key_press = "10001") then -- H pressed
					state <= OP_R;
					direction <= '1';
					halt <= '0';
					PR_mode <= '0';
					OP_mode <= '1';
					init <= '0';
					--Add_Data <= '1'; -- Don't care

				elsif (key_press = "10000") then -- L pressed   RW = 1
					state <= OP_F_Halt;
					direction <= '0';
					halt <= '1';
					PR_mode <= '0';
					OP_mode <= '1';
					init <= '0';
					--Add_Data <= '1';-- Don't care

				elsif (key_press = "10010") then -- SH pressed
					state <= PR_R_Data;
					-- direction <= '0'; -- Don't care
					halt <= '1';
					PR_mode <= '1';
					OP_mode <= '0';
					init <= '0';
					Add_Data <= '1';

				end if;
			end if;

			when OP_R =>
			if((data_valid = '1') and (data_valid_reg = '0')) then
				if (key_press = "10001") then -- H pressed
					state <= OP_R_Halt;
					direction <= '1';
					halt <= '1';
					PR_mode <= '0';
					OP_mode <= '1';
					init <= '0';
					--Add_Data <= '1'; -- Don't care
				elsif (key_press = "10000") then -- L pressed   RW = 1
					state <= OP_F;
					direction <= '0';
					halt <= '0';
					PR_mode <= '0';
					OP_mode <= '1';
					init <= '0';
					--Add_Data <= '1';-- Don't care
				elsif (key_press = "10010") then -- SH pressed
					state <= PR_R_Data;
					-- direction <= '0'; -- Don't care
					halt <= '1';
					PR_mode <= '1';
					OP_mode <= '0';
					init <= '0';
					Add_Data <= '1';
				end if;
			end if;
			when PR_F_Data =>
			if((data_valid = '1') and (data_valid_reg = '0')) then
				if (key_press = "10001") then -- H pressed
					state <= PR_F_Add;
					-- direction <= '0'; -- Don't care
					halt <= '1';
					PR_mode <= '1';
					OP_mode <= '0';
					init <= '0';
					Add_Data <= '0';
				elsif (key_press = "10000") then -- L pressed   RW = 0
					state <= PR_F_Data;
					-- direction <= '0'; -- Don't care
					halt <= '1';
					PR_mode <= '1';
					SRAM_RW <= '1';
					OP_mode <= '0';
					init <= '0';
					Add_Data <= '1';
				elsif (key_press = "10010") then -- SH pressed
					state <= OP_F_Halt;
					direction <= '0';
					halt <= '1';
					PR_mode <= '0';
					OP_mode <= '1';
					init <= '0';
					--Add_Data <= '1'; -- Don't care
				end if;
			end if;
			when PR_F_Add =>
			if((data_valid = '1') and (data_valid_reg = '0')) then
				if (key_press = "10001") then -- H pressed
					state <= PR_F_Data;
					-- direction <= '0'; -- Don't care
					halt <= '1';
					PR_mode <= '1';
					OP_mode <= '0';
					init <= '0';
					Add_Data <= '1';
				elsif (key_press = "10000") then -- L pressed   RW = 0
					state <= PR_F_Add;
					-- direction <= '0'; -- Don't care
					halt <= '1';
					PR_mode <= '1';
					SRAM_RW <= '1';
					OP_mode <= '0';
					init <= '0';
					Add_Data <= '0';
				elsif (key_press = "10010") then -- SH pressed
					state <= OP_F_Halt;
					direction <= '0';
					halt <= '1';
					PR_mode <= '0';
					OP_mode <= '1';
					init <= '0';
					--Add_Data <= '1'; -- Don't care
				end if;
			end if;
			when  PR_R_Data =>
				if((data_valid = '1') and (data_valid_reg = '0')) then
					if (key_press = "10001") then -- H pressed
						state <= PR_R_Add;
						-- direction <= '0'; -- Don't care
						halt <= '1';
						PR_mode <= '1';
						SRAM_RW <= '1';
						OP_mode <= '0';
						init <= '0';
						Add_Data <= '0';

					elsif (key_press = "10000") then -- L pressed   RW = 0
						state <= PR_R_Data;
						-- direction <= '0'; -- Don't care
						halt <= '1';
						PR_mode <= '1';
						SRAM_RW <= '1';
						OP_mode <= '0';
						init <= '0';
						Add_Data <= '1';

					elsif (key_press = "10010") then -- SH pressed
						state <= OP_R_Halt;
						direction <= '1';
						halt <= '1';
						PR_mode <= '0';
						OP_mode <= '1';
						init <= '0';
						--Add_Data <= '1'; -- Don't care
					end if;
				end if;
			when PR_R_Add =>
				if((data_valid = '1') and (data_valid_reg = '0')) then
					if (key_press = "10001") then -- H pressed
						state <= PR_R_Data;
						-- direction <= '0'; -- Don't care
						halt <= '1';
						PR_mode <= '1';
						OP_mode <= '0';
						init <= '0';
						Add_Data <= '1';
					elsif (key_press = "10000") then -- L pressed   RW = 0
						state <= PR_R_Add;
						-- direction <= '0'; -- Don't care
						halt <= '1';
						PR_mode <= '1';
						SRAM_RW <= '1';
						OP_mode <= '0';
						init <= '0';
						Add_Data <= '0';
					elsif (key_press = "10010") then -- SH pressed
						state <= OP_R_Halt;
						direction <= '1';
						halt <= '1';
						PR_mode <= '0';
						OP_mode <= '1';
						init <= '0';
						--Add_Data <= '1'; -- Don't care
					end if;
				end if;
			end case;
			data_valid_reg <= data_valid;
		end if;
	end process state_machine;
end behavioral; 

