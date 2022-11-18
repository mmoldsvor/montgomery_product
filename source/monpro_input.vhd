library ieee;
use ieee.std_logic_1164.all;

entity monpro_input is
    port (
        clk : in std_logic;

        -- Constant input
        n : in std_logic_vector(255 downto 0);
        n1 : in std_logic_vector(255 downto 0);
        n_inverse : in std_logic_vector(255 downto 0);

        -- Control logic
        mul1 : in std_logic;
        mul2 : in std_logic;
        mul3 : in std_logic;
        t_ready : in std_logic;

        add1 : in std_logic;
        add2 : in std_logic;
        sub : in std_logic;

        -- Input data
        a_bar : in std_logic_vector(255 downto 0);
        b_bar : in std_logic_vector(255 downto 0);
        p : in std_logic_vector(511 downto 0);

        add_s : in std_logic_vector(255 downto 0);
        add_c_out : in std_logic;

        -- Output data
        mul_reg1 : out std_logic_vector(255 downto 0);
        mul_reg2 : out std_logic_vector(255 downto 0);
        mul_valid : out std_logic;
        
        t_reg : out std_logic_vector(511 downto 0);

        add_reg1 : out std_logic_vector(256 downto 0);
        add_reg2 : out std_logic_vector(256 downto 0);
        add_c_reg : out std_logic
    );
end entity;

architecture behaviour of monpro_input is
begin
    process (clk) is
    begin
        if rising_edge(clk) then
            mul_valid <= '0';
            
            if mul1 = '1' then
                mul_reg1 <= a_bar;
                mul_reg2 <= b_bar;
                mul_valid <= '1';
            end if;

            if mul2 = '1' then
                mul_reg1 <= p(255 downto 0);
                mul_reg2 <= n1;
                mul_valid <= '1';
            end if;
            
            if mul3 = '1' then
                mul_reg1 <= p(255 downto 0);
                mul_reg2 <= n;
                mul_valid <= '1';
            end if;

            if t_ready = '1' then
                t_reg <= p;
            end if;

            if add1 = '1' then
                add_reg1 <= '0' & p(255 downto 0);
                add_reg2 <= '0' & t_reg(255 downto 0);
                add_c_reg <= '0';
            end if;

            if add2 = '1' then
                add_reg1 <= '0' & p(511 downto 256);
                add_reg2 <= '0' & t_reg(511 downto 256);
                add_c_reg <= add_c_out;
            end if;

            if sub = '1' then
                add_reg1 <= add_c_out & add_s;
                add_reg2 <= '1' & n_inverse;
                add_c_reg <= '1';
            end if;
        end if;
    end process;
end architecture;