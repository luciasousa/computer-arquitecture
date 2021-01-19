library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.MIPS_pkg.all;			--usar constante RAM_ADDR_SIZE

entity DataMemory is
	generic(RAM_ADDR_SIZE : positive := 6);
	port(clk : in std_logic;
		readEn : in std_logic;
		writeEn : in std_logic;
		address : in std_logic_vector((RAM_ADDR_SIZE-1) downto 0);
		address2 : in std_logic_vector((RAM_ADDR_SIZE-1) downto 0);
		writeData : in std_logic_vector(31 downto 0);
		readData : out std_logic_vector(31 downto 0);
		readData2 : out std_logic_vector(31 downto 0));		
end DataMemory;

architecture Behavioral of DataMemory is

constant NUM_WORDS : positive := (2** RAM_ADDR_SIZE);
subtype TData is std_logic_vector(31 downto 0);
type TMemory is array(0 to NUM_WORDS-1) of TData;
signal s_memory : TMemory;
begin
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(writeEn = '1') then
				s_memory(to_integer(unsigned(address))) <= writeData;
			end if;
		end if;
	end process;
	
	readData <= s_memory(to_integer(unsigned(address))) when
						readEn = '1' else (others => '-');
						
	readData2 <= s_memory(to_integer(unsigned(address2)));

end Behavioral;