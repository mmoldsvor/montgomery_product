library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier_input is
    generic (
        mul_width : integer := 32;
        quotient : integer := 8;
        counter_width : integer := 8
    );
    port (
        clk : in std_logic;

        a : in std_logic_vector(255 downto 0);
        b : in std_logic_vector(255 downto 0);
        counter : in unsigned(counter_width-1 downto 0);
        valid_in : in std_logic;
        
        a_slice : out std_logic_vector(mul_width-1 downto 0);
        b_slice : out std_logic_vector(mul_width-1 downto 0)
    );
end entity;

architecture behaviour of multiplier_input is
    signal a_reg, b_reg : std_logic_vector(255 downto 0);
begin
    process (clk) is
    begin
        if rising_edge(clk) then
            if counter = 0 then
                a_reg <= a;
                b_reg <= b;
            end if;
        end if;
    end process;

    process (clk) is
        variable c : integer;
    begin
        if rising_edge(clk) then
            if counter = 0 then
                a_slice <= a(mul_width-1 downto 0);
                b_slice <= b(mul_width-1 downto 0);
            else
                c := 0;
                for i in 0 to quotient-1 loop
                    for j in 0 to i loop
                        if counter = c then
                            a_slice <= a_reg(mul_width*((j)+1)-1 downto mul_width*(j));
                            b_slice <= b_reg(mul_width*((i-j)+1)-1 downto mul_width*(i-j));
                        end if;
                        
                        c := c + 1;
                    end loop;
                end loop;
                
                for i in quotient-1 downto 0 loop
                    for j in 0 to i-1 loop
                        if counter = c then
                            a_slice <= a_reg(mul_width*(quotient-i+j+1)-1 downto mul_width*(quotient-i+j));
                            b_slice <= b_reg(mul_width*((quotient-j))-1 downto mul_width*(quotient-j-1));
                        end if;
                        
                        c := c + 1;
                    end loop;
                end loop;
            end if;
        end if;
    end process;
end architecture;