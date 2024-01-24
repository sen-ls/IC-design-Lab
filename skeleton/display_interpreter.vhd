----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/05/2023 09:03:29 AM
-- Design Name: 
-- Module Name: display_interpreter - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity display_interpreter is
  Port (   clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           synchronize : in STD_LOGIC;
           global_state : in STD_LOGIC_VECTOR (6 downto 0);
           td_sec : in STD_LOGIC_VECTOR (6 downto 0);
           td_min : in STD_LOGIC_VECTOR (6 downto 0);
           td_hour : in STD_LOGIC_VECTOR (5 downto 0);
           td_day : in STD_LOGIC_VECTOR (5 downto 0);
           td_dow : in STD_LOGIC_VECTOR (2 downto 0);
           td_month : in STD_LOGIC_VECTOR (4 downto 0);
           td_year : in STD_LOGIC_VECTOR (7 downto 0);
           line1 : out STD_LOGIC_VECTOR (319 downto 0);
           line2 : out STD_LOGIC_VECTOR (319 downto 0)
           );
           
end display_interpreter;


architecture Behavioral of display_interpreter is

    signal sec : STD_LOGIC_VECTOR (7 downto 0);
    signal min : STD_LOGIC_VECTOR (7 downto 0);
    signal hour : STD_LOGIC_VECTOR (7 downto 0);
    signal day : STD_LOGIC_VECTOR (7 downto 0);
    signal dow : STD_LOGIC_VECTOR (2 downto 0);
    signal month : STD_LOGIC_VECTOR (7 downto 0);
    signal year : STD_LOGIC_VECTOR (7 downto 0);

    -- SOURCE: https://electronics.stackexchange.com/questions/626149/does-vhdl-2008-have-built-in-function-to-convert-std-logic-vector-to-character-t
    -- ADAPTED
    subtype byte is std_logic_vector(7 downto 0);
    subtype byte2 is std_logic_vector(15 downto 0);
    
    function to_byte(c : character) return byte is
  begin
    return byte(to_unsigned(character'pos(c), 8));
  end function;
  
  function number_to_char(b: std_logic_vector(7 downto 0)) return byte is
  begin
    --return byte(to_unsigned(character'pos(character'val(to_integer(unsigned(b)))), 8));
    case to_integer(unsigned(b)) is

        when 0 =>
            return "00110000"; 
        when 1 =>
            return "00110001";
        when 2 =>
            return "00110010";
        when 3 =>
            return "00110011";
        when 4 =>
            return "00110100";
        when 5 =>
            return "00110101";
        when 6 =>
            return "00110110";
        when 7 =>
            return "00110111";
        when 8 =>
            return "00111000";
        when 9 =>
            return "00111001";
        when others =>
            return "00110000"; 
        
    end case;
  end function;
    
    function char(l: std_logic_vector; pos: integer) return byte is
    begin
        return l(pos*8+7 downto pos*8);
    end function;
    
    
    function To2CharArray(input_num : unsigned(7 downto 0)) return std_logic_vector is
        variable tens_digit : integer range 0 to 9;
        variable units_digit : integer range 0 to 9;
        variable result : std_logic_vector(15 downto 0);
    begin
        tens_digit := to_integer(input_num)/10;
        units_digit := to_integer(input_num)-to_integer(input_num)/10*10;
        
        result := number_to_char(std_logic_vector(to_unsigned(units_digit, 8))) & number_to_char(std_logic_vector(to_unsigned(tens_digit, 8)));
        return result;
    end function;
    
    
    function checkBit(b: STD_LOGIC) return byte is
    begin
        if (b = '0') then
            return to_byte('0');
        elsif (b = '1') then
            return to_byte('1');
        else
            return to_byte('X');
            
        end if;
    end function;
    
--    function LastTwoDigitsToCharArray(input_num : in unsigned(7 downto 0)) return std_logic_vector is
--        variable units_digit : integer range 0 to 9;
--        variable tens_digit : integer range 0 to 9;
--        variable result : std_logic_vector(15 downto 0);
--    begin
--        tens_digit := (to_integer(input_num)-to_integer(input_num)/100*100)/10;
--        units_digit := to_integer(input_num)-(to_integer(input_num)-to_integer(input_num)/100*100)/10*10;

--        result := number_to_char(std_logic_vector(to_unsigned(units_digit, 8))) & number_to_char(std_logic_vector(to_unsigned(tens_digit, 8)));
--        return result;
--    end function;
    
    
begin

           sec <= '0' & td_sec;
           min <= '0' & td_min;
           hour <= "00" & td_hour;
           day <= "00" & td_day;
           dow <= td_dow;
           month <= "000" & td_month;
           year <= td_year;


    process(clk) is
    begin
    if (rising_edge(clk)) then
        case global_state is
            
            -- Debug
            when "0000000" =>
                for i in 0 to td_day'length-1 loop
                    line1(i*8+7 downto i*8) <= checkBit(td_day(i)); 
                end loop;
                for i in td_day'length-1 to 19 loop
                    line1(i*8+7 downto i*8) <= to_byte(' '); 
                end loop;
                
                
                for i in 0 to td_month'length-1 loop
                    line2(i*8+7 downto i*8) <= checkBit(td_month(i)); 
                end loop;
                for i in td_month'length-1 to 19 loop
                    line2(i*8+7 downto i*8) <= to_byte(' '); 
                end loop;
                
                
                for i in 20 to 20+td_hour'length-1 loop
                    line1(i*8+7 downto i*8) <= checkBit(td_hour(i-20)); 
                end loop;
                for i in 20+td_hour'length-1 to 20+19 loop
                    line1(i*8+7 downto i*8) <= to_byte(' '); 
                end loop;
                
                
                for i in 20 to 20+td_min'length-1 loop
                    line2(i*8+7 downto i*8) <= checkBit(td_min(i-20)); 
                end loop;
                for i in 20+td_min'length-1 to 20+19 loop
                    line2(i*8+7 downto i*8) <= to_byte(' '); 
                end loop;
                
                   
            --Time
            when "0000001" =>
                -- First Line
                for i in 0 to 6 loop
                    line1(i*8+7 downto i*8) <= to_byte(' ');
                end loop;
                
                line1(7 *8+7 downto 7 *8) <= to_byte('T');
                line1(8 *8+7 downto 8 *8) <= to_byte('I');
                line1(9 *8+7 downto 9 *8) <= to_byte('M');
                line1(10*8+7 downto 10*8) <= to_byte('E');
                line1(11*8+7 downto 11*8) <= to_byte(':');
                
                for i in 12 to 19 loop
                    line1(i*8+7 downto i*8) <= to_byte(' ');
                end loop;
                
                line2(0*8+7 downto 0*8) <= to_byte('A');
                
                for i in 1 to 4 loop
                    line2(i*8+7 downto i*8) <= to_byte(' ');
                end loop;
                
                -- Hour
                if (unsigned(hour) < 10) then
                    line2(5*8+7 downto 5*8) <= to_byte('0'); 
                    line2(6*8+7 downto 6*8) <= number_to_char(hour);
                else
                    line2(6*8+7 downto 5*8) <= To2CharArray(unsigned(hour));
                end if;
                    
                line2(7*8+7 downto 7*8) <= to_byte(':');
                
                -- Minutes
                if (unsigned(min) < 10) then
                    line2(8*8+7 downto 8*8) <= to_byte('0'); 
                    line2(9*8+7 downto 9*8) <= number_to_char(min);
                else
                    line2(9*8+7 downto 8*8) <= To2CharArray(unsigned(min));
                end if;
                
                line2(10*8+7 downto 10*8) <= to_byte(':');
                
                -- Seconds
                if (unsigned(sec) < 10) then
                    line2(11*8+7 downto 11*8) <= to_byte('0'); 
                    line2(12*8+7 downto 12*8) <= number_to_char(sec);
                else
                    line2(12*8+7 downto 11*8) <= To2CharArray(unsigned(sec));
                end if;
                
                line2(13*8+7 downto 13*8) <= to_byte(' ');
                line2(14*8+7 downto 14*8) <= to_byte(' ');
                
                if (synchronize = '1') then
                    line2(15*8+7 downto 15*8) <= to_byte('D');
                    line2(16*8+7 downto 16*8) <= to_byte('C');
                    line2(17*8+7 downto 17*8) <= to_byte('F');
                else
                    for i in 15 to 17 loop
                    line2(i*8+7 downto i*8) <= to_byte(' ');
                end loop;
                end if;
                
                line2(18*8+7 downto 18*8) <= to_byte(' ');
                line2(19*8+7 downto 19*8) <= to_byte('S');
                
                
                line1(20*8+7 downto 20*8) <= to_byte('*');
                for i in 21 to 38 loop
                    line1(i*8+7 downto i*8) <= to_byte(' ');
                end loop;
                line1(39*8+7 downto 39*8) <= to_byte('*');
                
                for i in 20 to 39 loop
                    line2(i*8+7 downto i*8) <= to_byte(' ');
                end loop;
        
        
            -- Time & Date
            when "0000010" =>
                -- First Line
                for i in 0 to 6 loop
                    line1(i*8+7 downto i*8) <= to_byte(' ');
                end loop;
                
                line1(7 *8+7 downto 7 *8) <= to_byte('T');
                line1(8 *8+7 downto 8 *8) <= to_byte('I');
                line1(9 *8+7 downto 9 *8) <= to_byte('M');
                line1(10*8+7 downto 10*8) <= to_byte('E');
                line1(11*8+7 downto 11*8) <= to_byte(':');
                
                for i in 12 to 19 loop
                    line1(i*8+7 downto i*8) <= to_byte(' ');
                end loop;
                
                line2(0*8+7 downto 0*8) <= to_byte('A');
                
                for i in 1 to 4 loop
                    line2(i*8+7 downto i*8) <= to_byte(' ');
                end loop;
                
                -- Hour
                if (unsigned(hour) < 10) then
                    line2(5*8+7 downto 5*8) <= to_byte('0'); 
                    line2(6*8+7 downto 6*8) <= number_to_char(hour);
                else
                    line2(6*8+7 downto 5*8) <= To2CharArray(unsigned(hour));
                end if;
                    
                line2(7*8+7 downto 7*8) <= to_byte(':');
                
                -- Minutes
                if (unsigned(min) < 10) then
                    line2(8*8+7 downto 8*8) <= to_byte('0'); 
                    line2(9*8+7 downto 9*8) <= number_to_char(min);
                else
                    line2(9*8+7 downto 8*8) <= To2CharArray(unsigned(min));
                end if;
                
                line2(10*8+7 downto 10*8) <= to_byte(':');
                
                -- Seconds
                if (unsigned(sec) < 10) then
                    line2(11*8+7 downto 11*8) <= to_byte('0'); 
                    line2(12*8+7 downto 12*8) <= number_to_char(sec);
                else
                    line2(12*8+7 downto 11*8) <= To2CharArray(unsigned(sec));
                end if;
                
                line2(13*8+7 downto 13*8) <= to_byte(' ');
                line2(14*8+7 downto 14*8) <= to_byte(' ');
                
                if (synchronize = '1') then
                    line2(15*8+7 downto 15*8) <= to_byte('D');
                    line2(16*8+7 downto 16*8) <= to_byte('C');
                    line2(17*8+7 downto 17*8) <= to_byte('F');
                else
                    for i in 15 to 17 loop
                    line2(i*8+7 downto i*8) <= to_byte(' ');
                end loop;
                end if;
                
                line2(18*8+7 downto 18*8) <= to_byte(' ');
                line2(19*8+7 downto 19*8) <= to_byte('S');
                
                line1(20*8+7 downto 20*8) <= to_byte('*');
                line1(21*8+7 downto 21*8) <= to_byte(' ');
                line1(22*8+7 downto 22*8) <= to_byte(' ');
                line1(23*8+7 downto 23*8) <= to_byte(' ');
                line1(24*8+7 downto 24*8) <= to_byte(' ');
                line1(25*8+7 downto 25*8) <= to_byte(' ');
                line1(26*8+7 downto 26*8) <= to_byte(' ');
                line1(27*8+7 downto 27*8) <= to_byte('D');
                line1(28*8+7 downto 28*8) <= to_byte('A');
                line1(29*8+7 downto 29*8) <= to_byte('T');
                line1(30*8+7 downto 30*8) <= to_byte('E');
                line1(31*8+7 downto 31*8) <= to_byte(':');
                for i in 32 to 38 loop
                    line1(i*8+7 downto i*8) <= to_byte(' ');
                end loop;
                line1(39*8+7 downto 39*8) <= to_byte('*');
                
                
                for i in 20 to 23 loop
                    line2(i*8+7 downto i*8) <= to_byte(' ');
                end loop;
                
                
                --Day Of the Week
                case dow is
                    when "000" => 
                        line2(24*8+7 downto 24*8) <= to_byte('S');
                        line2(25*8+7 downto 25*8) <= to_byte('u');
                        line2(26*8+7 downto 26*8) <= to_byte('n');
                    when "001" => 
                        line2(24*8+7 downto 24*8) <= to_byte('M');
                        line2(25*8+7 downto 25*8) <= to_byte('o');
                        line2(26*8+7 downto 26*8) <= to_byte('n');
                    when "010" => 
                        line2(24*8+7 downto 24*8) <= to_byte('T');
                        line2(25*8+7 downto 25*8) <= to_byte('u');
                        line2(26*8+7 downto 26*8) <= to_byte('e');
                    when "011" => 
                        line2(24*8+7 downto 24*8) <= to_byte('W');
                        line2(25*8+7 downto 25*8) <= to_byte('e');
                        line2(26*8+7 downto 26*8) <= to_byte('d');
                    when "100" => 
                        line2(24*8+7 downto 24*8) <= to_byte('T');
                        line2(25*8+7 downto 25*8) <= to_byte('h');
                        line2(26*8+7 downto 26*8) <= to_byte('u');
                    when "101" => 
                        line2(24*8+7 downto 24*8) <= to_byte('F');
                        line2(25*8+7 downto 25*8) <= to_byte('r');
                        line2(26*8+7 downto 26*8) <= to_byte('i');
                    when "110" => 
                        line2(24*8+7 downto 24*8) <= to_byte('S');
                        line2(25*8+7 downto 25*8) <= to_byte('a');
                        line2(26*8+7 downto 26*8) <= to_byte('t');
                    when others => 
                        line2(24*8+7 downto 24*8) <= to_byte(' ');
                        line2(25*8+7 downto 25*8) <= to_byte(' ');
                        line2(26*8+7 downto 26*8) <= to_byte(' ');
                end case;


                
                
                line2(27*8+7 downto 27*8) <= to_byte(' ');
                
                -- Month
                if (unsigned(month) < 10) then
                    line2(28*8+7 downto 28*8) <= to_byte('0'); 
                    line2(29*8+7 downto 29*8) <= number_to_char(month);
                else
                    line2(29*8+7 downto 28*8) <= To2CharArray(unsigned(month));
                end if;
                
                line2(30*8+7 downto 30*8) <= to_byte('/');
                
                -- Day
                if (unsigned(day) < 10) then
                    line2(31*8+7 downto 31*8) <= to_byte('0'); 
                    line2(32*8+7 downto 32*8) <= number_to_char(day);
                else
                    line2(32*8+7 downto 31*8) <= To2CharArray(unsigned(day));
                end if;
                
                line2(33*8+7 downto 33*8) <= to_byte('/');
                
                -- Year
                line2(35*8+7 downto 34*8) <= To2CharArray(unsigned(year));
                
                for i in 36 to 39 loop
                    line2(i*8+7 downto i*8) <= to_byte(' ');
                end loop;                    
                
                
            -- Alarm
            when "0000100" =>
            
            -- First Line
                for i in 0 to 6 loop
                    line1(i*8+7 downto i*8) <= to_byte(' ');
                end loop;
                
                line1(7 *8+7 downto 7 *8) <= to_byte('T');
                line1(8 *8+7 downto 8 *8) <= to_byte('I');
                line1(9*8+7 downto 9*8) <= to_byte('M');
                line1(10*8+7 downto 10*8) <= to_byte('E');
                line1(11*8+7 downto 11*8) <= to_byte(':');
                
                for i in 12 to 19 loop
                    line1(i*8+7 downto i*8) <= to_byte(' ');
                end loop;
                
                line2(0*8+7 downto 0*8) <= to_byte('A');
                
                for i in 1 to 4 loop
                    line2(i*8+7 downto i*8) <= to_byte(' ');
                end loop;
                
                -- Hour
                if (unsigned(hour) < 10) then
                    line2(5*8+7 downto 5*8) <= to_byte('0'); 
                    line2(6*8+7 downto 6*8) <= number_to_char(hour);
                else
                    line2(6*8+7 downto 5*8) <= To2CharArray(unsigned(hour));
                end if;
                    
                line2(7*8+7 downto 7*8) <= to_byte(':');
                
                -- Minutes
                if (unsigned(min) < 10) then
                    line2(8*8+7 downto 8*8) <= to_byte('0'); 
                    line2(9*8+7 downto 9*8) <= number_to_char(min);
                else
                    line2(9*8+7 downto 8*8) <= To2CharArray(unsigned(min));
                end if;
                
                line2(10*8+7 downto 10*8) <= to_byte(':');
                
                -- Seconds
                if (unsigned(sec) < 10) then
                    line2(11*8+7 downto 11*8) <= to_byte('0'); 
                    line2(12*8+7 downto 12*8) <= number_to_char(sec);
                else
                    line2(12*8+7 downto 11*8) <= To2CharArray(unsigned(sec));
                end if;
                
                line2(13*8+7 downto 13*8) <= to_byte(' ');
                
                if (synchronize = '1') then
                    line2(14*8+7 downto 14*8) <= to_byte('D');
                    line2(15*8+7 downto 15*8) <= to_byte('C');
                    line2(16*8+7 downto 16*8) <= to_byte('F');
                else
                    for i in 14 to 16 loop
                    line2(i*8+7 downto i*8) <= to_byte(' ');
                end loop;
                end if;
                
                line2(17*8+7 downto 17*8) <= to_byte(' ');
                line2(18*8+7 downto 18*8) <= to_byte(' ');
                line2(19*8+7 downto 19*8) <= to_byte('S');
            
                line1(20*8+7 downto 20*8) <= to_byte('*');
                line1(21*8+7 downto 21*8) <= to_byte(' ');
                line1(22*8+7 downto 22*8) <= to_byte(' ');
                line1(23*8+7 downto 23*8) <= to_byte(' ');
                line1(24*8+7 downto 24*8) <= to_byte(' ');
                line1(25*8+7 downto 25*8) <= to_byte(' ');
                line1(26*8+7 downto 26*8) <= to_byte('A');
                line1(27*8+7 downto 27*8) <= to_byte('l');
                line1(28*8+7 downto 28*8) <= to_byte('a');
                line1(29*8+7 downto 29*8) <= to_byte('r');
                line1(30*8+7 downto 30*8) <= to_byte('m');
                line1(31*8+7 downto 31*8) <= to_byte(':');
                line1(32*8+7 downto 32*8) <= to_byte(' ');
                line1(33*8+7 downto 33*8) <= to_byte(' ');
                line1(34*8+7 downto 34*8) <= to_byte(' ');
                line1(35*8+7 downto 35*8) <= to_byte(' ');
                line1(36*8+7 downto 36*8) <= to_byte(' ');
                line1(37*8+7 downto 37*8) <= to_byte(' ');
                line1(38*8+7 downto 38*8) <= to_byte(' ');
                line1(39*8+7 downto 39*8) <= to_byte('*');
                
                line2(20*8+7 downto 20*8) <= to_byte(' ');
                line2(21*8+7 downto 21*8) <= to_byte(' ');
                line2(22*8+7 downto 22*8) <= to_byte(' ');
                line2(23*8+7 downto 23*8) <= to_byte(' ');
                line2(24*8+7 downto 24*8) <= to_byte(' ');
                line2(25*8+7 downto 25*8) <= to_byte(' ');
                line2(26*8+7 downto 26*8) <= to_byte('0');
                line2(27*8+7 downto 27*8) <= to_byte('6');
                line2(28*8+7 downto 28*8) <= to_byte(':');
                line2(29*8+7 downto 29*8) <= to_byte('0');
                line2(30*8+7 downto 30*8) <= to_byte('0');
                line2(31*8+7 downto 31*8) <= to_byte(' ');
                line2(32*8+7 downto 32*8) <= to_byte(' ');
                line2(33*8+7 downto 33*8) <= to_byte(' ');
                line2(34*8+7 downto 34*8) <= to_byte(' ');
                line2(35*8+7 downto 35*8) <= to_byte(' ');
                line2(36*8+7 downto 36*8) <= to_byte(' ');
                line2(37*8+7 downto 37*8) <= to_byte(' ');
            
            
            -- Time Switch On
            when "0001000" =>
            for i in 0 to 7 loop
                line1(i*8+7 downto i*8) <= to_byte(' ');
            end loop;
        
            line1(8*8+7 downto 8*8) <= to_byte('O');
            line1(9*8+7 downto 9*8) <= to_byte('n');
            line1(10*8+7 downto 10*8) <= to_byte(':');
            
            for i in 11 to 19 loop
                line1(i*8+7 downto i*8) <= to_byte(' ');
            end loop;
            
            line2(0*8+7 downto 0*8) <= to_byte('A');
            line2(1*8+7 downto 1*8) <= to_byte(' ');
            line2(2*8+7 downto 2*8) <= to_byte(' ');
            
            line2(3*8+7 downto 3*8) <= to_byte('*');
            line2(4*8+7 downto 4*8) <= to_byte(' ');

            
            line2(5*8+7 downto 5*8) <= to_byte('0');
            line2(6*8+7 downto 6*8) <= to_byte('8');
            line2(7*8+7 downto 7*8) <= to_byte(':');
            line2(8*8+7 downto 8*8) <= to_byte('1');
            line2(9*8+7 downto 9*8) <= to_byte('5');
            line2(10*8+7 downto 10*8) <= to_byte(':');
            line2(11*8+7 downto 11*8) <= to_byte('0');
            line2(12*8+7 downto 12*8) <= to_byte('0');
            line2(13*8+7 downto 13*8) <= to_byte(' ');
            line2(14*8+7 downto 14*8) <= to_byte(' ');
            if (synchronize = '1') then
                line2(15*8+7 downto 15*8) <= to_byte('D');
                line2(16*8+7 downto 16*8) <= to_byte('C');
                line2(17*8+7 downto 17*8) <= to_byte('F');
            else
                line2(15*8+7 downto 15*8) <= to_byte(' ');
                line2(16*8+7 downto 16*8) <= to_byte(' ');
                line2(17*8+7 downto 17*8) <= to_byte(' ');
            end if;
            line2(18*8+7 downto 18*8) <= to_byte(' ');
            line2(19*8+7 downto 19*8) <= to_byte('S');
            
            
            line1(20*8+7 downto 20*8) <= to_byte('*');
            line1(21*8+7 downto 21*8) <= to_byte(' ');
            line1(22*8+7 downto 22*8) <= to_byte(' ');
            line1(23*8+7 downto 23*8) <= to_byte(' ');
            line1(24*8+7 downto 24*8) <= to_byte(' ');
            line1(25*8+7 downto 25*8) <= to_byte(' ');
            line1(26*8+7 downto 26*8) <= to_byte(' ');
            line1(27*8+7 downto 27*8) <= to_byte(' ');
            line1(28*8+7 downto 28*8) <= to_byte('O');
            line1(29*8+7 downto 29*8) <= to_byte('f');
            line1(30*8+7 downto 30*8) <= to_byte('f');
            line1(31*8+7 downto 31*8) <= to_byte(':');
            line1(32*8+7 downto 32*8) <= to_byte(' ');
            line1(33*8+7 downto 33*8) <= to_byte(' ');
            line1(34*8+7 downto 34*8) <= to_byte(' ');
            line1(35*8+7 downto 35*8) <= to_byte(' ');
            line1(36*8+7 downto 36*8) <= to_byte(' ');
            line1(37*8+7 downto 37*8) <= to_byte(' ');
            line1(38*8+7 downto 38*8) <= to_byte(' ');
            line1(39*8+7 downto 39*8) <= to_byte('*');
            
            
            line2(20*8+7 downto 20*8) <= to_byte(' ');
            line2(21*8+7 downto 21*8) <= to_byte(' ');
            line2(22*8+7 downto 22*8) <= to_byte(' ');
            line2(23*8+7 downto 23*8) <= to_byte(' ');
            line2(24*8+7 downto 24*8) <= to_byte(' ');

            line2(25*8+7 downto 25*8) <= to_byte('1');
            line2(26*8+7 downto 26*8) <= to_byte('7');
            line2(27*8+7 downto 27*8) <= to_byte(':');
            line2(28*8+7 downto 28*8) <= to_byte('3');
            line2(29*8+7 downto 29*8) <= to_byte('0');
            line2(30*8+7 downto 30*8) <= to_byte(':');
            line2(31*8+7 downto 31*8) <= to_byte('0');
            line2(32*8+7 downto 32*8) <= to_byte('0');
            line2(33*8+7 downto 33*8) <= to_byte(' ');
            line2(34*8+7 downto 34*8) <= to_byte(' ');
            line2(35*8+7 downto 35*8) <= to_byte(' ');
            line2(36*8+7 downto 36*8) <= to_byte(' ');
            line2(37*8+7 downto 37*8) <= to_byte(' ');
            line2(38*8+7 downto 38*8) <= to_byte(' ');
            line2(39*8+7 downto 39*8) <= to_byte(' ');
            
            -- Time Switch Off
            when "0010000" =>
            for i in 0 to 7 loop
                line1(i*8+7 downto i*8) <= to_byte(' ');
            end loop;
        
            line1(8*8+7 downto 8*8) <= to_byte('O');
            line1(9*8+7 downto 9*8) <= to_byte('n');
            line1(10*8+7 downto 10*8) <= to_byte(':');
            
            for i in 11 to 19 loop
                line1(i*8+7 downto i*8) <= to_byte(' ');
            end loop;
            
            line2(0*8+7 downto 0*8) <= to_byte('A');
            line2(1*8+7 downto 1*8) <= to_byte(' ');
            line2(2*8+7 downto 2*8) <= to_byte(' ');
            
            line2(3*8+7 downto 3*8) <= to_byte(' ');
            line2(4*8+7 downto 4*8) <= to_byte(' ');

            
            line2(5*8+7 downto 5*8) <= to_byte('0');
            line2(6*8+7 downto 6*8) <= to_byte('8');
            line2(7*8+7 downto 7*8) <= to_byte(':');
            line2(8*8+7 downto 8*8) <= to_byte('1');
            line2(9*8+7 downto 9*8) <= to_byte('5');
            line2(10*8+7 downto 10*8) <= to_byte(':');
            line2(11*8+7 downto 11*8) <= to_byte('0');
            line2(12*8+7 downto 12*8) <= to_byte('0');
            line2(13*8+7 downto 13*8) <= to_byte(' ');
            line2(14*8+7 downto 14*8) <= to_byte(' ');
            if (synchronize = '1') then
                line2(15*8+7 downto 15*8) <= to_byte('D');
                line2(16*8+7 downto 16*8) <= to_byte('C');
                line2(17*8+7 downto 17*8) <= to_byte('F');
            else
                line2(15*8+7 downto 15*8) <= to_byte(' ');
                line2(16*8+7 downto 16*8) <= to_byte(' ');
                line2(17*8+7 downto 17*8) <= to_byte(' ');
            end if;
            line2(18*8+7 downto 18*8) <= to_byte(' ');
            line2(19*8+7 downto 19*8) <= to_byte('S');
            
            
            line1(20*8+7 downto 20*8) <= to_byte('*');
            line1(21*8+7 downto 21*8) <= to_byte(' ');
            line1(22*8+7 downto 22*8) <= to_byte(' ');
            line1(23*8+7 downto 23*8) <= to_byte(' ');
            line1(24*8+7 downto 24*8) <= to_byte(' ');
            line1(25*8+7 downto 25*8) <= to_byte(' ');
            line1(26*8+7 downto 26*8) <= to_byte(' ');
            line1(27*8+7 downto 27*8) <= to_byte(' ');
            line1(28*8+7 downto 28*8) <= to_byte('O');
            line1(29*8+7 downto 29*8) <= to_byte('f');
            line1(30*8+7 downto 30*8) <= to_byte('f');
            line1(31*8+7 downto 31*8) <= to_byte(':');
            line1(32*8+7 downto 32*8) <= to_byte(' ');
            line1(33*8+7 downto 33*8) <= to_byte(' ');
            line1(34*8+7 downto 34*8) <= to_byte(' ');
            line1(35*8+7 downto 35*8) <= to_byte(' ');
            line1(36*8+7 downto 36*8) <= to_byte(' ');
            line1(37*8+7 downto 37*8) <= to_byte(' ');
            line1(38*8+7 downto 38*8) <= to_byte(' ');
            line1(39*8+7 downto 39*8) <= to_byte('*');
            
            
            line2(20*8+7 downto 20*8) <= to_byte(' ');
            line2(21*8+7 downto 21*8) <= to_byte(' ');
            line2(22*8+7 downto 22*8) <= to_byte(' ');
            line2(23*8+7 downto 23*8) <= to_byte(' ');
            line2(24*8+7 downto 24*8) <= to_byte('*');

            line2(25*8+7 downto 25*8) <= to_byte('1');
            line2(26*8+7 downto 26*8) <= to_byte('7');
            line2(27*8+7 downto 27*8) <= to_byte(':');
            line2(28*8+7 downto 28*8) <= to_byte('3');
            line2(29*8+7 downto 29*8) <= to_byte('0');
            line2(30*8+7 downto 30*8) <= to_byte(':');
            line2(31*8+7 downto 31*8) <= to_byte('0');
            line2(32*8+7 downto 32*8) <= to_byte('0');
            line2(33*8+7 downto 33*8) <= to_byte(' ');
            line2(34*8+7 downto 34*8) <= to_byte(' ');
            line2(35*8+7 downto 35*8) <= to_byte(' ');
            line2(36*8+7 downto 36*8) <= to_byte(' ');
            line2(37*8+7 downto 37*8) <= to_byte(' ');
            line2(38*8+7 downto 38*8) <= to_byte(' ');
            line2(39*8+7 downto 39*8) <= to_byte(' ');
            
            -- Timer
            when "0100000" =>
                -- First Line
                for i in 0 to 6 loop
                    line1(i*8+7 downto i*8) <= to_byte(' ');
                end loop;
                
                line1(7 *8+7 downto 7 *8) <= to_byte('T');
                line1(8 *8+7 downto 8 *8) <= to_byte('I');
                line1(9*8+7 downto 9*8) <= to_byte('M');
                line1(10*8+7 downto 10*8) <= to_byte('E');
                line1(11*8+7 downto 11*8) <= to_byte(':');
                
                for i in 12 to 19 loop
                    line1(i*8+7 downto i*8) <= to_byte(' ');
                end loop;
                
                line2(0*8+7 downto 0*8) <= to_byte('A');
                
                for i in 1 to 4 loop
                    line2(i*8+7 downto i*8) <= to_byte(' ');
                end loop;
                
                -- Hour
                if (unsigned(hour) < 10) then
                    line2(5*8+7 downto 5*8) <= to_byte('0'); 
                    line2(6*8+7 downto 6*8) <= number_to_char(hour);
                else
                    line2(6*8+7 downto 5*8) <= To2CharArray(unsigned(hour));
                end if;
                    
                line2(7*8+7 downto 7*8) <= to_byte(':');
                
                -- Minutes
                if (unsigned(min) < 10) then
                    line2(8*8+7 downto 8*8) <= to_byte('0'); 
                    line2(9*8+7 downto 9*8) <= number_to_char(min);
                else
                    line2(9*8+7 downto 8*8) <= To2CharArray(unsigned(min));
                end if;
                
                line2(10*8+7 downto 10*8) <= to_byte(':');
                
                -- Seconds
                if (unsigned(sec) < 10) then
                    line2(11*8+7 downto 11*8) <= to_byte('0'); 
                    line2(12*8+7 downto 12*8) <= number_to_char(sec);
                else
                    line2(12*8+7 downto 11*8) <= To2CharArray(unsigned(sec));
                end if;
                
                line2(13*8+7 downto 13*8) <= to_byte(' ');
                
                if (synchronize = '1') then
                    line2(14*8+7 downto 14*8) <= to_byte('D');
                    line2(15*8+7 downto 15*8) <= to_byte('C');
                    line2(16*8+7 downto 16*8) <= to_byte('F');
                else
                    for i in 14 to 16 loop
                    line2(i*8+7 downto i*8) <= to_byte(' ');
                end loop;
                end if;
                
                line2(17*8+7 downto 17*8) <= to_byte(' ');
                line2(18*8+7 downto 18*8) <= to_byte(' ');
                line2(19*8+7 downto 19*8) <= to_byte('S');
            
                line1(20*8+7 downto 20*8) <= to_byte('*');
                line1(21*8+7 downto 21*8) <= to_byte(' ');
                line1(22*8+7 downto 22*8) <= to_byte(' ');
                line1(23*8+7 downto 23*8) <= to_byte(' ');
                line1(24*8+7 downto 24*8) <= to_byte(' ');
                line1(25*8+7 downto 25*8) <= to_byte(' ');
                line1(26*8+7 downto 26*8) <= to_byte('T');
                line1(27*8+7 downto 27*8) <= to_byte('i');
                line1(28*8+7 downto 28*8) <= to_byte('m');
                line1(29*8+7 downto 29*8) <= to_byte('e');
                line1(30*8+7 downto 30*8) <= to_byte('r');
                line1(31*8+7 downto 31*8) <= to_byte(':');
                line1(32*8+7 downto 32*8) <= to_byte(' ');
                line1(33*8+7 downto 33*8) <= to_byte(' ');
                line1(34*8+7 downto 34*8) <= to_byte(' ');
                line1(35*8+7 downto 35*8) <= to_byte(' ');
                line1(36*8+7 downto 36*8) <= to_byte(' ');
                line1(37*8+7 downto 37*8) <= to_byte(' ');
                line1(38*8+7 downto 38*8) <= to_byte(' ');
                line1(39*8+7 downto 39*8) <= to_byte('*');
                
                line2(20*8+7 downto 20*8) <= to_byte(' ');
                line2(21*8+7 downto 21*8) <= to_byte(' ');
                line2(22*8+7 downto 22*8) <= to_byte(' ');
                line2(23*8+7 downto 23*8) <= to_byte(' ');
                line2(24*8+7 downto 24*8) <= to_byte(' ');
                line2(25*8+7 downto 25*8) <= to_byte('0');
                line2(26*8+7 downto 26*8) <= to_byte('1');
                line2(27*8+7 downto 27*8) <= to_byte(':');
                line2(28*8+7 downto 28*8) <= to_byte('1');
                line2(29*8+7 downto 29*8) <= to_byte('5');
                line2(30*8+7 downto 30*8) <= to_byte(':');
                line2(31*8+7 downto 31*8) <= to_byte('0');
                line2(32*8+7 downto 32*8) <= to_byte('0');
                line2(33*8+7 downto 33*8) <= to_byte(' ');
                line2(34*8+7 downto 34*8) <= to_byte('O');
                line2(35*8+7 downto 35*8) <= to_byte('f');
                line2(36*8+7 downto 36*8) <= to_byte('f');
                line2(37*8+7 downto 37*8) <= to_byte(' ');
                line2(38*8+7 downto 38*8) <= to_byte(' ');
                line2(39*8+7 downto 39*8) <= to_byte(' ');
            
             -- Stopwatch    
            when "1000000" =>
            -- First Line
                for i in 0 to 6 loop
                    line1(i*8+7 downto i*8) <= to_byte(' ');
                end loop;
                
                line1(7 *8+7 downto 7 *8) <= to_byte('T');
                line1(8 *8+7 downto 8 *8) <= to_byte('I');
                line1(9*8+7 downto 9*8) <= to_byte('M');
                line1(10*8+7 downto 10*8) <= to_byte('E');
                line1(11*8+7 downto 11*8) <= to_byte(':');
                
                for i in 12 to 19 loop
                    line1(i*8+7 downto i*8) <= to_byte(' ');
                end loop;
                
                line2(0*8+7 downto 0*8) <= to_byte('A');
                
                for i in 1 to 4 loop
                    line2(i*8+7 downto i*8) <= to_byte(' ');
                end loop;
                
                -- Hour
                if (unsigned(hour) < 10) then
                    line2(5*8+7 downto 5*8) <= to_byte('0'); 
                    line2(6*8+7 downto 6*8) <= number_to_char(hour);
                else
                    line2(6*8+7 downto 5*8) <= To2CharArray(unsigned(hour));
                end if;
                    
                line2(7*8+7 downto 7*8) <= to_byte(':');
                
                -- Minutes
                if (unsigned(min) < 10) then
                    line2(8*8+7 downto 8*8) <= to_byte('0'); 
                    line2(9*8+7 downto 9*8) <= number_to_char(min);
                else
                    line2(9*8+7 downto 8*8) <= To2CharArray(unsigned(min));
                end if;
                
                line2(10*8+7 downto 10*8) <= to_byte(':');
                
                -- Seconds
                if (unsigned(sec) < 10) then
                    line2(11*8+7 downto 11*8) <= to_byte('0'); 
                    line2(12*8+7 downto 12*8) <= number_to_char(sec);
                else
                    line2(12*8+7 downto 11*8) <= To2CharArray(unsigned(sec));
                end if;
                
                line2(13*8+7 downto 13*8) <= to_byte(' ');
                
                if (synchronize = '1') then
                    line2(14*8+7 downto 14*8) <= to_byte('D');
                    line2(15*8+7 downto 15*8) <= to_byte('C');
                    line2(16*8+7 downto 16*8) <= to_byte('F');
                else
                    for i in 14 to 16 loop
                    line2(i*8+7 downto i*8) <= to_byte(' ');
                end loop;
                end if;
                
                line2(17*8+7 downto 17*8) <= to_byte(' ');
                line2(18*8+7 downto 18*8) <= to_byte(' ');
                line2(19*8+7 downto 19*8) <= to_byte('S');
                
                line1(20*8+7 downto 20*8) <= to_byte('*');
                line1(21*8+7 downto 21*8) <= to_byte(' ');
                line1(22*8+7 downto 22*8) <= to_byte(' ');
                line1(23*8+7 downto 23*8) <= to_byte('S');
                line1(24*8+7 downto 24*8) <= to_byte('t');
                line1(25*8+7 downto 25*8) <= to_byte('o');
                line1(26*8+7 downto 26*8) <= to_byte('p');
                line1(27*8+7 downto 27*8) <= to_byte(' ');
                line1(28*8+7 downto 28*8) <= to_byte('W');
                line1(29*8+7 downto 29*8) <= to_byte('a');
                line1(30*8+7 downto 30*8) <= to_byte('t');
                line1(31*8+7 downto 31*8) <= to_byte('c');
                line1(32*8+7 downto 32*8) <= to_byte('h');
                line1(33*8+7 downto 33*8) <= to_byte(':');
                line1(34*8+7 downto 34*8) <= to_byte(' ');
                line1(35*8+7 downto 35*8) <= to_byte(' ');
                line1(36*8+7 downto 36*8) <= to_byte(' ');
                line1(37*8+7 downto 37*8) <= to_byte(' ');
                line1(38*8+7 downto 38*8) <= to_byte(' ');
                line1(39*8+7 downto 39*8) <= to_byte('*');
                
                line2(20*8+7 downto 20*8) <= to_byte('L');
                line2(21*8+7 downto 21*8) <= to_byte('a');
                line2(22*8+7 downto 22*8) <= to_byte('p');
                line2(23*8+7 downto 23*8) <= to_byte(' ');
                line2(24*8+7 downto 24*8) <= to_byte('0');
                line2(25*8+7 downto 25*8) <= to_byte('0');
                line2(26*8+7 downto 26*8) <= to_byte(':');
                line2(27*8+7 downto 27*8) <= to_byte('0');
                line2(28*8+7 downto 28*8) <= to_byte('1');
                line2(29*8+7 downto 29*8) <= to_byte(':');
                line2(30*8+7 downto 30*8) <= to_byte('5');
                line2(31*8+7 downto 31*8) <= to_byte('8');
                line2(32*8+7 downto 32*8) <= to_byte('.');
                line2(33*8+7 downto 33*8) <= to_byte('9');
                line2(34*8+7 downto 34*8) <= to_byte('3');
                line2(35*8+7 downto 35*8) <= to_byte(' ');
                line2(36*8+7 downto 36*8) <= to_byte(' ');
                line2(37*8+7 downto 37*8) <= to_byte(' ');
                line2(38*8+7 downto 38*8) <= to_byte(' ');
                line2(39*8+7 downto 39*8) <= to_byte(' ');
                
                
            when others =>
                null;
                
        end case; 
    
    end if;    
        
    end process;


end Behavioral;
