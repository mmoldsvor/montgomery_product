library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier_accumulate is
    generic (
        mul_width : integer := 32;
        extra_bits : integer := 3
    );
    port (
        clk : in std_logic;
        
        shift : in std_logic;
        restart : in std_logic;
        
        full_done : in std_logic;
        half_done : in std_logic;
        
        valid_full : out std_logic;
        valid_half : out std_logic;
           
        p_partial : in std_logic_vector(2*mul_width-1 downto 0);
        
        p : out std_logic_vector(511 downto 0)
    );
end entity;

architecture behaviour of multiplier_accumulate is
    signal adder_output : std_logic_vector(2*mul_width-1+extra_bits downto 0);
    
    signal shifter_shift : std_logic_vector(511+extra_bits downto 0);
    signal shifter_still : std_logic_vector(511+extra_bits downto 0);
    
    signal shifter_r : std_logic_vector(511+extra_bits downto 0);
begin 
    process (clk) is
    begin
        if rising_edge(clk) then
            if shift = '1' then
                shifter_r <= shifter_shift;
            elsif restart = '1' then
                shifter_r <= (others => '0');
            else
                shifter_r <= shifter_still;
            end if;
        end if;
    end process;
    
    process (clk) is
    begin
        if rising_edge(clk) then
            valid_full <= '0';
            valid_half <= '0';
            
            if full_done = '1' then
                p <= shifter_still(511 downto 0);
                valid_full <= '1';
            elsif half_done = '1' then
                p <= (511 downto 256 => '0') & shifter_still(512-2*mul_width-1 downto 256-2*mul_width);
                valid_half <= '1';
            end if;
        end if;
    end process;
    
    shifter_still <= adder_output(2*mul_width-1+extra_bits downto 0) & shifter_r(512-2*mul_width-1 downto 0);
    shifter_shift <= shifter_r(mul_width-1 downto 0) & adder_output(2*mul_width-1+extra_bits downto 0) & shifter_r(512-2*mul_width-1 downto mul_width);
    
    adder_output <= std_logic_vector(unsigned(shifter_r(511+extra_bits downto 512-2*mul_width)) + unsigned(p_partial));
end architecture;