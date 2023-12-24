library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;
use ieee.math_real.all;

entity RandomKey is
    port (
        clk : in std_logic;
        RandomVector : out string(1 to 8)
    );
end RandomKey;

architecture behavior of RandomKey is 
begin
    process(CLK)
        variable seed1 : integer := 2;
        variable seed2 : integer:= 24;

        impure function random_alphabet_number_gen
            return Integer is
            variable r : Real;
            variable temp : Integer;
        begin
            uniform(seed1, seed2, r);
            temp := integer(r * 25.0);
            return temp;
        end function;

        impure function random_upper_down_gen
            return Integer is
            variable r : Real;
            variable temp : Integer;
            variable alpha_type : Integer;
        begin
            uniform(seed1, seed2, r);
            temp := integer(r * 2.0);
            if(temp = 1) then
                alpha_type := 65;
            else
                alpha_type := 97;
            end if;
            return alpha_type;
        end function;

        impure function GenerateRandomString return string is
            variable string_key : string(1 to 8);
            variable number_key : Integer;
        begin
            for i in 1 to 8 loop
                number_key := random_alphabet_number_gen + random_upper_down_gen;
                string_key(i) := character'val(number_key);
            end loop;
            return string_key;
        end function;

        variable vectorRandom : string(1 to 8);
    begin
        if rising_edge(clk) then
            vectorRandom := GenerateRandomString;
            RandomVector <= vectorRandom;    
        end if;
    end process;
end architecture;
