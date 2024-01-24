----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/03/2023 03:48:56 PM
-- Design Name: 
-- Module Name: sincronize - Behavioral
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

entity synchronize is
    Port ( td_min       : in  STD_LOGIC_VECTOR (6 downto 0);
           de_set       : in  STD_LOGIC;
           clk          : in  STD_LOGIC;
           en_100        : in  STD_LOGIC;
           reset        : in  STD_LOGIC;
           SYN          : out STD_LOGIC;
           synchronized  : out STD_Logic);
end synchronize;

architecture Behavioral of synchronize is

    type t_State is (INIT, Z, ZO, ZOZ); 
    signal state        : t_State := INIT;
    
    signal prev_min     : STD_LOGIC_VECTOR (6 downto 0) := (others => '0');
    
    signal FSM_SYN      : STD_LOGIC := '0';
    
    
   
begin
    process(clk, td_min, de_set, reset, state) is
    begin
    
        if rising_edge(clk) then     
            -- Reset
            if (reset = '1') then
            
                prev_min <= (others => '0');
                FSM_SYN <= '0';
                synchronized <= '0';
                state <= INIT;
            
            else
                if rising_edge(FSM_SYN) OR (td_min /= prev_min) then
                    synchronized <= FSM_SYN;
                
                end if;
                --Transitions
                case state is
                    
                    when INIT   =>
                        if (de_set='0') then state <= Z; end if;
                     
                    when Z      =>
                        if (de_set='1') then state <= ZO; end if;
                    
                    when ZO     =>
                        if (de_set='0') then state <= ZOZ;
                        else                 state <= INIT;
                        end if;
                    
                    when ZOZ    =>
                        if (de_set='1') then state <= ZO; 
                        else state <= Z;
                        end if;
                        
                    when others =>
                        state <= INIT;    
                end case;
                
                --Saves previous minute
                prev_min <= td_min;
            
            -- Output
            case state is 
            
                when ZOZ    =>  FSM_SYN <= '1';
                when others =>  FSM_SYN <= '0';
                
            end case;
                     
            end if;
        end if;
    end process;

    SYN <= FSM_SYN;
    


end Behavioral;
