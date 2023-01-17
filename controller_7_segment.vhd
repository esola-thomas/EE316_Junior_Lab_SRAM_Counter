library ieee;
use ieee.std_logic_1164.all;
-- In HEX bit number 7 (left) is the decimal point, 
-- Applying a low logic level to a segment will light it up and applying a high logic level turns it off.
entity controller_7_segment is 
port(
    iData   : in std_logic_vector(3 downto 0);
    HEX     : out std_logic_vector (6 downto 0) 
);
end controller_7_segment;

architecture arch of controller_7_segment is

    begin
    HEX <=  "1000000" when iData = "0000" else -- 0
            "1111001" when iData = "0001" else -- 1
            "0100100" when iData = "0010" else -- 2
            "0110000" when iData = "0011" else -- 3
            "0011001" when iData = "0100" else -- 4
            "0010010" when iData = "0101" else -- 5
            "0000010" when iData = "0110" else -- 6
            "1111000" when iData = "0111" else -- 7
            "0000000" when iData = "1000" else -- 8
            "0010000" when iData = "1001" else -- 9
            "0100000" when iData = "1010" else -- A
            "0000011" when iData = "1011" else -- B
            "1000110" when iData = "1100" else -- C
            "0100001" when iData = "1101" else -- D
            "0000110" when iData = "1110" else -- E
            "0001110" when iData = "1111"; -- F
end arch;