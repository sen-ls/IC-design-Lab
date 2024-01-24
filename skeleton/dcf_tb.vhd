----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/25/2023 11:10:39 AM
-- Design Name: 
-- Module Name: dcf_tb - tb
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dcf_tb is
--  Port ( );
end dcf_tb;

architecture tb of dcf_tb is
       signal clk          :  STD_LOGIC := '0';
       signal en_100        :  STD_LOGIC := '1';
       signal en_10         :  STD_LOGIC := '1';
       signal en_1         :  STD_LOGIC := '1';
       signal reset        :  STD_LOGIC;
       
       constant T : time := 1ps;
       
       
       signal dcf :  STD_LOGIC;
       signal de_set :   STD_LOGIC;
       signal de_dow :   STD_LOGIC_VECTOR (2 downto 0);
       signal de_day :   STD_LOGIC_VECTOR (5 downto 0);
       signal de_month :   STD_LOGIC_VECTOR (4 downto 0);
       signal de_year :   STD_LOGIC_VECTOR (7 downto 0);
       signal de_hour :   STD_LOGIC_VECTOR (5 downto 0);
       signal de_min :   STD_LOGIC_VECTOR (6 downto 0);
begin

    --Clock generation
    process is
    begin
        wait for T;
        clk <= NOT(clk);
    end process;
    
    --en_100 generation
    process is
    begin
            en_100 <= NOT(en_100);
        wait for 9*T;
            en_100 <= NOT(en_100);
        wait for T;
         
    end process;
    
    --en_10 generation
    process is
    begin
            en_10 <= NOT(en_10);
        wait for 90*T;
            en_10 <= NOT(en_10);
        wait for T;
         
    end process;
    
    --en_1 generation
    process is
    begin
            en_1 <= NOT(en_1);
        wait for 900*T;
            en_1 <= NOT(en_1);
        wait for T;
         
    end process;
    
    --Reset
    process is
    begin
        reset <= '1';
        wait for 5*T;
        reset <= '0';
        wait;
    end process;
    
    
    UUT: entity work.dcf_decode
        port map    (
                    clk=>clk,
                    reset=>reset,
                    en_100=>en_100,
                    dcf=>dcf,
                    de_set=>de_set,
                    de_dow=>de_dow,
                    de_day=>de_day,
                    de_month=>de_month,
                    de_year=>de_year,
                    de_hour=>de_hour,
                    de_min=>de_min
                    );
    
    
    DCF_gen: entity work.dcf_gen
        port map    (
                    clk => clk,
                    reset=>reset,
                    en_10=>en_10,
                    en_1=>en_1,
                    dcf=>dcf
                    );
    

end tb;
