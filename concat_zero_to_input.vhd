library ieee;
use ieee.std_logic_1164.all;	-- standard unresolved logic UX01ZWLH-
use ieee.numeric_std.all;       -- for the signed, unsigned types and arithmetic ops
 
entity concat_zero_to_input is 
generic(
    in_size     : integer := 16;
    out_size    : integer := 18 
);
port (
    iData : in  std_logic_vector(in_size  downto 0);
    oData : out std_logic_vector(out_size downto 0)
);
end concat_zero_to_input;

architecture arch of concat_zero_to_input is 

begin
    oData(in_size-1 downto 0)           <= iData;
    oData(out_size-1 downto in_size)    <= (others => '0');
end arch;