library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

library work;
use work.DisplayUnit_pkg.all;

entity InstructionMemory is
	generic(ADDR_BUS_SIZE : positive := 6);
	port(readAddr :  in std_logic_vector((ADDR_BUS_SIZE - 1) downto 0);
		  Instr    : out std_logic_vector(31 downto 0));
end InstructionMemory;

architecture Behavioral of InstructionMemory is
	constant NUM_WORDS : positive := (2 ** ADDR_BUS_SIZE);
	subtype TData is std_logic_vector(31 downto 0);
	type TMemory is array(0 to NUM_WORDS - 1) of TData;
	constant s_memory : TMemory := (X"00000014", -- .word 20
											 X"00000011", -- .word 17
											 X"FFFFFFFE", -- .word -2
											 X"00000019", -- .word 25
											 X"00000005", -- .word 5
											 X"FFFFFFFF", -- .word -1
											 others => X"00000000");
begin
	Instr <= s_memory(to_integer(unsigned(readAddr)));
	
	-- Ponto de leitura para efeitos de visualização (ligado ao módulo
	-- de visualização através dos sinais globais DU_IMaddr e DU_IMdata)
	DU_IMdata <= s_memory(to_integer(unsigned(DU_IMaddr)));
end Behavioral;