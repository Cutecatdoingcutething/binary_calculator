library ieee ;
use ieee.std_logic_1164.ALL ;
use ieee.std_logic_unsigned.ALL ;
use ieee.numeric_std.ALL ;

entity division is
   Generic(	N : integer := 10) ;
   Port( CLK       : in std_logic ;
			RST       : in std_logic ;
         A         : in std_logic_vector(N-1 downto 0):= (others => '0') ;
			B         : in std_logic_vector(N-1 downto 0) := (others => '0') ;
         Quotient  : out std_logic_vector( 2*N-1 downto 0 ):= (others => '0') ; 
			Remainder : out std_logic_vector( 2*N-1 downto 0 ):= (others => '0') ;
			sign      : out std_logic);
end division ;

architecture Behave of division is
   type state_type is (S1, S2, S3) ;
	signal state       : state_type := s1 ;
	signal STR_in      : std_logic := '0' ;
   signal A_in        : std_logic_vector( 2*N-1 downto 0 ):= (others => '0') ;
   signal B_in        : std_logic_vector( 2*N-1 downto 0 ):= (others => '0') ;
	signal unsigned_A  : std_logic_vector(N-1 downto 0) ;
	signal unsigned_B  : std_logic_vector(N-1 downto 0) ;
   signal Q           : std_logic_vector( N-1 downto 0 ):= (others => '0') ;
	signal R           : std_logic_vector(2*N-1 downto 0):= (others => '0') ;
   signal bit_counter : integer := 0 ;
	signal sign_in     : std_logic ;
	
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
		
		STR_in <= '0' ;
-- --------------------- Sign Detector ------------------------
		process (CLK, RST, A, B)
		begin
			if A(9) ='1' and B(9) ='1' and A /= "0000000000" and B /= "0000000000" then 
				sign_in <= '0' ;
			elsif A(9) ='0' and B(9) ='0' and A /= "0000000000" and B /= "0000000000" then 
				sign_in <= '0' ;
			elsif A(9) ='1' and B(9) ='0' and A /= "0000000000" and B /= "0000000000" then 
				sign_in <= '1' ;
			elsif A(9) ='0' and B(9) ='1' and A /= "0000000000" and B /= "0000000000" then 
				sign_in <= '1' ;
			elsif A = "0000000000" and B /=  "0000000000" then
				sign_in <= '0' ;
			end if ;
-- -------------------------- Reset ---------------------------
			if (RST = '0') then 
				state     <= S1 ;
				A_in      <= (others => '0') ;
				B_in      <= (others => '0') ;
				Quotient  <= (others => '0') ;
				Remainder <= (others => '0') ;
				sign      <= '0' ;
				sign_in   <= '0' ;
			  
			elsif (CLK' event and CLK = '1') then
				case state is
-- ------------------------- S1 State -------------------------
					when S1 =>
						if (STR_in = '0') then  
							A_in(N-1 downto 0)   <= unsigned_A ; 
							B_in(2*N-1 downto N) <= unsigned_B ;   
							state                <= S2 ;            
						else
							state <= S1 ; 
						end if ;
-- ------------------------- S2 State -------------------------		
					when S2 => 
						if (bit_counter < N+1) then
							A_in <= A_in - B_in ;
							state <= S3 ;
						else 
							bit_counter            <= 0 ;
							A_in                   <= (others => '0') ;
							B_in                   <= (others => '0') ;
							Q                      <= (others => '0') ;
							Quotient(N-1 downto 0) <= Q ;
							Remainder              <= A_in(2*N-1 downto 0) ;
							state                  <= S1 ;
						end if ;
-- ------------------------- S2 State -------------------------
						when S3 => 
							if (A_in(2*N-1) = '1') then            
								A_in        <= B_in + A_in ;
								B_in        <= std_logic_vector(shift_right(unsigned(B_in), 1)) ; 
								Q           <= std_logic_vector(shift_left(unsigned(Q), 1)) ; 
								bit_counter <= bit_counter + 1;
							else                       
								Q           <= std_logic_vector(shift_left(unsigned(Q), 1)) ; 
								Q(0)        <= '1' ;
								B_in        <= std_logic_vector(shift_right(unsigned(B_in), 1)) ; 								 
								bit_counter <= bit_counter + 1 ;
							end if ;
							state <= S2 ;
							sign  <= sign_in ;
-- ----------------------- Others State -----------------------
						when others =>
							state <= S1 ;
				end case ;
			end if ;
		end process ;
end Behave ;