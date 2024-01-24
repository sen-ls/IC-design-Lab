----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/03/2023 03:39:17 PM
-- Design Name: 
-- Module Name: time_date - Behavioral
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
--use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity time_date is
    Port ( 
    
           clk : in  std_logic;
           reset : in  std_logic;          
           en_1 : in  std_logic;
    
    
           s_dow : in STD_LOGIC_VECTOR (2 downto 0);
           s_day : in STD_LOGIC_VECTOR (5 downto 0);
           s_hour : in STD_LOGIC_VECTOR (5 downto 0);
           s_min : in STD_LOGIC_VECTOR (6 downto 0);
           s_month : in STD_LOGIC_VECTOR (4 downto 0);
           s_year : in STD_LOGIC_VECTOR (7 downto 0);
           
           
           SYN : in std_logic;
           
           
           td_dow : out STD_LOGIC_VECTOR (2 downto 0);
           td_day : out STD_LOGIC_VECTOR (5 downto 0);
           td_hour : out STD_LOGIC_VECTOR (5 downto 0);
           td_min : out STD_LOGIC_VECTOR (6 downto 0);
           td_sec : out STD_LOGIC_VECTOR (6 downto 0);
           td_year : out STD_LOGIC_VECTOR (7 downto 0);
           td_month: out STD_LOGIC_VECTOR (4 downto 0));
           
           
           
           
end time_date;

architecture Behavioral of time_date is
    -- Impulse of respectively a min,hour,day,month,year .... 
    signal sec_1: STD_LOGIC:='0';
    signal min_1: STD_LOGIC:='0';
    signal hour_1: STD_LOGIC:='0';
    signal day_1: STD_LOGIC:='0';
    signal month_1: STD_LOGIC:='0';
    
    
    -- if the year is a leap year
    signal year_r: STD_LOGIC:='0';
    
     constant sec_ref:  integer:= 0  ;
     constant min_ref:  integer:= 0  ;
     constant hour_ref: integer:= 0  ;
     constant day_ref:  integer:= 1  ;
     constant dow_ref:  integer:= 1   ;
     constant month_ref:integer:= 1   ;
     constant year_ref: integer:= 1   ;

     signal sec:   integer:= sec_ref  ;
     signal min:   integer:= min_ref  ;
     signal hour:  integer:= hour_ref  ;
     signal day:   integer:= day_ref  ;
     signal dow:   integer:= dow_ref   ;
     signal month: integer:= month_ref   ;
     signal year:  integer:= year_ref   ;
     
       
     
--    signal sec_L: STD_LOGIC;
--    signal min_L: STD_LOGIC;
--    signal hour_L: STD_LOGIC;
--    signal day_L: STD_LOGIC;
--    signal month_L: STD_LOGIC;

begin

--    changes: process(clk, sec_1, min_1, hour_1, day_1, month_1) is
--    begin
--        if rising_edge(clk) then
--            if reset='1' then
--                sec_L <= '0';
--                min_L <= '0';
--                hour_L <= '0';
--                day_L <= '0';
--                month_L <= '0';
--            else
--                -- Seconds
--                if rising_edge(sec_1) then
--                    sec_1 <= '0';
--                end if;
                
--                -- Minutes
--                if rising_edge(min_1) then
--                    min_1 <= '0';
--                end if;
                
--                -- Hours
--                if rising_edge(hour_1) then
--                    hour_1 <= '0';
--                end if;
                
--                -- Days
--                if rising_edge(day_1) then
--                    day_1 <= '0';
--                end if;
                
--                -- Months
--                if rising_edge(month_1) then
--                    month_1 <= '0';
--                end if;
--            end if;
--        end if;
--    end process;
    
    seconds: process(clk,en_1,SYN,reset,sec) is
        
    begin
        --if rising_edge(clk) then
            if (reset = '1') then
                sec <= sec_ref;
            else
                if SYN = '1' then
                    sec <= 0;
                elsif rising_edge(en_1) then
                    if (sec<59) then
                        sec_1 <= '0';  
                        sec <= sec+1;
                    else
                        sec <= 0;
                        sec_1 <= '1';
                    end if;
                end if;
            end if;
        --end if;
     end process;
     td_sec <= std_logic_vector(to_unsigned(sec, td_sec'length));
      
     
        minutes: process(clk,sec_1,SYN,reset,min,s_min) is
     
        begin
            --if rising_edge(clk) then
                if (reset = '1') then
                    min <= min_ref;
                    
                else
                    if SYN = '1' then
                        min <= to_integer(unsigned(s_min));
                    
                    elsif rising_edge(sec_1) then
                        if(min >= 59) then
                            min <= 0;
                            min_1 <= '1'; 
                        else
                            min_1 <= '0';
                            min <= min+1;        
                        end if;    
                    end if; 
                end if;
            --end if;
        end process;
          
        td_min <= std_logic_vector(to_unsigned(min, td_min'length));
          
          
        hours: process(clk,min_1,SYN,reset,hour,s_hour) is
        begin
            --if rising_edge(clk) then
                if (reset = '1') then
                    hour <= hour_ref;
                else
                    if SYN = '1' then
                        hour <= to_integer(unsigned(s_hour));
                        
                    elsif rising_edge(min_1) then
                        if(hour > 22) then
                            hour <= 0;
                            hour_1 <= '1'; 
                        else
                            hour_1 <= '0'; 
                            hour <= hour+1;
                        end if;  
                    end if;
                end if;
            --end if;
          end process;
          td_hour <= std_logic_vector(to_unsigned(hour, td_hour'length));
          
          days: process(clk,hour_1,SYN,reset,day,month,s_day,year_r) is
         
         begin
            --if rising_edge(clk) then
                if (reset = '1') then
                    day <= day_ref;
                else
                    if SYN = '1'then
                        day <= to_integer(unsigned(s_day));                                       
                    elsif rising_edge(hour_1)  then                                                         
                        if ((month=1 or month=3 or month=5 or month=7 or month=8 or month=10 or month=12) and  day>30) then
                            day <= 1;
                            day_1 <= '1';                     
                        elsif month /= 2 and day > 29 then
                            day <= 1;
                            day_1 <= '1';
                        
                        elsif month=2 and year_r = '1' and day > 28 then
                            day <=1;
                            day_1 <= '1';
                            
                        elsif month=2 and year_r = '0' and day>27 then
                            day<=1;
                            day_1 <='1';
                        
                        else
                            day_1 <= '0';
                            day <= day+1;  
                        end if;
                    end if;
                end if;
            --end if;
          
          end process;
          td_day <= std_logic_vector(to_unsigned(day,td_day'length));
          --day_1 <= day_1;
          
          dows: process(clk,hour_1,reset,SYN,dow,s_dow) is
          
            begin
                --if rising_edge(clk) then
                    if (reset = '1') then
                        dow<=dow_ref;
                    else
                        if SYN = '1' then
                            dow <= to_integer(unsigned(s_dow));
                            
                        elsif rising_edge(hour_1)  then
                            if dow >= 6 then
                                dow <= 0;
                            else
                                dow <= dow+1;
                            end if;
                        end if;
                    end if;
                --end if;
          end process;
          
          td_dow <= std_logic_vector(to_unsigned(dow,td_dow'length));
          
          
          months: process(clk,day_1,reset,SYN,month,s_month) is
          
          begin
            --if rising_edge(clk) then
                if (reset = '1') then
                    month<=month_ref;
                else    
                    if SYN = '1' then
                        month <= to_integer(unsigned(s_month));
                    elsif rising_edge(day_1) then
                   
                        if month > 11 then
                            month <= 1;
                            month_1 <= '1';
                        else
                            month_1 <= '0';
                            month <= month+1;
                        end if;
                     end if;
                --end if;
            end if;
                
          end process;
          
          td_month <= std_logic_vector(to_unsigned(month,td_month'length));
          
          years: process (clk,month_1,SYN,reset,year,s_year) is
          
            begin
                --if rising_edge(clk) then
                    if (reset = '1') then
                        year <= year_ref;
                    else
                        if SYN = '1' then
                            year <= to_integer(unsigned(s_year));
                        
                        elsif rising_edge(month_1) then
                            year <= year +1;
                        end if;
                    end if;    
                --end if;     
          end process;
          
          --year <= year;
          td_year <= std_logic_vector(to_unsigned(year,td_year'length));
          
          
          
          
          
          leap_years: process (clk,year) is
          
            begin
                if rising_edge(clk) then
                        if ((year+2000) mod 4) = 0 and ((year+2000) mod 100) /= 0 then
                            year_r <= '1'; 
                        elsif ((year+2000) mod 400) = 0 then
                            year_r <= '1';
                        else
                            year_r <= '0';
                        end if; 
                end if;
          end process;
            

end Behavioral;
