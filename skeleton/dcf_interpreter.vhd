----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/25/2023 11:50:54 AM
-- Design Name: 
-- Module Name: dcf_interpreter - Behavioral
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

entity dcf_interpreter is
  Port (   
           clk : in STD_LOGIC;
           
           de_set : in STD_LOGIC;
           de_dow : in  STD_LOGIC_VECTOR (2 downto 0);
           de_day : in  STD_LOGIC_VECTOR (5 downto 0);
           de_month : in  STD_LOGIC_VECTOR (4 downto 0);
           de_year : in  STD_LOGIC_VECTOR (7 downto 0);
           de_hour : in  STD_LOGIC_VECTOR (5 downto 0);
           de_min : in  STD_LOGIC_VECTOR (6 downto 0);
           
           s_dow : out  STD_LOGIC_VECTOR (2 downto 0);
           s_day : out  STD_LOGIC_VECTOR   (5 downto 0);
           s_month : out  STD_LOGIC_VECTOR (4 downto 0);
           s_year : out  STD_LOGIC_VECTOR  (7 downto 0);
           s_hour : out  STD_LOGIC_VECTOR  (5 downto 0);
           s_min : out  STD_LOGIC_VECTOR   (6 downto 0)
        );
end dcf_interpreter;

architecture Behavioral of dcf_interpreter is
        
        signal dcf_dow : std_logic_vector(2 downto 0);
        signal dcf_day : std_logic_vector(7 downto 0);
        signal dcf_month : std_logic_vector(7 downto 0);
        signal dcf_year : std_logic_vector(7 downto 0);
        signal dcf_hour : std_logic_vector(7 downto 0);
        signal dcf_min : std_logic_vector(7 downto 0);

        signal day_temp : std_logic_vector(7 downto 0);
        signal month_temp : std_logic_vector(7 downto 0);
        signal year_temp : std_logic_vector(7 downto 0);
        signal hour_temp : std_logic_vector(7 downto 0);
        signal min_temp : std_logic_vector(7 downto 0);
        
        signal valid : STD_LOGIC := '0';
        
        
        function to_binary ( bcd : unsigned(7 downto 0) ) return unsigned is
        variable i : integer:=0;
        variable binary : unsigned(7 downto 0) := (others => '0');  
        variable temp : unsigned(6 downto 0) := (others => '0');
        variable bcdt : unsigned(7 downto 0) := bcd;   
        variable tens : unsigned(7 downto 0) := (others => '0');

       begin

         for i in 0 to 7 loop  -- repeating 12 times.

         if(i >=0 and i<4) then
            binary := ((temp&bcdt(i) ) sll i ) + binary;
         end if;         

         if(i >=4 and i<8) then         
            tens := (((temp&bcdt(i) ) sll (i-4) ) sll 3) + (((temp&bcdt(i) ) sll (i-4) ) sll 1); --multiply by 10           
            binary := tens + binary;
         end if;         

         end loop;     

       return binary;
    end to_binary;

begin   
        process(clk, de_set, de_dow, de_day, de_month, de_year, de_hour, de_min) is
        begin
            if rising_edge(clk) then
                if (de_set='1') then
                    dcf_dow <= de_dow;
                    dcf_day <= "00" & de_day;
                    dcf_month <= "000" & de_month;
                    dcf_year <= de_year;
                    dcf_hour <= "00" & de_hour;
                    dcf_min <= "0" & de_min;
                    valid <= '1';
                else
                    valid <= '0';
                end if;
            end if;
        
        end process;


--        s_day <= std_logic_vector(to_unsigned(day_temp, s_day'length));
--        s_month <= std_logic_vector(to_unsigned(month_temp, s_month'length));
--        s_year <= std_logic_vector(to_unsigned(year_temp, s_year'length));
--        s_hour <= std_logic_vector(to_unsigned(hour_temp, s_hour'length));
--        s_min <= std_logic_vector(to_unsigned(min_temp, s_min'length));

        s_day   <= day_temp   (5 downto 0); 
        s_month <= month_temp (4 downto 0);
        s_year  <= year_temp  (7 downto 0);
        s_hour  <= hour_temp  (5 downto 0);
        s_min   <= min_temp   (6 downto 0); 
        
        -- DOW
        s_dow <= dcf_dow;
        
        
        process(clk) is
        begin
            if rising_edge(clk) then
                day_temp <= std_logic_vector(to_binary(unsigned(dcf_day)));
                month_temp <= std_logic_vector(to_binary(unsigned(dcf_month)));
                year_temp <= std_logic_vector(to_binary(unsigned(dcf_year)));
                hour_temp <= std_logic_vector(to_binary(unsigned(dcf_hour)));
                min_temp <= std_logic_vector(to_binary(unsigned(dcf_min)));
            end if;
        end process;
--        -- day
--        process(clk, dcf_day, valid) is
--        begin
--            if rising_edge(clk) and valid = '1'then
                
--                    for i in -1 to (dcf_day'length-1) loop
--                        if i=-1 then
--                            day_temp <= 0;  -- Initialize the sum to zero
--                        elsif dcf_day(i) = '1' and i>-1 then
--                            case i is
--                                when 0 =>
--                                    day_temp <= day_temp + 1;
--                                when 1 =>
--                                    day_temp <= day_temp + 2;
--                                when 2 =>
--                                    day_temp <= day_temp + 4;
--                                when 3 =>
--                                    day_temp <= day_temp + 8;
--                                when 4 =>
--                                    day_temp <= day_temp + 10;
--                                when 5 =>
--                                    day_temp <= day_temp + 20;
--                                when others =>
--                                    null;
--                            end case;
--                        end if;
--                    end loop;
--            end if;
--        end process;
        
--        -- month
--        process(clk, dcf_month, valid) is
--        begin
--            if rising_edge(clk) and valid = '1' then
                
--                    for i in -1 to (dcf_month'length-1) loop
--                        if i=-1 then
--                            month_temp <= 0;  -- Initialize the sum to zero
                    
--                        elsif dcf_month(i) = '1' and i>-1 then
--                            case i is
--                                when 0 =>
--                                    month_temp <= month_temp + 1;
--                                when 1 =>
--                                    month_temp <= month_temp + 2;
--                                when 2 =>
--                                    month_temp <= month_temp + 4;
--                                when 3 =>
--                                    month_temp <= month_temp + 8;
--                                when 4 =>
--                                    month_temp <= month_temp + 10;
--                                when others =>
--                                    null;
--                            end case;
--                        end if;
--                    end loop;
--            end if;
--        end process;
        
--        -- year
--        process(clk, dcf_year, valid) is
--        begin
--            if rising_edge(clk) and valid = '1' then
--                for i in -1 to (dcf_year'length-1) loop
--                        if i=-1 then
--                            year_temp <= 0;  -- Initialize the sum to zero
                    
--                        elsif dcf_year(i) = '1' and i>-1 then
--                            case i is
--                                when 0 =>
--                                    year_temp <= year_temp + 1;
--                                when 1 =>
--                                    year_temp <= year_temp + 2;
--                                when 2 =>
--                                    year_temp <= year_temp + 4;
--                                when 3 =>
--                                    year_temp <= year_temp + 8;
--                                when 4 =>
--                                    year_temp <= year_temp + 10;
--                                when 5 =>
--                                    year_temp <= year_temp + 20;
--                                when 6 =>
--                                    year_temp <= year_temp + 40;
--                                when 7 =>
--                                    year_temp <= year_temp + 80;
--                                when others =>
--                                    null;
--                            end case;
--                        end if;
--                    end loop;
--             end if;
--        end process;
        
--        -- hour
--        process(clk, dcf_hour, valid) is
--        begin
--            if rising_edge(clk) and valid = '1' then
--                for i in -1 to (dcf_hour'length-1) loop
--                        if i=-1 then
--                            hour_temp <= 0;  -- Initialize the sum to zero
                    
--                        elsif dcf_hour(i) = '1' and i>-1 then
--                            case i is
--                                when 0 =>
--                                    hour_temp <= hour_temp + 1;
--                                when 1 =>
--                                    hour_temp <= hour_temp + 2;
--                                when 2 =>
--                                    hour_temp <= hour_temp + 4;
--                                when 3 =>
--                                    hour_temp <= hour_temp + 8;
--                                when 4 =>
--                                    hour_temp <= hour_temp + 10;
--                                when 5 =>
--                                    hour_temp <= hour_temp + 20;
--                                when others =>
--                                    null;
--                            end case;
--                        end if;
--                    end loop;
--            end if;
--        end process;
        
--        -- min
--        process(clk, dcf_min, valid) is
--        begin
--            if rising_edge(clk) and valid = '1' then
--                    for i in -1 to (dcf_min'length-1) loop
--                        if i=-1 then
--                            min_temp <= 0;  -- Initialize the sum to zero
                    
--                        elsif dcf_min(i) = '1' and i>-1 then
--                            case i is
--                                when 0 =>
--                                    min_temp <= min_temp + 1;
--                                when 1 =>
--                                    min_temp <= min_temp + 2;
--                                when 2 =>
--                                    min_temp <= min_temp + 4;
--                                when 3 =>
--                                    min_temp <= min_temp + 8;
--                                when 4 =>
--                                    min_temp <= min_temp + 10;
--                                when 5 =>
--                                    min_temp <= min_temp + 20;
--                                when 6 =>
--                                    min_temp <= min_temp + 40;
--                                when others =>
--                                    null;
--                            end case;
--                        end if;
--                    end loop;
--            end if;
--        end process;


    


end Behavioral;
