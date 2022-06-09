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
	GEN_REG: for i in 7 downto 0 generate
		Biti: bitstorage PORT MAP(datain(i), enout, writein, dataout(i));
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
	component register8 is
		port(datain: in std_logic_vector(7 downto 0);
	     		enout:  in std_logic;
	     		writein: in std_logic;
	     		dataout: out std_logic_vector(7 downto 0));
	end component;
	signal writeMode: std_logic_vector(2 downto 0) := "000";
	signal enableMode: std_logic_vector(2 downto 0) := "111";
	signal regWriteSelect: std_logic_vector(3 downto 0) := "0000";
	signal regEnSelect: std_logic_vector(3 downto 0) := "1111";
begin
	
	writeMode <= writein32 & writein16 & writein8;
	enableMode <= enout32 & enout16 & enout8;

	WITH writeMode SELECT
		regWriteSelect <= "1111" WHEN "100",
				  "0011" WHEN "010",
				  "0001" WHEN "001",
                                  "0000" WHEN OTHERS;
	WITH enableMode SELECT
		regEnSelect <= "0000" WHEN "011",
				"1100" WHEN "101",
				"1110" WHEN "110",
				"1111" WHEN OTHERS;
	
	reg32: register8 PORT MAP( datain(31 downto 24), regEnSelect(3), regWriteSelect(3), dataout(31 downto 24) );
	reg24: register8 PORT MAP( datain(23 downto 16), regEnSelect(2), regWriteSelect(2), dataout(23 downto 16) );
	reg16: register8 PORT MAP( datain(15 downto 8), regEnSelect(1), regWriteSelect(1), dataout(15 downto 8) );
	reg8: register8 PORT MAP( datain(7 downto 0), regEnSelect(0), regWriteSelect(0), dataout(7 downto 0) );

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
	component fulladder is
    		port (a : in std_logic;
          		b : in std_logic;
         		 cin : in std_logic;
          		sum : out std_logic;
         		 carry : out std_logic);
	end component;
	signal newb: std_logic_vector(31 downto 0);
	signal carry: std_logic_vector(32 downto 0);
	
begin
	with add_sub select
		newb <= datain_b when '0',
			     NOT datain_b when others;
	GEN_adder: FOR i in 31 downto 1 GENERATE
		Resulti: fulladder PORT MAP(datain_a(i), newb(i), carry(i), dataout(i), carry(i+1));
	END GENERATE;
	
	carry(0) <= add_sub;
	
	Result0: fulladder PORT MAP(datain_a(0), newb(0), carry(0), dataout(0), carry(1));

	co <= carry(32);
	
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
	
	signal ctrl: std_logic_vector(5 DOWNTO 0);
begin
	ctrl <= dir & shamt;
	with ctrl select
	dataout <= ("000" & datain(31 DOWNTO 3)) WHEN "100011",
		("00" & datain(31 DOWNTO 2)) WHEN "100010",
		("0" & datain(31 DOWNTO 1)) WHEN "100001",
		(datain(28 DOWNTO 0) & "000") WHEN "000011",
		(datain(29 DOWNTO 0) & "00") WHEN "000010",
		(datain(30 DOWNTO 0) & "0") WHEN "000001",
		datain WHEN others;	

end architecture shifter;


