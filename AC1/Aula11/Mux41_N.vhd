library ieee;
use ieee.std_logic_1164.all;

entity Mux41_N is
	generic(N : positive := 32);
	port(op1  :  in std_logic_vector((N - 1) downto 0);
		  op2  :  in std_logic_vector((N - 1) downto 0);
		  op3  :  in std_logic_vector((N - 1) downto 0);
		  op4  :  in std_logic_vector((N - 1) downto 0);
		  sel  :  in std_logic_vector(1 downto 0);
		  outp : out std_logic_vector((N - 1) downto 0));
end Mux41_N;

architecture Behavioral of Mux41_N is
	begin
	process
		begin
			case sel is
				when "00" =>
					outp <= op1;
				when "01" =>
					outp <= op2;
				when "10" =>
					outp <= op3;
				when "11" =>
					outp <= op4;
			end case;
	end process;
end Behavioral;