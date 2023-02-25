library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_ahmes is
--  Port ( );
end tb_ahmes;

architecture Behavioral of tb_ahmes is  

component ahmes
    Port( reset : in STD_LOGIC;
            clk : in std_logic;
        
           AC : out STD_LOGIC_VECTOR (7 downto 0);
           PC : out STD_LOGIC_VECTOR (7 downto 0);
           
           flagN : out STD_LOGIC;
           flagZ : out STD_LOGIC;
           flagB : out STD_LOGIC;
           flagV : out STD_LOGIC;
           flagC : out STD_LOGIC);
end component;

signal reset :  STD_LOGIC;
signal clk :  std_logic;

signal AC :  STD_LOGIC_VECTOR (7 downto 0);
signal PC :  STD_LOGIC_VECTOR (7 downto 0);

signal flagN :  STD_LOGIC;
signal flagZ :  STD_LOGIC;
signal flagB :  STD_LOGIC;
signal flagV :  STD_LOGIC;
signal flagC :  STD_LOGIC;

-- Clock period definitions
constant clk_period : time := 40 ns;
begin
    comp_ahmes: ahmes
    Port map( reset => reset,
            clk => clk,
        
           AC => AC,
           PC => PC,
           
           flagN => flagN,
           flagZ => flagZ,
           flagB => flagB,
           flagV => flagV,
           flagC => flagC);
           
    -- Clock process definitions
   clk_process :process
   begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
   end process;    -- Stimulus process
   
   stim_proc: process
   begin        
      -- hold reset state for 100 ns.
      
      wait for 100 ns;           
      wait for clk_period*10;       
      
      -- insert stimulus here 
        wait for 20 ns;
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 1 sec;
        wait;
   end process;
         
end Behavioral;

