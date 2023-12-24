library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use std.textio.all;
use IEEE.std_logic_textio.all;

entity FileHandling is
    port (
        EN : in STD_LOGIC;
        saved_key : in string(1 to 8);
        saved_password : in string(1 to 8)
    );
end entity FileHandling;

architecture rtl of FileHandling is
begin
    process (EN)
        file dest_text : text;
        file temp_text : text;

        variable row : line;
    begin
        if (EN = '1') then
            file_open(dest_text, "Pass.txt", read_mode);
            file_open(temp_text, "TEMP.txt", write_mode);
    
            while not endfile(dest_text) loop
                readline(dest_text, row);
                writeline(temp_text, row);
            end loop;
    
            file_close(dest_text);
            file_close(temp_text);
    
            file_open(dest_text, "Pass.txt", write_mode);
            file_open(temp_text, "TEMP.txt", read_mode);
    
            while not endfile(temp_text) loop
                readline(temp_text, row);
                writeline(dest_text, row);
            end loop;
    
            write(row, saved_password & " " & saved_key);
            writeline(dest_text, row);
    
            file_close(dest_text);
            file_close(temp_text);

            file_open(temp_text, "TEMP.txt", write_mode);
            write(temp_text, "");
            file_close(temp_text);
        end if;
    end process;
    
end architecture rtl;