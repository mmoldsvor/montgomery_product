library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier_controller is
    generic (
        mul_latency : integer := 6;
        mul_iterations : integer := 64;
        shift_flip : integer := 8;
        counter_width : integer := 8
    );
    port (
        clk : in std_logic;
        reset_n : in std_logic;
        
        valid_in : in std_logic;
        
        shift : out std_logic;
        restart : out std_logic;
        
        full_done : out std_logic;
        half_done : out std_logic;
        
        mul_counter : out unsigned(7 downto 0)
    );
end entity;

architecture behaviour of multiplier_controller is
    signal mul_counter_r : unsigned(counter_width-1 downto 0);
    signal add_counter_r : unsigned(counter_width-1 downto 0);
    
    signal mul_done : std_logic;
begin
    multiplier_process : process (clk, reset_n) is
    begin
        if reset_n = '0' then
            mul_counter_r <= (others => '0');
        elsif rising_edge(clk) then
            mul_done <= '0';
            
            if (mul_counter_r /= 0 or valid_in = '1') then
                mul_counter_r <= mul_counter_r  + 1;
                if mul_counter_r = mul_latency-1 then
                    mul_done <= '1';
                elsif mul_counter_r = mul_iterations then
                    mul_counter_r <= (others => '0');
                end if;
            end if;
        end if;
    end process;

    adder_process : process (clk, reset_n) is
    begin
        if reset_n = '0'then
            add_counter_r <= (others => '0');
        elsif rising_edge(clk) then
            restart <= '0';
            shift <= '0';
            half_done <= '0';
            full_done <= '0';
            
            if (add_counter_r /= 0 or mul_done = '1') then
                add_counter_r <= add_counter_r  + 1;
                
                for i in 1 to (2*shift_flip-2) loop
                    if i <= shift_flip then
                        if add_counter_r = ((i+1)*i / 2 - 1) then
                            shift <= '1';
                        end if;
                    else
                        if add_counter_r = (shift_flip + 2*shift_flip*i - shift_flip*shift_flip - (i*i + i)/2 - 1) then
                            shift <= '1';
                        end if;
                    end if;
                end loop;
                
                if add_counter_r = (shift_flip*(shift_flip+1)/2) then
                    half_done <= '1';
                elsif add_counter_r = (shift_flip*shift_flip-1) then
                    full_done <= '1';
                    add_counter_r <= (others => '0');
                end if;
            elsif add_counter_r = 0 then
                restart <= '1';
            end if;
        end if;
    end process;
    
    mul_counter <= mul_counter_r;
end architecture;

