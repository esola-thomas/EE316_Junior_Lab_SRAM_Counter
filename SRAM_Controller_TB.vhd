library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SRAM_Controller_TB is
end SRAM_Controller_TB;

architecture tb of SRAM_Controller_TB is 

signal birData   : std_logic_vector(15 downto 0);
signal iMemAdress       :  std_logic_vector(19 downto 0);
signal R_W              :  std_logic; 
signal clk              :  std_logic;
signal clk_en           :  std_logic := '0'; 
signal oMemAdress       :  std_logic_Vector(19 downto 0);
signal oCE, oUB, oLB, oWE, oOE :  std_logic;
signal Data_r_conf :  std_logic := '1'

component SRAM_Controller is
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
end component;

    clk <= not clk after 10 ns;

    DUT : SRAM_Controller 
        generic map (write_speed_delay <= X"5"); -- Hold for 5 cycles
        port map (
            birData     => birData;
            iMemAdress  => iMemAdress;
            R_W         => R_W;
            clk         => clk;
            clk_en      => clk_en;
            oMemAdress  => oMemAdress;
            oCE         => oCE;
            oUB         => oUB;
            oLB         => oLB;
            oWE         => oWE;
            oOE         => oOE;
        );

    process begin
    
        clk_en      <= '0';
        R_W         <= '1';
    wait for 10 ns;
    
    end process
begin
    iMemAdress  <= (others => '0');

end tb;