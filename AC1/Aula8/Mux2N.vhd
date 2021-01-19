library ieee;
use ieee.std_logic_1164.all;

entity Mux2N is
	generic(N : positive := 32);
	port(op1  :  in std_logic_vector((N - 1) downto 0);
		  op2  :  in std_logic_vector((N - 1) downto 0);
		  sel  :  in std_logic;
		  outp : out std_logic_vector((N - 1) downto 0));
end Mux2N;

architecture Behavioral of Mux2N is
	begin
		outp <= op1 when sel = '1' else op2;
end Behavioral;