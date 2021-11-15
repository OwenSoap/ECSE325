library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;
LIBRARY lpm;
USE lpm.lpm_components.all;

entity g02_complex_square is
port (
	i_clk : in std_logic;
	i_rstb : in std_logic;
	i_x : in std_logic_vector(31 downto 0);
	i_y : in std_logic_vector(31 downto 0);
	o_xx, o_yy : out std_logic_vector(64 downto 0));
end g02_complex_square;

architecture rtl of g02_complex_square is

signal xx, yy, xy : std_logic_vector(64 downto 0);

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
		RESULT : out std_logic_vector(LPM_WIDTHP-1 downto 0));
end component;

begin
	
	p_mult : process(i_clk,i_rstb)
	begin
		if(i_rstb='0') then
			o_xx <= (others=>'0');
			o_yy <= (others=>'0');
		elsif(rising_edge(i_clk)) then
			o_xx <= std_logic_vector(xx - yy);
			o_yy <= std_logic_vector(xy);
			end if;
		end process p_mult;
		
		mult1 : LPM_MULT generic map (
		LPM_WIDTHA => 32,
		LPM_WIDTHB => 32,
		LPM_WIDTHP => 65,
		LPM_REPRESENTATION => "SIGNED",
		LPM_PIPELINE => 4
		)
		port map ( DATAA => i_x, DATAB => i_x, CLOCK => i_clk, RESULT => xx );
		
		mult2 : LPM_MULT generic map (
		LPM_WIDTHA => 32,
		LPM_WIDTHB => 32,
		LPM_WIDTHP => 65,
		LPM_REPRESENTATION => "SIGNED",
		LPM_PIPELINE => 4
		)
		port map ( DATAA => i_y, DATAB => i_y, CLOCK => i_clk, RESULT => yy );
		
		mult3 : LPM_MULT generic map (
		LPM_WIDTHA => 32,
		LPM_WIDTHB => 32,
		LPM_WIDTHP => 65,
		LPM_REPRESENTATION => "SIGNED",
		LPM_PIPELINE => 4
		)
		port map ( DATAA => i_x, DATAB => i_y, CLOCK => i_clk, RESULT => xy );

end rtl;