library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.rsa_tb_util.all;

entity tb_monpro_multiplier is
end entity;

architecture testbench of tb_monpro_multiplier is
    constant n : std_logic_vector(255 downto 0) := X"99925173ad65686715385ea800cd28120288fc70a9bc98dd4c90d676f8ff768d";
    constant n1 : std_logic_vector(255 downto 0) := X"cec4f7862f7488bc9635da7471b8a8de5da7fb55c04749ffa617a7468833c3bb";

    signal clk : std_logic := '0';
    signal reset_n : std_logic := '0';
    
    signal a, b : std_logic_vector(255 downto 0);
    signal p : std_logic_vector(511 downto 0);
    
    signal done : std_logic;
    signal half_done : std_logic;
    signal valid_in : std_logic;
begin
    clk <= not clk after 2.5 ns;
    
    monpro_multiplier : entity work.monpro_multiplier(behaviour)
        port map(
            clk => clk,
            reset_n => reset_n,
            
            valid_in => valid_in,
            
            a => a,
            b => b,
            
            done => done,
            half_done => half_done,
                
            p => p        
        );
        
    process is
    begin
        a <= (others => '0');
        b <= (others => '0');
        valid_in <= '0';
        
        apply_reset(reset_n, 20 ns);
        
        valid_in <= '1';
        a <= X"666dae8c529a9798eac7a157ff32d7edfd77038f56436722b36f298907008973";
        b <= X"666dae8c529a9798eac7a157ff32d7edfd77038f56436722b36f298907008973";
        
        wait for 10 ns;
        valid_in <= '0';
        a <= (others => '0');
        b <= (others => '0');
        
        wait;
    end process;
end architecture;