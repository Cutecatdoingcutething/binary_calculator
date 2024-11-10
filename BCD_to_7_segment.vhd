library ieee ;
library work ;
use ieee.std_logic_1164.ALL ;
use ieee.std_logic_arith.ALL ;
use ieee.std_logic_unsigned.ALL ;
use work.state_package.ALL ;

entity BCD_to_7_segment is
   Port(	CLK           : in std_logic ;
			BCD           : in std_logic_vector(3 downto 0) ;
         seven_segment : out std_logic_vector(6 downto 0)) ;
end BCD_to_7_segment ;

architecture data_process of BCD_to_7_segment is
begin
   process (CLK)
   begin
      if (CLK' event and CLK = '1') then
			case BCD is
				when "1010" => seven_segment <= "0011100" ; -- 7-segment display ooo (top) (10)
				when "1011" => seven_segment <= "0100011" ; -- 7-segment display ooo (bottom) (11)
				when "1100" => seven_segment <= "1111111" ; -- 7-segment display empty (12)
				when "1101" => seven_segment <= "0111111" ; -- 7-segment display - for subtractor (13)
				when "1110" => seven_segment <= "0110110" ; -- 7-segment display = for division (14)
				when "0000" => seven_segment <= "1000000" ; -- 7-segment display number 0
				when "0001" => seven_segment <= "1111001" ; -- 7-segment display number 1
				when "0010" => seven_segment <= "0100100" ; -- 7-segment display number 2
				when "0011" => seven_segment <= "0110000" ; -- 7-segment display number 3
				when "0100" => seven_segment <= "0011001" ; -- 7-segment display number 4
				when "0101" => seven_segment <= "0010010" ; -- 7-segment display number 5
				when "0110" => seven_segment <= "0000010" ; -- 7-segment display number 6
				when "0111" => seven_segment <= "1111000" ; -- 7-segment display number 7
				when "1000" => seven_segment <= "0000000" ; -- 7-segment display number 8
				when "1001" => seven_segment <= "0010000" ; -- 7-segment display number 9
				when others => seven_segment <= "0001110" ; -- 7-segment display FFFFFF (15)
			end case ;
      end if ;
   end process ;
end data_process ;