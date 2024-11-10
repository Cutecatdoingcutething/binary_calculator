library ieee ;
library work ;
use ieee.std_logic_1164.ALL ;
use ieee.std_logic_arith.ALL ;
use ieee.std_logic_unsigned.ALL ;
use work.state_package.ALL ;

entity convert_to_BCD is
	Port(	CLK         : in std_logic ;
			RST         : in std_logic ;
			STR         : in std_logic ;
			state       : in state_type := s1 ;
			data        : in std_logic_vector(19 downto 0) ;
			current     : in std_logic_vector(9 downto 0) ;
			rmd         : in std_logic_vector(19 downto 0) ;
			OP          : in std_logic_vector(1 downto 0) ;
			sign        : in std_logic ;
			BCD_digit_1 : out std_logic_vector(3 downto 0) ;
			BCD_digit_2 : out std_logic_vector(3 downto 0) ;
			BCD_digit_3 : out std_logic_vector(3 downto 0) ;
			BCD_digit_4 : out std_logic_vector(3 downto 0) ;
			BCD_digit_5 : out std_logic_vector(3 downto 0) ;
			BCD_digit_6 : out std_logic_vector(3 downto 0)) ;
end convert_to_BCD ;

architecture Behavioral of convert_to_BCD is
	signal int_data_1   : integer := 0 ;
	signal int_data_2   : integer := 0 ;
	signal int_data_3   : integer := 0 ;
	signal int_data_4   : integer := 0 ;
	signal int_data_5   : integer := 0 ;
	signal num_data     : std_logic_vector(18 downto 0) ;
	signal comp_data    : std_logic_vector(19 downto 0) ;
	signal comp_current : std_logic_vector(9 downto 0) ;
	signal OP_data_0    : std_logic_vector(1 downto 0) ;
	signal OP_data_1    : std_logic_vector(1 downto 0) ;
	signal sign_BCD     : std_logic_vector(3 downto 0) ;
	
	begin
		num_data <= data(18 downto 0) ;

		process(OP)
		begin
-- ---------------- 2' Complement of Full Adder and Subtractor ----------------
			if (OP = "11") or (OP = "10") then
				if data(19) = '0' then
					comp_data <= '0' & num_data ;
				else
					comp_data <= '0' & not(num_data) + 1 ;
				end if ;
				
			elsif (OP = "01") then
				comp_data <= data ;
				
			elsif (OP = "00") then
				comp_data <= data ;
			end if ;
		end process ;
		
		process(CLK, RST)
		begin
-- -------------------------- Reset ---------------------------
			if (RST = '0') then
				int_data_1 <= 11 ;
				int_data_2 <= 11 ;
				int_data_3 <= 11 ;
				int_data_4 <= 10 ;
				int_data_5 <= 10 ;
				sign_BCD   <= "1010" ;
				
			elsif (CLK' event and CLK = '1') then
				case state is
-- ------------------------- S1 State ------------------------- First State
					when S1 =>
						int_data_1 <= 11 ;
						int_data_2 <= 11 ;
						int_data_3 <= 11 ;
						int_data_4 <= 10 ;
						int_data_5 <= 10 ;
						sign_BCD   <= "1010" ;
-- ------------------------- S2 State ------------------------- Input A (10 bits)
					when S2 =>
						if (current(9) = '0') then
							int_data_1 <= conv_integer(unsigned(current)) mod 10 ;
							int_data_2 <= (conv_integer(unsigned(current))/10) mod 10 ;
							int_data_3 <= (conv_integer(unsigned(current))/100) mod 10 ;
							int_data_4 <= (conv_integer(unsigned(current))/1000) mod 10 ;
							int_data_5 <= (conv_integer(unsigned(current))/10000) mod 10 ;
							sign_BCD   <= "1100" ;
							
						else
							comp_current <= not(current) + 1 ;
							int_data_1   <= conv_integer(unsigned(comp_current)) mod 10 ;
							int_data_2   <= (conv_integer(unsigned(comp_current))/10) mod 10 ;
							int_data_3   <= (conv_integer(unsigned(comp_current))/100) mod 10 ;
							int_data_4   <= (conv_integer(unsigned(comp_current))/1000) mod 10 ;
							int_data_5   <= (conv_integer(unsigned(comp_current))/10000) mod 10 ;
							sign_BCD     <= "1101" ;
						end if ;
-- ------------------------- S3 State ------------------------- Display Nothing
					when S3 =>
						int_data_1 <= 12 ;
						int_data_2 <= 12 ;
						int_data_3 <= 12 ;
						int_data_4 <= 12 ;
						int_data_5 <= 12 ;
						sign_BCD   <= "1100" ;
-- ------------------------- S4 State ------------------------- Input B (10 bits)
					when S4 =>
						if (current(9) = '0') then
							int_data_1 <= conv_integer(unsigned(current)) mod 10 ;
							int_data_2 <= (conv_integer(unsigned(current))/10) mod 10 ;
							int_data_3 <= (conv_integer(unsigned(current))/100) mod 10 ;
							int_data_4 <= (conv_integer(unsigned(current))/1000) mod 10 ;
							int_data_5 <= (conv_integer(unsigned(current))/10000) mod 10 ;
							sign_BCD   <= "1100" ;
						
						else
							comp_current <= not(current) + 1 ;
							int_data_1 <= conv_integer(unsigned(comp_current)) mod 10 ;
							int_data_2 <= (conv_integer(unsigned(comp_current))/10) mod 10 ;
							int_data_3 <= (conv_integer(unsigned(comp_current))/100) mod 10 ;
							int_data_4 <= (conv_integer(unsigned(comp_current))/1000) mod 10 ;
							int_data_5 <= (conv_integer(unsigned(comp_current))/10000) mod 10 ;
							sign_BCD   <= "1101" ;
						end if ;
-- ------------------------- S5 State ------------------------- Display Nothing
					when S5 =>
						int_data_1 <= 12 ;
						int_data_2 <= 12 ;
						int_data_3 <= 12 ;
						int_data_4 <= 12 ;
						int_data_5 <= 12 ;
						sign_BCD   <= "1100" ;
-- ------------------------- S6 State ------------------------- select Operator
					when S6 =>
						OP_data_0(0) <= current(0) ;
						OP_data_1(0) <= current(1) ;
						int_data_1   <= conv_integer(unsigned(OP_data_0)) ;
						int_data_2   <= conv_integer(unsigned(OP_data_1)) ;
						int_data_3   <= 12 ;
						int_data_4   <= 12 ;
						int_data_5   <= 12 ;
						sign_BCD   <= "1100" ;
-- ------------------------- S7 State ------------------------- Display Result
					when S7 =>
						if (OP = "11") or (OP = "10") then
							int_data_1 <= conv_integer(unsigned(comp_data)) mod 10 ;
							int_data_2 <= (conv_integer(unsigned(comp_data))/10) mod 10 ;
							int_data_3 <= (conv_integer(unsigned(comp_data))/100) mod 10 ;
							int_data_4 <= (conv_integer(unsigned(comp_data))/1000) mod 10 ;
							int_data_5 <= (conv_integer(unsigned(comp_data))/10000) mod 10 ;
							sign_BCD   <= "110" & sign ;
						
						elsif (OP = "01") then
							if (conv_integer(unsigned(data)) / 10000) >= 10 then
								int_data_1 <= 15 ;
								int_data_2 <= 15 ;
								int_data_3 <= 15 ;
								int_data_4 <= 15 ;
								int_data_5 <= 15 ;
								sign_BCD   <= "1111" ;
							else
								int_data_1 <= conv_integer(unsigned(comp_data)) mod 10 ;
								int_data_2 <= (conv_integer(unsigned(comp_data))/10) mod 10 ;
								int_data_3 <= (conv_integer(unsigned(comp_data))/100) mod 10 ;
								int_data_4 <= (conv_integer(unsigned(comp_data))/1000) mod 10 ;
								int_data_5 <= (conv_integer(unsigned(comp_data))/10000) mod 10 ;
								sign_BCD   <= "110" & sign ;
							end if ;
							
						elsif (OP = "00") then
							if (conv_integer(unsigned(comp_data)) / 10 >= 10) or (conv_integer(unsigned(rmd)) / 10 >= 10)	 then
								int_data_1 <= 15 ;
								int_data_2 <= 15 ;
								int_data_3 <= 15 ;
								int_data_4 <= 15 ;
								int_data_5 <= 15 ;
								sign_BCD   <= "1111" ;
								
							else
								int_data_1 <= conv_integer(unsigned(rmd)) mod 10 ;
								int_data_2 <= (conv_integer(unsigned(rmd))/10) mod 10 ;
								int_data_3 <= 14 ;
								int_data_4 <= conv_integer(unsigned(comp_data)) mod 10 ;
								int_data_5 <= (conv_integer(unsigned(comp_data))/10) mod 10 ;
								sign_BCD   <= "110" & sign ;
							end if ;
						end if ;
					end case ;
			end if ;
		end process ;
		
		BCD_digit_1 <= conv_std_logic_vector(int_data_1, 4) ;
		BCD_digit_2 <= conv_std_logic_vector(int_data_2, 4) ;
		BCD_digit_3 <= conv_std_logic_vector(int_data_3, 4) ;
		BCD_digit_4 <= conv_std_logic_vector(int_data_4, 4) ;
		BCD_digit_5 <= conv_std_logic_vector(int_data_5, 4) ;
		BCD_digit_6 <= sign_BCD ;
end Behavioral ;