----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/04/2023 10:47:24 AM
-- Design Name: 
-- Module Name: display_decoder - Behavioral
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

entity display_decoder is
    Port ( char : in STD_LOGIC_VECTOR (7 downto 0);
           upper : out STD_LOGIC_VECTOR (3 downto 0);
           lower : out STD_LOGIC_VECTOR (3 downto 0));
end display_decoder;

architecture Behavioral of display_decoder is
-- Use this: https://electronics.stackexchange.com/questions/626149/does-vhdl-2008-have-built-in-function-to-convert-std-logic-vector-to-character-t
begin

    process (char) is
    begin
        -- Empty
        if (unsigned(char) < 33 OR unsigned(char) > 127) then
            upper <= (others => '0');
            lower <= (others => '0');
        
        -- Normal character    
        else
            upper <= char(7 downto 4);
            lower <= char(3 downto 0);
        
        end if;
    end process;


end Behavioral;
