--------------------------------------------------------------------------------
--
-- LAB #4
--
--------------------------------------------------------------------------------

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity ALU is
	Port(	DataIn1: in std_logic_vector(31 downto 0);
		DataIn2: in std_logic_vector(31 downto 0);
		ALUCtrl: in std_logic_vector(4 downto 0);
		Zero: out std_logic;
		ALUResult: out std_logic_vector(31 downto 0) );
end entity ALU;

architecture ALU_Arch of ALU is
	-- ALU components	
	component adder_subtracter
		port(	datain_a: in std_logic_vector(31 downto 0);
			datain_b: in std_logic_vector(31 downto 0);
			add_sub: in std_logic;
			dataout: out std_logic_vector(31 downto 0);
			co: out std_logic);
	end component adder_subtracter;

	component shift_register
		port(	datain: in std_logic_vector(31 downto 0);
		   	dir: in std_logic;
			shamt:	in std_logic_vector(4 downto 0);
			dataout: out std_logic_vector(31 downto 0));
	end component shift_register;
	SIGNAL whatIsThisFor : std_logic;
	SIGNAL ADDERRESULT : std_logic_vector(31 DOWNTO 0);
	SIGNAL SHIFTRESULT : std_logic_vector(31 DOWNTO 0);

	
	SIGNAL TEMPRES: std_logic_vector(31 DOWNTO 0);

	SIGNAL BITHOLDER :STD_LOGIC;
	
begin

	WITH ALUCtrl SELECT
	BITHOLDER <= '0' WHEN "00000", --ADD
		'1' WHEN "00001", --SUB
		'0' WHEN "00010", --ADDI
		'0' WHEN "00011", --AND
		'0' WHEN "00100", --ANDI
		'0' WHEN "00101", --OR
		'0' WHEN "00110", --ORI
		'0' WHEN "00111",
		'0' WHEN "01000",
		'1' WHEN "01001",
		'1' WHEN OTHERS;
	
	--Add, Sub, Addi
	A0:adder_subtracter PORT MAP (DataIn1, DataIn2, BITHOLDER, ADDERRESULT, whatIsThisFor);
	--Sll, SLLI, SRL, SRLI
	A3:shift_register PORT MAP(DataIn1, BITHOLDER, DataIn2(4 Downto 0), SHIFTRESULT);
	
	WITH ALUCtrl SELECT
	TEMPRES <= ADDERRESULT WHEN "00000", --ADD
		ADDERRESULT WHEN "00001", --SUB
		ADDERRESULT WHEN "00010", --ADDI
		(DataIn1 AND DataIn2) WHEN "00011", --AND
		(DataIn1 AND DataIn2) WHEN "00100", --ANDI
		(DataIn1 OR DataIn2) WHEN "00101", --OR
		(DataIn1 OR DataIn2) WHEN "00110", --ORI
		SHIFTRESULT WHEN "00111", --SLL
		SHIFTRESULT WHEN "01000", --SLLI
		SHIFTRESULT WHEN "01001", --SRL
		SHIFTRESULT WHEN OTHERS; --SRLI
	
	Zero <= '1' WHEN TEMPRES = X"00000000" ELSE '0';

	ALUResult <= TEMPRES;

	

end architecture ALU_Arch;
