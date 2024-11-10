library ieee ;
use ieee.std_logic_1164.ALL ;
use ieee.numeric_std.ALL ;

--  ---------------- Subtractor Component ----------------
entity subtractor_component is
   Port(	A     : in std_logic ;
         B     : in std_logic ;
         C_in  : in std_logic ;
         C_out : out std_logic ;
         diff  : out std_logic) ;
end subtractor_component ;

architecture data_flow of subtractor_component is
	begin
		C_out <= ((A xor B) and C_in) or (A and B) ;
		diff  <= (A xor B) xor C_in ;
end data_flow ;
--  ---------------- Subtractor Generator ----------------
library ieee ;
use ieee.std_logic_1164.ALL ;
use ieee.numeric_std.ALL ;

entity subtractor is
	Generic(	N : integer := 10) ;
	Port(	A     : in std_logic_vector(N-1 downto 0) ;
			B     : in std_logic_vector(N-1 downto 0) ;
			C_out : out std_logic ;
			V     : out std_logic ;
			diff  : out std_logic_vector(2*N-1 downto 0) ;
			sign  : out std_logic) ;
end subtractor ;

architecture data_flow of subtractor is
	component subtractor_component
	Port(	A     : in std_logic ;
			B     : in std_logic ;
			C_in  : in std_logic ;
			C_out : out std_logic ;
			diff  : out std_logic) ;
	end component ;
	
	signal X       : std_logic_vector(2*N downto 0) ;
	signal T       : std_logic_vector(2*N-1 downto 0) ;
	signal A_in    : std_logic_vector(2*N-1 downto 0) ;
	signal B_in    : std_logic_vector(2*N-1 downto 0) ;
	signal diff_in : std_logic_vector(2*N-1 downto 0) ;
	
	begin
		A_in <= std_logic_vector(resize(signed(A), A_in' length)) ;
		B_in <= std_logic_vector(resize(signed(B), B_in' length)) ;
		X(0) <= '1' ;
		T    <= not B_in ;
		
		sub : for i in 0 to 2*N-1 generate
		sub : subtractor_component port map(A_in(i), T(i), X(i), X(i+1), diff_in(i)) ;
		end generate ;
		
		diff  <= diff_in ;
		V     <= X(N) xor X(N-1) ;
		C_out <= X(N) ;
		sign  <= diff_in(2*N-1) ;
end data_flow ;