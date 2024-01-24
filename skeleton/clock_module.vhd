----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:55:49 04/30/2013 
-- Design Name: 
-- Module Name:    clockMain - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;

entity clock_module is
    Port ( clk : in  std_logic;          
           reset : in  std_logic;
           en_1K : in  std_logic;
           en_100 : in  std_logic;
           en_10 : in  std_logic;
           en_1 : in  std_logic;
			  
           key_action_imp : in  std_logic;
		   key_action_long : in std_logic;
           key_mode_imp : in  std_logic;
           key_minus_imp : in  std_logic;
           key_plus_imp : in  std_logic;
           key_plus_minus : in  std_logic;
           key_enable : in  std_logic;
			  
           de_set : in  std_logic;
           de_dow : in  std_logic_vector (2 downto 0);
           de_day : in  std_logic_vector (5 downto 0);
           de_month : in  std_logic_vector (4 downto 0);
           de_year : in  std_logic_vector (7 downto 0);
           de_hour : in  std_logic_vector (5 downto 0);
           de_min : in  std_logic_vector (6 downto 0);
			  
           led_alarm_act : out  std_logic;
           led_alarm_ring : out  std_logic;
           led_countdown_act : out  std_logic;
           led_countdown_ring : out  std_logic;
           led_switch_act : out  std_logic;
           led_switch_on : out  std_logic;
			  
			  lcd_en : out std_logic;
			  lcd_rw : out std_logic;
			  lcd_rs : out std_logic;
			  lcd_data : out std_logic_vector(7 downto 0)
			  
			  
			  
			  
			  -- OLED signal only for development
			  --oled_en : out std_logic;
			  --oled_dc : out std_logic;
			  --oled_data : out std_logic;
			  --oled_reset : out std_logic;
			  --oled_vdd : out std_logic;
			  --oled_vbat : out std_logic
		);
end clock_module;

architecture Behavioral of clock_module is
    signal td_dow :  STD_LOGIC_VECTOR (2 downto 0):= (others=>'0');
    signal td_day :  STD_LOGIC_VECTOR (5 downto 0):= (others=>'0');
    signal td_hour :  STD_LOGIC_VECTOR (5 downto 0):= (others=>'0');
    signal td_min :  STD_LOGIC_VECTOR (6 downto 0):= (others=>'0');
    signal td_sec :  STD_LOGIC_VECTOR (6 downto 0):= (others=>'0');
    signal td_year :  STD_LOGIC_VECTOR (7 downto 0):= (others=>'0');
    signal td_month:  STD_LOGIC_VECTOR (4 downto 0):= (others=>'0');
    
    signal s_dow :  STD_LOGIC_VECTOR (2 downto 0):= (others=>'0');
    signal s_day :  STD_LOGIC_VECTOR (5 downto 0):= (others=>'0');
    signal s_hour :  STD_LOGIC_VECTOR (5 downto 0):= (others=>'0');
    signal s_min :  STD_LOGIC_VECTOR (6 downto 0):= (others=>'0');
    signal s_sec :  STD_LOGIC_VECTOR (6 downto 0):= (others=>'0');
    signal s_year :  STD_LOGIC_VECTOR (7 downto 0):= (others=>'0');
    signal s_month:  STD_LOGIC_VECTOR (4 downto 0):= (others=>'0');
    
    signal SYN: STD_LOGIC:= '0';
    signal synchronized : std_logic:= '0'; 
    signal global_state : STD_LOGIC_VECTOR (6 downto 0) := "0000001";
    signal line1 : STD_LOGIC_VECTOR (319 downto 0):= (others=>'0');
    signal line2 : STD_LOGIC_VECTOR (319 downto 0):= (others=>'0');
     

begin

	time_date: entity work.time_date
	   port map(   clk => clk,
	               reset=>reset,
	               en_1=>en_1,
	               s_dow=>s_dow,
	               s_day=>s_day,
	               s_hour=>s_hour,
	               s_min=>s_min,
	               s_month=>s_month,
	               s_year=>s_year,
	               SYN => SYN,
	               td_dow => td_dow,
	               td_day => td_day,
                   td_hour  => td_hour,
                   td_min => td_min,
                   td_sec => td_sec,
                   td_year  => td_year,
                   td_month => td_month   
	 
	           );
	   
    synchronize: entity work.synchronize
        port map(   clk=>clk,
                    td_min=>td_min,
                    de_set=>de_set,
                    en_100 => en_100,
                    reset => reset,
                    SYN => SYN,
                    synchronized => synchronized
                );
         
    display_interpreter: entity work.display_interpreter
        Port map (  clk => clk,
                    reset => reset,
                    synchronize => synchronized,
                    global_state => global_state,
                    td_sec => td_sec,
                    td_min => td_min,
                    td_hour => td_hour, 
                    td_day => td_day,
                    td_dow => td_dow,
                    td_month => td_month,
                    td_year => td_year,
                    line1 => line1,
                    line2 => line2
                );
                
    display_controller: entity work.display_controller
         port map ( clk => clk,
                    reset => reset,
                    global_state => global_state,
                    l1 => line1,
                    l2 => line2,
                    lcd_en => lcd_en,
                    lcd_rs => lcd_rs,
                    lcd_rw => lcd_rw,
                    lcd_data => lcd_data
                 );
     state_control: entity work.state_control
        port map (  clk => clk,
                    reset => reset,
                    en_10 => en_10,
                    mode_imp => key_mode_imp,
                    minus_imp => key_minus_imp,
                    plus_imp => key_plus_imp,
                    stasel => global_state
                 );
      dcf_interpreter: entity work.dcf_interpreter
        port map    (
                     -- IN
                     clk=>clk,
                     de_set=>de_set,
                     de_dow=>de_dow,
                     de_day=>de_day,
                     de_month=>de_month,
                     de_year=>de_year,
                     de_hour=>de_hour,
                     de_min=>de_min,
                     -- OUT
                     s_dow=>s_dow,
                     s_day=>s_day,
                     s_month=>s_month,
                     s_year=>s_year,
                     s_hour=>s_hour,
                     s_min=>s_min
                     );
            
end Behavioral;

