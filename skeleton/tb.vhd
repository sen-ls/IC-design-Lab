----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/10/2023 04:31:10 PM
-- Design Name: 
-- Module Name: tb - Behavioral
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

entity tb is
--  Port ( );
end tb;

architecture testbench of tb is
    signal GCLK: STD_LOGIC;
    signal BTNC : std_logic; -- Button Center
	signal BTNU : std_logic; -- Button Up
	signal BTND : std_logic; -- Button Down
	signal BTNL : std_logic; -- Button Left
	signal BTNR : std_logic; -- Button Right
	signal SW   : std_logic_vector(7 downto 0); -- Switches
	
	signal TTT : std_logic := '0';
begin

    UUT: entity work.hardware
        port map(
            GCLK=>GCLK,
            BTNC=>BTNC,
            BTNU=>BTNU,
            BTND=>BTND,
            BTNL=>BTNL,
            BTNR=>BTNR,
            SW=>SW  
        );
        
     process
     begin
        GCLK<='0';
        if (TTT<='1') then
            BTND<='0';
        end if;
        
        wait for 5 ns;
        
        GCLK<='1';
        
        if (TTT = '0') then
            BTND<='1';
            TTT<='1';
        end if;
        
        wait for 5 ns;
        
     end process;

end testbench;
