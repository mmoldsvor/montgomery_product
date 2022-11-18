library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier_multiply is
    generic (
        mul_width : integer := 32;
        stages : integer := 6
    );
    port (
        clk : in std_logic;
        a : in std_logic_vector(mul_width-1 downto 0);
        b : in std_logic_vector(mul_width-1 downto 0);
        p : out std_logic_vector(2*mul_width-1 downto 0)
    );
end entity;

architecture behaviour of multiplier_multiply is
    type pipeline_reg is array (natural range <>) of std_logic_vector(2*mul_width-1 downto 0);
    signal reg : pipeline_reg(0 to stages-1);

    signal product : std_logic_vector(2*mul_width-1 downto 0);
begin
    process (clk) is
    begin
        if rising_edge(clk) then
            reg(0) <= product;
            for i in 1 to stages-1 loop
                reg(i) <= reg(i-1);
            end loop;
        end if;
    end process;
    
    product <= std_logic_vector(unsigned(a) * unsigned(b));
    p <= reg(stages-1);
end architecture;