library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
library work;
use work.DisplayUnit_pkg.all;
entity RegFile is
	port( clk : in std_logic;
			 writeEnable  :  in std_logic;
		  readAddr1    :  in std_logic_vector(4 downto 0);
		  readAddr2    :  in std_logic_vector(4 downto 0);
		  writeAddr    :  in std_logic_vector(4 downto 0);
		  writeData    :  in std_logic_vector(31 downto 0);
		  readData1    : out std_logic_vector(31 downto 0);
		  readData2    : out std_logic_vector(31 downto 0));
end RegFile;

architecture Behavioral of RegFile is
begin
	DP_Memory1 : entity work.DP_Memory(Behavioral)
	generic map(WORD_BITS => 32,
					ADDR_BITS => 5)
	port map(clk => clk,
				writeEnable => writeEnable,
				readAddr => readAddr1,
				writeAddr => writeAddr,
				writeData => writeData,
				readData => readData1);
	
	DP_Memory2 : entity work.DP_Memory(Behavioral)
	generic map(WORD_BITS => 32,
					ADDR_BITS => 5)
	port map(clk => clk,
				writeEnable => writeEnable,
				readAddr => readAddr2,
				writeAddr => writeAddr,
				writeData => writeData,
				readData => readData2);
				
	DP_Memory3 : entity work.DP_Memory(Behavioral)
	generic map(WORD_BITS => 32,
					ADDR_BITS => 5)
	port map(clk => clk,
				writeEnable => writeEnable,
				readAddr => DU_RFaddr,
				writeAddr => writeAddr,
				writeData => writeData,
				readData => DU_RFdata);
end Behavioral;