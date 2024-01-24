library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity state_control is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           en_10 : in STD_LOGIC;
           mode_imp : in STD_LOGIC;
           minus_imp : in STD_LOGIC;
           plus_imp : in STD_LOGIC;
           stasel : out STD_LOGIC_VECTOR(6 DOWNTO 0));
           --stasel : out integer range 0 to 6);
end state_control;
 
architecture Behavioral of state_control is
 
type states is (s0, s1, s2, s3, s4, s5, s6);
-- s0 time s1 date s2 alarm, s3 switch on s4 switch off s5 timer s6 stop watch
--signal next_state, current_state: states;

--signal selecting: integer range 0 to 6;
signal selecting: std_logic_vector(6 downto 0):= "0000010";

signal count: integer range 0 to 30 := 0;
signal restart: STD_LOGIC := '0';
 
begin   

--process(en_10, reset) is
--    begin
--        if (reset='1') then
--            count <= 0;
--        else
--            if rising_edge(en_10) then
--                if count < 30 AND restart = '1' then
--                    count <= count + 1;
            
--                elsif count >= 30 OR restart = '0' then
--                    count <= 0;
                    
--                end if;
--            end if;
--        end if;
--end process;           

--process(mode_imp, plus_imp, minus_imp) --next state
--begin
--    if rising_edge(clk) then
--        if (reset = '1') then
--            selecting <= "0000001";
            
--        else
--            --if en_10 = '1' then
--                --current_state <= next_state;
--            --end if;
          
--                if selecting <= "0000001" then --s0
--                    if mode_imp = '1' then selecting <= "0000010"; restart <= '1';
--                    elsif (plus_imp = '1') or (minus_imp = '1')  then selecting <= "1000000";
--                    --elsif minus_imp = '1' then selecting <= "1000000";
--                    end if;         
          
--                elsif selecting <= "0000010" then --s1
--                    if mode_imp = '1' then selecting <= "0000100"; restart <= '0';
--                    elsif count = 30 then selecting <= "0000001"; restart <= '0';
--                    end if;
              
--                elsif selecting <= "0000100" then --s2
--                    if mode_imp = '1' then selecting <= "0001000";
--                    end if;
                  
--                elsif selecting <= "0001000" then --s3
--                    if mode_imp = '1' then selecting <= "0010000";
--                    end if;
                  
--                elsif selecting <= "0010000" then --s4
--                    if mode_imp = '1' then selecting <= "0100000";
--                    end if;
                  
--                elsif selecting <= "0100000" then --s5
--                    if mode_imp = '1' then selecting <= "0000001";     
--                    end if;
                  
--                elsif selecting <= "1000000" then --s6
--                    if mode_imp = '1' then selecting <= "0000001";
--                    end if;
                  
--                end if;
--         end if;
--      end if;        
-- end process;     

stasel <= selecting;
 
end Behavioral;