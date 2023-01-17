entity driver_7_degemnt is 
port(
    SRAM_Add    : in std_logic_vector(7 downto 0); -- Two Hex values
    SRAM_oData  : in std_logic_vector(15 downto 0);
    HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : out std_logic_vector(6 downto 0));
end driver_7_degemnt;

architecture arch of driver_7_degemnt

-- 7 Segment Display LUT component declaration
component controller_7_segment is port(
    iData   : in std_logic_vector(3 downto 0);
    HEX     : out std_logic_vector (6 downto 0));
end component controller_7_segment;

-- Signals
SRAM_Add_d1 <= SRAM_Add (3 downto 0);
SRAM_Add_d2 <= SRAM_Add (7 downto 4)

SRAM_oData_d1 <= SRAM_oData (3 downto 0)
SRAM_oData_d2 <= SRAM_oData (7 downto 4)
SRAM_oData_d3 <= SRAM_oData (11 downto 8)
SRAM_oData_d4 <= SRAM_oData (15 downto 11)

begin

    oData_d1 : controller_7_segment port map (
        iData   => SRAM_oData_d1
        HEX     => HEX1
    );

    oData_d2 : controller_7_segment port map (
        iData   => SRAM_oData_d2
        HEX     => HEX1
    );

    oData_d3 : controller_7_segment port map (
        iData   => SRAM_oData_d3
        HEX     => HEX1
    );

    oData_d4 : controller_7_segment port map (
        iData   => SRAM_oData_d4
        HEX     => HEX1
    );

    Add_d1 : controller_7_segment port map (
        iData   => SRAM_Add_d1
        HEX     => HEX4
    );

    Add_d2 : controller_7_segment port map (
        iData   => SRAM_Add_d2
        HEX     => HEX5
    );

end arch;