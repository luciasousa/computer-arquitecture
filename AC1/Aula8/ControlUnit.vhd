library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity ControlUnit is
	port(opcode   :  in std_logic_vector(5 downto 0);
		  RegDst   : out std_logic;
		  RegWrite : out std_logic;
		  MemWrite : out std_logic;
		  MemRead  : out std_logic;
		  MemToReg : out std_logic;
		  ALUsrc   : out std_logic;
		  ALUop    : out std_logic_vector(1 downto 0);
		  Branch   : out std_logic;
		  Jump     : out std_logic);
end ControlUnit;

architecture Behavioral of ControlUnit is
begin

	process(opcode)
	begin
		RegDst <= '0';
		RegWrite <= '0';
		MemWrite <= '0';
		MemRead <= '0';
		MemToReg <= '0';
		ALUsrc <= '0';
		ALUop <= "00";
		Branch <= '0';
		Jump <= '0';
	
		case opcode is
			when "000000" => -- R-Type instructions
				RegDst <= '1';
				RegWrite <= '1';
				ALUop <= "10";
			when "000100" => -- BEQ
				ALUop <= "01";
				Branch <= '1';
			when "100011" => -- LW
				RegWrite <= '1';
				MemRead <= '1';
				MemToReg <= '1';
				ALUsrc <= '1';
			when "101011" => -- SW
				MemWrite <= '1';
				ALUsrc <= '1';
			when "001000" => -- ADDI
				RegWrite <= '1';
				ALUsrc <= '1';
			when "001010" => -- SLTI
				RegWrite <= '1';
				ALUsrc <= '1';
				ALUop <= "11";
			when "000010" => -- J
				Jump <= '1';
			when others =>
		end case;
	end process;
	
end Behavioral;