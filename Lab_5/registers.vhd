--------------------------------------------------------------------------------
--
-- LAB #3
--
--------------------------------------------------------------------------------

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity bitstorage is
	port(bitin: in std_logic;
		 enout: in std_logic;
		 writein: in std_logic;
		 bitout: out std_logic);
end entity bitstorage;

architecture memlike of bitstorage is
	signal q: std_logic := '0';
begin
	process(writein) is
	begin
		if (rising_edge(writein)) then
			q <= bitin;
		end if;
	end process;
	
	-- Note that data is output only when enout = 0	
	bitout <= q when enout = '0' else 'Z';
end architecture memlike;

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity fulladder is
    port (a : in std_logic;
          b : in std_logic;
          cin : in std_logic;
          sum : out std_logic;
          carry : out std_logic
         );
end fulladder;

architecture addlike of fulladder is
begin
  sum   <= a xor b xor cin; 
  carry <= (a and b) or (a and cin) or (b and cin); 
end architecture addlike;


--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity register8 is
	port(datain: in std_logic_vector(7 downto 0);
	     enout:  in std_logic;
	     writein: in std_logic;
	     dataout: out std_logic_vector(7 downto 0));
end entity register8;

architecture memmy of register8 is


	component bitstorage
		port(bitin: in std_logic;
		 	 enout: in std_logic;
		 	 writein: in std_logic;
		 	 bitout: out std_logic);
	end component;


begin

	Gen8: FOR j IN 0 TO 7 GENERATE
		aj: bitstorage PORT MAP (datain(j), enout, writein, dataout(j));
	END GENERATE;

end architecture memmy;

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity register32 is
	port(datain: in std_logic_vector(31 downto 0);
		 enout32,enout16,enout8: in std_logic;
		 writein32, writein16, writein8: in std_logic;
		 dataout: out std_logic_vector(31 downto 0));
end entity register32;

architecture biggermem of register32 is

	-- hint: you'll want to put register8 as a component here 
	-- so you can use it below
	component register8
		port(datain: in std_logic_vector(7 downto 0);
	     		enout:  in std_logic;
	     		writein: in std_logic;
	     		dataout: out std_logic_vector(7 downto 0));
	end component;
	signal megaenout : std_logic_vector (2 DOWNTO 0);
	signal megawritein : std_logic_vector(2 DOWNTO 0);
	signal enableout : std_logic_vector(3 DOWNTO 0);
	signal enablewrite : std_logic_vector(3 DOWNTO 0);
begin
	megaenout <= enout32 & enout16 & enout8;
	megawritein <= writein32 & writein16 & writein8;

	with megaenout select
		enableout <= "0000" WHEN "011",
			"1100" WHEN "101", 
			"1110" WHEN "110",
			"1111" WHEN OTHERS;

	with megawritein select
		enablewrite <= "1111" WHEN "100",
			"0011" WHEN "010", 
			"0001" WHEN "001",
			"0000" WHEN OTHERS;
	byte4: register8 PORT MAP (datain(31 downto 24), enableout(3), enablewrite(3), dataout(31 downto 24));
	byte3: register8 PORT MAP (datain(23 downto 16), enableout(2), enablewrite(2), dataout(23 downto 16));
	byte2: register8 PORT MAP (datain(15 downto 8), enableout(1), enablewrite(1), dataout(15 downto 8));	
	byte1: register8 PORT MAP (datain(7 downto 0), enableout(0), enablewrite(0), dataout(7 downto 0));		

end architecture biggermem;

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity adder_subtracter is
	port(	datain_a: in std_logic_vector(31 downto 0);
		datain_b: in std_logic_vector(31 downto 0);
		add_sub: in std_logic;
		dataout: out std_logic_vector(31 downto 0);
		co: out std_logic);
end entity adder_subtracter;

architecture calc of adder_subtracter is

component fulladder
    port (a : in std_logic;
          b : in std_logic;
          cin : in std_logic;
          sum : out std_logic;
          carry : out std_logic
         );
end component;

	signal carryRow : std_logic_vector(31 DOWNTO 0);
	signal datain_b_hold : std_logic_vector(31 DOWNTO 0);

begin
	with add_sub select
		datain_b_hold <= datain_b WHEN '0',
		not datain_b WHEN OTHERS;
	

	a0: fulladder PORT MAP (datain_a(0), datain_b_hold(0), add_sub, dataout(0), carryRow(0));

	Gen8: FOR f IN 1 TO 30 GENERATE
		af: fulladder PORT MAP (datain_a(f), datain_b_hold(f), carryRow(f-1), dataout(f), carryRow(f));
	END GENERATE;

	a31: fulladder PORT MAP (datain_a(31), datain_b_hold(31), carryRow(30), dataout(31), co);
	

end architecture calc;

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity shift_register is
	port(	datain: in std_logic_vector(31 downto 0);
	   	dir: in std_logic;
		shamt:	in std_logic_vector(4 downto 0);
		dataout: out std_logic_vector(31 downto 0));
end entity shift_register;

architecture shifter of shift_register is
	signal sel: std_logic_vector(5 DOWNTO 0);
begin
	sel <= dir & shamt;
	with sel select
	dataout <= ("000" & datain(31 DOWNTO 3)) WHEN "100011",
		("00" & datain(31 DOWNTO 2)) WHEN "100010",
		("0" & datain(31 DOWNTO 1)) WHEN "100001",
		(datain(28 DOWNTO 0) & "000") WHEN "000011",
		(datain(29 DOWNTO 0) & "00") WHEN "000010",
		(datain(30 DOWNTO 0) & "0") WHEN "000001",
		datain WHEN others;
end architecture shifter;



