library ieee;
use ieee.std_logic_1164.all;

library work;
use work.rsa_tb_util.all;

entity tb_monpro_adder is
end entity;

architecture behaviour of tb_monpro_adder is
    signal clk : std_logic := '0';
    
    signal a : std_logic_vector(255 downto 0);
    signal b : std_logic_vector(255 downto 0);
    signal c_in : std_logic;
    
    signal s : std_logic_vector(255 downto 0);
    signal c_out : std_logic;
begin
    clk <= not clk after 2.5 ns;
    
    monpro_adder : entity work.monpro_adder(testing)
        port map (
            clk => clk,
            
            a => '0' & a,
            b => '0' & b,
            c_in => c_in,
            
            s => s,
            c_out => c_out
        );
    
    process is
    begin
        a <= (others => '0');
        b <= (others => '0');
        c_in <= '0';
        
        wait for 20 ns;
    
        a <= X"99925173ad65686715385ea800cd28120288fc70a9bc98dd4c90d676f8ff768d";
        b <= X"99925173ad65686715385ea800cd28120288fc70a9bc98dd4c90d676f8ff768d";
        c_in <= '0';
        wait for 10 ns;
        
        c_in <= '1';
        wait for 10 ns;
    
        wait;
    end process;

end architecture;