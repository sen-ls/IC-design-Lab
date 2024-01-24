----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/24/2023 09:29:10 AM
-- Design Name: 
-- Module Name: sync_tb - tb
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

entity sync_tb is
--  Port ( );
end sync_tb;

architecture tb of sync_tb is
       signal min       : unsigned(6 downto 0) := (others => '0');
       signal td_min       : std_logic_vector (6 downto 0) := (others => '0');
       signal de_set       :   STD_LOGIC;
       signal clk          :  STD_LOGIC := '0';
       signal en_100        :  STD_LOGIC := '1';
       signal reset        :  STD_LOGIC;
       signal SYN          :  STD_LOGIC;
       signal synchronized  :  STD_Logic;
       
       constant T : time := 1ns;
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
    
    --Reset
    process is
    begin
        reset <= '1';
        wait for 5*T;
        reset <= '0';
        wait;
    end process;
    
    --Minutes
    process is
    begin
        wait for 100*T;
        min <= min + 1;
    end process;
    
    
    --de_set
    process is
    begin
        de_set <= '0';
        wait for 10*T;
        de_set <= '1';
        wait for T;
        de_set <= '0';
        wait for 200*T;
        de_set <= '1';
        wait for 4*T;
    end process;
    
    td_min <= std_logic_vector(min);
    
    UUT: entity work.synchronize
        port map    (
                        td_min=>td_min,
                        de_set=>de_set,
                        clk=>clk,
                        en_100=>en_100,
                        reset=>reset,
                        SYN=>SYN,
                        synchronized=>synchronized
                    );

           


end tb;
