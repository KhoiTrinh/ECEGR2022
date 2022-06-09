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
	SIGNAL cout : std_logic;
	SIGNAL as_result : std_logic_vector(31 DOWNTO 0);
	SIGNAL shift_result : std_logic_vector(31 DOWNTO 0);

	
	SIGNAL temp: std_logic_vector(31 DOWNTO 0);

	SIGNAL BITHOLDER :STD_LOGIC;
	
begin

	WITH ALUCtrl SELECT
	BITHOLDER <= '0' WHEN "00000", --add
		'1' WHEN "00001", --sub
		'0' WHEN "00010", --addi
		'0' WHEN "00011", --and
		'0' WHEN "00100", --andi
		'0' WHEN "00101", --or
		'0' WHEN "00110", --ori
		'0' WHEN "00111", --sll
		'0' WHEN "01000", --slli
		'1' WHEN "01001", --srl
		'1' WHEN OTHERS; --srli
	
	--Add, Sub, Addi
	A0:adder_subtracter PORT MAP (DataIn1, DataIn2, BITHOLDER, as_result, cout);
	--Sll, SLLI, SRL, SRLI
	A3:shift_register PORT MAP(DataIn1, BITHOLDER, DataIn2(4 Downto 0), shift_result);
	
	WITH ALUCtrl SELECT
	TEMPRES <= as_result WHEN "00000", --add
		as_result WHEN "00001", --sub
		as_result WHEN "00010", --addi
		(DataIn1 AND DataIn2) WHEN "00011", --and
		(DataIn1 AND DataIn2) WHEN "00100", --andi
		(DataIn1 OR DataIn2) WHEN "00101", --or
		(DataIn1 OR DataIn2) WHEN "00110", --ori
		shift_result WHEN "00111", --sll
		shift_result WHEN "01000", --slli
		shift_result WHEN "01001", --srl
		shift_result WHEN OTHERS; --srli
	
	Zero <= '1' WHEN temp = X"00000000" ELSE '0';

	ALUResult <= temp;

	

end architecture ALU_Arch;

