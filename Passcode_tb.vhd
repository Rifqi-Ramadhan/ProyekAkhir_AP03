library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.std_logic_textio.all;
use std.textio.all;


entity Passcode_tb is
end entity;

architecture rtl of Passcode_tb is
    component Main
        Port (
            clk : in STD_LOGIC;
            start : in STD_LOGIC;
            mode : in STD_LOGIC;
            reset : in STD_LOGIC;
            input_password : in string(1 to 8);

            success : out STD_LOGIC;
            fail : out STD_LOGIC
        );
    end component;

    signal clk : std_logic := '1';
    signal start, mode, reset : std_logic := '0';
    signal input_password : string(1 to 8);

    signal success : std_logic;
    signal fail : std_logic;

    constant CLK_PERIOD : time := 100 ps;
begin
    MAIN_UUT : Main
        port map (
            clk => clk,
            start => start,
            mode => mode,
            reset => reset,
            input_password => input_password,
            success => success,
            fail => fail
        );
    
    CLOCK_TB : process
    begin
        for i in 0 to 34 loop
            wait for CLK_PERIOD / 2;
            CLK <= '0';
            wait for CLK_PERIOD / 2;
            CLK <= '1';
        end loop;
        wait;
    end process;
    
    tb : process
        type test_array is array (0 to 3) of string(1 to 8);
        variable register_password : test_array := 
            (0 => "abcdefgh",
             1 => "zxcvbnml",
             2 => "terqwyui",
             3 => "Daniel12");

        variable login_password : test_array := 
            (0 => "zxcvbnml",
             1 => "hgfasdjk",
             2 => "9283iuad",
             3 => "Daniel12");
    begin
        --Register All Passcode
        mode <= '0';
            
        for i in 0 to 3 loop
            input_password <= register_password(i);
            wait for CLK_PERIOD * 4;
        end loop;
        
        mode <= '1';
            
        for i in 0 to 3 loop
            input_password <= login_password(i);
            wait for CLK_PERIOD * 4;
        end loop;

        reset <= '1';
        wait for CLK_PERIOD * 2;
        wait;
    end process;
    
    start_TB : process
    begin
        wait for CLK_PERIOD / 2;
        start <= '1';
        wait;
    end process;
end architecture rtl;