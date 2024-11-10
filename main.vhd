library ieee ;
library work ;
use ieee.std_logic_1164.ALL ;
use ieee.std_logic_arith.ALL ;
use ieee.std_logic_unsigned.ALL ;
use work.state_package.ALL ;

entity main is
	Port(	clock           : in std_logic ;
			reset           : in std_logic ;
			start           : in std_logic ;
			input           : in std_logic_vector(9 downto 0) ;
			done            : out std_logic ;
			segment_digit_1 : out std_logic_vector(6 downto 0) ;
			segment_digit_2 : out std_logic_vector(6 downto 0) ;
			segment_digit_3 : out std_logic_vector(6 downto 0) ;
			segment_digit_4 : out std_logic_vector(6 downto 0) ;
			segment_digit_5 : out std_logic_vector(6 downto 0) ;
			segment_digit_6 : out std_logic_vector(6 downto 0)) ;
end main ;

architecture Behavioral of main is
	signal state         : state_type := S1 ;
	signal startpv       : std_logic := '1' ;
	signal A             : std_logic_vector(9 downto 0) ;
	signal B             : std_logic_vector(9 downto 0) ;
	signal current       : std_logic_vector(9 downto 0) ;
	signal OP            : std_logic_vector(1 downto 0) ;
-- ------------------------------------------------------------
	signal add_port      : std_logic_vector(19 downto 0) ;
	signal sub_port      : std_logic_vector(19 downto 0) ;
	signal mul_port      : std_logic_vector(19 downto 0) ;
	signal div_port      : std_logic_vector(19 downto 0) ;
	signal rmd_port      : std_logic_vector(19 downto 0) ;
	signal asign_port    : std_logic ;
	signal ssign_port    : std_logic ;
	signal msign_port    : std_logic ;
	signal dsign_port    : std_logic ;
	signal result_port   : std_logic_vector(19 downto 0) ;
	signal rmd_out_port  : std_logic_vector(19 downto 0) ;
	signal sign_out_port : std_logic ;
	signal BCD_1         : std_logic_vector(3 downto 0) ;
	signal BCD_2         : std_logic_vector(3 downto 0) ;
	signal BCD_3         : std_logic_vector(3 downto 0) ;
	signal BCD_4         : std_logic_vector(3 downto 0) ;
	signal BCD_5         : std_logic_vector(3 downto 0) ;
	signal BCD_6         : std_logic_vector(3 downto 0) ;
	
	begin
		process(clock, reset, start)
		begin
-- -------------------------- Reset ---------------------------
			if (reset = '0') then
				state <= S1 ;
				A     <= (others => '0') ;
				B     <= (others => '0') ;
			
			elsif (clock' event and clock = '1') then
				startpv <= start ;
				case state is
-- ------------------------- S1 State ------------------------- Begin State
					when S1 =>
						if (start = '0') then
							state <= S2 ;
						else
							done <= '0' ;
						end if ;
-- ------------------------- S2 State ------------------------- Input A (10 bits)
					when S2 =>
						if (start = '0') and (startpv = '1') then
							A     <= input ;
							state <= S3 ;
						else
							current <= input ;
							done    <= '0' ;
						end if ;
-- ------------------------- S3 State ------------------------- Display Nothing
					when S3 =>
						if (start = '0') and (startpv = '1') then
							state <= S4 ;
						else
							done  <= '0' ;
						end if ;
-- ------------------------- S4 State ------------------------- Input B (10 bits)
					when S4 =>
						if (start = '0') and (startpv = '1') then
							B     <= input ;
							state <= S5 ;
						else
							current <= input ;
							done    <= '0' ;
						end if ;
-- ------------------------- S5 State ------------------------- Display Nothing
					when S5 =>
						if (start = '0') and (startpv = '1') then
							state <= S6 ;
						else
							done  <= '0' ;
						end if ;
-- ------------------------- S6 State ------------------------- Select Operator
					when S6 =>
						if (start = '0') and (startpv = '1') then
							OP    <= input(1 downto 0) ;
							state <= S7 ;
						else
							current(1 downto 0) <= input(1 downto 0) ;
							done                <= '0' ;
						end if ;
-- ------------------------- S7 State ------------------------- Display Result
					when S7 =>
						if (reset = '0') then
							state <= S1 ;
						else
							done  <= '1' ;
						end if ;
-- ------------------------- Others State ---------------------
					when others =>
						state <= S1 ;
				end case ;
			end if ;
		end process ;
-- ------------------------- Port Map -------------------------
		full_adder : entity work.full_adder(data_flow)
			Port map(	A    => A,
							B    => B,
							sum  => add_port,
							sign => asign_port) ;
							
		subtractor : entity work.subtractor(data_flow)
			Port map(	A    => A,
							B    => B,
							diff => sub_port,
							sign => ssign_port) ;
							
		multiplication : entity work.multiplication(Behave)
			Port map(	CLK     => clock,
							RST     => reset,
							STR     => start,
							A       => A,
							B       => B,
							product => mul_port,
							sign    => msign_port) ;
		
		division : entity work.division(Behave)
			Port map(	CLK       => clock,
							RST       => reset,
							A         => A,
							B         => B,
							quotient  => div_port,
							remainder => rmd_port,
							sign      => dsign_port) ;
		
		operator : entity work.operator(Behavioral)
			Port map(	add      => add_port,
							sub      => sub_port,
							mul      => mul_port,
							div      => div_port,
							rmd      => rmd_port,
							asign    => asign_port,
							ssign    => ssign_port,
							msign    => msign_port,
							dsign    => dsign_port,
							OP       => OP,
							result   => result_port,
							rmd_out  => rmd_out_port,
							sign_out => sign_out_port) ;
		
		convert_to_BCD : entity work.convert_to_BCD(Behavioral)
			Port map(	CLK     => clock,
							RST     => reset,
							STR     => start,
							state   => state,
							data    => result_port,
							current => current,
							rmd     => rmd_out_port,
							OP      => OP,
							sign    => sign_out_port,
							BCD_digit_1 => BCD_1,
							BCD_digit_2 => BCD_2,
							BCD_digit_3 => BCD_3,
							BCD_digit_4 => BCD_4,
							BCD_digit_5 => BCD_5,
							BCD_digit_6 => BCD_6) ;
							
		BCD_to_7_segment_1 : entity work.BCD_to_7_segment(data_process)
			Port map(	CLK => clock,
							BCD => BCD_1,
							seven_segment => segment_digit_1) ;

		BCD_to_7_segment_2 : entity work.BCD_to_7_segment(data_process)
			Port map(	CLK => clock,
							BCD => BCD_2,
							seven_segment => segment_digit_2) ;

		BCD_to_7_segment_3 : entity work.BCD_to_7_segment(data_process)
			Port map(	CLK => clock,
							BCD => BCD_3,
							seven_segment => segment_digit_3) ;
					
		BCD_to_7_segment_4 : entity work.BCD_to_7_segment(data_process)
			Port map(	CLK => clock,
							BCD => BCD_4,
							seven_segment => segment_digit_4) ;

		BCD_to_7_segment_5 : entity work.BCD_to_7_segment(data_process)
			Port map(	CLK => clock,
							BCD => BCD_5,
							seven_segment => segment_digit_5) ;
					
		BCD_to_7_segment_6 : entity work.BCD_to_7_segment(data_process)
			Port map(	CLK => clock,
							BCD => BCD_6,
							seven_segment => segment_digit_6) ;
end Behavioral ;