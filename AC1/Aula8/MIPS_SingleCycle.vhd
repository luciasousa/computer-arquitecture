---------------------------------------------------------------------------
-- University of Aveiro - DETI
-- "Computer Architecture I" course (Practical classes)
-- 
-- MIPS single-cycle datapath
---------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

library work;
use work.MIPS_pkg.all;
use work.DisplayUnit_pkg.all;

entity MIPS_SingleCycle is
	port(CLOCK_50 :  in std_logic;
		  SW       :  in std_logic_vector(2 downto 0);
		  KEY      :  in std_logic_vector(3 downto 0);
		  HEX0     : out std_logic_vector(6 downto 0);
		  HEX1     : out std_logic_vector(6 downto 0);
		  HEX2     : out std_logic_vector(6 downto 0);
		  HEX3     : out std_logic_vector(6 downto 0);
		  HEX4     : out std_logic_vector(6 downto 0);
		  HEX5     : out std_logic_vector(6 downto 0);
		  HEX6     : out std_logic_vector(6 downto 0);
		  HEX7     : out std_logic_vector(6 downto 0);
		  LEDR     : out std_logic_vector(9 downto 0));
end MIPS_SingleCycle;

architecture Shell of MIPS_SingleCycle is
	signal s_clk, s_reset, s_RegDst, s_RegWrite, s_MemWrite, s_MemRead, s_MemToReg, s_ALUSrc, s_Branch, s_Jump, s_zero, s_ovf : std_logic;
	signal s_pc, s_instr, s_extended, s_RegData1, s_RegData2, s_RegData3, s_ALUop2, s_ALUres, s_DMRead : std_logic_vector(31 downto 0);
	signal s_jAddr : std_logic_vector(25 downto 0);
	signal s_imm : std_logic_vector(15 downto 0);
	signal s_opcode, s_funct : std_logic_vector(5 downto 0);
	signal s_rs, s_rt, s_rd, s_shamt, s_RegAddr3 : std_logic_vector(4 downto 0);
	signal s_ALUcontrol : std_logic_vector(2 downto 0);
	signal s_ALUop : std_logic_vector(1 downto 0);
begin
	
	PCupdate : entity work.PCupdate(Behavioral)
				  port map(clk => s_clk,
							  reset => '0',
							  branch => s_Branch,
							  jump => s_Jump,
							  zero => s_zero,
							  offset => s_extended,
							  jAddr => s_jAddr,
							  pc => s_pc);
							  
	DU_PC <= s_pc;
				
	InstructionMemory : entity work.InstructionMemory(Behavioral)
							  generic map(ADDR_BUS_SIZE => ROM_ADDR_SIZE)
							  port map(readAddr => s_pc(7 downto 2),
										  Instr    => s_instr);
										 
	SignExtend : entity work.SignExtend(Behavioral)
					 port map(dataIn => s_imm,
								 dataOut => s_extended);
								 
	InstrSplitter : entity work.InstrSplitter(Behavioral)
						 port map(instruction => s_instr,
									 opcode => s_opcode,
									 rs => s_rs,
									 rt => s_rt,
									 rd => s_rd,
									 shamt => s_shamt,
									 funct => s_funct,
									 imm => s_imm,
									 jAddr => s_jAddr);
									 
	RegDstMux : entity work.Mux2N(Behavioral)
					generic map(N => 5)
					port map(op1 => s_rd,
								op2 => s_rt,
								sel => s_RegDst,
								outp => s_RegAddr3);
								
	RegFile : entity work.RegFile(Behavioral)
				 port map(clk => s_clk,
							 writeEnable => s_RegWrite,
							 readAddr1 => s_rs,
							 readAddr2 => s_rt,
							 writeAddr => s_RegAddr3,
							 writeData => s_RegData3,
							 readData1 => s_RegData1,
							 readData2 => s_RegData2);
							 
	ALUSrcMux : entity work.Mux2N(Behavioral)
					generic map(N => 32)
					port map(op1 => s_extended,
								op2 => s_RegData2,
								sel => s_ALUSrc,
								outp => s_ALUop2);
							
	ALU32 : entity work.ALU32(Behavioral)
			  port map(op1 => s_RegData1,
						  op2 => s_ALUop2,
						  opcode => s_ALUcontrol,
						  zero => s_zero,
						  ovf => s_ovf,
						  result => s_ALUres);
						  
	ALUcontrol : entity work.ALUcontrol(Behavioral)
					 port map(ALUop => s_ALUop,
					          funct => s_funct,
								 ALUcontrol => s_ALUcontrol);
								 
								 
	MemToRegMux : entity work.Mux2N(Behavioral)
					  generic map(N => 32)
					  port map(op1 => s_DMRead,
								  op2 => s_ALUres,
								  sel => s_MemToReg,
								  outp => s_RegData3);
								  
	DataMemory : entity work.DataMemory(Behavioral)
					 port map(clk => s_clk,
								 readEn => s_MemRead,
								 writeEn => s_MemWrite,
								 address => s_ALUres(7 downto 2),
								 address2 => DU_DMaddr,
								 writeData => s_RegData2,
								 readData => s_DMRead,
								 readData2 => DU_DMdata);
								  
	ControlUnit : entity work.ControlUnit(Behavioral)
					  port map(opcode => s_opcode,
								  RegDst => s_RegDst,
								  RegWrite => s_RegWrite,
								  MemWrite => s_MemWrite,
								  MemRead => s_MemRead,
								  MemToReg => s_MemToReg,
								  ALUsrc => s_ALUsrc,
								  ALUop => s_ALUop,
								  Branch => s_Branch,
								  Jump => s_Jump);
								  
	LEDR(9) <= s_RegDst;
	LEDR(8) <= s_RegWrite;
	LEDR(7) <= s_MemWrite;
	LEDR(6) <= s_MemRead;
	LEDR(5) <= s_MemToReg;
	LEDR(4) <= s_ALUsrc;
	LEDR(3 downto 2) <= s_ALUop;
	LEDR(1) <= s_Branch;
	LEDR(0) <= s_Jump;
	
									 
	-- Debouncer
	debnc: entity work.DebounceUnit(Behavioral)
			 generic map(mSecMinInWidth => 100,
							 inPolarity => '0',
							 outPolarity => '1')
			 port map(refClk => CLOCK_50,
						 dirtyIn => KEY(0),
						 pulsedOut => s_clk);
						 
	-- Display module
	displ: entity work.DisplayUnit(Behavioral)
			 generic map(dataPathType => SINGLE_CYCLE_DP,
							 IM_ADDR_SIZE => ROM_ADDR_SIZE,
							 DM_ADDR_SIZE => RAM_ADDR_SIZE)
			 port map(RefClk => CLOCK_50,
						 InputSel => SW(1 downto 0),
						 DispMode => SW(2),
						 NextAddr => KEY(3),
						 Dir => KEY(2),
						 disp0 => HEX0,
						 disp1 => HEX1,
						 disp2 => HEX2,
						 disp3 => HEX3,
						 disp4 => HEX4,
						 disp5 => HEX5,
						 disp6 => HEX6,
						 disp7 => HEX7); 
	
end Shell;