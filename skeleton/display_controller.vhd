----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/04/2023 11:31:13 AM
-- Design Name: 
-- Module Name: display_controller - controller
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

entity display_controller is
    Port ( clk : in STD_LOGIC; -- kHz
           reset : in STD_lOGIC;            
           global_state : in STD_LOGIC_VECTOR (6 downto 0) := (others => '0');
           l1 : in STD_LOGIC_VECTOR (0 to 319);
           l2 : in STD_LOGIC_VECTOR (0 to 319);
           lcd_en : out STD_LOGIC;
           lcd_rw : out STD_LOGIC;
           lcd_rs : out STD_LOGIC;
           lcd_data : out STD_LOGIC_VECTOR (7 downto 0));
           
end display_controller;

architecture controller of display_controller is
    
    type t_State is (POWER, INIT, SET, CLEAR, MODE, DISPLAY, ADDR, WRITE, NEXTC); 
    signal state : t_state := POWER;
    
    signal count : integer := 0;
    
    signal en : std_logic;
    
    signal address : std_logic_vector (7 downto 0) := "10000000";
    
    signal line1 : string (1 to 40);
    signal line2 : string (1 to 40);
    
    subtype byte is std_logic_vector(7 downto 0);
    subtype byte2 is std_logic_vector(15 downto 0);

    function decode(char: character) return byte is
    begin
        -- Invalid Character
        if (to_unsigned(character'pos(char), 8) < 33 OR to_unsigned(character'pos(char), 8) > 127) then
            return "10001000"; --Send space character
        
         --Normal character    
        else
            return byte(to_unsigned(character'pos(char), 8));
        
        end if;
    end function;
    
begin

    lcd_en<=en;

    process(clk) is
        variable clk_count : integer := 0;
    begin
        if (rising_edge(clk)) then
            clk_count := clk_count + 1;
            if (clk_count = 5) then
                en <= '1';
            elsif (clk_count = 10) then
                en <= '0';
                clk_count := 0;
            end if;
        end if;
    end process;
    
    
    process(en, l1, l2) is
        variable k : integer := 0;
    begin
        for i in 39 downto 0 loop
            k := 40-i;
            line1(k) <= character'val(to_integer(unsigned(l1(i*8 to i*8+7))));
            line2(k) <= character'val(to_integer(unsigned(l2(i*8 to i*8+7))));
            
        end loop;
    end process;
    
    
    process(en) is
        variable clk_count : integer := 0;
    begin
        if rising_edge(en) then
            
        
            --Reset
            if (reset = '1') then
                clk_count := 0;
                state <= POWER;
                lcd_rw <= '0';
                lcd_rs <= '0';
                lcd_data <= (others => '0');
                
            -- Normal
            else
                
                case state is
                    
                    when POWER =>
                        clk_count := clk_count + 1;
                        if (clk_count >= 10) then -- Wait 10ms
                            state <= INIT;
                            lcd_rw <= '0';
                            lcd_rs <= '0';
                            lcd_data <= "00111000";
                        end if;
                        
                    when INIT =>
                        lcd_rs <= '0';
                        lcd_data <= "00111000";
                        state <= SET;
                    
                    when SET =>
                            lcd_data <= "00001000";
                            state <= CLEAR;

                        
                    when CLEAR =>
                            clk_count := 0;
                            lcd_data <= "00000001";
                            state <= MODE;

                        
                    when MODE =>
                        clk_count := clk_count + 1;
                        if (clk_count >= 2) then -- Wait 2ms
                            lcd_data <= "00000110";
                            state <= DISPLAY;
                            
                        elsif (clk_count >= 1) then
                            lcd_data <= "00000000";
                        end if;
                    
                    when DISPLAY =>
                            lcd_data <= "00001100";
                            state <= ADDR;

                        
                    when ADDR =>
                            lcd_data <= "10000000";
                            address <= "10000000";
                            state <= WRITE;
                        
                    
                    when WRITE =>
                        lcd_rs <= '1';
                        lcd_rw <= '0';
                        
                        if(count < 40) then
                            lcd_data <= decode(line1(count+1));
                        else
                            lcd_data <= decode(line2(count-39));
                        end if;
                        
                        state <= NEXTC;
                        count <= count + 1;
                        address <= std_logic_vector(to_unsigned(to_integer(unsigned( address )) + 1, 8));
                    
                    when NEXTC =>
                        lcd_rs <= '0';
                        lcd_rw <= '0';
                        
                        if (count = 40) then
                            lcd_data <= "11000000";
                            address <= "11000000";
                            state <= WRITE;
                        elsif (count = 80) then
                            count <= 0;
                            state <= ADDR;
                        else
                            lcd_data <= address;
                            state <= WRITE;
                        end if;
                    
                    when others =>
                        state <= POWER;
                    
                    
                 end case;
            
            end if;
            
        
        
        end if;
    
    end process;





end controller;
