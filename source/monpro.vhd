--this is an instantiated file
library ieee;
use ieee.std_logic_1164.all;

entity monpro is
    port (
        clk : in std_logic;
        reset_n : in std_logic;
        
        -- Constant input
        n : in std_logic_vector(255 downto 0);
        n1 : in std_logic_vector(255 downto 0);
        n_inverse : in std_logic_vector(255 downto 0);
        
        monpro_start : in std_logic;
        a_bar : in std_logic_vector(255 downto 0);
        b_bar : in std_logic_vector(255 downto 0);
        
        monpro_done : out std_logic;
        x_bar : out std_logic_vector(255 downto 0)
	);
end monpro;


architecture behaviour of monpro is
    signal p : std_logic_vector(511 downto 0);
    
    signal mul_reg1 : std_logic_vector(255 downto 0);
    signal mul_reg2 : std_logic_vector(255 downto 0);
    signal mul_valid : std_logic;
    
    signal t_reg : std_logic_vector(511 downto 0);

    signal add_reg1 : std_logic_vector(256 downto 0);
    signal add_reg2 : std_logic_vector(256 downto 0);
    signal add_c_reg : std_logic;
    
    signal add_s : std_logic_vector(255 downto 0);
    signal add_c_out : std_logic;

    signal mul1 : std_logic;
    signal mul2 : std_logic;
    signal mul3 : std_logic;
    signal t_ready : std_logic;

    signal add1 : std_logic;
    signal add2 : std_logic;
    signal sub : std_logic;

    signal valid_half : std_logic;
    signal valid_full : std_logic;
begin
    monpro_controller : entity work.monpro_controller(behaviour)
        port map (
            clk => clk,
            reset_n => reset_n,

            monpro_start => monpro_start,

            valid_half => valid_half,
            valid_full => valid_full,

            mul1 => mul1,
            mul2 => mul2,
            mul3 => mul3,
            t_ready => t_ready,
            
            add1 => add1,
            add2 => add2,
            sub => sub,

            monpro_done => monpro_done
        );

    monpro_input : entity work.monpro_input(behaviour)
        port map(
            clk => clk,

            n => n,
            n1 => n1,
            n_inverse => n_inverse,
            
            mul1 => mul1,
            mul2 => mul2,
            mul3 => mul3,
            
            add1 => add1,
            add2 => add2,
            sub => sub,
            t_ready => t_ready,
            
            a_bar => a_bar,
            b_bar => b_bar,
            p => p,

            add_s => add_s,
            add_c_out => add_c_out,

            mul_reg1 => mul_reg1,
            mul_reg2 => mul_reg2,
            mul_valid => mul_valid,
            
            t_reg => t_reg,
            
            add_reg1 => add_reg1,
            add_reg2 => add_reg2,
            add_c_reg => add_c_reg
        );
    
    monpro_multiplier : entity work.monpro_multiplier(behaviour)
        port map (
            clk => clk,
            reset_n => reset_n,

            a => mul_reg1,
            b => mul_reg2,
            valid_in => mul_valid,
            
            valid_half => valid_half,
            valid_full => valid_full,
            
            p => p
        );
        
     monpro_adder : entity work.monpro_adder(behaviour)
        port map (
            clk => clk,

            a => add_reg1,
            b => add_reg2,
            c_in => add_c_reg,

            s => add_s,
            c_out => add_c_out
        );
        
     monpro_output : entity work.monpro_output(behaviour)
        port map (
            clk => clk,

            sub => sub,

            add_output => add_s,
            sub_output => add_s,
            sub_sign => add_c_out,
            result => x_bar
        );
end behaviour;