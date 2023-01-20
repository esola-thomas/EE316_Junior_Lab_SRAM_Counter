library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity state_system_tb is
end entity;

architecture testbench of state_system_tb is
signal CLK : std_logic := '0';
signal RESET : std_logic;
signal DATA_VALID : std_logic;
signal KEY_PRESS : std_logic_vector(4 downto 0);

signal DIRECTION :  std_logic;  -- to counter
signal HALT :  std_logic;  -- to counter
signal PR_PULSE :  std_logic; -- to SRAM Controller
signal OP_MODE :  std_logic; -- to SRAM Controller
signal INIT :  std_logic; -- to Shift Registers
signal ADD_DATA :  std_logic;
constant PER : time := 20 ns;

component system_state is
port ( clk : in std_logic;
ireset : in std_logic;
data_valid : in std_logic;
key_press : in std_logic_vector(4 downto 0);

direction : out std_logic;  -- to counter
halt : out std_logic;  -- to counter
PR_pulse : out std_logic; -- to SRAM Controller
OP_mode : out std_logic; -- to SRAM Controller
init : out std_logic; -- to Shift Registers
Add_Data : out std_logic
);
end component;

begin

CLK <= not CLK after 10 ns;

DUT: system_state
port map( clk => CLK,
ireset => RESET,
data_valid => DATA_VALID,
key_press => KEY_PRESS,

direction => DIRECTION,
halt => HALT,
PR_pulse => PR_PULSE,
OP_mode => OP_MODE,
init => INIT,
Add_Data => ADD_DATA
);

res : process
begin
RESET <= '1';
wait for 4*PER;
RESET <= '0';
wait;
end process;

valid_data : process
begin

DATA_VALID <= '0';
wait for 4*PER; -- wait for reset
DATA_VALID <= '1';
KEY_PRESS <= "10001";
wait for 5 ns;
DATA_VALID <= '0';

wait for 4*PER; -- wait for reset

DATA_VALID <= '1';
KEY_PRESS <= "10000";
wait for 5 ns;
DATA_VALID <= '0';

end process;

end architecture; 