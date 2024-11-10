library ieee ;
use ieee.std_logic_1164.ALL ;
use ieee.std_logic_unsigned.ALL ;
use ieee.numeric_std.ALL ;

entity multiplication is
	Generic(	N : integer := 10) ;
	Port(	CLK     : in std_logic ;
			RST     : in std_logic ;
			STR     : in std_logic ;
			A       : in std_logic_vector(N-1 downto 0) ;
			B       : in std_logic_vector(N-1 downto 0) ;
			product : out std_logic_vector(2*N-1 downto 0) ;
			sign    : out std_logic) ;
end multiplication ;

architecture Behave of multiplication is
	type state_type is (S1, S2) ;
	signal state  : state_type := s1 ;
	signal STR_in      : std_logic := '0' ;
	signal A_in        : std_logic_vector(2*N-1 downto 0) := (others => '0') ;
	signal B_in        : std_logic_vector(N-1 downto 0) := (others => '0') ;
	signal unsigned_A  : std_logic_vector(N-1 downto 0) ;
	signal unsigned_B  : std_logic_vector(N-1 downto 0) ;
	signal product_in  : std_logic_vector(2*N-1 downto 0) := (others => '0') ;
	signal sign_in     : std_logic ;
	signal bit_counter : integer := 0 ;

	begin
-- ----------------- 2' Complement Inputs ---------------------
		process(unsigned_A, unsigned_B)
		begin
			if A(N-1) = '1' and B(N-1) = '1' then 
				unsigned_A <= not(A) + 1 ;
				unsigned_B <= not(B) + 1 ;
			elsif A(N-1) = '0' and B(N-1) = '0' then 
				unsigned_A <= A ;
				unsigned_B <= B ;
			elsif A(N-1) = '1' and B(N-1) = '0' then 
				unsigned_A <= not(A) + 1 ;
				unsigned_B <= B ;
			elsif A(N-1) = '0' and B(N-1) = '1' then 
				unsigned_A <= A ;
				unsigned_B <= not(B) + 1 ;
			end if;
		end process ;
-- --------------------- Sign Detector ------------------------
		process(CLK, RST, STR)
		begin
			if A(N-1) ='1' and B(N-1) = '1' then 
				Sign_in <= '0' ;
			elsif A(N-1) = '0' and B(N-1) = '0' then 
				Sign_in <= '0' ;
			elsif A(N-1) = '1' and B(N-1) = '0' then 
				Sign_in <= '1' ;
			elsif A(N-1) = '0' and B(N-1) = '1' then 
				Sign_in <= '1' ;
			end if;
-- -------------------------- Reset ---------------------------
			if (RST = '0') then
				State       <= S1 ;
				A_in        <= (others => '0') ;
				B_in        <= (others => '0') ;
				product_in  <= (others => '0') ;
				product     <= (others => '0') ;
				sign_in     <= '0' ;
			
			elsif (CLK' event and CLK = '1') then
				case state is
-- ------------------------- S1 State -------------------------		
					when S1 =>
						if (STR_in = '0') then
							A_in(N-1 downto 0) <= unsigned_A ;
							B_in               <= unsigned_B ;
							state              <= S2 ;
						else
							state <= S1 ;
						end if ;
-- ------------------------- S2 State -------------------------		
					when S2 =>
						if (bit_counter < N) then
							if (B_in(bit_counter) = '1') then
								product_in  <= product_in + A_in ;
							end if ;
								A_in        <= std_logic_vector(shift_left(unsigned(A_in), 1)) ;
								bit_counter <= bit_counter + 1 ;
						else
							product     <= product_in ;
							bit_counter <= 0 ;
							product_in  <= (others => '0') ;
							A_in        <= (others => '0') ;
							B_in        <= (others => '0') ;
							state       <= S1 ;
						end if ;
						sign <= sign_in ;
-- ----------------------- Others State -----------------------
					when others =>
						state <= s1 ;
				end case ;
			end if ;
		end process ;
end Behave ;