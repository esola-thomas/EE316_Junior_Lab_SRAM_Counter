library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SRAM_Controller_TB is
end SRAM_Controller_TB;

architecture tb of SRAM_Controller_TB is 

signal birData   : std_logic_vector(15 downto 0);
signal iMemAdress       :  std_logic_vector(19 downto 0);
signal R_W              :  std_logic; 
signal clk              :  std_logic := '1';
signal clk_en           :  std_logic := '0'; 
signal oMemAdress       :  std_logic_Vector(19 downto 0);
signal oCE, oUB, oLB, oWE, oOE :  std_logic := '0';
signal iData       : std_logic_vector(15 downto 0);
signal SRAM_data   : std_logic_vector(15 downto 0);

component SRAM_Controller is
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
end component;

begin

    clk <= not clk after 10 ns;

    DUT : SRAM_Controller 
        port map (
            iData       => iData,
            iMemAdress  => iMemAdress,
            R_W         => R_W,
            clk         => clk,
            clk_en      => clk_en,
            SRAM_data   => SRAM_data,
            oMemAdress  => oMemAdress,
            oCE         => oCE,
            oUB         => oUB,
            oLB         => oLB,
            oWE         => oWE,
            oOE         => oOE
        ); 
    process begin
        iData           <= (others => '0');  
        R_W             <= '1';  
        clk_en          <= '0';  
        iMemAdress      <= (others => '0'); 
        SRAM_data       <= (others => 'Z');  
    wait for 20 ns;

    -- Write data to SRAM

        iData           <= X"DEAD";  
        R_W             <= '0';  
        clk_en          <= '1';  
        --SRAM_data       <= ;  
    wait for 20 ns;

        iData           <= X"DEAD";  
        R_W             <= '0';  
        clk_en          <= '0';  
        --SRAM_data       <= ;  
    wait for 20 ns;

        iData           <= X"DEAD";  
        R_W             <= '0';  
        clk_en          <= '0';  
        --SRAM_data       <= ;  
    wait for 20 ns;

        iData           <= X"DEAD";  
        R_W             <= '0';  
        clk_en          <= '0';  
        --SRAM_data       <= ;  
    wait for 20 ns;
        
    -- Read Data in 

        iData           <= (others => '0');  
        R_W             <= '1';  
        clk_en          <= '1';  
        SRAM_data       <= X"FFFF";  
    wait for 20 ns;

        iData           <= (others => '0'); 
        R_W             <= '0';  
        clk_en          <= '0';  
        SRAM_data       <= X"FFFF";  
    wait for 20 ns;

        iData           <= (others => '0');  
        R_W             <= '0';  
        clk_en          <= '0';  
        SRAM_data       <= (others => 'Z');  
    wait for 20 ns;
    wait;

    end process;

end tb;