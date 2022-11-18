library ieee;
use ieee.std_logic_1164.all;

entity monpro_output is
    port (
        clk : in std_logic;

        sub : in std_logic;

        add_output : in std_logic_vector(255 downto 0);
        sub_output : in std_logic_vector(255 downto 0);
        sub_sign : in std_logic;

        result : out std_logic_vector(255 downto 0)
    );
end entity;

architecture behaviour of monpro_output is
    signal sum_reg : std_logic_vector(255 downto 0);
begin
    process (clk) is
    begin
        if rising_edge(clk) then
            if sub = '1' then
                sum_reg <= add_output;
            end if;
        end if;
    end process;

    process (all) is
    begin
        if sub_sign = '1' then
            result <= sum_reg;
        else
            result <= sub_output;
        end if;
    end process;
end architecture;