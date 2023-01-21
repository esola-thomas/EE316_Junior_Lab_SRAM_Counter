library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity system_state is
port ( clk : in std_logic;
ireset : in std_logic;
data_valid : in std_logic;
key_press : in std_logic_vector(4 downto 0);

direction : out std_logic;  -- to counter
halt : out std_logic;  -- to counter
PR_mode : out std_logic; -- to SRAM Controller
RW_pulse : out std_logic;
OP_mode : out std_logic; -- to SRAM Controller
init : out std_logic; -- to Shift Registers
Add_Data : out std_logic
);
end entity;

architecture behavioral of system_state is
type state_type is (Initialize, OP_F_Halt, OP_R_Halt, OP_F, OP_R, PR_F_Data, PR_F_Add, PR_R_Data, PR_R_Add);
signal state : state_type;
signal clk_en : std_logic;
signal direction_s : std_logic := '0';
signal halt_s : std_logic := '0';
signal PR_mode_s : std_logic := '0';
signal RW_pulse_s : std_logic := '0';
signal OP_mode_s : std_logic := '0';
signal init_s : std_logic := '0';
signal Add_Data_s : std_logic := '0';
signal data_valid_reg : std_logic := '0';
signal count : std_logic_vector(27 downto 0) := X"000000F";

begin
RW_pulse <= RW_pulse_s;

clk_enabler:
process(clk, ireset)
begin
    if (ireset = '1') then
        count <= (others => '0');
        clk_en <= '0';
    elsif (rising_edge(clk)) then
count <= count + 1;
        if (count = X"61A8") then -- (count = 25000) => 1KHz clock divider (60ms ?)
clk_en <= '1';
count <= (others => '0');
        else
clk_en <= '0';
        end if;
    end if;
end process;


process(clk, ireset)
begin
    if (ireset = '1') then
        count <= (others => '0');
        clk_en <= '0';
    elsif (rising_edge(clk)) then
count <= count + 1;
        if (count = X"17D7840") then -- (count = 25000000) => 1Hz clock divider (1 sec ?)
clk_en <= '1';
count <= (others => '0');
        else
clk_en <= '0';
        end if;
    end if;
end process;


process(clk)
begin
	if ireset = '1' then
	state <= Initialize;
	--direction <= '0'; -- Don't care
	--halt <= '1'; -- Don't care
	PR_mode <= '0';
	OP_mode <= '0';
	init <= '1';
	--Add_Data <= '1'; -- Don't care

	elsif(rising_edge(clk)) then
		if RW_pulse_s = '1' then
			RW_pulse_s <= '0';
		end if;
		
		case state is
		-- if data_valid '1' being here makes OP_F_HALT only occur when DV = '1'
		when Initialize =>
		state <= OP_F_Halt;   -- RW = 0
		direction <= '0';
		halt <= '1';
		PR_mode <= '0';
		OP_mode <= '1';
		init <= '0';
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
		RW_pulse_s <= '1';
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
		RW_pulse_s <= '1';
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
		RW_pulse_s <= '1';
		OP_mode <= '0';
		init <= '0';
		Add_Data <= '0';

		elsif (key_press = "10000") then -- L pressed   RW = 0
		state <= PR_R_Data;
		-- direction <= '0'; -- Don't care
		halt <= '1';
		PR_mode <= '1';
		RW_pulse_s <= '1';
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
		RW_pulse_s <= '1';
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
	
end process;
end behavioral; 

