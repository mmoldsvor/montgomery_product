library ieee;
use ieee.std_logic_1164.all;

package rsa_tb_util is
    procedure apply_reset(
        signal reset_n : out std_logic;
        constant period : in time
    );
    
    procedure handshake_send(
        signal clk : in std_logic;
        signal ready : in std_logic;
        signal valid : out std_logic
    );
    
    procedure handshake_recv(
        signal clk : in std_logic;
        signal ready : out std_logic;
        signal valid : in std_logic
    );
end package;

package body rsa_tb_util is
    procedure apply_reset(
        signal reset_n : out std_logic;
        constant period : in time
    ) is
    begin
        reset_n <= '0';
        wait for period;
        reset_n <= '1';
    end procedure;
    
    procedure handshake_send(
        signal clk : in std_logic;
        signal ready : in std_logic;
        signal valid : out std_logic
    ) is
    begin
        valid <= '1';
        wait until ready = '1' and rising_edge(clk);
        valid <= '0';
    end procedure;
    
    procedure handshake_recv(
        signal clk : in std_logic;
        signal ready : out std_logic;
        signal valid : in std_logic
    ) is
    begin
        ready <= '1';
        wait until valid = '1' and rising_edge(clk);
        ready <= '0';
    end procedure;
end package body;