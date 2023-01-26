-- In idle state the design outputs the last Data value
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SRAM_Controller is 
port(
    iData       : in std_logic_vector(15 downto 0); -- Input port for data to be written to SRAM
    iMemAdress  : in std_logic_vector(19 downto 0); -- Memory adress to read/write
    R_W         : in std_logic; -- Read when HIGH, Write when LOW
    clk         : in std_logic;
    clk_en      : in std_logic; -- clk enable from counter this triggers change form idle

    -- Memory outputs
    SRAM_data   : inout std_logic_vector(15 downto 0); -- Bus to SRAM IC
    oMemAdress  : out std_logic_Vector(19 downto 0);
    oCE, oUB, oLB, oWE, oOE : out std_logic
    );
end SRAM_Controller;

architecture arch of SRAM_Controller is
    signal Data_reg     : std_logic_vector(15 downto 0) := (others => '0'); -- Data reg for tristate buffer (inout port)
    signal birData_in   : std_logic := '1'; -- Tristate buff is input when 1
    signal count        : std_logic := '0'; -- Count when '1'
    signal counter_delay: std_logic_vector(27 downto 0) := (others => '0'); -- Counter for delay hold delay of data to SRAM
    -- Memory State Machine

    -- Read SRAM reg
    signal read_delay : std_logic := '0';

    type mem_operation is (
        idle, 
        mem_read,
        mem_write,
        mem_write_end
    );

    signal mem_state : mem_operation := idle;

begin

    read_write_counter : process (clk) begin 
        if (rising_edge(clk)) then
            if (count = '1') then -- Count up
                counter_delay <= counter_delay + '1';
            else 
                counter_delay <= (others => '0');
            end if;
        end if;
    end process read_write_counter;
    
    mem_state_machine : process (clk, clk_en, R_W) begin

        if (mem_state = idle) then -- Wating for new isntruction
            birData_in <= '0'; -- Output the current Data_reg value
            -- Outputs to memory
            oWE <= '1';
            oOE <= '1';
            Data_reg <= Data_reg;    -- Set Data register to all 1's on idle
            count <= '0';
            read_delay <= '0';

            -- Change current state
            if (rising_edge(clk_en)) then   -- The counter clk enable went HIGH
                if (R_W = '1') then         -- READ STATE
                mem_state <= mem_read;
                birData_in <= '1';
                elsif (R_W = '0') then      -- WRITE STATE
                mem_state <= mem_write;
                Data_reg <= iData;
                else                        -- Stay in idle state
                mem_state <= idle;
                end if;
            end if;

        elsif (mem_state = mem_read) then
            birData_in <= '1'; -- Reading from SRAM so data acts as input
            oWE <= '1';
            oOE <= '0';
            if (read_delay = '1') then
                mem_state <= idle;
                Data_reg <= SRAM_data;
            else     
                read_delay <= '1';
            end if;

        elsif (mem_state = mem_write)  then
            birData_in <= '0'; -- Writing to SRAM so data acts as output
            Data_reg <= iData; -- Write data to SRAM
            if (read_delay = '1') then
                oWE <= '0';
                oOE <= '1';
                read_delay <= '0';
                mem_state <= mem_write_end;
            else     
                read_delay <= '1';
            end if;

        elsif (mem_state = mem_write_end) then 
            birData_in <= '0'; -- Writing to SRAM so data acts as output
            Data_reg <= iData; -- Write data to SRAM
            if (read_delay = '1') then
                oWE <= '1';
                mem_state <= idle;
            else 
                read_delay <= '1';
            end if;
        end if;

    end process mem_state_machine;

    oMemAdress <= iMemAdress;
    -- Tristate buffer configuration, when birData_in = 1 the port acts as input
    SRAM_data <= (others => 'Z') when (birData_in = '1') else Data_reg;
    -- For Current requirements this outputs can be set low
    oCE <= '0';
    oUB <= '0';
    oLB <= '0';
end arch;