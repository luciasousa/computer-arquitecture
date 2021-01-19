library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU32 is
Port ( op1 	:  in std_logic_vector(31 downto 0);
		  op2 	:  in std_logic_vector(31 downto 0);
		  opcode :  in std_logic_vector(2 downto 0);
		  zero   : out std_logic;
		  ovf    : out std_logic;
		  result : out std_logic_vector(31 downto 0));
end ALU32;

architecture Behavioral of ALU32 is

signal s_op1, s_op2, s_result : unsigned(31 downto 0);
begin
	s_op1 <= unsigned(op1);
	s_op2 <= unsigned(not op2) + 1 when opcode = "110" else unsigned(op2); -- comp. 2 (subtraçao)
	
	s_result <= s_op1 and s_op2 when opcode = "000" else
					s_op2 or s_op2 when opcode = "001" else
					s_op1 + s_op2 when opcode = "010" or opcode = "110" else
					X"00000001" when opcode = "111" and (signed(op1) < signed(op2)) else
					(others => '0') when opcode = "111" else
					(others => '-');
					
	zero <= '1' when s_result = X"00000000" else '0';
	ovf <= '1' when ((s_op1(31) = s_op2(31)) and not (s_result(31) = s_op1(31))) else '0';
	result <= std_logic_vector(s_result);
end Behavioral;