library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity monpro_multiplier is
    generic (
        mul_width : integer := 64;
        mul_latency : integer := 16;
        mul_iterations : integer := 16;
        shift_flip : integer := 4;
        counter_width : integer := 8;
        add_extra_bits : integer := 4
    );
    port (
        clk : in std_logic;
        reset_n : in std_logic;
        
        a : in std_logic_vector(255 downto 0);
        b : in std_logic_vector(255 downto 0);
        
        valid_in : in std_logic;
            
        valid_half : out std_logic;
        valid_full : out std_logic;
        
        p : out std_logic_vector(511 downto 0)
    );
end entity;

architecture behaviour of monpro_multiplier is
    signal a_slice, b_slice : std_logic_vector(mul_width-1 downto 0);
    signal p_partial : std_logic_vector(2*mul_width-1 downto 0);
    signal mul_counter : unsigned(counter_width-1 downto 0);
    
    signal shift : std_logic;
    signal restart : std_logic;
    
    signal half_done : std_logic;
    signal full_done : std_logic;
begin
    multiplier_multiply : entity work.multiplier_multiply(behaviour)
        generic map (
            mul_width => mul_width,
            stages => mul_latency
        )
        port map (
            clk => clk,
            a => a_slice,
            b => b_slice,
            p => p_partial
        );
    
    multiplier_controller : entity work.multiplier_controller(behaviour)
        generic map (
            mul_latency => mul_latency,
            mul_iterations => mul_iterations,
            shift_flip => shift_flip,
            counter_width => counter_width
        )
        port map(
            clk => clk,
            reset_n => reset_n,
            
            valid_in => valid_in,
            
            mul_counter => mul_counter,
    
            shift => shift,
            restart => restart,
            
            full_done => full_done,
            half_done => half_done,
        );
    
    multiplier_input : entity work.multiplier_input(behaviour)
        generic map (
            mul_width => mul_width,
            quotient => 256/mul_width,
            counter_width => counter_width
        )
        port map (
            clk => clk,

            a => a,
            b => b,
            counter => mul_counter,
            valid_in => valid_in,

            a_slice => a_slice,
            b_slice => b_slice
        );
        
    multiplier_accumulate : entity work.multiplier_accumulate(behaviour)
        generic map (
            mul_width => mul_width,
            extra_bits => add_extra_bits
        )
        port map (
            clk => clk,
            
            shift => shift,
            restart => restart,
            
            half_done => half_done,
            full_done => full_done,
            
            valid_full => valid_full,
            valid_half => valid_half,
            
            p_partial => p_partial,
            
            p => p
        );
end architecture;