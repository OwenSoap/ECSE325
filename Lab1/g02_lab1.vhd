library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity g02_lab1 is
  Port(        clk          :in std_logic;
               countbytwo   :in std_logic;
					rst          :in std_logic;
					enable       :in std_logic;
					output       :out std_logic_vector(7 downto 0));
end g02_lab1;

architecture counter8 of g02_lab1 is
  signal count: integer range 0 to 256;
 
begin
	process(clk, rst)
	begin
		if rst = '1' then
			count <= 0;
		elsif rising_edge(clk) then
			if enable='1' then
				if countbytwo = '1' then
					count <= count + 2;
				else
					count <= count + 1;
				end if;
			end if;
		end if;
	end process;
	output <= std_logic_vector(to_unsigned(count, 8));
end counter8;
	   
   