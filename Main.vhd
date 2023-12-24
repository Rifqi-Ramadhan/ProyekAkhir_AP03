library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;

entity Main is
    Port ( 
        clk : in STD_LOGIC;
        start : in STD_LOGIC;
        mode : in STD_LOGIC;
        reset : in STD_LOGIC;
        input_password : in string(1 to 8);

        success : out STD_LOGIC;
        fail : out STD_LOGIC
    );
end Main;

architecture Behavioral of Main is

    component RandomKey is
        port (
            clk : in std_logic;
            RandomVector : out string(1 to 8)
        );
    end component;

    component FileHandling is
        port (
            EN : in STD_LOGIC;
            saved_key : in string(1 to 8);
            saved_password : in string(1 to 8)
        );
    end component;

    type state_type is (IDLE, CLR, REG, ENCRYPT, SAVE, LOGIN, CHECK, WRONG, CORRECT);
    signal curr_state : state_type := IDLE;
    signal next_state : state_type;
    signal RandomVector : string(1 to 8);
    
    signal EN : std_logic;
    signal saved_password : string(1 to 8);
    signal saved_key : string(1 to 8);

    function check_valid_password(to_check : string(1 to 8))
        return STD_LOGIC is

        file pass_text : text ;
        variable row_read : line;

        variable encrypted_check : string (1 to 8);
        variable temp_pass_string : string(1 to 8);
        variable temp_key_string : string(1 to 8);
        variable temp_string : string(1 to 17);

        variable char_key_int : Integer;
        variable char_pass_int : Integer;
        variable char_encrypt_int : Integer;
    begin
        file_open(pass_text, "Pass.txt", read_mode);
        while not endfile(pass_text) loop
            readline(pass_text, row_read);
            read(row_read, temp_string);

            temp_pass_string := temp_string(1 to 8);
            temp_key_string := temp_string(10 to 17);
            for i in 1 to 8 loop
                char_key_int := character'pos(temp_key_string(i));
                char_pass_int := character'pos(to_check(i));
                char_encrypt_int := (char_pass_int + char_key_int - 5);
                char_encrypt_int := char_encrypt_int * 2;
                char_encrypt_int := (char_encrypt_int mod 93) + 33;

                encrypted_check(i) := character'val(char_encrypt_int);
            end loop;

            report temp_pass_string & "|||" & temp_key_string;
            if(encrypted_check = temp_pass_string) then
                return '1';
            end if;

        end loop;
        
        return '0';
    end function;

    procedure encrypt_pass(signal pass : inout string (1 to 8);
                           signal key : in string(1 to 8)) is
        variable char_key_int : Integer;
        variable char_pass_int : Integer;
        variable char_encrypt_int : Integer;
        variable pass_temp : string(1 to 8);
    begin
        for i in 1 to 8 loop
            char_key_int := character'pos(key(i));
            char_pass_int := character'pos(pass(i));
            char_encrypt_int := (char_pass_int + char_key_int - 5);
            char_encrypt_int := char_encrypt_int * 2;
            char_encrypt_int := (char_encrypt_int mod 93) + 33;

            pass_temp(i) := character'val(char_encrypt_int);
        end loop;

        pass <= pass_temp;
    end procedure;

    procedure clear_file(constant yes : std_logic) is
        file pass_text : text;
    begin
        if(yes = '1') then
            file_open(pass_text, "Pass.txt", write_mode);
            write(pass_text, "");
            
            report "All passcode has been deleted";

            file_close(pass_text);
        end if;
    end procedure;
begin
    RandomKey_instance : RandomKey port map (clk => clk, RandomVector => RandomVector);
    FileHandling_instance : FileHandling port map (EN => EN, saved_key => saved_key, saved_password => saved_password);

    process(CLK)
    begin
        if(rising_edge(CLK)) then
            case curr_state is
                when IDLE =>
                    EN <= '0';
                    success <= '0';
                    fail <= '0';
                    if(start = '1') then
                        if(reset = '1') then
                            curr_state <= CLR;
                        elsif (mode = '1') then
                            curr_state <= LOGIN;
                        elsif(mode = '0') then
                            curr_state <= REG;
                        else
                            curr_state <= IDLE;
                        end if;
                    else
                        curr_state <= IDLE;
                    end if;

                when CLR =>
                    clear_file('1');
                    success <= '1';
                    curr_state <= IDLE;

                when REG =>
                    saved_password <= input_password;
                    saved_key <= RandomVector;
                    curr_state <= ENCRYPT;

                when ENCRYPT =>
                    encrypt_pass(saved_password, saved_key);
                    curr_state <= SAVE;

                when SAVE =>
                    EN <= '1';
                    success <= '1';
                    curr_state <= IDLE;

                when LOGIN =>
                    saved_password <= input_password;
                    curr_state <= CHECK;

                when CHECK =>
                    if(check_valid_password(saved_password) = '1') then
                        curr_state <= CORRECT;
                    else
                        curr_state <= WRONG;
                    end if;

                when CORRECT =>
                    report "ANJAY MASUK";
                    success <= '1';
                    curr_state <= IDLE;

                when WRONG =>
                    report "BJIR SALAH";
                    fail <= '1';
                    curr_state <= IDLE;
            end case;
        end if;
    end process;

    
end architecture;
