library ieee ;
library work ;
use ieee.std_logic_1164.ALL ;
use ieee.std_logic_arith.ALL ;
use ieee.std_logic_unsigned.ALL ;
use work.state_package.ALL ;

entity operator is
	Generic(	N : integer := 20) ;
	Port(	add      : in std_logic_vector(N-1 downto 0) ;
			sub      : in std_logic_vector(N-1 downto 0) ;
			mul      : in std_logic_vector(N-1 downto 0) ;
			div      : in std_logic_vector(N-1 downto 0) ;
			rmd      : in std_logic_vector(N-1 downto 0) ;
			asign    : in std_logic ;
			ssign    : in std_logic ;
			msign    : in std_logic ;
			dsign    : in std_logic ;
			OP       : in std_logic_vector(1 downto 0) ;
			result   : out std_logic_vector(N-1 downto 0) ;
			rmd_out  : out std_logic_vector(N-1 downto 0) ;
			sign_out : out std_logic) ;
end operator ;

architecture Behavioral of operator is
	begin
		process(OP)
		begin
			case OP is
-- ------------------------- Adder Mode ----------------------------
				when "11" =>
					result   <= add ;
					sign_out <= asign ;
-- ------------------------- Subtractor Mode -----------------------
				when "10" =>
					result   <= sub ;
					sign_out <= ssign ;
-- ------------------------- Multiplication Mode -------------------
				when "01" =>
					result   <= mul ;
					sign_out <= msign ;
-- ------------------------- Division Mode -------------------------
				when "00" =>
					result   <= div ;
					rmd_out  <= rmd ;
					sign_out <= dsign ;
-- ------------------------- Others Case ------------------------
				when others =>
					result <= (others => '0') ;
			end case ;
		end process ;
end Behavioral ;