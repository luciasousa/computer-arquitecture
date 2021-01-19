library IEEE;
use ieee.std_logic_1164.all;

entity SignExtend is
	port(dataIn  : in  std_logic_vector(15 downto 0);
		  dataOut : out std_logic_vector(31 downto 0));
end SignExtend;

architecture Behavioral of SignExtend is
begin
	dataOut(31 downto 16) <= (others => dataIn(15)); --repete bit +significativo
	dataOut(15 downto 0)  <= dataIn;						 --16bits -significativos iguais
end Behavioral;