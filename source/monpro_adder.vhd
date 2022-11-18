library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity monpro_adder is
    generic (
        add_width : integer := 256;
        stages : integer := 2
    );
    port (
        clk : in std_logic;

        a : in std_logic_vector(add_width downto 0);
        b : in std_logic_vector(add_width downto 0);
        c_in : in std_logic;
        
        s : out std_logic_vector(add_width-1 downto 0);
        c_out : out std_logic
    );
end entity;

architecture testing of monpro_adder is
    signal sum_lower : std_logic_vector(128 downto 0);
    signal sum_upper : std_logic_vector(128 downto 0);
    
    signal carry_r : std_logic;
    signal carry_out_r : std_logic;
    
    signal s_reg : std_logic_vector(255 downto 0);
begin
    process (clk) is
    begin
        if rising_edge(clk) then
            carry_r <= sum_lower(128);
            carry_out_r <= sum_upper(128);
            s_reg <= sum_upper(127 downto 0) & sum_lower(127 downto 0);
        end if;
    end process;
    
    
    sum_upper <= std_logic_vector(unsigned(a(256 downto 128)) + unsigned(b(256 downto 128)) + ("" & carry_r));
    sum_lower <= std_logic_vector(unsigned('0' & a(127 downto 0)) + unsigned('0' & b(127 downto 0)) + ("" & c_in));
    s <= s_reg;
    c_out <= carry_out_r;
end architecture;
