-- In idle state the design outputs the last Data value
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SRAM_Controller is 
generic(
    write_speed_delay : std_logic_vector(27 downto 0) := X"17D7840" -- Set to 25,000,000 clock cycles (10 ns) 
);
port(
    birData     : inout std_logic_vector(15 downto 0); -- Input data (write)
    iMemAdress  : in std_logic_vector(19 downto 0);
    R_W         : in std_logic; -- Read when HIGH, Write when LOW
    clk         : in std_logic;
    clk_en      : in std_logic; -- clk enable from counter this triggers change form idle

    -- Memory outputs
    oMemAdress  : out std_logic_Vector(19 downto 0);
    oCE, oUB, oLB, oWE, oOE : out std_logic;

    Data_r_conf : out std_logic := '1' -- When HIGH the data buffer in the bus will be set to HIGH impedance
    );
end SRAM_Controller;

architecture arch of SRAM_Controller is
    signal Data_reg     : std_logic_vector(15 downto 0) := (others => '0'); -- Data reg for tristate buffer (inout port)
    signal birData_in   : std_logic := '1'; -- Tristate buff is input when 1
    signal counter_delay: std_logic_vector(27 downto 0) := (others => '0'); -- Counter for delay hold delay of data to SRAM

    -- Memory State Machine
    type mem_operation is (
        idle, 
        mem_read,
        mem_write
    );

    signal mem_state : mem_operation := idle;

begin

    mem_state_machine : process (clk, clk_en, R_W) begin
        if (mem_state = idle) then -- Wating for new isntruction
            birData_in <= '0'; -- Output the current Data_reg value
            -- Outputs to memory
            oWE <= '1';
            oOE <= '1';
            Data_reg <= Data_reg;    -- Set Data register to all 1's on idle
            counter_delay <= (others => '0'); 
            Data_r_conf <= '0';

            -- Change current state
            if (rising_edge(clk_en)) then   -- The counter clk enable went HIGH
                if (R_W = '1') then         -- READ STATE
                mem_state <= mem_read;
                elsif (R_W = '0') then      -- WRITE STATE
                mem_state <= mem_write;
                else                        -- Stay in idle state
                mem_state <= idle;
                end if;
            end if;
        elsif (mem_state = mem_read) then
            birData_in <= '1'; -- Reading from SRAM so data acts as input
            oWE <= '1';
            oOE <= '0';
            Data_r_conf <= '1'; -- Set Data buf to HIGH Impedance to allow SRAM to read birData output
            Data_reg <= birData;
            counter_delay <= counter_delay + '1';
            if (counter_delay = write_speed_delay) then -- Values have been hold for enough time (10 ns)
                mem_state <= idle;
            end if;

        elsif (mem_state = mem_write)  then
            birData_in <= '0'; -- Writing to SRAM so data acts as output
            oWE <= '0';
            oOE <= '1';
            Data_r_conf <= '0'; -- Allow this module to read form Data buf
            Data_reg <= birData; -- Read data from SRAM, will be displayed during IDLE
        end if;

    end process mem_state_machine;

    oMemAdress <= iMemAdress;
    -- Tristate buffer configuration, when birData_in = 1 the port acts as input
    birData <= Data_reg when (birData_in = '1') else (others => 'Z');
    
    -- For Current requirements this outputs can be set low
    oCE <= '0';
    oUB <= '0';
    oLB <= '0';
end arch;