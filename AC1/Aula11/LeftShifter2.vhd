library ieee;
use ieee.std_logic_1164.all;

entity LeftShifter2 is
	port(input  : in  std_logic_vector(31 downto 0);
		  output : out std_logic_vector(31 downto 0));
end LeftShifter2;

architecture Behavioral of LeftShifter2 is
begin
	output <= input(29 downto 0) & "00";
end Behavioral;