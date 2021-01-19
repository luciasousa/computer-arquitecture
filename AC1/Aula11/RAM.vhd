library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

library work;
use work.MIPS_pkg.all;			--usar constante RAM_ADDR_SIZE

entity RAM is
	generic(ADDR_BUS_SIZE : positive := 6;
				DATA_BUS_SIZE: positive := 32);
	port(clk	:in std_logic;
		ce		:in std_logic;
		rd		:in std_logic;
		wr		:in std_logic;
		addr 	:in std_logic_vector((ADDR_BUS_SIZE-1) downto 0);
		data	:out std_logic_vector((DATA_BUS_SIZE-1)downto 0));		
end RAM;

architecture Behavioral of RAM is

constant NUM_WORDS : positive := (2** ADDR_BUS_SIZE);
subtype TData is std_logic_vector(31 downto 0);
type TMemory is array(0 to NUM_WORDS-1) of TData;
signal s_memory : TMemory := ( X"8C010000", -- lw $1,0x0000($0)
										X"20210004", -- addi $1,$1,4
										X"AC010004", -- sw $1,4($0)
										others => X"00000000");
begin
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(ce = '1') then
				data <= s_memory(to_integer(unsigned(addr)));
			end if;
		end if;
	end process;
	
	data <= s_memory(to_integer(unsigned(addr))) when
						rd = '1' and wr = '0' else (others => '-');
						
	--DU_IMdata <= s_memory(to_integer(unsigned(DU_IMaddr)));
	--DU_DMdata <= s_memory(to_integer(unsigned(DU_DMaddr)));

end Behavioral;
