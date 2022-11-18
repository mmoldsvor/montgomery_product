library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.rsa_tb_util.all;

entity tb_monpro is
end entity;

architecture testbench of tb_monpro is
    constant n : std_logic_vector(255 downto 0) := X"99925173ad65686715385ea800cd28120288fc70a9bc98dd4c90d676f8ff768d";
    constant n1 : std_logic_vector(255 downto 0) := X"cec4f7862f7488bc9635da7471b8a8de5da7fb55c04749ffa617a7468833c3bb";

    signal clk : std_logic := '0';
    signal reset_n : std_logic := '0';
    signal a : std_logic_vector(255 downto 0);
    signal b : std_logic_vector(255 downto 0);
    
    signal x_bar : std_logic_vector(255 downto 0);
    
    signal monpro_start : std_logic := '0';
    signal monpro_done : std_logic;

    signal n_inverse : std_logic_vector(255 downto 0);
begin
    clk <= not clk after 2.5 ns;

    n_inverse <= not n;
    
    monpro : entity work.monpro(behaviour)
        port map (
            clk => clk,
            reset_n => reset_n,
                
            n => n,
            n1 => n1,
            n_inverse => n_inverse,
            
            monpro_start => monpro_start,
            a_bar => a,
            b_bar => b,

            monpro_done => monpro_done,
            
            x_bar => x_bar
        );
        
    process is
    begin
        apply_reset(reset_n, 20 ns);
        
        a <= X"8d36d904f162ef1ef57893da3b67e7fc870f493b2348679550487f1af6930bc4";
        b <= X"c4174dea36a4820f861b6c4356542156dbd6e5d3138ae59993c89c9e18d98de0";
        
        wait for 20 ns;
        monpro_start <= '1';
        wait for 5 ns;
        monpro_start <= '0';
        
        
        wait;
    end process;
end architecture;