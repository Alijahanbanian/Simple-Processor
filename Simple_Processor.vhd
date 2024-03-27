--*********************************************
-- Ali jahanbanian - 9811307
-- File: Simple_Processor.vhd
-- Design Units:
--		input: key0, key1, key2, sw
--		output: ledr
-- Version VHDL: Standard 2008
--********************************************	
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

PACKAGE register_file IS
	CONSTANT REG_NUM	:	 INTEGER := 8;
	CONSTANT REG_BIT	:   INTEGER := 9;	
	CONSTANT BUS_BIT	:	 INTEGER := 9;							
	CONSTANT ADDRESS_Bit	:	INTEGER := 5;
	TYPE reg_file_type IS ARRAY (REG_NUM - 1 DOWNTO 0) OF
		STD_LOGIC_VECTOR(REG_BIT - 1 DOWNTO 0);
		
END PACKAGE register_file;
--*********************************************
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.register_file.ALL;

ENTITY Simple_Processor IS
	PORT
	(
		key0, key1, key2		: IN STD_LOGIC;
		sw							: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		ledr						: OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
	);
END Simple_Processor;

ARCHITECTURE Beh OF Simple_Processor IS

	COMPONENT Processor
		PORT
		(
			din					: IN STD_LOGIC_VECTOR(BUS_BIT - 1 DOWNTO 0);
			reset, clk, run	: IN STD_LOGIC;
			done					: OUT STD_LOGIC;
			bus_wires			: OUT STD_LOGIC_VECTOR(BUS_BIT - 1 DOWNTO 0)
	);
	END COMPONENT;
	COMPONENT rom
		PORT
		(
			address		: IN STD_LOGIC_VECTOR (ADDRESS_Bit - 1 DOWNTO 0);
			clock			: IN STD_LOGIC;
			q				: OUT STD_LOGIC_VECTOR (BUS_BIT - 1 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT Counter
		PORT
		(
			clock		: IN STD_LOGIC ;
			sclr		: IN STD_LOGIC ;
			q			: OUT STD_LOGIC_VECTOR (ADDRESS_Bit - 1 DOWNTO 0)
		);
	END COMPONENT;

	SIGNAL reset, pclock, mclock, run, done		: STD_LOGIC;
	SIGNAL d_in, Bus_wires						 		: STD_LOGIC_VECTOR(BUS_BIT - 1 DOWNTO 0);
	SIGNAL pc												: STD_LOGIC_VECTOR(ADDRESS_Bit - 1 DOWNTO 0);
	
BEGIN

	reset  <= key0;
	pclock <= key1;
	mclock <= key2;
	run	 <= sw(9);
	
	Counter_INST	 	: counter PORT MAP(reset, mclock, pc);
	INST_ROM		 		: rom PORT MAP(pc, mclock, d_in);
	SIMPLE_Processor 	: Processor PORT MAP(d_in, reset, pclock, run, done, Bus_wires);
	
	ledr(8 DOWNTO 0)	<= Bus_wires;
	ledr(9) 				<= done;
	
End Beh;
