--------------------------------------------------------------------------------
--
-- LAB #6 - Processor Elements
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BusMux2to1 is
	Port(	selector: in std_logic;
			In0, In1: in std_logic_vector(31 downto 0);
			Result: out std_logic_vector(31 downto 0) );
end entity BusMux2to1;
	
architecture selection of BusMux2to1 is
begin
-- Add your code here
	with selector select
		result <= In0 WHEN '0',
			  In1 WHEN others;
end architecture selection;

--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Control is
      Port(clk : in  STD_LOGIC;
           opcode : in  STD_LOGIC_VECTOR (6 downto 0);
           funct3  : in  STD_LOGIC_VECTOR (2 downto 0);
           funct7  : in  STD_LOGIC_VECTOR (6 downto 0);
           Branch : out  STD_LOGIC_VECTOR(1 downto 0);
           MemRead : out  STD_LOGIC;
           MemtoReg : out  STD_LOGIC;
           ALUCtrl : out  STD_LOGIC_VECTOR(4 downto 0);
           MemWrite : out  STD_LOGIC;
           ALUSrc : out  STD_LOGIC;
           RegWrite : out  STD_LOGIC;
           ImmGen : out STD_LOGIC_VECTOR(1 downto 0));
end Control;

architecture Boss of Control is

signal characteristic: std_logic_vector (9 DOWNTO 0);
	signal binary: std_logic_vector(13 DOWNTO 0);

begin
-- Add your code here

	binary <=    ("00100000000100") WHEN (funct7 = "0000000" AND funct3 & opcode = "0000110011") ELSE
		     ("00100000100100") WHEN (funct7 = "0100000" AND funct3 & opcode = "0000110011") ELSE
		     ("00100001001110") WHEN (characteristic = "0000010011") ELSE
		     ("00100001100100") WHEN (funct7 = "0000000" AND funct3 & opcode = "1110110011") ELSE
		     ("00100010100100") WHEN (funct7 = "0000000" AND funct3 & opcode = "1100110011") ELSE
		     ("00100011100100") WHEN (funct7 = "0000000" AND funct3 & opcode = "0010110011") ELSE
		     ("00100100100100") WHEN (funct7 = "0000000" AND funct3 & opcode = "1010110011") ELSE
		     ("00010001001110") WHEN (funct3 & opcode = "0100000011") ELSE
		     ("00100001011011") WHEN (funct3 & opcode = "0100100011") ELSE
		     ("10100000100001") WHEN (funct3 & opcode = "0001100011") ELSE
		     ("01100000100001") WHEN (funct3 & opcode = "0011100011") ELSE
		     ("00100000001100") WHEN (opcode = "0110111") ELSE
		     ("00100010001110") WHEN (funct3 & opcode = "0000010011") ELSE
		     ("00100011001110") WHEN (funct3 & opcode = "1100010011") ELSE
		     ("00100100001110") WHEN (funct7 = "0000000" AND funct3 & opcode = "0010010011") ELSE
		     ("00100101001110") WHEN (funct7 = "0000000" AND funct3 & opcode = "1010010011") ELSE "00100000000000"; 

	Branch <= binary(13 DOWNTO 12);
	MemRead <= binary(11);
	MemtoReg <= binary(10);
	ALUCtrl <= binary(9 DOWNTO 5);
	MemWrite <= binary(4);
	ALUSrc <= binary(3);
	RegWrite <= binary(2);
	ImmGen <= binary(1 DOWNTO 0);

end Boss;

--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ProgramCounter is
    Port(Reset: in std_logic;
	 Clock: in std_logic;
	 PCin: in std_logic_vector(31 downto 0);
	 PCout: out std_logic_vector(31 downto 0));
end entity ProgramCounter;

architecture executive of ProgramCounter is
begin
-- Add your code here
	process(Reset, Clock) is
		begin
		if Reset = '1' then 
			PCout <= X"00400000";
		end if;
		if rising_edge(Clock) then
			PCout <= PCin;
		end if;
	
	end process;

end executive;
