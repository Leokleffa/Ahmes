----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/01/2023 10:28:03 PM
-- Design Name: 
-- Module Name: ahmes - Behavioral
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

entity ahmes is
    Port ( reset : in STD_LOGIC;
            clk : in std_logic;
        
           AC : out STD_LOGIC_VECTOR (7 downto 0);
           PC : out STD_LOGIC_VECTOR (7 downto 0);
           
           flagN : out STD_LOGIC;
           flagZ : out STD_LOGIC;
           flagB : out STD_LOGIC;
           flagV : out STD_LOGIC;
           flagC : out STD_LOGIC);
end ahmes;

architecture Behavioral of ahmes is

component control_ahmes 
    Port ( reset    : in    STD_LOGIC;
           clk      : in    STD_LOGIC;
           
           flagN    : in    STD_LOGIC;
           flagZ    : in    STD_LOGIC;
           flagB    : in    STD_LOGIC;
           flagV    : in    STD_LOGIC;
           flagC    : in    STD_LOGIC;
           
           reg_RI   : in    STD_LOGIC_VECTOR (7 downto 0);
           
           cargaREM : out   STD_LOGIC;
           cargaRDM : out   STD_LOGIC;
           cargaAC  : out   STD_LOGIC;
           cargaRI  : out   STD_LOGIC;
           
           cargaN   : out   STD_LOGIC;
           cargaZ   : out   STD_LOGIC;
           cargaB   : out   STD_LOGIC;
           cargaV   : out   STD_LOGIC;
           cargaC   : out   STD_LOGIC;
           
           cargaPC  : out   STD_LOGIC;
           incPC    : out   STD_LOGIC;
           
           sel   : out   STD_LOGIC;
           selULA   : out   STD_LOGIC_VECTOR (3 downto 0);

           wr       : out   STD_LOGIC;--_VECTOR(0 DOWNTO 0);
           rd       : out   STD_LOGIC);
end component;

----------------------------------------------------------------------------------
component datapath_ahmes
    Port ( clk : in STD_LOGIC;
           reset: in STD_LOGIC;    
           
           cargaREM: in STD_LOGIC;
           cargaRDM : in STD_LOGIC;
           cargaAC : in STD_LOGIC;
           cargaRI : in STD_LOGIC;
           
           cargaN : in STD_LOGIC;
           cargaZ : in STD_LOGIC;
           cargaB : in STD_LOGIC;
           cargaV : in STD_LOGIC;
           cargaC : in STD_LOGIC;
           
           cargaPC : in STD_LOGIC;
           incPC : in STD_LOGIC;
           
           sel : in STD_LOGIC;
           selULA : in STD_LOGIC_VECTOR (3 downto 0);

           wr : in STD_LOGIC;--_VECTOR(0 DOWNTO 0);
           rd : in STD_LOGIC;
           
           out_RI : out STD_LOGIC_VECTOR (7 downto 0);
           out_PC : out STD_LOGIC_VECTOR (7 downto 0);
           out_AC : out STD_LOGIC_VECTOR (7 downto 0);
           
           flagN : out STD_LOGIC;
           flagZ : out STD_LOGIC;
           flagB : out STD_LOGIC;
           flagV : out STD_LOGIC;
           flagC : out STD_LOGIC);
end component;

signal N : STD_LOGIC;
signal Z : STD_LOGIC;
signal V : STD_LOGIC;
signal B : STD_LOGIC;
signal C : STD_LOGIC;

signal reg_RI   : STD_LOGIC_VECTOR (7 downto 0);
signal reg_PC, reg_AC : STD_LOGIC_VECTOR (7 downto 0);
signal cargaREM : STD_LOGIC;
signal cargaRDM : STD_LOGIC;
signal cargaAC  : STD_LOGIC;
signal cargaRI  : STD_LOGIC;
           
signal cargaN   : STD_LOGIC;
signal cargaZ   : STD_LOGIC;
signal cargaB   : STD_LOGIC;
signal cargaV   : STD_LOGIC;
signal cargaC   : STD_LOGIC;
           
signal cargaPC  : STD_LOGIC;
signal incPC    : STD_LOGIC;
           
signal sel   : STD_LOGIC;
signal selULA   : STD_LOGIC_VECTOR (3 downto 0);

signal wr       : STD_LOGIC;--_VECTOR(0 DOWNTO 0);
signal rd       : STD_LOGIC;

begin
    control: control_ahmes 
    
    Port map( reset    => reset,
           clk      => clk,
           
           flagN    => N,
           flagZ    => Z,
           flagB    => B,
           flagV    => V,
           flagC    => C,
           
           reg_RI   => reg_RI,
           
           cargaREM => cargaREM,
           cargaRDM => cargaRDM,
           cargaAC  => cargaAC,
           cargaRI  => cargaRI,
           
           cargaN   => cargaN,
           cargaZ   => cargaZ,
           cargaB   => cargaB,
           cargaV   => cargaV,
           cargaC   => cargaC,
           
           cargaPC  => cargaPC,
           incPC    => incPC,
           
           sel   => sel,
           selULA   => selULA,

           wr       => wr,
           rd       => rd);
           
    datapath: datapath_ahmes 
    Port map( reset    => reset,
           clk      => clk,
           
           flagN    => N,
           flagZ    => Z,
           flagB    => B,
           flagV    => V,
           flagC    => C,
           
           out_RI   => reg_RI,
           out_PC => reg_PC, 
           out_AC => reg_AC,
           
           cargaREM => cargaREM,
           cargaRDM => cargaRDM,
           cargaAC  => cargaAC,
           cargaRI  => cargaRI,
           
           cargaN   => cargaN,
           cargaZ   => cargaZ,
           cargaB   => cargaB,
           cargaV   => cargaV,
           cargaC   => cargaC,
           
           cargaPC  => cargaPC,
           incPC    => incPC,
           
           sel   => sel,
           selULA   => selULA,

           wr       => wr,
           rd       => rd);
           
    flagN <= N;
    flagZ <= Z;
    flagB <= B;
    flagV <= V;
    flagC <= C;
    PC <= reg_PC;        
    AC <= reg_AC;
end Behavioral;

