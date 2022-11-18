library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity monpro_controller is
    generic (
        add_latency : integer := 3
    );
    port (
        clk : in std_logic;
        reset_n : in std_logic;

        -- Control input
        monpro_start : in std_logic;
        
        valid_half : in std_logic;
        valid_full : in std_logic;

        -- Control output
        mul1 : out std_logic;
        mul2 : out std_logic;
        mul3 : out std_logic;
        t_ready : out std_logic;

        add1 : out std_logic;
        add2 : out std_logic;
        sub : out std_logic;

        monpro_done : out std_logic
    );
end entity;

architecture behaviour of monpro_controller is
    type state is (IDLE, MUL_STATE1, MUL_STATE2, MUL_STATE3, ADD_STATE1, ADD_STATE2, SUB_STATE);
    signal current_state, next_state : state;

    signal counter : unsigned(7 downto 0);
begin
    process (clk) is
    begin
        if rising_edge(clk) then
            counter <= counter + 1;
            if add2 = '1' or counter = add_latency then
                counter <= (others => '0');
            end if;
        end if;
    end process;

    process (all) is
    begin
        next_state <= current_state;
        
        mul1 <= '0';
        mul2 <= '0';
        mul3 <= '0';
        t_ready <= '0';
        
        add1 <= '0';
        add2 <= '0';
        sub <= '0';

        monpro_done <= '0';
        
        case current_state is
            when IDLE =>
                if monpro_start = '1' then
                    mul1 <= '1';
                    next_state <= MUL_STATE1;
                end if;
            when MUL_STATE1 =>
                if valid_half = '1' then
                    mul2 <= '1';
                    next_state <= MUL_STATE2;
                end if;
            when MUL_STATE2 =>
                if valid_full = '1' then
                    t_ready <= '1';
                end if;

                if valid_half = '1' then
                    mul3 <= '1';
                    next_state <= MUL_STATE3;
                end if;
            when MUL_STATE3 =>
                if valid_half = '1' then
                    add1 <= '1';
                    next_state <= ADD_STATE1;
                end if;
            when ADD_STATE1 =>
                if valid_full = '1' then
                    add2 <= '1';
                    next_state <= ADD_STATE2;
                end if;
            when ADD_STATE2 =>
                if counter = add_latency then
                    sub <= '1';
                    next_state <= SUB_STATE;
                end if;
            when SUB_STATE =>
                if counter = add_latency then
                    monpro_done <= '1';
                    next_state <= IDLE;
                end if;
            when others =>
                next_state <= IDLE;
        end case;
    end process;
    
    process (clk, reset_n) is
    begin
        if reset_n = '0' then
            current_state <= IDLE;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;
end architecture;