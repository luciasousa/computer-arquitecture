library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity PCupdate is
	port(clk				: in std_logic;
		  reset 			: in std_logic;
		  zero			: in std_logic;
	     PCSource		: in std_logic_vector(1 downto 0);
		  PCWrite		: in std_logic;
		  PCWriteCond	: in std_logic;
		  PC4				: in std_logic_vector(31 downto 0);
		  BTA				: in std_logic_vector(31 downto 0);
		  jAddr			: in std_logic_vector(25 downto 0);
		  pc				: out std_logic_vector(31 downto 0));
end PCupdate;

architecture Behavioral of PCupdate is
	signal s_pc : std_logic_vector(31 downto 0);
	begin
		process(clk)
		begin
			if(rising_edge(clk)) then
				if(reset = '1') then
					s_pc <= (others => '0');
				elsif(PCWrite = '1' or (PCWriteCond = '1' and zero = '0')) then
					case PCSource is
						when "01" => 
							s_pc <= BTA;
						when "10" => 
							s_pc <= s_pc(31 downto 28) & jAddr & "00";
						when others => 
							s_pc <= PC4;
					end case;
				end if;
			end if;
		end process;
		pc <= s_pc;
end Behavioral;
