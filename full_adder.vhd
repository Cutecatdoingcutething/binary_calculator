library ieee ;
use ieee.std_logic_1164.ALL ;
use ieee.numeric_std.ALL ;

--  ---------------- Full Adder Component ----------------
entity adder_component is
   Port(	A     : in std_logic ;
         B     : in std_logic ;
         C_in  : in std_logic ;
         C_out : out std_logic ;
         sum   : out std_logic) ;
end adder_component ;

architecture data_flow of adder_component is
	begin
		C_out <= ((A xor B) and C_in) or (A and B) ;
		sum  <= (A xor B) xor C_in ;
end data_flow ;
--  ---------------- Full Adder Generator ----------------
library ieee ;
use ieee.std_logic_1164.ALL ;
use ieee.numeric_std.ALL ;

entity full_adder is
	Generic(	N : integer := 10) ;
	Port(	A     : in std_logic_vector(N-1 downto 0) ;
			B     : in std_logic_vector(N-1 downto 0) ;
			C_out : out std_logic ;
			V     : out std_logic ;
			sum   : out std_logic_vector(2*N-1 downto 0) ;
			sign  : out std_logic) ;
end full_adder ;

architecture data_flow of full_adder is
	component adder_component
	Port(	A     : in std_logic ;
			B     : in std_logic ;
			C_in  : in std_logic ;
			C_out : out std_logic ;
			sum   : out std_logic) ;
	end component ;
	
	signal X      : std_logic_vector(2*N downto 0) ;
	signal A_in   : std_logic_vector(2*N-1 downto 0) ;
	signal B_in   : std_logic_vector(2*N-1 downto 0) ;
	signal sum_in : std_logic_vector(2*N-1 downto 0) ;
	
	begin
		A_in <= std_logic_vector(resize(signed(A), A_in' length)) ;
		B_in <= std_logic_vector(resize(signed(B), B_in' length)) ;
		X(0) <= '0' ;
		
		adder : for i in 0 to 2*N-1 generate
		adder : adder_component port map(A_in(i), B_in(i), X(i), X(i+1), sum_in(i)) ;
		end generate ;
		
		sum   <= sum_in ;
		V     <= X(N) xor X(N-1) ;
		C_out <= X(N) ;
		sign  <= sum_in(2*N-1) ;
end data_flow ;