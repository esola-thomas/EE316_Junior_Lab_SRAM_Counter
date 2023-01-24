library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mux_2_input is
    generic(
        bus_with : integer := 16 
    );
    port(
        iData0  : in std_logic_vector(bus_with-1 downto 0);
        iData1  : in std_logic_vector(bus_with-1 downto 0);
        sel     : in std_logic;
        oData   : out std_logic_vector(bus_with-1 downto 0)
    );
end mux_2_input;

architecture arch of mux_2_input is
begin
    oData <=    iData0 when sel = '0' else
                iData1 when sel = '1';
end arch;