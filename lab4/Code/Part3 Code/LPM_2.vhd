library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
LIBRARY lpm;
USE lpm.lpm_components.all;

entity g02_complex_square is
port (
	i_clk 	: in std_logic;								-- Clock
	i_rstb 	: in std_logic;								-- Reset
	i_x 	: in std_logic_vector(31 downto 0);			-- Imaginary parts of the input x
	i_y 	: in std_logic_vector(31 downto 0);			-- Imaginary parts of the input y
	o_xx, o_yy : out std_logic_vector(64 downto 0));	-- Output complex number
end g02_complex_square;

architecture rtl of g02_complex_square is

signal xx, yy, xy : signed(63 downto 0);				-- Registers for multiplication results

--------------------- COMPONENT DECLARATION------------------------------------
component LPM_MULT
generic ( LPM_WIDTHA : natural;
LPM_WIDTHB : natural;
LPM_WIDTHP : natural;
LPM_REPRESENTATION : string := "SIGNED";
LPM_PIPELINE : natural := 0;
LPM_TYPE: string := L_MULT;
LPM_HINT : string := "UNUSED");
port ( DATAA : in std_logic_vector(LPM_WIDTHA-1 downto 0);
	DATAB : in std_logic_vector(LPM_WIDTHB-1 downto 0);
	ACLR : in std_logic := '0';
	CLOCK : in std_logic := '0';
	CLKEN : in std_logic := '1';
	RESULT : out signed(LPM_WIDTHP-1 downto 0));
end component;

begin

------------------- MULT1 COMPONENT INSTANTIATION ----------------------------
	mult1 : LPM_MULT generic map (
	LPM_WIDTHA => 32,
	LPM_WIDTHB => 32,
	LPM_WIDTHP => 64,
	LPM_REPRESENTATION => "SIGNED",
	LPM_PIPELINE => 2
	)
	port map ( DATAA => i_x, DATAB => i_x, CLOCK => i_clk, RESULT => xx );
	
------------------- MULT2 COMPONENT INSTANTIATION ----------------------------		
	mult2 : LPM_MULT generic map (
	LPM_WIDTHA => 32,
	LPM_WIDTHB => 32,
	LPM_WIDTHP => 64,
	LPM_REPRESENTATION => "SIGNED",
	LPM_PIPELINE => 2
	)
	port map ( DATAA => i_y, DATAB => i_y, CLOCK => i_clk, RESULT => yy );
	
------------------- MULT3 COMPONENT INSTANTIATION ----------------------------		
	mult3 : LPM_MULT generic map (
	LPM_WIDTHA => 32,
	LPM_WIDTHB => 32,
	LPM_WIDTHP => 64,
	LPM_REPRESENTATION => "SIGNED",
	LPM_PIPELINE => 2
	)
	port map ( DATAA => i_x, DATAB => i_y, CLOCK => i_clk, RESULT => xy );
	
	p_mult : process(i_clk,i_rstb)
	begin
		if(i_rstb='0') then								-- Reset everything
			o_xx <= (others=>'0');
			o_yy <= (others=>'0');
		elsif(rising_edge(i_clk)) then					-- Process calculation
			o_xx <= std_logic_vector(('0'&(xx)) - yy);	-- Substraction to calculate real parts of output 
			o_yy <= std_logic_vector(xy & '0');			-- Multiplication to calculate imaginary parts of output 
		end if;
	end process p_mult;

end rtl;
