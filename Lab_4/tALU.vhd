--------------------------------------------------------------------------------
--
-- Test Bench for LAB #4
--
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY testALU_vhd IS
END testALU_vhd;

ARCHITECTURE behavior OF testALU_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT ALU
		Port(	DataIn1: in std_logic_vector(31 downto 0);
			DataIn2: in std_logic_vector(31 downto 0);
			ALUCtrl: in std_logic_vector(4 downto 0);
			Zero: out std_logic;
			ALUResult: out std_logic_vector(31 downto 0) );
	end COMPONENT ALU;

	--Inputs
	SIGNAL datain_a : std_logic_vector(31 downto 0) := (others=>'0');
	SIGNAL datain_b : std_logic_vector(31 downto 0) := (others=>'0');
	SIGNAL control	: std_logic_vector(4 downto 0)	:= (others=>'0');

	--Outputs
	SIGNAL result   :  std_logic_vector(31 downto 0);
	SIGNAL zeroOut  :  std_logic;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: ALU PORT MAP(
		DataIn1 => datain_a,
		DataIn2 => datain_b,
		ALUCtrl => control,
		Zero => zeroOut,
		ALUResult => result
	);
	

	tb : PROCESS
	BEGIN

		-- Wait 100 ns for global reset to finish
		wait for 100 ns;

		-- Start testing the ALU
		datain_a <= X"00000005";	-- DataIn in hex
		datain_b <= X"00000002";
		control  <= "00000";		-- Control in binary (ADD test)
		wait for 100 ns; 			-- result = 0x00000007  and zeroOut = 0

		datain_a <= x"00000007";
		datain_b <= x"00000001";
		control <= "00001";		--SUB test
		wait for 100 ns;			--result = 00000006 and zeroOut = 0

		datain_a <= x"00000001";
		datain_b <= x"00000001";
		control <= "00010";		--ADDI test
		wait for 100 ns;			--result = 0x00000002 and zeroOut = 0

		datain_a <= "11111111111111111111111111111111" ;
		datain_b <= "10101010101010101010101010101010" ;
		control <= "00011";		--AND test
		wait for 100 ns;			--result = 0xAAAAAAAA and zeroOut = 0

		control <= "00100";		--ANDI test
		wait for 100 ns;                        --result = 10101010101010101010101010101010 and zeroOut = 0

		datain_a <= x"50505050";
		datain_b <= x"05050505";
		control <= "00101";		--OR test
							--result = 0x55555555 and zeroOut = 0
		wait for 100 ns;

		control <= "00110";		--ORI test
		wait for 100 ns;

		datain_a <= x"00000001";
		datain_b <= x"00000003";	--sll test
		control <= "00111";			--result = 0x0x00000008
		wait for 100 ns;

		control <= "01000";		--slli test
		wait for 100 ns;

		datain_a <= X"00000008";
		datain_b <= X"00000003";
		control <= "00100";		--srl test
		wait for 100 ns;			--result = 0x00000001  and zeroOut = 0

		control <= "01010";		--srli test
		wait for 100 ns;



		wait; -- will wait forever
	END PROCESS;

END;
